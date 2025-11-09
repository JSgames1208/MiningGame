local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local Sift = require(ReplicatedStorage.Packages.Sift)
local PoissonDiskSampling = require(ReplicatedStorage.Shared.modules.math.PoissonDiskSampling)
local AnimationService = require(ReplicatedStorage.Shared.services.AnimationService.AnimationService)
local MiningServiceClient = require(ReplicatedStorage.Shared.services.MiningService.MiningServiceClient)
local PlayerServiceClient = require(ReplicatedStorage.Shared.services.PlayerService.PlayerServiceClient)
local RootUI = require(ReplicatedStorage.Shared.ui.app.RootUI)
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local e = React.createElement

MiningServiceClient:init()
PlayerServiceClient:init()
AnimationService:init()

local root = ReactRoblox.createRoot(playerGui)
root:render(e(RootUI))

local points, grid = PoissonDiskSampling.getPoints(10, 30, 100, 100)

local parts = {}

for i, pos in ipairs(points) do
	local part = Instance.new("Part")
	part.Anchored = true
	part.Position = Vector3.new(pos.X, 10, pos.Y)
	part.Color = Color3.fromRGB(255, 0, 0)
	part.Size = Vector3.new(1, 1, 1)
	part.Parent = workspace

	parts[i] = part
end

while true do
	wait(0.3)

	if #points == 0 then
		print("no more points", grid, #grid)
		continue
	end

	-- remove random existing point
	local removeIndex = math.random(1, #points)
	local pos = table.remove(points, removeIndex)

	-- remove from grid
	local cellSize = 20 / math.sqrt(2)
	local xindex = math.floor(pos.X / cellSize) + 1
	local yindex = math.floor(pos.Y / cellSize) + 1
	if grid[xindex] then
		grid[xindex][yindex] = nil
	end

	-- remove the part
	if parts[removeIndex] then
		parts[removeIndex]:Destroy()
		table.remove(parts, removeIndex)
	end

	-- add a new point
	local newPoint, pts, g = PoissonDiskSampling.addPointAdaptive(50, 100, 100, grid, points, 5)
	points = pts
	grid = g

	if newPoint then
		table.insert(points, newPoint)
		local part = Instance.new("Part")
		part.Anchored = true
		part.Position = Vector3.new(newPoint.X, 10, newPoint.Y)
		part.Color = Color3.fromRGB(0, 255, 0)
		part.Size = Vector3.new(1, 1, 1)
		part.Parent = workspace
		table.insert(parts, part)
	end
end
