--!strict

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local InventoryServiceServer = require(ServerScriptService.Server.services.InventoryService.InventoryServiceServer)
local MinableGenerator = require(ServerScriptService.Server.services.MiningService.util.MinableGenerator)
local MinableRegistry = require(ServerScriptService.Server.services.MiningService.util.MinableRegistry)
local MiningFXServer = require(ServerScriptService.Server.services.MiningService.util.MiningFXServer)
local PlayerServiceServer = require(ServerScriptService.Server.services.PlayerService.PlayerServiceServer)
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local ToolRegistry = require(ReplicatedStorage.Shared.services.ToolService.util.ToolRegistry)

MiningFXServer:init()
MinableGenerator:init()

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

	local minableData = MinableRegistry.getMinableData(target)

	if not minableData then
		return
	end

	self.networker:fire(player, "startMining", target, minableData)
end

function MiningServiceServer.attemptMine(self: MiningServiceServer, player: Player, target: BasePart)
	local toolId: string = DataService:get(player, { "tools", "equipped" })
	local toolInstance: DataTemplate.ToolInstance = DataService:get(player, { "inventory", "tools", toolId })
	local toolData = toolInstance.data

	if not toolData then
		return
	end

	local toolStats = toolData.stats

	if not lastMined[player.UserId] or lastMined[player.UserId] + 1.5 / toolStats.miningSpeed < tick() then
		lastMined[player.UserId] = tick()

		local minableData = MinableRegistry.getMinableData(target)

		if not minableData then
			return
		end

		minableData.health -= toolStats.miningPower

		self.networker:fire(player, "mine", target, minableData.health)

		if minableData.health <= 0 then
			MinableRegistry.removeMinable(target)

			task.delay(0.75, function()
				self.networker:fire(player, "stopMining")
				target:Destroy()

				PlayerServiceServer:addCurrency(player, 100)
				InventoryServiceServer:addItem(
					player,
					"tools",
					{ id = `tool_{HttpService:GenerateGUID()}`, data = ToolRegistry["stone_pickaxe"], upgrades = {} }
				)
			end)
		end
	end
end

type MiningServiceServer = typeof(MiningServiceServer) & {
	networker: Networker.Server,
}

return MiningServiceServer :: MiningServiceServer
