--!strict

export type PlayerStats = {
	xp: number,
	mined: number,
	playTime: number,
}

export type Currency = {
	coins: number,
}

export type ToolData = {
	equipped: string?,
}

export type ToolInstance = {
	id: string,
	guid: string,
	data: { level: number, xp: number },
	upgrades: {},
}

export type InventoryCategory = "tool" | "upgrade" | "potion" | "item"

export type InventoryEntry = {
	id: string,
	guid: string,
	type: "tool" | "item",
	amount: number,

	toolData: {
		level: number,
		xp: number,
		upgrades: { [string]: { id: string, level: number }? },
	}?,
}

export type Inventory = {
	[InventoryCategory]: { [string]: InventoryEntry },
}

export type SavedQuestProgress = {
	started: number,
	progress: {
		[string]: {
			current: number,
			target: number,
		},
	},
}

export type Quests = {
	active: { [string]: SavedQuestProgress },
	pinned: { [string]: true },
	completed: { [string]: true },
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
	quests: Quests,
	zones: ZoneData,
	crafting: Crafting,
	settings: Settings,
	statistics: StatsTracking,
}

local DefaultPlayerData: PlayerData = {
	version = 1,
	stats = {
		xp = 0,
		mined = 0,
		playTime = 0,
	},
	currency = {
		coins = 0,
	},
	tools = {
		equipped = nil,
	},
	inventory = {
		tool = {},
		upgrade = {},
		potion = {},
		item = {},
	},
	quests = {
		active = {},
		pinned = {},
		completed = {},
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
