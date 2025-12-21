--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local AttributeServiceServer = require(ServerScriptService.Server.services.AttributeService.AttributeServiceServer)
local QuestSignals = require(ServerScriptService.Server.services.QuestService.QuestSignals)
local Networker = require(ReplicatedStorage.Packages.Networker)

local PlayerServiceServer = {}

function PlayerServiceServer.init(self: PlayerServiceServer)
	self.networker = Networker.server.new("PlayerService", self, {})
end

function PlayerServiceServer.addCurrency(
	self: PlayerServiceServer,
	player: Player,
	currencyType: string,
	baseAmount: number
)
	if currencyType ~= "coins" then
		warn("Game only supports 'coins' as currency type right now")
		return
	end

	local amount = baseAmount * AttributeServiceServer:get(player, "coins")

	DataService:update(player, { "currency", currencyType }, function(currentValue: number)
		return currentValue + amount
	end)

	QuestSignals.CurrencyAdded:Fire(player, currencyType, amount)

	self.networker:fire(player, "setCurrency", DataService:get(player, { "currency", currencyType }))
end

function PlayerServiceServer.addXP(self: PlayerServiceServer, player: Player, amount: number)
	DataService:update(player, { "stats", "xp" }, function(currentValue: number)
		return currentValue + amount
	end)
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
