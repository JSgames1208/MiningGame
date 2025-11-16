local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemRegistry = require(ReplicatedStorage.Shared.modules.core.ItemRegistry)

export type RarityColors = { [ItemRegistry.ItemRarity]: Color3 }

local RarityColors: RarityColors = {
	["common"] = Color3.fromHex("adb5bd"),
	["uncommon"] = Color3.fromHex("00b4d8"),
	["rare"] = Color3.fromHex("70e000"),
}

return RarityColors
