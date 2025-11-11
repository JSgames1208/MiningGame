--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)

local PlayerServiceClient = {}

function PlayerServiceClient.init(self: PlayerServiceClient)
	self.networker = Networker.client.new("PlayerService", self)

	hudSlice.actions.setCurrency(DataService:get({ "currency", "coins" }))

	DataService:getChangedSignal({ "currency", "coins" }):Connect(function(amount: number)
		hudSlice.actions.setCurrency(amount)
	end)
end

function PlayerServiceClient.setCurrency(self: PlayerServiceClient, amount: number)
	hudSlice.actions.setCurrency(amount)
end

type PlayerServiceClient = typeof(PlayerServiceClient) & {
	networker: Networker.Client,
}

return PlayerServiceClient :: PlayerServiceClient
