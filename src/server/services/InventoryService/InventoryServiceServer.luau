--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local Networker = require(ReplicatedStorage.Packages.Networker)

local InventoryServiceServer = {}

function InventoryServiceServer.init(self: InventoryServiceServer)
	self.networker = Networker.server.new("InventoryService", self, {})
end

function InventoryServiceServer.addItem(self: InventoryServiceServer, player: Player, category, item: any)
	DataService:set(player, { "inventory", category, item.id }, item)

	self.networker:fire(player, "addItem", category, item)
end

type InventoryServiceServer = typeof(InventoryServiceServer) & {
	networker: Networker.Server,
}

return InventoryServiceServer :: InventoryServiceServer
