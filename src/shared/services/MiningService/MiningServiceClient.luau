--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Networker = require(ReplicatedStorage.Packages.Networker)
local AnimationIds = require(ReplicatedStorage.Shared.services.AnimationService.AnimationIds)
local AnimationService = require(ReplicatedStorage.Shared.services.AnimationService.AnimationService)
local MiningFXService = require(ReplicatedStorage.Shared.services.MiningService.util.MiningFXService)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)

MiningFXService:init()

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local MiningServiceClient = {}

function MiningServiceClient.init(self: MiningServiceClient)
	self.networker = Networker.client.new("MiningService", self)

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
			self:startMining(mouse.Target)
		end
	end)
end

function MiningServiceClient.startMining(self: MiningServiceClient, target: Part)
	self.isMining = true

	if target:HasTag("minable") then
		miningSlice.actions.setMining(true)
		miningSlice.actions.setCurrentTarget(target)
		miningSlice.actions.setCurrentHP(10000)
		miningSlice.actions.setCurrentMaxHP(10000)
		MiningFXService:startMining(target)

		self.mouseConn = mouse.Button1Down:Connect(function()
			self.networker:fire("attemptMine", target)
		end)
	end
end

function MiningServiceClient.mine(self: MiningServiceClient, target: Part)
	miningSlice.actions.setCurrentHP(miningSlice.states.currentHP() - 100)

	self.animation = AnimationService:playAnimation(AnimationIds.mine, 1.5)
	if not self.animation then
		return
	end
	self.animation.Ended:Connect(function()
		self.animation = nil
	end)
end

function MiningServiceClient.stopMining(self: MiningServiceClient)
	self.isMining = false
	if self.mouseConn then
		self.mouseConn:Disconnect()
		self.mouseConn = nil
	end

	miningSlice.actions.setMining(false)
	miningSlice.actions.setCurrentTarget(nil)

	MiningFXService:stopMining()
end

type MiningServiceClient = typeof(MiningServiceClient) & {
	networker: Networker.Client,
	isMining: boolean,
	isHovering: boolean,
	mouseConn: RBXScriptConnection?,
	animation: AnimationTrack?,
}

return MiningServiceClient :: MiningServiceClient
