--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local Networker = require(ReplicatedStorage.Packages.Networker)

local PlayerServiceServer = {}

function PlayerServiceServer.init(self: PlayerServiceServer)
	self.networker = Networker.server.new("PlayerService", self, {})
end

function PlayerServiceServer.addCurrency(self: PlayerServiceServer, player: Player, amount: number)
	DataService:update(player, { "currency", "coins" }, function(currentValue: number)
		return currentValue + amount
	end)

	self.networker:fire(player, "setCurrency", DataService:get(player, { "currency", "coins" }))
end

function PlayerServiceServer.addXP(self: PlayerServiceServer, player: Player, amount: number)
	print("Add xp: " .. amount)
end

function PlayerServiceServer.onPlayerAdded(self: PlayerServiceServer, player: Player)
	DataService:waitForData(player)

	local coins = DataService:get(player, { "currency", "coins" })

	self.networker:fire(player, "setCurrency", coins)
end

type PlayerServiceServer = typeof(PlayerServiceServer) & {
	networker: Networker.Server,
}

return PlayerServiceServer :: PlayerServiceServer
