local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)
local PoissonDiskSampling = {}

-- Helper: valid placement check
local function isValidPoint(p: Vector2, grid: { { Vector2 } }, radius: number, width: number, height: number): boolean
	if p.X < 0 or p.X > width or p.Y < 0 or p.Y > height then
		return false
	end

	local cellSize = radius / math.sqrt(2)

	local xindex: number = math.floor(p.X / cellSize)
	local yindex: number = math.floor(p.Y / cellSize)
	local i0 = math.max(xindex - 1, 0)
	local i1 = math.min(xindex + 1, width - 1)
	local j0 = math.max(yindex - 1, 0)
	local j1 = math.min(yindex + 1, height - 1)

	for i = i0, i1 do
		if not grid[i] then
			continue
		end
		for j = j0, j1 do
			if grid[i][j] ~= nil then
				if (grid[i][j] - p).Magnitude < radius then
					return false
				end
			end
		end
	end

	return true
end

function PoissonDiskSampling.getPoints(
	radius: number,
	k: number,
	width: number,
	height: number
): ({ Vector2 }, { { Vector2 } })
	local N = 2

	local points: { Vector2 } = {}
	local active: { Vector2 } = {}

	local p0: Vector2 = Vector2.new(math.random() * width, math.random() * height)

	local grid: { { Vector2 } } = {}
	local cellSize = radius / math.sqrt(2)

	local ncells_width = math.ceil(width / cellSize) + 1
	local ncells_height = math.ceil(height / cellSize) + 1

	for i = 1, ncells_width do
		grid[i] = {}
	end

	local function insertPoint(point: Vector2)
		local xindex = math.floor(point.X / cellSize) + 1
		local yindex = math.floor(point.Y / cellSize) + 1

		grid[xindex][yindex] = point
	end

	insertPoint(p0)
	table.insert(points, p0)
	table.insert(active, p0)

	while Sift.Array.count(active) > 0 do
		local random_index = math.random(Sift.Array.count(active))
		local p = active[random_index]

		local found: boolean = false
		for tries = 0, k do
			local theta = math.random() * 2 * math.pi

			local new_radius = math.random() * radius + radius
			local pnewx = p.X + new_radius * math.cos(theta)
			local pnewy = p.Y + new_radius * math.sin(theta)

			local pnew: Vector2 = Vector2.new(pnewx, pnewy)

			if not isValidPoint(pnew, grid, radius, width, height) then
				continue
			end

			table.insert(points, pnew)
			insertPoint(pnew)
			table.insert(active, pnew)
			found = true
			break
		end

		if not found then
			table.remove(active, random_index)
		end
	end

	return points, grid
end

function PoissonDiskSampling.addPointAdaptive(radius, width, height, grid, points, gridResolution)
	gridResolution = gridResolution or 5 -- size of each cell in studs (coarser = faster, finer = better)
	local bestDist = -math.huge
	local bestPos = nil

	-- iterate over a coarse grid to find farthest empty spot
	for x = 0, width, gridResolution do
		for y = 0, height, gridResolution do
			local candidate = Vector2.new(x, y)
				+ Vector2.new((math.random() * 2 - 1) * gridResolution, (math.random() * 2 - 1) * gridResolution)
			local minDist = math.huge

			-- distance to nearest existing point
			for _, p in ipairs(points) do
				local d = (candidate - p).Magnitude
				if d < minDist then
					minDist = d
				end
			end

			if minDist > bestDist then
				bestDist = minDist
				bestPos = candidate
			end
		end
	end

	-- only insert if it satisfies radius requirement
	if bestPos and bestDist >= radius then
		-- insert into points table
		table.insert(points, bestPos)

		-- compute grid indices
		local cellSize = radius / math.sqrt(2)
		local xindex = math.floor(bestPos.X / cellSize) + 1
		local yindex = math.floor(bestPos.Y / cellSize) + 1
		grid[xindex] = grid[xindex] or {}
		grid[xindex][yindex] = bestPos

		return bestPos, points, grid
	end

	return nil, points, grid
end

return PoissonDiskSampling
