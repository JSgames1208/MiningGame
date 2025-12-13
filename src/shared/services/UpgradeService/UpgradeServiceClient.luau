--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)

local UpgradeServiceClient = {}

function UpgradeServiceClient.init(self: UpgradeServiceClient)
	self.networker = Networker.client.new("UpgradeService", self)
end

function UpgradeServiceClient.selectTool(self: UpgradeServiceClient, guid: string)
	upgradeSlice.actions.setSelectedGuid(guid)
end

function UpgradeServiceClient.attemptSelect(self: UpgradeServiceClient, guid: string)
	if self.networker:fetch("validateTool", guid) then
		self:selectTool(guid)
		return true
	end

	return false
end

type UpgradeServiceClient = typeof(UpgradeServiceClient) & {
	networker: Networker.Client,
}

return UpgradeServiceClient :: UpgradeServiceClient
