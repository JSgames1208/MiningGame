--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local ErrorServiceClient = require(ReplicatedStorage.Shared.services.ErrorService.ErrorServiceClient)
local zoneSlice = require(ReplicatedStorage.Shared.ui.features.zones.state.zoneSlice)

local ZoneServiceClient = {}

function ZoneServiceClient.init(self: ZoneServiceClient)
	self.networker = Networker.client.new("ZoneService", self)

	self.proximityConnections = {}

	self:populateZoneGates()

	zoneSlice.signals.attemptUnlockSignal:Connect(function(zoneId: string)
		if not zoneId then
			return
		end

		self:attemptUnlockZone(zoneId)
	end)
end

function ZoneServiceClient.getGates(self: ZoneServiceClient)
	local gatesFolder = workspace:FindFirstChild("ZoneGates")

	return gatesFolder:GetChildren()
end

function ZoneServiceClient.populateZoneGates(self: ZoneServiceClient)
	local gates = self:getGates()

	for _, gate in pairs(gates) do
		if gate:GetAttribute("unlocks") then
			local id = gate:GetAttribute("unlocks")

			local zoneEntry = Registries.ZONE:get(id)

			if not zoneEntry then
				continue
			end

			local name = zoneEntry.name
			local cost = zoneEntry.cost :: number

			zoneSlice.actions.lockZone({ name = name, cost = cost, id = id })

			self.proximityConnections[id] = gate.Attachment.ProximityPrompt.Triggered:Connect(function(player)
				zoneSlice.actions.setConfirmMenuZoneId(id)
				zoneSlice.actions.setConfirmMenuOpen(true)
			end)
		end
	end
end

function ZoneServiceClient.unlockZone(self: ZoneServiceClient, zoneId: string, boolean: boolean, err: string)
	if boolean then
		print("Unlocked zone", zoneId)
		local gates = self:getGates()

		for _, gate in pairs(gates) do
			if gate:GetAttribute("unlocks") then
				local id = gate:GetAttribute("unlocks")

				if id == zoneId then
					gate:Destroy()
					if self.proximityConnections[zoneId] then
						self.proximityConnections[zoneId]:Disconnect()
						self.proximityConnections[zoneId] = nil
					end
				end
			end
		end

		zoneSlice.actions.unlockZone(zoneId)
	else
		ErrorServiceClient:displayError(err)
	end
end

function ZoneServiceClient.attemptUnlockZone(self: ZoneServiceClient, zoneId: string)
	self.networker:fire("attemptUnlockZone", zoneId)
end

export type ZoneServiceClient = typeof(ZoneServiceClient) & {
	networker: Networker.Client,
	proximityConnections: { [string]: RBXScriptConnection },
}

return ZoneServiceClient :: ZoneServiceClient
