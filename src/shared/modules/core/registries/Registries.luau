local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local ItemType = require(ReplicatedStorage.Shared.modules.core.types.ItemType)
local UpgradeType = require(ReplicatedStorage.Shared.modules.core.types.UpgradeType)

type Registry<T> = Registry.Registry<T>

export type Registries = {
	ITEM: Registry.Registry<ItemType.ItemData>,
	UPGRADE: Registry.Registry<UpgradeType.UpgradeData<any>>,
}

local Registries: Registries = {
	ITEM = Registry.new() :: Registry<ItemType.ItemData>,
	UPGRADE = Registry.new() :: Registry<UpgradeType.UpgradeData<any>>,
}

return Registries
