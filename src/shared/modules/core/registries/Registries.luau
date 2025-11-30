local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local ItemType = require(ReplicatedStorage.Shared.modules.core.types.ItemType)

type Registry<T> = Registry.Registry<T>

export type Registries = {
	ITEM: Registry.Registry<ItemType.ItemData>,
}

local Registries: Registries = {
	ITEM = Registry.new() :: Registry<ItemType.ItemData>,
}

return Registries
