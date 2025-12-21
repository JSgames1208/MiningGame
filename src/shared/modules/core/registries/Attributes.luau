local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local AttributeTypes = require(ReplicatedStorage.Shared.modules.core.types.AttributeTypes)

type Attribute = AttributeTypes.Attribute

export type Attributes = {
	MINING_SPEED: Attribute,
	MINING_POWER: Attribute,

	get: (id: string) -> Attribute?,
	idOf: (attribute: Attribute) -> string?,
}

local Attributes = {} :: Attributes

local function register(id: string, data: Attribute)
	Registries.ATTRIBUTE:register(id, data)
end

Attributes.MINING_SPEED = register("mining_speed", {
	defaultValue = 1,
	minValue = 0.01,
	maxValue = math.huge,
})

Attributes.MINING_POWER = register("mining_power", {
	defaultValue = 1,
	minValue = 0.01,
	maxValue = math.huge,
})

Attributes.COINS = register("coins", {
	defaultValue = 1,
	minValue = 0.01,
	maxValue = math.huge,
})

function Attributes.get(id: string): Attribute?
	return Registries.ATTRIBUTE:get(id)
end

function Attributes.idOf(attribute: Attribute): string?
	return Registries.ATTRIBUTE:idOf(attribute)
end

return Attributes
