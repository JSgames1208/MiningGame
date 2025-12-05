--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local OreType = require(ReplicatedStorage.Shared.modules.core.types.OreType)

type OreData = OreType.OreData

export type Ores = {
	DIRT: OreData,

	get: (id: string) -> OreData?,
	idOf: (ore: OreData) -> string?,
}

local Ores = {} :: Ores

Ores.DIRT = Registry.register(Registries.ORE, "dirt", {
	name = "Dirt",
	maxHealth = 10,
})

function Ores.get(id: string)
	return Registries.ORE:get(id)
end

function Ores.idOf(ore: OreData)
	return Registries.ORE:idOf(ore)
end

return Ores
