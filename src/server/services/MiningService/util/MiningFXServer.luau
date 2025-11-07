local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local MiningFXServer = {}

function MiningFXServer.init(self: MiningFXServer)
	self.networker = Networker.server.new("MiningFXService", self, {
		self.walkTo,
	})
end

function MiningFXServer.walkTo(self: MiningFXServer, player: Player, humanoid: Humanoid, position: Vector3)
	humanoid:MoveTo(position)
end

type MiningFXServer = typeof(MiningFXServer) & {
	networker: Networker.Server,
}

return MiningFXServer :: MiningFXServer
