local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local LootTableType = require(ReplicatedStorage.Shared.modules.core.types.LootTableType)

type LootTable = LootTableType.LootTable

export type LootTables = {
	DIRT: LootTable,
	STONE: LootTable,
	COAL: LootTable,

	get: (id: string) -> LootTable?,
	idOf: (lootTable: LootTable) -> string?,
}

local LootTables = {} :: LootTables

LootTables.DIRT = Registry.register(Registries.LOOTTABLE, "dirt", {
	maxChance = 10000,
	drops = {
		{ id = "efficiency_i", min = 1, max = 1, chance = 1000 },
		{ id = "power_i", min = 1, max = 1, chance = 1000 },
		{ id = "stone_pickaxe", min = 1, max = 1, chance = 500 },
		{ id = "dirt", min = 2, max = 4, chance = 10000 },
	},
	xp = {
		mining = 5,
		player = 3,
	},
})

LootTables.STONE = Registry.register(Registries.LOOTTABLE, "stone", {
	maxChance = 10000,
	drops = {
		{ id = "efficiency_i", min = 1, max = 1, chance = 2500 },
		{ id = "power_i", min = 1, max = 1, chance = 2500 },
		{ id = "efficiency_ii", min = 1, max = 1, chance = 1000 },
		{ id = "power_ii", min = 1, max = 1, chance = 1000 },
		{ id = "stone_pickaxe", min = 1, max = 1, chance = 1000 },
		{ id = "stone", min = 2, max = 4, chance = 10000 },
	},
	xp = {
		mining = 10,
		player = 10,
	},
})

LootTables.COAL = Registry.register(Registries.LOOTTABLE, "coal", {
	maxChance = 10000,
	drops = {
		{ id = "efficiency_ii", min = 1, max = 1, chance = 2500 },
		{ id = "power_ii", min = 1, max = 1, chance = 2500 },
		{ id = "efficiency_iii", min = 1, max = 1, chance = 500 },
		{ id = "power_iii", min = 1, max = 1, chance = 500 },
		{ id = "stone_pickaxe", min = 1, max = 1, chance = 2500 },
		{ id = "coal", min = 2, max = 4, chance = 10000 },
	},
	xp = {
		mining = 25,
		player = 100,
	},
})

function LootTables.get(id: string)
	return Registries.LOOTTABLE:get(id)
end

function LootTables.idOf(lootTable: LootTable)
	return Registries.LOOTTABLE:idOf(lootTable)
end

return LootTables
