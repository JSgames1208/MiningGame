local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local ItemType = require(ReplicatedStorage.Shared.modules.core.types.ItemType)
local LootTableType = require(ReplicatedStorage.Shared.modules.core.types.LootTableType)
local OreType = require(ReplicatedStorage.Shared.modules.core.types.OreType)
local QuestType = require(ReplicatedStorage.Shared.modules.core.types.QuestType)
local UpgradeType = require(ReplicatedStorage.Shared.modules.core.types.UpgradeType)
local ZoneType = require(ReplicatedStorage.Shared.modules.core.types.ZoneType)

type Registry<T> = Registry.Registry<T>

export type Registries = {
	ITEM: Registry<ItemType.ItemData>,
	UPGRADE: Registry<UpgradeType.UpgradeData<any>>,
	ORE: Registry<OreType.OreData>,
	LOOTTABLE: Registry<LootTableType.LootTable>,
	ZONE: Registry<ZoneType.ZoneData>,
	QUEST: Registry<QuestType.QuestData>,
}

local Registries: Registries = {
	ITEM = Registry.new() :: Registry<ItemType.ItemData>,
	UPGRADE = Registry.new() :: Registry<UpgradeType.UpgradeData<any>>,
	ORE = Registry.new() :: Registry<OreType.OreData>,
	LOOTTABLE = Registry.new() :: Registry<LootTableType.LootTable>,
	ZONE = Registry.new() :: Registry<ZoneType.ZoneData>,
	QUEST = Registry.new() :: Registry<QuestType.QuestData>,
}

return Registries
