local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local ItemType = require(ReplicatedStorage.Shared.modules.core.types.ItemType)
local LootTableType = require(ReplicatedStorage.Shared.modules.core.types.LootTableType)
local OreType = require(ReplicatedStorage.Shared.modules.core.types.OreType)
local UpgradeType = require(ReplicatedStorage.Shared.modules.core.types.UpgradeType)
local ZoneType = require(ReplicatedStorage.Shared.modules.core.types.ZoneType)

type Registry<T> = Registry.Registry<T>

export type Registries = {
	ITEM: Registry.Registry<ItemType.ItemData>,
	UPGRADE: Registry.Registry<UpgradeType.UpgradeData<any>>,
	ORE: Registry.Registry<OreType.OreData>,
	LOOTTABLE: Registry.Registry<LootTableType.LootTable>,
	ZONE: Registry.Registry<ZoneType.ZoneData>,
}

local Registries: Registries = {
	ITEM = Registry.new() :: Registry<ItemType.ItemData>,
	UPGRADE = Registry.new() :: Registry<UpgradeType.UpgradeData<any>>,
	ORE = Registry.new() :: Registry<OreType.OreData>,
	LOOTTABLE = Registry.new() :: Registry<LootTableType.LootTable>,
	ZONE = Registry.new() :: Registry<ZoneType.ZoneData>,
}

return Registries
