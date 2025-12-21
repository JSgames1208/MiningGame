local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)

local ZoneServiceClient = {}

function ZoneServiceClient.init(self: ZoneServiceClient)
	self.networker = Networker.client.new("ZoneService", self)
end

function ZoneServiceClient.unlockZone(self: ZoneServiceClient, zoneId: string)
	local gatesFolder = workspace:FindFirstChild("ZoneGates")
	local gates = gatesFolder:GetChildren()

	for _, gate in pairs(gates) do
		if gate:GetAttribute("zoneId") then
			local id = gate:GetAttribute("zoneId")

			if id == zoneId then
				gate:Destroy()
			end
		end
	end
end

export type ZoneServiceClient = typeof(ZoneServiceClient) & {
	networker: Networker.Client,
}

return ZoneServiceClient :: ZoneServiceClient
