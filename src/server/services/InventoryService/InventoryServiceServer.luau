--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local QuestSignals = require(ServerScriptService.Server.services.QuestService.QuestSignals)
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local Items = require(ReplicatedStorage.Shared.modules.core.registries.Items)

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

function InventoryServiceServer.addItem(self: InventoryServiceServer, player: Player, entry: InventoryEntry)
	local key = getInventoryKey(entry)
	local itemEntry = Items.get(entry.id)
	if not itemEntry then
		return
	end
	local category = itemEntry.type
	if DataService:get(player, { "inventory", category, key }) then
		DataService:update(player, { "inventory", category, key }, function(currentValue: InventoryEntry)
			return {
				amount = (currentValue.amount or 0) + entry.amount,
				guid = currentValue.guid,
				id = currentValue.id,
				type = currentValue.type,
				toolData = currentValue.toolData,
			}
		end)
	else
		DataService:set(player, { "inventory", category, key }, entry)
	end
	QuestSignals.ItemCollected:Fire(player, entry.id, entry.amount)
	self.networker:fire(player, "setItem", category, DataService:get(player, { "inventory", category, key }))
end

function InventoryServiceServer.removeItem(
	self: InventoryServiceServer,
	player: Player,
	itemId: string,
	_amount: number?,
	itemGuid: string?
)
	local amount = _amount or 1

	local key = itemGuid ~= nil and itemGuid or itemId

	local itemEntry = Items.get(itemId)
	if not itemEntry then
		return
	end

	local inventoryEntry: InventoryEntry = DataService:get(player, { "inventory", itemEntry.type, key })

	local category = itemEntry.type
	if inventoryEntry then
		local newAmount = inventoryEntry.amount - amount

		if newAmount <= 0 then
			DataService:set(player, { "inventory", category, key }, nil)
			self.networker:fire(player, "removeItem", category, key)
			return
		end

		DataService:update(player, { "inventory", category, key }, function(currentValue: InventoryEntry)
			return {
				amount = (currentValue.amount or 0) - amount,
				guid = currentValue.guid,
				id = currentValue.id,
				type = currentValue.type,
				toolData = currentValue.toolData,
			}
		end)

		self.networker:fire(player, "setItem", category, DataService:get(player, { "inventory", category, key }))
	end
end

function InventoryServiceServer.onPlayerAdded(self: InventoryServiceServer, player: Player)
	--[[local inventory: DataTemplate.Inventory = DataService:get(player, { "inventory" })

	local checkedInv = {}

	if inventory then
		for category, categoryMap in inventory do
			for key, entry in categoryMap do
				local itemEntry = Items.get(entry.id)
				if not itemEntry then
					continue
				end

				if not checkedInv[itemEntry.type] then
					checkedInv[itemEntry.type] = {}
				end

				Sift.Dictionary.update(checkedInv[itemEntry.type], key, function(currentValue: InventoryEntry)
					return {
						amount = (currentValue.amount or 0) + entry.amount,
						toolData = currentValue.toolData,
						guid = currentValue.guid,
						id = currentValue.id,
						type = itemEntry.type,
					}
				end)
			end
		end
	end

	for category, categoryMap in checkedInv do
		for key, entry in categoryMap do
			self.networker:fire(player, "setItem", category, entry)
		end
	end

	DataService:set(player, { "inventory" }, checkedInv)]]
end

type InventoryServiceServer = typeof(InventoryServiceServer) & {
	networker: Networker.Server,
}

return InventoryServiceServer :: InventoryServiceServer
