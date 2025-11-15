--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)

local InventoryServiceServer = {}

function InventoryServiceServer.init(self: InventoryServiceServer)
	self.networker = Networker.server.new("InventoryService", self, {})
end

function InventoryServiceServer.addItem(
	self: InventoryServiceServer,
	player: Player,
	category,
	item: { id: string, amount: number } | DataTemplate.ToolInstance
)
	if category ~= "tools" then
		local i: { id: string, amount: number } = item :: { id: string, amount: number }
		DataService:update(player, { "inventory", category, item.id }, function(currentValue)
			return { id = item.id, amount = (currentValue and currentValue.amount or 0) + i.amount }
		end)
	else
		local i = item :: DataTemplate.ToolInstance
		DataService:set(player, { "inventory", category, i.guid }, item)
	end

	self.networker:fire(player, "addItem", category, item)
end

type InventoryServiceServer = typeof(InventoryServiceServer) & {
	networker: Networker.Server,
}

return InventoryServiceServer :: InventoryServiceServer
