--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Networker = require(ReplicatedStorage.Packages.Networker)
local MiningFXService = require(ReplicatedStorage.Shared.services.MiningService.util.MiningFXService)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)

MiningFXService:init()

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local MiningServiceClient = {}

function MiningServiceClient.init(self: MiningServiceClient)
	self:handleInput()
end

function MiningServiceClient.handleInput(self: MiningServiceClient)
	self.isHovering = false

	UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if gameProcessed or self.isMining then
			self.isHovering = false
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if mouse.Target and mouse.Target:HasTag("minable") then
				self.isHovering = true
			else
				self.isHovering = false
			end
		end
	end)

	mouse.Button1Down:Connect(function()
		if self.isHovering and not self.isMining then
			self:startMining()
		end
	end)
end

function MiningServiceClient.startMining(self: MiningServiceClient)
	self.isMining = true

	local target = mouse.Target
	if target:HasTag("minable") then
		miningSlice.actions.setMining(true)
		MiningFXService:startMining(target)
	end
end

function MiningServiceClient.stopMining(self: MiningServiceClient)
	self.isMining = false

	miningSlice.actions.setMining(false)

	MiningFXService:stopMining()
end

type MiningServiceClient = typeof(MiningServiceClient) & {
	isMining: boolean,
	isHovering: boolean,
	networker: Networker.Client,
}

return MiningServiceClient :: MiningServiceClient
