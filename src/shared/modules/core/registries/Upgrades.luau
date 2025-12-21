local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local UpgradeType = require(ReplicatedStorage.Shared.modules.core.types.UpgradeType)

type UpgradeData<T> = UpgradeType.UpgradeData<T>

type Upgrades = {
	EFFICIENCY: UpgradeData<any>,
	FORTUNE: UpgradeData<any>,
	POWER: UpgradeData<any>,

	get: (id: string) -> UpgradeData<any>?,
	idOf: (upgrade: UpgradeData<any>) -> string?,
}

local Upgrades = {}

Upgrades.EFFICIENCY = Registry.register(Registries.UPGRADE, "efficiency", {
	name = "Efficiency",
	description = "Increases mining speed.",
	maxLevel = 3,
	levels = {
		[1] = "efficiency_i",
		[2] = "efficiency_ii",
		[3] = "efficiency_iii",
	},
	excludes = { "efficiency" },

	effect = {
		scaleType = "ADD",
		stats = {
			mining_speed = 0.2,
		},
	},
})

Upgrades.POWER = Registry.register(Registries.UPGRADE, "power", {
	name = "Power",
	description = "Increases mining power.",
	maxLevel = 3,
	levels = {
		[1] = "power_i",
		[2] = "power_ii",
		[3] = "power_iii",
	},
	excludes = { "power" },

	effect = {
		scaleType = "MULTIPLY_BASE",
		stats = {
			mining_power = 0.2,
		},
	},
})

Upgrades.FORTUNE = Registry.register(Registries.UPGRADE, "fortune", {
	name = "Fortune",
	description = "Chance to drop extra items.",
	maxLevel = 3,
	levels = {
		[1] = "fortune_i",
		[2] = "fortune_ii",
		[3] = "fortune_iii",
	},
	excludes = { "fortune" },

	effect = {
		scaleType = "ADD",
		dropMultiplier = 1,
	},
})

function Upgrades.get(id: string): UpgradeData<any>?
	return Registries.UPGRADE:get(id)
end

function Upgrades.idOf(upgrade: UpgradeData<any>): string?
	return Registries.UPGRADE:idOf(upgrade)
end

return Upgrades :: Upgrades
