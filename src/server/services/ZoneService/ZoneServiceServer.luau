--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local Networker = require(ReplicatedStorage.Packages.Networker)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)

local ZoneServiceServer = {}

function ZoneServiceServer.init(self: ZoneServiceServer)
	self.networker = Networker.server.new("ZoneService", self, {
		self.attemptUnlockZone :: any,
	})
end

function ZoneServiceServer.onPlayerAdded(self: ZoneServiceServer, player: Player)
	self:loadPlayer(player)
end

function ZoneServiceServer.loadPlayer(self: ZoneServiceServer, player: Player)
	local playerZoneData = DataService:get(player, { "zones" })
	local unlockedZones = playerZoneData.unlockedZones

	for zoneId, _ in pairs(unlockedZones) do
		self:unlockZone(player, zoneId)
	end
end

function ZoneServiceServer.hasPreviousZone(self: ZoneServiceServer, player: Player, zoneId: string)
	local zoneEntry = Registries.ZONE:get(zoneId)

	if not zoneEntry then
		return false
	end

	local previousZoneId = zoneEntry.previous
	if not previousZoneId then
		return true
	end

	local playerZoneData = DataService:get(player, { "zones" })
	local unlockedZones = playerZoneData.unlockedZones

	return unlockedZones[previousZoneId]
end

function ZoneServiceServer.canAffordZone(self: ZoneServiceServer, player: Player, zoneId: string)
	local zoneEntry = Registries.ZONE:get(zoneId)

	if not zoneEntry then
		return false
	end

	local cost = zoneEntry.cost
	local playerCoins = DataService:get(player, { "currency", "coins" })

	return playerCoins >= cost
end

function ZoneServiceServer.canUnlockZone(self: ZoneServiceServer, player: Player, zoneId: string): (boolean, string?)
	if not self:hasPreviousZone(player, zoneId) then
		return false, "Unlock the previous zone first!"
	elseif not self:canAffordZone(player, zoneId) then
		return false, "Not enough coins!"
	end

	return true
end

function ZoneServiceServer.attemptUnlockZone(self: ZoneServiceServer, player: Player, zoneId: string)
	local canUnlock, err = self:canUnlockZone(player, zoneId)

	if canUnlock then
		local zoneEntry = Registries.ZONE:get(zoneId)
		if zoneEntry then
			local cost = zoneEntry.cost
			DataService:update(player, { "currency", "coins" }, function(currentValue: number)
				return currentValue - cost :: number
			end)

			self:unlockZone(player, zoneId)
		else
			return
		end
	else
		self:rejectUnlockZone(player, zoneId, err)
	end
end

function ZoneServiceServer.rejectUnlockZone(
	self: ZoneServiceServer,
	player: Player,
	zoneId: string,
	errorMessage: string?
)
	self.networker:fire(player, "unlockZone", zoneId, false, errorMessage)
end

function ZoneServiceServer.unlockZone(self: ZoneServiceServer, player: Player, zoneId: string)
	local zoneEntry = Registries.ZONE:get(zoneId)

	if zoneEntry then
		local playerZoneData = DataService:get(player, { "zones" })
		local unlockedZones = playerZoneData.unlockedZones
		unlockedZones[zoneId] = true

		DataService:set(player, { "zones" }, playerZoneData)

		self.networker:fire(player, "unlockZone", zoneId, true, nil)
	end
end

export type ZoneServiceServer = typeof(ZoneServiceServer) & {
	networker: Networker.Server,
}

return ZoneServiceServer :: ZoneServiceServer
