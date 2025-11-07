local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MiningFXServer = require(ServerScriptService.Server.services.MiningService.util.MiningFXServer)
local Networker = require(ReplicatedStorage.Packages.Networker)

MiningFXServer:init()

local MiningServiceServer = {}

function MiningServiceServer.init(self: MiningServiceServer)
	self.networker = Networker.server.new("MiningService", self)
end

type MiningServiceServer = typeof(MiningServiceServer) & {
	networker: Networker.Server,
}

return MiningServiceServer :: MiningServiceServer
