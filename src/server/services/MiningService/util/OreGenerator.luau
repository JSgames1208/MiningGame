--!strict
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Sift = require(ReplicatedStorage.Packages.Sift)
local Ores = require(ReplicatedStorage.Shared.modules.core.registries.Ores)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local OreType = require(ReplicatedStorage.Shared.modules.core.types.OreType)
local OreStore = require(ServerScriptService.Server.services.MiningService.util.OreStore)
local PoissonDiskSampling = require(ReplicatedStorage.Shared.modules.math.PoissonDiskSampling)
local OreGenerator = {}

function OreGenerator.init(self: OreGenerator)
	self:populateAll()
end

function OreGenerator.populateAll(self: OreGenerator)
	for _, spawnArea in ipairs(workspace.SpawnAreas:GetChildren()) do
		self:populate(spawnArea)
	end
end

function OreGenerator.spawnOre(self: OreGenerator, id: string, oreData: OreType.OreData) end

function OreGenerator.populate(self: OreGenerator, spawnArea: Part)
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude

	local points, _ = PoissonDiskSampling.getPoints(20, 30, spawnArea.Size.X, spawnArea.Size.Z)

	for _, point in ipairs(points) do
		local worldPoint = Vector2.new(
			point.X + spawnArea.Position.X - spawnArea.Size.X / 2,
			point.Y + spawnArea.Position.Z - spawnArea.Size.Z / 2
		)

		local part = Instance.new("Part")
		part.CanCollide = false
		part.Anchored = true
		part.Size = Vector3.new(5, 5, 5)
		part:AddTag("minable")

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

		OreStore.add(part, {
			id = Registries.ORE:idOf(Ores.DIRT) :: string,
			guid = HttpService:GenerateGUID(),
			oreData = Ores.DIRT,
			health = 0,
		})
	end
end

type OreGenerator = typeof(OreGenerator) & {}

return OreGenerator :: OreGenerator
