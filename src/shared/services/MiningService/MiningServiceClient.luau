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
		if self.isHovering and not miningSlice.states.mining() and not hudSlice.states.screenCovered() then
			self.networker:fire("startMining", mouse.Target)
		end
	end)

	UserInputService.TouchMoved:Connect(function(touch)
		if miningSlice.states.mining() then
			return
		end

		local result = mobileRaycast(touch.Position)
		if not result or not result.Instance or not result.Instance:HasTag("minable") then
			self.isHovering = false
			if self.highlight then
				self.highlight:Destroy()
				self.highlight = nil
			end
			return
		end

		self.isHovering = true

		if self.highlight then
			self.highlight:Destroy()
		end

		self.highlight = Instance.new("Highlight")
		if self.highlight then
			self.highlight.FillColor = Color3.fromRGB(255, 0, 0)
			self.highlight.Parent = result.Instance
			self.highlight.Adornee = result.Instance
			self.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

			local dist = (hrp.Position - result.Position).Magnitude
			self.highlight.FillTransparency = dist > 40 and 0.75 or 1
		end
	end)

	-- MOBILE TAP SUPPORT
	UserInputService.TouchTap:Connect(function(touchPositions)
		if hudSlice.states.screenCovered() then
			return
		end

		local pos = touchPositions[1]
		local result = mobileRaycast(pos)

		if result and result.Instance and result.Instance:HasTag("minable") then
			if not result or not result.Instance then
				return
			end

			self.networker:fire("startMining", result.Instance)
		end
	end)
end

function MiningServiceClient.startMining(self: MiningServiceClient, target: Part, minableData: OreInstance)
	self.isHovering = false
	if self.highlight then
		self.highlight:Destroy()
		self.highlight = nil
	end

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

function MiningServiceClient.mine(self: MiningServiceClient, target: Part, currentHP: number, speed: number)
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
	highlight: Highlight?,
}

return MiningServiceClient :: MiningServiceClient
