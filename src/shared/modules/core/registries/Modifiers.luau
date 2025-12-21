local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local ModifierTypes = require(ReplicatedStorage.Shared.modules.core.types.ModifierTypes)

type Modifier = ModifierTypes.Modifier

export type Modifiers = {
	POTION_HASTE: Modifier,
	POTION_POWER: Modifier,

	get: (id: string) -> Modifier?,
	idOf: (attribute: Modifier) -> string?,
}

local Modifiers = {} :: Modifiers

local function register(id: string, data: Modifier)
	Registries.MODIFIER:register(id, data)
end

Modifiers.POTION_HASTE = register("potion_haste", {
	id = "potion_haste",
	type = "MULTIPLY_TOTAL",
	attribute = "mining_speed",
	value = 1.5,
	persistent = true,
})

Modifiers.POTION_POWER = register("potion_power", {
	id = "potion_power",
	type = "MULTIPLY_TOTAL",
	attribute = "mining_power",
	value = 1.5,
	persistent = true,
})

function Modifiers.get(id: string): Modifier?
	return Registries.MODIFIER:get(id)
end

function Modifiers.idOf(modifier: Modifier): string?
	return Registries.MODIFIER:idOf(modifier)
end

return Modifiers
