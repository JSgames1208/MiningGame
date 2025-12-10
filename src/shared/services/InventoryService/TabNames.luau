local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)

type InventoryCategory = DataTemplate.InventoryCategory

local categoryMap = {
	tool = "Tools",
	upgrade = "Upgrades",
	potion = "Potions",
	item = "Items",
}

return categoryMap :: { [InventoryCategory]: string }
