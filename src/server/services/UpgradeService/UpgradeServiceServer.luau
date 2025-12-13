--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local Networker = require(ReplicatedStorage.Packages.Networker)

local UpgradeServiceServer = {}

function UpgradeServiceServer.init(self: UpgradeServiceServer)
	self.networker = Networker.server.new("UpgradeService", self, {})
end

function UpgradeServiceServer.onPlayerAdded(self: UpgradeServiceServer, player: Player)
	local equippedGuid = DataService:get(player, { "tools", "equipped" })

	self.networker:fire(player, "selectTool", equippedGuid)
end

function UpgradeServiceServer.validateTool(self: UpgradeServiceServer, player: Player, guid: string)
	return DataService:get(player, { "inventory", "tool", guid }) ~= nil
end

type UpgradeServiceServer = typeof(UpgradeServiceServer) & {
	networker: Networker.Server,
}

return UpgradeServiceServer :: UpgradeServiceServer
