export type ItemType = "item"

export type ItemRarity = "common" | "uncommon" | "rare"

export type ToolStats = {
	toolType: "pickaxe" | "shovel",
	durability: number,
	miningPower: number,
	miningSpeed: number,
}

export type ItemData = {
	name: string,
	description: string,
	rarity: ItemRarity,
	type: "item" | "tool" | "upgrade" | "potion",

	toolStats: ToolStats?,
}

return {}
