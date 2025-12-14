local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)

local InventoryServiceClient = {}

type InventoryEntry = DataTemplate.InventoryEntry
type InventoryCategory = DataTemplate.InventoryCategory

function InventoryServiceClient.init(self: InventoryServiceClient)
	self.networker = Networker.client.new("InventoryService", self)

	local inventory: DataTemplate.Inventory = DataService:get({ "inventory" })

	for categoryName, category in inventory do
		for _, entry in category do
			inventorySlice.actions.setItem(categoryName, entry)
		end
	end
end

function InventoryServiceClient.removeItem(self: InventoryServiceClient, category: InventoryCategory, key: string)
	inventorySlice.actions.removeItem(category, key)
end

function InventoryServiceClient.setItem(
	self: InventoryServiceClient,
	category: InventoryCategory,
	entry: InventoryEntry
)
	inventorySlice.actions.setItem(category, entry)
end

type InventoryServiceClient = typeof(InventoryServiceClient) & {
	networker: Networker.Client,
}

return InventoryServiceClient :: InventoryServiceClient
