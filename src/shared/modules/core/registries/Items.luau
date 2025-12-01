--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local ItemType = require(ReplicatedStorage.Shared.modules.core.types.ItemType)

type ItemData = ItemType.ItemData

export type Items = {
	WOODEN_PICKAXE: ItemData,
	STONE_PICKAXE: ItemData,
	DIRT: ItemData,
	POTION_RED: ItemData,
	POTION_GREEN: ItemData,
	POTION_YELLOW: ItemData,

	get: (id: string) -> ItemData?,
}

local Items = {}

-- Register items
Items.WOODEN_PICKAXE = Registry.register(Registries.ITEM, "wooden_pickaxe", {
	name = "Wooden Pickaxe",
	description = "A wooden pickaxe.",
	rarity = "common",
	type = "tool",

	toolStats = {
		toolType = "pickaxe",
		durability = 100,
		miningPower = 1,
		miningSpeed = 1.0,
	},
})

Items.STONE_PICKAXE = Registry.register(Registries.ITEM, "stone_pickaxe", {
	name = "Stone Pickaxe",
	description = "A stone pickaxe.",
	rarity = "uncommon",
	type = "tool",

	toolStats = {
		toolType = "pickaxe",
		durability = 200,
		miningPower = 2,
		miningSpeed = 1.2,
	},
})

Items.DIRT = Registry.register(Registries.ITEM, "dirt", {
	name = "Dirt",
	description = "A ball of dirt.",
	rarity = "common",
	type = "material",
})

Items.POTION_RED = Registry.register(Registries.ITEM, "potion_red", {
	name = "Red Potion",
	description = "A red potion.",
	rarity = "rare",
	type = "potion",
})

Items.POTION_GREEN = Registry.register(Registries.ITEM, "potion_green", {
	name = "Green Potion",
	description = "A green potion.",
	rarity = "rare",
	type = "potion",
})

Items.POTION_YELLOW = Registry.register(Registries.ITEM, "potion_yellow", {
	name = "Yellow Potion",
	description = "A yellow potion.",
	rarity = "rare",
	type = "potion",
})

-- getter
function Items.get(id: string)
	return Registries.ITEM:get(id)
end

return Items :: Items
