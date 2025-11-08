--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MiningFXServer = require(ServerScriptService.Server.services.MiningService.util.MiningFXServer)
local Networker = require(ReplicatedStorage.Packages.Networker)

MiningFXServer:init()

local MiningServiceServer = {}

local lastMined: { [number]: number } = {}

function MiningServiceServer.init(self: MiningServiceServer)
	self.networker = Networker.server.new("MiningService", self, {
		self.attemptMine :: any,
	})
end

function MiningServiceServer.attemptMine(self: MiningServiceServer, player: Player, target: BasePart)
	if not lastMined[player.UserId] or lastMined[player.UserId] + 1 < tick() then
		lastMined[player.UserId] = tick()

		self.networker:fire(player, "mine", target)
	end
end

type MiningServiceServer = typeof(MiningServiceServer) & {
	networker: Networker.Server,
}

return MiningServiceServer :: MiningServiceServer
