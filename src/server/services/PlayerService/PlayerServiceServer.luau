--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Networker = require(ReplicatedStorage.Packages.Networker)

local PlayerServiceServer = {}

function PlayerServiceServer.init(self: PlayerServiceServer)
	self.networker = Networker.server.new("PlayerService", self, {})

	local lastTick = 0
	RunService.Heartbeat:Connect(function()
		if tick() > lastTick + 1 then
			lastTick = tick()
			self.networker:fireAll("updateCurrency", 100)
		end
	end)
end

type PlayerServiceServer = typeof(PlayerServiceServer) & {
	networker: Networker.Server,
}

return PlayerServiceServer :: PlayerServiceServer
