--!strict

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Networker = require(ReplicatedStorage.Packages.Networker)
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp: BasePart = character:WaitForChild("HumanoidRootPart")
local humanoid: Humanoid = character:WaitForChild("Humanoid")

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
		camera.CFrame = camera.CFrame:Lerp(cameraCFrame, dt * 4)
		depthOfField.InFocusRadius = (cameraCFrame.Position - camera.CFrame.Position).Magnitude + 10

		if (camera.CFrame.Position - cameraCFrame.Position).Magnitude < 0.05 then
			if self.cameraConn then
				self.cameraConn:Disconnect()
				self.cameraConn = nil
			end
		end
	end)

	local direction = Vector3.new((hrp.Position - target.Position).X, 0, (hrp.Position - target.Position).Z)

	self.networker:fire("walkTo", humanoid, target.Position + direction.Unit * 7)

	self.moveToConn = humanoid.MoveToFinished:Connect(function()
		if self.moveToConn then
			self.moveToConn:Disconnect()
		end
		task.defer(function()
			task.wait(0.01)
			hrp.Anchored = true
		end)

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

function MiningFXService.stopMining(self: MiningFXService)
	Controls:Enable()
	hrp.Anchored = false
	camera.CameraType = Enum.CameraType.Custom
	depthOfField.Enabled = false

	if self.cameraConn then
		print("DISCONNECT CAMERA")
		self.cameraConn:Disconnect()
		self.cameraConn = nil
	end
	if self.turnConn then
		print("DISCONNECT TURN")
		self.turnConn:Disconnect()
		self.turnConn = nil
	end
	if self.moveToConn then
		print("DISCONNECT MOVE")
		self.moveToConn:Disconnect()
		self.moveToConn = nil
	end
end

function MiningFXService.getCameraCFrame(self: MiningFXService, target: BasePart): CFrame
	local distance = 10
	local direction = Vector3.new((hrp.Position - target.Position).X, 0, (hrp.Position - target.Position).Z).Unit
	local rightDirection = direction:Cross(Vector3.new(0, -1, 0)).Unit
	local height = 4

	local cameraPos = target.Position
		+ direction * distance
		+ Vector3.new(0, height, 0)
		+ (rightDirection * distance / 2)

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
