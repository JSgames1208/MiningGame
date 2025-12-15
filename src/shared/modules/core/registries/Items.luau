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
	STONE: ItemData,
	COAL: ItemData,

	POTION_RED: ItemData,
	POTION_GREEN: ItemData,
	POTION_YELLOW: ItemData,

	EFFICIENCY_I: ItemData,
	EFFICIENCY_II: ItemData,
	EFFICIENCY_III: ItemData,

	get: (id: string) -> ItemData?,
	idOf: (item: ItemData) -> string?,
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
		miningPower = 5,
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
	type = "item",
})

Items.STONE = Registry.register(Registries.ITEM, "stone", {
	name = "Stone",
	description = "A block of stone.",
	rarity = "common",
	type = "item",
})

Items.COAL = Registry.register(Registries.ITEM, "coal", {
	name = "Coal",
	description = "A block of coal.",
	rarity = "uncommon",
	type = "item",
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

Items.EFFICIENCY_I = Registry.register(Registries.ITEM, "efficiency_i", {
	name = "Efficiency I",
	description = "An efficiency I upgrade.",
	rarity = "common",
	type = "upgrade",

	upgrade = {
		id = "efficiency",
		level = 1,
	},
})

Items.EFFICIENCY_II = Registry.register(Registries.ITEM, "efficiency_ii", {
	name = "Efficiency II",
	description = "An efficiency II upgrade.",
	rarity = "uncommon",
	type = "upgrade",

	upgrade = {
		id = "efficiency",
		level = 2,
	},
})

Items.EFFICIENCY_III = Registry.register(Registries.ITEM, "efficiency_iii", {
	name = "Efficiency III",
	description = "An efficiency III upgrade.",
	rarity = "rare",
	type = "upgrade",

	upgrade = {
		id = "efficiency",
		level = 3,
	},
})

Items.POWER_I = Registry.register(Registries.ITEM, "power_i", {
	name = "Power I",
	description = "A Power I upgrade.",
	rarity = "common",
	type = "upgrade",

	upgrade = {
		id = "power",
		level = 1,
	},
})

Items.POWER_II = Registry.register(Registries.ITEM, "power_ii", {
	name = "Power II",
	description = "A Power II upgrade.",
	rarity = "uncommon",
	type = "upgrade",

	upgrade = {
		id = "power",
		level = 2,
	},
})

Items.POWER_III = Registry.register(Registries.ITEM, "power_iii", {
	name = "Power III",
	description = "A Power III upgrade.",
	rarity = "rare",
	type = "upgrade",

	upgrade = {
		id = "power",
		level = 3,
	},
})

-- getter
function Items.get(id: string)
	return Registries.ITEM:get(id)
end

function Items.idOf(item: ItemData)
	return Registries.ITEM:idOf(item)
end

return Items :: Items
