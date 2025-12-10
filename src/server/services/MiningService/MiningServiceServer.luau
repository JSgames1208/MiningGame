--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local LootServiceServer = require(ServerScriptService.Server.services.LootService.LootServiceServer)
local OreGenerator = require(ServerScriptService.Server.services.MiningService.util.OreGenerator)
local OreStore = require(ServerScriptService.Server.services.MiningService.util.OreStore)
local MiningFXServer = require(ServerScriptService.Server.services.MiningService.util.MiningFXServer)
local PlayerServiceServer = require(ServerScriptService.Server.services.PlayerService.PlayerServiceServer)
local ToolServiceServer = require(ServerScriptService.Server.services.ToolService.ToolServiceServer)
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local LootTables = require(ReplicatedStorage.Shared.modules.core.registries.LootTables)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local Upgrades = require(ReplicatedStorage.Shared.modules.core.registries.Upgrades)
local ToolUtil = require(ReplicatedStorage.Shared.services.ToolService.util.ToolUtil)

MiningFXServer:init()
OreGenerator:init()

local MiningServiceServer = {}

local lastMined: { [number]: number } = {}

function MiningServiceServer.init(self: MiningServiceServer)
	self.networker = Networker.server.new("MiningService", self, {
		self.attemptMine :: any,
		self.startMining :: any,
	})
end

function MiningServiceServer.startMining(self: MiningServiceServer, player: Player, target: BasePart)
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp: BasePart = character:WaitForChild("HumanoidRootPart") :: BasePart
	if (hrp.Position - target.Position).Magnitude > 40 then
		return
	end

	local minableData = OreStore.getOreInstance(target)

	if not minableData then
		return
	end

	self.networker:fire(player, "startMining", target, minableData)
end

function MiningServiceServer.attemptMine(self: MiningServiceServer, player: Player, target: BasePart)
	local toolId: string = DataService:get(player, { "tools", "equipped" })
	local toolInstance: DataTemplate.InventoryEntry = DataService:get(player, { "inventory", "tool", toolId })
	local toolData = Registries.ITEM:get(toolInstance.id)

	if not toolData then
		return
	end

	local toolStats = toolData.toolStats
	if not toolStats then
		error("[MiningServiceServer] TOOL HAS NO STATS!")
	end

	local finalStats = ToolUtil.getStats(toolStats, (toolInstance.toolData :: any).upgrades)

	if not lastMined[player.UserId] or lastMined[player.UserId] + 1.5 / finalStats.miningSpeed < tick() then
		lastMined[player.UserId] = tick()

		local minableData = OreStore.getOreInstance(target)

		if not minableData then
			return
		end

		minableData.health -= finalStats.miningPower

		self.networker:fire(player, "mine", target, minableData.health, finalStats.miningSpeed)

		if minableData.health <= 0 then
			OreStore.removeOre(target)

			task.delay(0.75, function()
				self.networker:fire(player, "stopMining")
				target:Destroy()

				PlayerServiceServer:addCurrency(player, 100)
				LootServiceServer:giveLoot(player, LootTables.DIRT)

				-- TEMPORARY TESTING --

				ToolServiceServer:incrementUpgrade(
					player,
					DataService:get(player, { "tools", "equipped" }),
					Registries.UPGRADE:idOf(Upgrades.POWER) :: string
				)

				ToolServiceServer:incrementUpgrade(
					player,
					DataService:get(player, { "tools", "equipped" }),
					Registries.UPGRADE:idOf(Upgrades.EFFICIENCY) :: string
				)
			end)
		end
	end
end

type MiningServiceServer = typeof(MiningServiceServer) & {
	networker: Networker.Server,
}

return MiningServiceServer :: MiningServiceServer
