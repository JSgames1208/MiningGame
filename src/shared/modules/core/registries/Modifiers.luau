local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local ModifierTypes = require(ReplicatedStorage.Shared.modules.core.types.ModifierTypes)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)

type Modifier = ModifierTypes.Modifier

export type Modifiers = {
	MINING_SPEED_1: Modifier,
	MINING_POWER_1: Modifier,

	get: (id: string) -> Modifier?,
	idOf: (attribute: Modifier) -> string?,
}

local Modifiers = {} :: Modifiers

local function register(id: string, data: Modifier)
	Registries.MODIFIER:register(id, data)
end

Modifiers.MINING_SPEED_1 = register("potion.mining_speed_1", {
	id = "potion.mining_speed_1",
	type = "MULTIPLY_TOTAL",
	attribute = "mining_speed",
	duration = 100,
	value = 0.5,

	icon = ImageIds.icons["potion.mining_speed_1"],
	displayName = "Mining Speed Potion I",
	description = "Increases mining speed by 50% for 3 seconds.",

	persistent = true,
})

Modifiers.MINING_POWER_1 = register("potion.mining_power_1", {
	id = "potion.mining_power_1",
	type = "MULTIPLY_TOTAL",
	attribute = "mining_power",
	duration = 100,
	value = 0.5,

	icon = ImageIds.icons["potion.mining_power_1"],
	displayName = "Mining Power Potion I",
	description = "Increases mining power by 50% for 3 seconds.",

	persistent = true,
})

Modifiers.COINS_1 = register("potion.coins_1", {
	id = "potion.coins_1",
	type = "MULTIPLY_TOTAL",
	attribute = "coins",
	duration = 100,
	value = 0.25,

	icon = ImageIds.icons["potion.coins_1"],
	displayName = "Coins Potion I",
	description = "Increases coins by 25% for 3 seconds.",

	persistent = true,
})

function Modifiers.get(id: string): Modifier?
	return Registries.MODIFIER:get(id)
end

function Modifiers.idOf(modifier: Modifier): string?
	return Registries.MODIFIER:idOf(modifier)
end

return Modifiers
