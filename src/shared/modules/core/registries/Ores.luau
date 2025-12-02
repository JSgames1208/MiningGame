--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OreType = require(ReplicatedStorage.Shared.modules.core.types.OreType)

type OreData = OreType.OreData

export type Ores = {
	DIRT: OreData,
}

local Ores = {} :: Ores

Ores.DIRT = {
	name = "Dirt",
	maxHealth = 10,
}

return Ores
