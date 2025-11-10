--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)

local PlayerServiceClient = {}

function PlayerServiceClient.init(self: PlayerServiceClient)
	self.networker = Networker.client.new("PlayerService", self)
end

function PlayerServiceClient.setCurrency(self: PlayerServiceClient, amount: number)
	hudSlice.actions.setCurrency(amount)
end

type PlayerServiceClient = typeof(PlayerServiceClient) & {
	networker: Networker.Client,
}

return PlayerServiceClient :: PlayerServiceClient
