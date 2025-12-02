local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local ItemType = require(ReplicatedStorage.Shared.modules.core.types.ItemType)
local OreType = require(ReplicatedStorage.Shared.modules.core.types.OreType)
local UpgradeType = require(ReplicatedStorage.Shared.modules.core.types.UpgradeType)

type Registry<T> = Registry.Registry<T>

export type Registries = {
	ITEM: Registry.Registry<ItemType.ItemData>,
	UPGRADE: Registry.Registry<UpgradeType.UpgradeData<any>>,
	ORE: Registry.Registry<OreType.OreData>,
}

local Registries: Registries = {
	ITEM = Registry.new() :: Registry<ItemType.ItemData>,
	UPGRADE = Registry.new() :: Registry<UpgradeType.UpgradeData<any>>,
	ORE = Registry.new() :: Registry<OreType.OreData>,
}

return Registries
