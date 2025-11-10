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

export type ToolData = {
	equipped: ToolRegistry.ToolData?,
}

export type Inventory = {
	items: { [string]: number },
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
		equipped = table.clone(ToolRegistry["wooden_shovel"]),
	},
	inventory = {
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
