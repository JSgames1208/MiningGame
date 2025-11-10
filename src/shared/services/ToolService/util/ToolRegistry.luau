--!strict

export type ToolStats = {
	durability: number,
	miningPower: number,
	miningSpeed: number,
}

export type ToolData = {
	id: string,
	name: string,
	toolType: string,
	stats: ToolStats,
}

export type ToolRegistry = {
	[string]: ToolData,
}

local ToolRegistry: ToolRegistry = {
	wooden_shovel = {
		id = "wooden_shovel",
		name = "Wooden Shovel",
		toolType = "shovel",
		stats = {
			durability = 50,
			miningPower = 1,
			miningSpeed = 1.0,
		},
	},
	wooden_pickaxe = {
		id = "wooden_pickaxe",
		name = "Wooden Pickaxe",
		toolType = "pickaxe",
		stats = {
			durability = 60,
			miningPower = 1,
			miningSpeed = 1.0,
		},
	},
	stone_pickaxe = {
		id = "stone_pickaxe",
		name = "Stone Pickaxe",
		toolType = "pickaxe",
		stats = {
			durability = 120,
			miningPower = 2,
			miningSpeed = 1.2,
		},
	},
}

return ToolRegistry
