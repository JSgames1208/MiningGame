local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)
local PoissonDiskSampling = {}

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
	local cellSize = math.floor(radius / math.sqrt(N))
	local ncells_width = math.ceil(width / cellSize) + 1
	local ncells_height = math.ceil(height / cellSize) + 1
	for i = 0, ncells_width do
		grid[i] = {}
	end
	local function insertPoint(point: Vector2)
		local xindex = math.floor(point.X / cellSize)
		local yindex = math.floor(point.Y / cellSize)
		grid[xindex][yindex] = point
	end
	local function isValidPoint(p: Vector2): boolean
		if p.X < 0 or p.X > width or p.Y < 0 or p.Y > height then
			return false
		end
		local xindex: number = math.floor(p.X / cellSize)
		local yindex: number = math.floor(p.Y / cellSize)
		local i0 = math.max(xindex - 1, 0)
		local i1 = math.min(xindex + 1, ncells_width - 1)
		local j0 = math.max(yindex - 1, 0)
		local j1 = math.min(yindex + 1, ncells_height - 1)
		for i = i0, i1 do
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
			if not isValidPoint(pnew) then
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

-- DON'T USE, DOESN'T WORK YET!
function PoissonDiskSampling.addPointAdaptive(radius, width, height, grid, points, candidateCount)
	candidateCount = candidateCount or 20 -- number of random candidates to try
	local bestCandidate = nil
	local bestDist = -math.huge

	local cellSize = math.floor(radius / math.sqrt(2))
	local ncells_width = math.ceil(width / cellSize) + 1
	local ncells_height = math.ceil(height / cellSize) + 1

	local function isValidPoint(p)
		if p.X < 0 or p.X > width or p.Y < 0 or p.Y > height then
			return false
		end

		local xindex = math.floor(p.X / cellSize)
		local yindex = math.floor(p.Y / cellSize)

		local i0 = math.max(xindex - 1, 0)
		local i1 = math.min(xindex + 1, ncells_width - 1)
		local j0 = math.max(yindex - 1, 0)
		local j1 = math.min(yindex + 1, ncells_height - 1)

		local minDist = math.huge
		for i = i0, i1 do
			for j = j0, j1 do
				if grid[i] and grid[i][j] then
					local d = (grid[i][j] - p).Magnitude
					if d < minDist then
						minDist = d
					end
				end
			end
		end

		return minDist >= radius, minDist
	end

	for _ = 1, candidateCount do
		-- random candidate anywhere
		local candidate = Vector2.new(math.random() * width, math.random() * height)
		local valid, minDist = isValidPoint(candidate)
		if valid and minDist > bestDist then
			bestDist = minDist
			bestCandidate = candidate
		end
	end

	if bestCandidate then
		-- insert into points
		table.insert(points, bestCandidate)

		-- insert into grid
		local xindex = math.floor(bestCandidate.X / cellSize)
		local yindex = math.floor(bestCandidate.Y / cellSize)
		grid[xindex] = grid[xindex] or {}
		grid[xindex][yindex] = bestCandidate

		return bestCandidate, points, grid
	end

	-- no valid candidate found
	return nil, points, grid
end

return PoissonDiskSampling
