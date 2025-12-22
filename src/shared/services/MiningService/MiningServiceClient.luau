--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Charm = require(ReplicatedStorage.Packages.Charm)
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local OreType = require(ReplicatedStorage.Shared.modules.core.types.OreType)
local HighlightUtils = require(ReplicatedStorage.Shared.modules.util.HighlightUtils)
local ModelUtils = require(ReplicatedStorage.Shared.modules.util.ModelUtils)
local AnimationIds = require(ReplicatedStorage.Shared.services.AnimationService.AnimationIds)
local AnimationService = require(ReplicatedStorage.Shared.services.AnimationService.AnimationService)
local MiningFXService = require(ReplicatedStorage.Shared.services.MiningService.util.MiningFXService)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

type OreInstance = OreType.OreInstance

MiningFXService:init()

local mouse = player:GetMouse()

local MiningServiceClient = {}

function MiningServiceClient.init(self: MiningServiceClient)
	self.networker = Networker.client.new("MiningService", self)

	Charm.subscribe(miningSlice.states.mining, function(mining: boolean)
		if not mining then
			self:stopMining()
		end
	end)

	self:handleInput()
end

local function mobileRaycast(position: Vector2)
	local camera = workspace.CurrentCamera
	local ray = camera:ScreenPointToRay(position.X, position.Y)
	return workspace:Raycast(ray.Origin, ray.Direction * 300)
end

function MiningServiceClient.handleInput(self: MiningServiceClient)
	self.isHovering = false

	UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if gameProcessed or miningSlice.states.mining() then
			self.isHovering = false
			HighlightUtils.removeAll()
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local model = ModelUtils.findTaggedParent(mouse.Target, "minable")

			if model then
				self.isHovering = true

				HighlightUtils.removeAll()

				local highlight = HighlightUtils.apply(model, Color3.fromRGB(255, 0, 0))

				local distance = (hrp.Position - ModelUtils.getPosition(model)).Magnitude
				highlight.FillTransparency = distance > 40 and 0.75 or 1
			else
				self.isHovering = false
				HighlightUtils.removeAll()
			end
		end
	end)

	mouse.Button1Down:Connect(function()
		if self.isHovering and not miningSlice.states.mining() and not hudSlice.states.screenCovered() then
			local model = ModelUtils.findTaggedParent(mouse.Target, "minable")

			if model then
				self.networker:fire("startMining", model)
			end
		end
	end)

	UserInputService.TouchMoved:Connect(function(touch)
		if miningSlice.states.mining() then
			return
		end

		local result = mobileRaycast(touch.Position)
		local model = result and ModelUtils.findTaggedParent(result.Instance, "minable")

		if model then
			self.isHovering = true

			HighlightUtils.removeAll()

			local highlight = HighlightUtils.apply(model, Color3.fromRGB(255, 0, 0))

			local distance = (hrp.Position - ModelUtils.getPosition(model)).Magnitude
			highlight.FillTransparency = distance > 40 and 0.75 or 1
		else
			self.isHovering = false
			HighlightUtils.removeAll()
		end
	end)

	-- MOBILE TAP SUPPORT
	UserInputService.TouchTap:Connect(function(touchPositions)
		if hudSlice.states.screenCovered() then
			return
		end

		local pos = touchPositions[1]
		local result = mobileRaycast(pos)

		local model = result and ModelUtils.findTaggedParent(result.Instance, "minable")

		if model then
			self.networker:fire("startMining", model)
		end
	end)
end

function MiningServiceClient.startMining(self: MiningServiceClient, target: Model, minableData: OreInstance)
	self.isHovering = false
	HighlightUtils.removeAll()

	miningSlice.actions.setMining(true)
	miningSlice.actions.setCurrentTarget(target)
	miningSlice.actions.setCurrentHP(minableData.health)
	miningSlice.actions.setCurrentMaxHP(minableData.oreData.maxHealth)
	inventorySlice.actions.setInventoryOpen(false)
	MiningFXService:startMining(target)

	self.mouseConn = mouse.Button1Down:Connect(function()
		self.networker:fire("attemptMine", target)
	end)
end

function MiningServiceClient.mine(self: MiningServiceClient, target: Model, currentHP: number, speed: number)
	miningSlice.actions.setCurrentHP(miningSlice.states.currentHP(currentHP))

	task.delay(0.3, function()
		MiningFXService:mine(target)
	end)

	local toolId: string = DataService:get({ "tools", "equipped" })
	local toolInstance: DataTemplate.InventoryEntry = DataService:get({ "inventory", "tool", toolId })
	local toolData = Registries.ITEM:get(toolInstance.id)

	if not toolData then
		return
	end
	local toolStats = toolData.toolStats
	if not toolStats then
		return
	end

	local toolType = toolStats.toolType

	local animationId = ""
	if toolType == "shovel" then
		animationId = AnimationIds.dig
	else
		animationId = AnimationIds.mine
	end

	self.animation = AnimationService:playAnimation(animationId or AnimationIds.mine, speed)
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

	--miningSlice.actions.setMining(false)
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
