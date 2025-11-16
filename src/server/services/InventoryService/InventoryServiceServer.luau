--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)

local InventoryServiceServer = {}

type InventoryEntry = DataTemplate.InventoryEntry
type InventoryCategory = DataTemplate.InventoryCategory

function InventoryServiceServer.init(self: InventoryServiceServer)
	self.networker = Networker.server.new("InventoryService", self, {})
end

local function getInventoryKey(entry: InventoryEntry): string
	if entry.type == "tool" then
		if entry.guid then
			return entry.guid
		end
		return entry.id
	else
		return entry.id
	end
end

function InventoryServiceServer.addItem(
	self: InventoryServiceServer,
	player: Player,
	category: InventoryCategory,
	entry: InventoryEntry
)
	local key = getInventoryKey(entry)
	if DataService:get(player, { "inventory", category, key }) then
		DataService:update(player, { "inventory", category, key }, function(currentValue: InventoryEntry)
			return {
				amount = (currentValue.amount or 0) + entry.amount,
				data = currentValue.data,
				guid = currentValue.guid,
				id = currentValue.id,
				type = currentValue.type,
			}
		end)
	else
		DataService:set(player, { "inventory", category, key }, entry)
	end
	self.networker:fire(player, "setItem", category, DataService:get(player, { "inventory", category, key }))
end

type InventoryServiceServer = typeof(InventoryServiceServer) & {
	networker: Networker.Server,
}

return InventoryServiceServer :: InventoryServiceServer
