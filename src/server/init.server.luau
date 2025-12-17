local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.modules.core.RegistryLoader)
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local InventoryServiceServer = require(ServerScriptService.Server.services.InventoryService.InventoryServiceServer)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local Quests = require(ReplicatedStorage.Shared.modules.core.registries.Quests)
local MiningServiceServer = require(ServerScriptService.Server.services.MiningService.MiningServiceServer)
local PlayerServiceServer = require(ServerScriptService.Server.services.PlayerService.PlayerServiceServer)
local QuestServiceServer = require(ServerScriptService.Server.services.QuestService.QuestServiceServer)
local ToolServiceServer = require(ServerScriptService.Server.services.ToolService.ToolServiceServer)
local UpgradeServiceServer = require(ServerScriptService.Server.services.UpgradeService.UpgradeServiceServer)

DataService:init({
	template = DataTemplate,
	profileStoreIndex = "Testing",
	useMock = false,
	resetData = false,
})

MiningServiceServer:init()
PlayerServiceServer:init()
ToolServiceServer:init()
InventoryServiceServer:init()
UpgradeServiceServer:init()
QuestServiceServer:init()

Players.PlayerAdded:Connect(function(player)
	DataService:waitForData(player)

	PlayerServiceServer:onPlayerAdded(player)
	ToolServiceServer:onPlayerAdded(player)
	UpgradeServiceServer:onPlayerAdded(player)
	InventoryServiceServer:onPlayerAdded(player)
	QuestServiceServer:onPlayerAdded(player)

	QuestServiceServer:grantQuest(player, Quests.idOf(Quests.MINE_COAL_1))

	task.delay(3, function()
		QuestServiceServer:grantQuest(player, Quests.idOf(Quests.MINE_COAL_2))
	end)
end)
