--!strict
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Sift = require(ReplicatedStorage.Packages.Sift)
local Ores = require(ReplicatedStorage.Shared.modules.core.registries.Ores)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local FarthestPointSampling = require(ReplicatedStorage.Shared.modules.math.FarthestPointSampling)
local OreStore = require(ServerScriptService.Server.services.MiningService.util.OreStore)

local OreGenerator = {}

local Random = Random.new()

local ZoneState: { [Part]: {
	points: { Vector2 },
	targetCount: number,
	radius: number,
	regenerating: boolean,
} } =
	{}

function OreGenerator.init(self: OreGenerator)
	self:populateAll()
end

function OreGenerator.populateAll(self: OreGenerator)
	for _, spawnArea in ipairs(workspace.SpawnAreas:GetChildren()) do
		self:populate(spawnArea)
	end
end

function OreGenerator.spawnOreAtPoint(self: OreGenerator, spawnArea: Part, point: Vector2)
	local oreId = "coal"

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude

	local worldPoint = Vector2.new(
		point.X + spawnArea.Position.X - spawnArea.Size.X / 2,
		point.Y + spawnArea.Position.Z - spawnArea.Size.Z / 2
	)

	local part = ReplicatedStorage.Assets.ores:FindFirstChild(oreId):Clone()

	rayParams.FilterDescendantsInstances = { spawnArea }
	for _, player in Players:GetPlayers() do
		rayParams.FilterDescendantsInstances =
			Sift.Array.join(rayParams.FilterDescendantsInstances, player.Character:GetDescendants())
	end

	local rayResult = workspace:Raycast(
		Vector3.new(worldPoint.X, spawnArea.Position.Y + 100, worldPoint.Y),
		Vector3.new(0, -200, 0),
		rayParams
	)

	if rayResult then
		part.Position = rayResult.Position + Vector3.new(0, part.Size.Y / 2, 0)
	else
		part.Position =
			Vector3.new(worldPoint.X, spawnArea.Position.Y + spawnArea.Size.Y + part.Size.Y / 2, worldPoint.Y)
	end

	local particleAttachment = ReplicatedStorage.ParticleAttachment:Clone()
	particleAttachment.Parent = part

	part.Parent = spawnArea

	OreStore.add(part, oreId)
end

function OreGenerator.populate(self: OreGenerator, spawnArea: Part)
	local radius = 20
	local numOres = 100

	local points = FarthestPointSampling(spawnArea.Size.X, spawnArea.Size.Z, radius, {}, numOres)

	ZoneState[spawnArea] = {
		points = points,
		targetCount = numOres,
		radius = radius,
		regenerating = false,
	}

	for _, point in ipairs(points) do
		self:spawnOreAtPoint(spawnArea, point)
	end
end

function OreGenerator.onOreMined(self: OreGenerator, spawnArea: Part, localPoint: Vector2)
	local state = ZoneState[spawnArea]
	if not state then
		return
	end

	for i, p in ipairs(state.points) do
		if (p - localPoint).Magnitude < 0.01 then
			table.remove(state.points, i)
			break
		end
	end

	self:startRegenLoop(spawnArea)
end

function OreGenerator.startRegenLoop(self: OreGenerator, spawnArea: Part)
	local state = ZoneState[spawnArea]
	if not state or state.regenerating then
		return
	end

	state.regenerating = true

	task.spawn(function()
		while #state.points < state.targetCount do
			task.wait(Random:NextNumber(1, 5))

			local before = #state.points

			local updated =
				FarthestPointSampling(spawnArea.Size.X, spawnArea.Size.Z, state.radius, state.points, before + 1)

			if #updated > before then
				local newPoint = updated[#updated]
				table.insert(state.points, newPoint)
				self:spawnOreAtPoint(spawnArea, newPoint)
			else
				break
			end
		end

		state.regenerating = false
	end)
end

type OreGenerator = typeof(OreGenerator) & {}

return OreGenerator :: OreGenerator
