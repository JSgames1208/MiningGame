local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemType = require(ReplicatedStorage.Shared.modules.core.types.ItemType)

export type RarityColors = { [ItemType.ItemRarity]: Color3 } & { fallback: Color3 }

local RarityColors: RarityColors = {
	["common"] = Color3.fromHex("adb5bd"),
	["uncommon"] = Color3.fromHex("#00c7ef"),
	["rare"] = Color3.fromHex("70e000"),
	fallback = Color3.fromHex("adb5bd"),
}

return RarityColors
