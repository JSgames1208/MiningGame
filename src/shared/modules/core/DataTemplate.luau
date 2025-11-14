--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToolRegistry = require(ReplicatedStorage.Shared.services.ToolService.util.ToolRegistry)

export type PlayerStats = {
	level: number,
	xp: number,
	mined: number,
	playTime: number,
}

export type Currency = {
	coins: number,
}

export type ToolInstance = {
	id: string,
	data: ToolRegistry.ToolData,
	upgrades: {},
}

export type ToolData = {
	equipped: string?,
}

export type PotionStack = {
	id: string,
	amount: number,
}

export type ItemStack = {
	id: string,
	amount: number,
}

export type MaterialStack = {
	id: string,
	amount: number,
}

export type Inventory = {
	tools: { [string]: ToolInstance },
	potions: { [string]: PotionStack },
	materials: { [string]: MaterialStack },
	items: { [string]: ItemStack },
}

export type ZoneData = {
	unlockedZones: { [string]: boolean },
	lastZone: string?,
}

export type Crafting = {
	knownRecipes: { [string]: boolean },
}

export type Settings = {
	sfxEnabled: boolean,
	musicEnabled: boolean,
	notifications: boolean,
}

export type StatsTracking = {
	totalCoinsEarned: number,
	totalMined: number,
	totalCrafted: number,
}

export type PlayerData = {
	version: number,
	stats: PlayerStats,
	currency: Currency,
	tools: ToolData,
	inventory: Inventory,
	zones: ZoneData,
	crafting: Crafting,
	settings: Settings,
	statistics: StatsTracking,
}

local DefaultPlayerData: PlayerData = {
	version = 1,
	stats = {
		level = 0,
		xp = 0,
		mined = 0,
		playTime = 0,
	},
	currency = {
		coins = 0,
	},
	tools = {
		equipped = "tool_1",
	},
	inventory = {
		tools = {
			["tool_1"] = {
				id = "tool_1",
				data = ToolRegistry["wooden_pickaxe"],
				upgrades = {},
			},
		},
		materials = {},
		potions = {},
		items = {},
	},
	zones = {
		unlockedZones = { ["zone_1"] = true },
		lastZone = "zone_1",
	},
	crafting = {
		knownRecipes = {},
	},
	settings = {
		sfxEnabled = true,
		musicEnabled = true,
		notifications = true,
	},
	statistics = {
		totalCoinsEarned = 0,
		totalMined = 0,
		totalCrafted = 0,
	},
}

return DefaultPlayerData
