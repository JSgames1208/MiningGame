local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MaxHeap = require(ReplicatedStorage.Shared.modules.math.MaxHeap)

local Random = Random.new()

local function farthestPointSampling(
	width: number,
	height: number,
	radius: number,
	initialPoints: { Vector2 }?,
	numPoints: number
)
	local points = initialPoints or {}
	local gridSize = radius / math.sqrt(2)
	local grid = {}

	-- helper: grid cell index
	local function cellIndex(p: Vector2)
		return math.floor(p.X / gridSize), math.floor(p.Y / gridSize)
	end

	-- helper: min distance to existing points
	local function minDistToNeighbors(p: Vector2)
		local ix, iy = cellIndex(p)
		local minDist = math.huge
		for dx = -2, 2 do
			for dy = -2, 2 do
				local gx = ix + dx
				local gy = iy + dy
				if grid[gx] and grid[gx][gy] then
					for _, gpoint in ipairs(grid[gx][gy]) do
						local d = (gpoint - p).Magnitude
						if d < minDist then
							minDist = d
						end
					end
				end
			end
		end
		return minDist
	end

	-- insert a point into grid
	local function insertIntoGrid(p: Vector2)
		local ix, iy = cellIndex(p)
		grid[ix] = grid[ix] or {}
		grid[ix][iy] = grid[ix][iy] or {}
		table.insert(grid[ix][iy], p)
	end

	local function insertPoint(p: Vector2)
		table.insert(points, p)
		insertIntoGrid(p)
	end

	for _, p in ipairs(points) do
		insertIntoGrid(p)
	end

	local heap = MaxHeap.new()
	local candidateSpacing = radius / 1.5

	for x = 0, math.floor(width / candidateSpacing) do
		for y = 0, math.floor(height / candidateSpacing) do
			local candidate = Vector2.new(
				x * candidateSpacing + Random:NextNumber() * candidateSpacing,
				y * candidateSpacing + Random:NextNumber() * candidateSpacing
			)
			local dist = minDistToNeighbors(candidate)
			heap:push(dist, candidate)
		end
	end

	while not heap:isEmpty() and #points < numPoints do
		local _, cand = heap:pop()
		local dist = minDistToNeighbors(cand)
		if dist >= radius then
			insertPoint(cand)
		end
	end

	return points
end

return farthestPointSampling
