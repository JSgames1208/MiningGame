export type Drop = {
	id: string,
	min: number,
	max: number,
	chance: number,
}

export type ItemType = "tools" | "materials" | "potions" | "items"

export type Drops = { [ItemType]: { Drop } }

export type XP = {
	mining: number,
	player: number,
}

export type LootTable = {
	maxChance: number,
	drops: Drops?,
	xp: XP?,
}

export type LootTables = {
	[string]: LootTable,
}

local LootTables: LootTables = {
	["dirt"] = {
		maxChance = 10000,
		drops = {
			materials = { { id = "dirt", min = 1, max = 3, chance = 10000 } },
			tools = {
				{ id = "wooden_pickaxe", min = 1, max = 1, chance = 7500 },
				{ id = "stone_pickaxe", min = 1, max = 1, chance = 2500 },
			},
		},
		xp = {
			mining = 5,
			player = 3,
		},
	},
}

return LootTables
