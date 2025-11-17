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

export type InventoryCategory = "tools" | "materials" | "potions" | "items"

export type InventoryEntry = {
	id: string,
	guid: string?,
	type: "tool" | "item",
	amount: number,
	data: { [string]: any }?,
}

export type Inventory = {
	[InventoryCategory]: { [string]: InventoryEntry },
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
		tools = {},
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
