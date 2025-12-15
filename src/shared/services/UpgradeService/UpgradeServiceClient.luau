--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)

local UpgradeServiceClient = {}

function UpgradeServiceClient.init(self: UpgradeServiceClient)
	self.networker = Networker.client.new("UpgradeService", self)

	upgradeSlice.signals.selectToolRequest:Connect(function(guid: string)
		self:attemptSelectTool(guid)
	end)
	upgradeSlice.signals.selectUpgradeRequest:Connect(
		function(upgrade: { slot: string, upgradeData: { id: string, level: number } })
			self:attemptSelectUpgrade(upgrade)
		end
	)
	upgradeSlice.signals.removeUpgradeRequest:Connect(function(slot: string)
		local guid = upgradeSlice.states.selectedGuid()
		if self.networker:fetch("removeUpgradeRequest", guid, slot) then
			self:selectUpgrade({ slot = slot, upgradeData = nil })
		end
	end)
end

function UpgradeServiceClient.selectTool(self: UpgradeServiceClient, guid: string)
	upgradeSlice.actions.setSelectedGuid(guid)

	local tool = DataService:get({ "inventory", "tool", guid })
	if tool then
		upgradeSlice.actions.setSelectedUpgrades(tool.toolData.upgrades)
	end
end

function UpgradeServiceClient.attemptSelectTool(self: UpgradeServiceClient, guid: string)
	if self.networker:fetch("validateTool", guid) then
		self:selectTool(guid)
		return true
	end

	return false
end

function UpgradeServiceClient.selectUpgrade(
	self: UpgradeServiceClient,
	upgrade: { slot: string, upgradeData: { id: string, level: number }? }
)
	upgradeSlice.actions.setSelectedUpgrade(upgrade)
end

function UpgradeServiceClient.attemptSelectUpgrade(
	self: UpgradeServiceClient,
	upgrade: { slot: string, upgradeData: { id: string, level: number } }
)
	local selectedToolGuid = upgradeSlice.states.selectedGuid()
	if self.networker:fetch("selectUpgradeRequest", selectedToolGuid, upgrade) then
		self:selectUpgrade(upgrade)
	end
end

type UpgradeServiceClient = typeof(UpgradeServiceClient) & {
	networker: Networker.Client,
}

return UpgradeServiceClient :: UpgradeServiceClient
