local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LootTableType = require(ReplicatedStorage.Shared.modules.core.types.LootTableType)

export type OreData = {
	maxHealth: number,
	name: string,
}

export type OreEntry = {
	oreData: OreData,
	lootTable: LootTableType.LootTable,
}

export type OreInstance = {
	id: string,
	guid: string,
	health: number,
	oreData: OreData,
}

return {}
