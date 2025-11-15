--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
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

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.L then
				print(DataService:get({ "inventory", "tools" }))
			end
		end
	end)
end

function PlayerServiceClient.setCurrency(self: PlayerServiceClient, amount: number)
	hudSlice.actions.setCurrency(amount)
end

type PlayerServiceClient = typeof(PlayerServiceClient) & {
	networker: Networker.Client,
}

return PlayerServiceClient :: PlayerServiceClient
