export type ItemRarity = "common" | "uncommon" | "rare"

export type ItemData = {
	name: string,
	description: string,
	rarity: ItemRarity,
}

export type ItemRegistry = {
	[string]: ItemData,
}

local ItemRegistry: ItemRegistry = {
	["wooden_pickaxe"] = {
		name = "Wooden Pickaxe",
		description = "A wooden pickaxe.",
		rarity = "common",
	},
	["stone_pickaxe"] = {
		name = "Stone Pickaxe",
		description = "A stone pickaxe.",
		rarity = "uncommon",
	},
	["dirt"] = {
		name = "Dirt",
		description = "A ball of dirt.",
		rarity = "common",
	},
	["potion_red"] = {
		name = "Red Potion",
		description = "A red potion.",
		rarity = "rare",
	},
	["potion_green"] = {
		name = "Green Potion",
		description = "A green potion.",
		rarity = "rare",
	},
	["potion_yellow"] = {
		name = "Yellow Potion",
		description = "A yellow potion.",
		rarity = "rare",
	},
}

return ItemRegistry
