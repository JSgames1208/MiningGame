--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local XpUtil = require(ReplicatedStorage.Shared.services.PlayerService.XpUtil)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)

local PlayerServiceClient = {}

function PlayerServiceClient.init(self: PlayerServiceClient)
	self.networker = Networker.client.new("PlayerService", self)

	self:setCurrency(DataService:get({ "currency", "coins" }))

	local levelInfo = XpUtil.getLevelProgress(DataService:get({ "stats", "xp" }))

	self:setLevel(levelInfo.level)
	self:setXP(levelInfo.xpIntoLevel)
	self:setMaxXP(levelInfo.xpNeeded)

	DataService:getChangedSignal({ "currency", "coins" }):Connect(function(amount: number)
		self:setCurrency(amount)
	end)

	DataService:getChangedSignal({ "stats", "xp" }):Connect(function(xp: number)
		local levelInfo = XpUtil.getLevelProgress(xp)

		self:setLevel(levelInfo.level)
		self:setXP(levelInfo.xpIntoLevel)
		self:setMaxXP(levelInfo.xpNeeded)
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.L then
				print(DataService:get())
			end
		end
	end)
end

function PlayerServiceClient.setCurrency(self: PlayerServiceClient, amount: number)
	hudSlice.actions.setCurrency(amount)
end

function PlayerServiceClient.setLevel(self: PlayerServiceClient, level: number)
	hudSlice.actions.setLevel(level)
end

function PlayerServiceClient.setXP(self: PlayerServiceClient, xp: number)
	hudSlice.actions.setXP(xp)
end

function PlayerServiceClient.setMaxXP(self: PlayerServiceClient, maxXP: number)
	hudSlice.actions.setMaxXP(maxXP)
end

type PlayerServiceClient = typeof(PlayerServiceClient) & {
	networker: Networker.Client,
}

return PlayerServiceClient :: PlayerServiceClient
