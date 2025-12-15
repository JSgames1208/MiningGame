local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local Ores = require(ReplicatedStorage.Shared.modules.core.registries.Ores)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local ZoneType = require(ReplicatedStorage.Shared.modules.core.types.ZoneType)
export type Zones = {
	STONEHILL_FIELDS: ZoneType.ZoneData,
	COALRIDGE_PLAINS: ZoneType.ZoneData,

	get: (id: string) -> ZoneType.ZoneData?,
	idOf: (zone: ZoneType.ZoneData) -> string?,
}

local Zones = {} :: Zones

local function register(id: string, data: ZoneType.ZoneData)
	return Registry.register(Registries.ZONE, id, data)
end

Zones.STONEHILL_FIELDS = register("stonehill_fields", {
	name = "Stonehill Fields",
	description = "Stonehill Fields",
	ores = {
		weights = {
			[Ores.idOf(Ores.DIRT) :: string] = 100,
			[Ores.idOf(Ores.STONE) :: string] = 50,
		},
	},
})

Zones.COALRIDGE_PLAINS = register("coalridge_plains", {
	name = "Coalridge Plains",
	description = "Coalridge Plains",
	ores = {
		weights = {
			[Ores.idOf(Ores.STONE) :: string] = 100,
			[Ores.idOf(Ores.COAL) :: string] = 100,
		},
	},
})

function Zones.get(id: string)
	return Registries.ZONE:get(id)
end

function Zones.idOf(zone: ZoneType.ZoneData)
	return Registries.ZONE:idOf(zone)
end

return Zones
