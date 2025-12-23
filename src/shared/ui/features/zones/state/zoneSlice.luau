local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Signal = require(ReplicatedStorage.Packages.Signal)
local ZoneType = require(ReplicatedStorage.Shared.modules.core.types.ZoneType)
local atom: typeof(Charm.atom) = Charm.atom

-- TYPE DEFS

type Atom<T> = Charm.Atom<T>
type ZoneData = ZoneType.ZoneUIData

-- STATES

local lockedZoneIds: Charm.Atom<{ string }> = atom({})
local zoneById: { [string]: Atom<ZoneData> } = {}

local confirmMenuOpen: Atom<boolean> = atom(false)
local confirmMenuZoneId: Atom<string> = atom("")

-- SIGNALS

local attemptUnlockSignal = Signal.new()

-- ACTIONS

local actions = {
	lockZone = function(zone: ZoneData)
		zoneById[zone.id] = atom(zone)
		lockedZoneIds(function(list)
			return Sift.Array.push(list, zone.id)
		end)
	end,
	unlockZone = function(zoneId: string)
		zoneById[zoneId] = nil
		lockedZoneIds(function(list)
			return Sift.Array.filter(list, function(id)
				return id ~= zoneId
			end)
		end)
	end,
	getZoneById = function(id: string)
		return zoneById[id]
	end,
	setConfirmMenuZoneId = function(zoneId: string)
		confirmMenuZoneId(zoneId)
	end,
	setConfirmMenuOpen = function(open: boolean)
		confirmMenuOpen(open)

		if not open then
			confirmMenuZoneId("")
		end
	end,
}

return {
	states = {
		lockedZoneIds = lockedZoneIds,
		confirmMenuOpen = confirmMenuOpen,
		confirmMenuZoneId = confirmMenuZoneId,
	},
	signals = {
		attemptUnlockSignal = attemptUnlockSignal,
	},
	actions = actions,
}
