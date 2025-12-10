local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local LootTableType = require(ReplicatedStorage.Shared.modules.core.types.LootTableType)

type LootTable = LootTableType.LootTable

export type LootTables = {
	DIRT: LootTable,
	STONE: LootTable,

	get: (id: string) -> LootTable?,
	idOf: (lootTable: LootTable) -> string?,
}

local LootTables = {} :: LootTables

LootTables.DIRT = Registry.register(Registries.LOOTTABLE, "dirt", {
	maxChance = 10000,
	drops = {
		{ id = "dirt", min = 1, max = 3, chance = 10000 },
		{ id = "wooden_pickaxe", min = 1, max = 1, chance = 7500 },
		{ id = "stone_pickaxe", min = 1, max = 1, chance = 2500 },
	},
	xp = {
		mining = 5,
		player = 3,
	},
})

function LootTables.get(id: string)
	return Registries.LOOTTABLE:get(id)
end

function LootTables.idOf(lootTable: LootTable)
	return Registries.LOOTTABLE:idOf(lootTable)
end

return LootTables
