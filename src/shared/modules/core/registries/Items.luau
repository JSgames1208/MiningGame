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

	POTION_MINING_POWER_1: ItemData,
	POTION_MINING_SPEED_1: ItemData,
	POTION_COINS_1: ItemData,

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
		miningPower = 5,
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

Items.POTION_MINING_POWER_1 = Registry.register(Registries.ITEM, "potion.mining_power_1", {
	name = "Mining Power Potion I",
	description = "A mining power potion.",
	rarity = "rare",
	type = "potion",

	modifierId = "potion.mining_power_1",
})

Items.POTION_MINING_SPEED_1 = Registry.register(Registries.ITEM, "potion.mining_speed_1", {
	name = "Mining Speed Potion I",
	description = "A mining speed potion.",
	rarity = "rare",
	type = "potion",

	modifierId = "potion.mining_speed_1",
})

Items.POTION_COINS_1 = Registry.register(Registries.ITEM, "potion.coins_1", {
	name = "Coin Potion I",
	description = "A coins potion.",
	rarity = "rare",
	type = "potion",

	modifierId = "potion.coins_1",
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
