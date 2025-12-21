local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.modules.core.RegistryLoader)
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local AttributeServiceServer = require(ServerScriptService.Server.services.AttributeService.AttributeServiceServer)
local DialogueServiceServer = require(ServerScriptService.Server.services.DialogueService.DialogueServiceServer)
local InventoryServiceServer = require(ServerScriptService.Server.services.InventoryService.InventoryServiceServer)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local MiningServiceServer = require(ServerScriptService.Server.services.MiningService.MiningServiceServer)
local PlayerServiceServer = require(ServerScriptService.Server.services.PlayerService.PlayerServiceServer)
local QuestServiceServer = require(ServerScriptService.Server.services.QuestService.QuestServiceServer)
local ToolServiceServer = require(ServerScriptService.Server.services.ToolService.ToolServiceServer)
local UpgradeServiceServer = require(ServerScriptService.Server.services.UpgradeService.UpgradeServiceServer)
local ZoneServiceServer = require(ServerScriptService.Server.services.ZoneService.ZoneServiceServer)

DataService:init({
	template = DataTemplate,
	profileStoreIndex = "Testing",
	useMock = false,
	resetData = false,
})

AttributeServiceServer:init()
MiningServiceServer:init()
PlayerServiceServer:init()
ToolServiceServer:init()
InventoryServiceServer:init()
UpgradeServiceServer:init()
QuestServiceServer:init()
DialogueServiceServer:init()
ZoneServiceServer:init()

Players.PlayerAdded:Connect(function(player)
	DataService:waitForData(player)

	AttributeServiceServer:onPlayerAdded(player)
	PlayerServiceServer:onPlayerAdded(player)
	ToolServiceServer:onPlayerAdded(player)
	UpgradeServiceServer:onPlayerAdded(player)
	InventoryServiceServer:onPlayerAdded(player)
	QuestServiceServer:onPlayerAdded(player)
end)
