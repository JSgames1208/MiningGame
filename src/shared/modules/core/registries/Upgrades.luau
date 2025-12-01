local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local UpgradeType = require(ReplicatedStorage.Shared.modules.core.types.UpgradeType)
type UpgradeData<T> = UpgradeType.UpgradeData<T>

type Upgrades = {
	EFFICIENCY: UpgradeData<any>,
	FORTUNE: UpgradeData<any>,

	get: (id: string) -> UpgradeData<any>?,
}

local Upgrades = {} :: Upgrades

Upgrades.EFFICIENCY = Registry.register(Registries.UPGRADE, "efficiency", {
	name = "Efficiency",
	description = "Increases mining speed.",
	maxLevel = 3,

	apply = function(item, level)
		print("APPLY UPGRADE")
	end,
})

Upgrades.FORTUNE = Registry.register(Registries.UPGRADE, "fortune", {
	name = "Fortune",
	description = "Chance to drop extra items.",
	maxLevel = 3,

	apply = function(item, level)
		print("APPLY UPGRADE")
	end,
})

function Upgrades.get(id: string): UpgradeData<any>?
	return Registries.UPGRADE:get(id)
end

return Upgrades :: Upgrades
