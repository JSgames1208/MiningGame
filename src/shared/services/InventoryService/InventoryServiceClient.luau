local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)

local InventoryServiceClient = {}

function InventoryServiceClient.init(self: InventoryServiceClient)
	self.networker = Networker.client.new("InventoryService", self)

	local inventory: DataTemplate.Inventory = DataService:get({ "inventory" })

	for categoryName, category in inventory do
		for _, item in category do
			inventorySlice.actions.setItem(categoryName, item, 1)
		end
	end
end

function InventoryServiceClient.addItem(self: InventoryServiceClient, category: string, item)
	inventorySlice.actions.setItem(category, item, 1)
end

type InventoryServiceClient = typeof(InventoryServiceClient) & {
	networker: Networker.Client,
}

return InventoryServiceClient :: InventoryServiceClient
