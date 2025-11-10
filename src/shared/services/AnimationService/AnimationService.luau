local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimationIds = require(ReplicatedStorage.Shared.services.AnimationService.AnimationIds)
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid: Humanoid = character:WaitForChild("Humanoid")
local animator: Animator = humanoid:WaitForChild("Animator") :: Animator

local AnimationService = {}
local animationCache = {}

function AnimationService.init(self: AnimationService)
	for _, animationId in pairs(AnimationIds) do
		local track = animationCache[animationId]
		if not track then
			local animation = Instance.new("Animation")
			animation.AnimationId = animationId
			track = animator:LoadAnimation(animation)
			animationCache[animationId] = track
		end
	end
end

function AnimationService.playAnimation(self: AnimationService, animationId: string, speed: number)
	local track = animationCache[animationId]
	if not track then
		local animation = Instance.new("Animation")
		animation.AnimationId = animationId
		track = animator:LoadAnimation(animation)
		animationCache[animationId] = track
	end

	track:Play()
	track:AdjustSpeed(speed)

	return track
end

type AnimationService = typeof(AnimationService) & {}

return AnimationService
