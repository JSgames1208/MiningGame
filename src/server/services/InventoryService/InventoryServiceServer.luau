--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)

local InventoryServiceServer = {}

function InventoryServiceServer.init(self: InventoryServiceServer)
	self.networker = Networker.server.new("InventoryService", self, {})
end

function InventoryServiceServer.addItem(self: InventoryServiceServer, player: Player, tool: DataTemplate.ToolInstance)
	DataService:set(player, { "inventory", "tools", tool.id }, tool)

	self.networker:fire(player, "addItem", tool)
end

type InventoryServiceServer = typeof(InventoryServiceServer) & {
	networker: Networker.Server,
}

return InventoryServiceServer :: InventoryServiceServer
