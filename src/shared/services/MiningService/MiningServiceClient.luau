--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local AnimationIds = require(ReplicatedStorage.Shared.services.AnimationService.AnimationIds)
local AnimationService = require(ReplicatedStorage.Shared.services.AnimationService.AnimationService)
local MiningFXService = require(ReplicatedStorage.Shared.services.MiningService.util.MiningFXService)
local MiningServiceUtil = require(ReplicatedStorage.Shared.services.MiningService.util.MiningServiceUtil)
local ToolRegistry = require(ReplicatedStorage.Shared.services.ToolService.util.ToolRegistry)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp: BasePart = character:WaitForChild("HumanoidRootPart")
local humanoid: Humanoid = character:WaitForChild("Humanoid")

type MinableData = MiningServiceUtil.MinableData

MiningFXService:init()

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
			if self.highlight then
				self.highlight:Destroy()
				self.highlight = nil
			end
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if mouse.Target and mouse.Target:HasTag("minable") then
				self.isHovering = true

				if self.highlight then
					self.highlight:Destroy()
				end

				self.highlight = Instance.new("Highlight")

				if not self.highlight then
					return
				end

				self.highlight.FillColor = Color3.fromRGB(255, 0, 0)
				self.highlight.Parent = mouse.Target
				self.highlight.Adornee = mouse.Target
				self.highlight.Enabled = true
				self.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

				if (hrp.Position - mouse.Target.Position).Magnitude > 40 then
					self.highlight.FillTransparency = 0.75
				else
					self.highlight.FillTransparency = 1
				end
			else
				self.isHovering = false
				if self.highlight then
					self.highlight:Destroy()
					self.highlight = nil
				end
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
	self.isHovering = false
	if self.highlight then
		self.highlight:Destroy()
		self.highlight = nil
	end

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

	task.delay(0.3, function()
		MiningFXService:mine(target)
	end)

	local toolData: ToolRegistry.ToolData = DataService:get({ "tools", "equipped" })
	local toolType = toolData.toolType

	local animationId = ""
	if toolType == "shovel" then
		animationId = AnimationIds.dig
	else
		animationId = AnimationIds.mine
	end

	self.animation = AnimationService:playAnimation(animationId or AnimationIds.mine, toolData.stats.miningSpeed)
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
	highlight: Highlight?,
}

return MiningServiceClient :: MiningServiceClient
