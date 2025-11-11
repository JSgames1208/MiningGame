local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)

local InventoryServiceClient = {}

function InventoryServiceClient.init(self: InventoryServiceClient)
	self.networker = Networker.client.new("InventoryService", self)

	local inventory: { DataTemplate.ToolInstance } = DataService:get({ "inventory", "tools" })

	for _, v in inventory do
		inventorySlice.actions.setItem(v, 1)
	end
end

function InventoryServiceClient.addItem(self: InventoryServiceClient, tool: DataTemplate.ToolInstance)
	inventorySlice.actions.setItem(tool, 1)
end

type InventoryServiceClient = typeof(InventoryServiceClient) & {
	networker: Networker.Client,
}

return InventoryServiceClient :: InventoryServiceClient
