--!strict

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Networker = require(ReplicatedStorage.Packages.Networker)
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp: BasePart = character:WaitForChild("HumanoidRootPart")
local humanoid: Humanoid = character:WaitForChild("Humanoid")

local turningCircle: Part = workspace:WaitForChild("TurningCirclePart")

local depthOfField: DepthOfFieldEffect = Lighting:FindFirstChild("DepthOfField")

depthOfField.FarIntensity = 1

local playerModule = player.PlayerScripts.PlayerModule
local Controls = nil
if playerModule then
	Controls = (require(playerModule) :: any):GetControls()
end

local camera = workspace.CurrentCamera

local MiningFXService = {}

function MiningFXService.init(self: MiningFXService)
	self.networker = Networker.client.new("MiningFXService", self)
	return
end

function MiningFXService.startMining(self: MiningFXService, target: BasePart)
	local cameraCFrame = self:getCameraCFrame(target)

	Controls:Disable()

	camera.CameraType = Enum.CameraType.Scriptable

	depthOfField.Enabled = true

	self.cameraConn = RunService.RenderStepped:Connect(function(dt: number)
		camera.CFrame = camera.CFrame:Lerp(cameraCFrame, dt * 5)
		depthOfField.InFocusRadius = (cameraCFrame.Position - camera.CFrame.Position).Magnitude + 10

		if (camera.CFrame.Position - cameraCFrame.Position).Magnitude < 0.05 then
			if self.cameraConn then
				self.cameraConn:Disconnect()
				self.cameraConn = nil
			end
		end
	end)

	local direction = Vector3.new((hrp.Position - target.Position).X, 0, (hrp.Position - target.Position).Z)

	turningCircle.Position = target.Position + direction.Unit * 4 + Vector3.new(0, -target.Size.Y / 2 + 0.05, 0)

	self.networker:fire("walkTo", humanoid, target.Position + direction.Unit * 7)

	self.moveToConn = humanoid.MoveToFinished:Connect(function()
		if self.moveToConn then
			self.moveToConn:Disconnect()
		end

		self.turnConn = RunService.RenderStepped:Connect(function(dt: number)
			hrp.CFrame = hrp.CFrame:Lerp(
				CFrame.new(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)),
				dt * 4
			)

			local facingDiff = (hrp.CFrame.LookVector - (target.Position - hrp.Position).Unit).Magnitude
			if facingDiff < 0.01 then
				if self.turnConn then
					self.turnConn:Disconnect()
					self.turnConn = nil
				end
			end
		end)
	end)
end

function MiningFXService.mine(self: MiningFXService, target: BasePart)
	local particleAttachment: Attachment = target:FindFirstChild("ParticleAttachment") :: Attachment

	if not particleAttachment then
		return
	end

	particleAttachment.Position = (workspace.CurrentCamera.CFrame.Position - target.Position) / 3

	local particleEmitter: ParticleEmitter = particleAttachment:FindFirstChild("ParticleEmitter") :: ParticleEmitter

	particleEmitter:Emit(1)

	local function bobTarget(target: BasePart)
		local originalOrientation: Vector3 = target.Orientation
		local orientation = originalOrientation + Vector3.new(0, (math.random(1, 2) - 1.5) * 2 * 10, 0)
		local originalSize = target.Size
		local size = originalSize + Vector3.new(0.1, 0.1, 0.1)

		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true)
		local tween = TweenService:Create(target, tweenInfo, { Orientation = orientation, Size = size })
		tween:Play()
		tween.Completed:Wait()

		target.Orientation = originalOrientation
		tween:Destroy()
		tween = nil
	end

	bobTarget(target)
end

function MiningFXService.stopMining(self: MiningFXService)
	Controls:Enable()

	depthOfField.Enabled = false

	-- Clean up connections
	if self.cameraConn then
		self.cameraConn:Disconnect()
		self.cameraConn = nil
	end
	if self.turnConn then
		self.turnConn:Disconnect()
		self.turnConn = nil
	end
	if self.moveToConn then
		self.moveToConn:Disconnect()
		self.moveToConn = nil
	end

	local cameraCFrame = workspace.Camera.CFrame
	workspace.Camera.CameraType = Enum.CameraType.Custom
	RunService.RenderStepped:Wait()
	workspace.Camera.CFrame = cameraCFrame
end

function MiningFXService.getCameraCFrame(self: MiningFXService, target: BasePart): CFrame
	local distance = 10
	local direction = Vector3.new((hrp.Position - target.Position).X, 0, (hrp.Position - target.Position).Z).Unit
	local rightDirection = direction:Cross(Vector3.new(0, -1, 0)).Unit
	local height = 4

	local cameraPos = target.Position
		+ direction * distance
		+ Vector3.new(0, height, 0)
		+ (rightDirection * distance / 1.5)

	local cf = CFrame.new(cameraPos, target.Position - rightDirection * distance / 3 + Vector3.new(0, -2, 0))
	return cf
end

type MiningFXService = typeof(MiningFXService) & {
	networker: Networker.Client,
	cameraConn: RBXScriptConnection?,
	moveToConn: RBXScriptConnection?,
	turnConn: RBXScriptConnection?,
}

return MiningFXService :: MiningFXService
