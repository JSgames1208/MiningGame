local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local MiningServiceServer = require(ServerScriptService.Server.services.MiningService.MiningServiceServer)
local PlayerServiceServer = require(ServerScriptService.Server.services.PlayerService.PlayerServiceServer)
local ToolServiceServer = require(ServerScriptService.Server.services.ToolService.ToolServiceServer)

DataService:init({
	template = DataTemplate,
	profileStoreIndex = "Testing",
	useMock = false,
	resetData = false,
})

MiningServiceServer:init()
PlayerServiceServer:init()
ToolServiceServer:init()

Players.PlayerAdded:Connect(function(player)
	DataService:waitForData(player)
	PlayerServiceServer:onPlayerAdded(player)
	ToolServiceServer:onPlayerAdded(player)
end)
