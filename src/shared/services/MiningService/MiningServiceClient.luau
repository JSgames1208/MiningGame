--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Networker = require(ReplicatedStorage.Packages.Networker)
local AnimationIds = require(ReplicatedStorage.Shared.services.AnimationService.AnimationIds)
local AnimationService = require(ReplicatedStorage.Shared.services.AnimationService.AnimationService)
local MiningFXService = require(ReplicatedStorage.Shared.services.MiningService.util.MiningFXService)
local MiningServiceUtil = require(ReplicatedStorage.Shared.services.MiningService.util.MiningServiceUtil)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)

type MinableData = MiningServiceUtil.MinableData

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
		if gameProcessed or miningSlice.states.mining() then
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
		if self.isHovering and not miningSlice.states.mining() then
			self.networker:fire("startMining", mouse.Target)
		end
	end)
end

function MiningServiceClient.startMining(self: MiningServiceClient, target: Part, minableData: MinableData)
	miningSlice.actions.setMining(true)
	miningSlice.actions.setCurrentTarget(target)
	miningSlice.actions.setCurrentHP(minableData.health)
	miningSlice.actions.setCurrentMaxHP(minableData.maxHealth)
	MiningFXService:startMining(target)

	self.mouseConn = mouse.Button1Down:Connect(function()
		self.networker:fire("attemptMine", target)
	end)
end

function MiningServiceClient.mine(self: MiningServiceClient, target: Part, currentHP: number)
	miningSlice.actions.setCurrentHP(miningSlice.states.currentHP(currentHP))

	self.animation = AnimationService:playAnimation(AnimationIds.mine, 1.5)
	if not self.animation then
		return
	end
	self.animation.Ended:Connect(function()
		self.animation = nil
	end)
end

function MiningServiceClient.stopMining(self: MiningServiceClient)
	miningSlice.actions.setMining(false)

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
	isHovering: boolean,
	mouseConn: RBXScriptConnection?,
	animation: AnimationTrack?,
}

return MiningServiceClient :: MiningServiceClient
