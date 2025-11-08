local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid: Humanoid = character:WaitForChild("Humanoid")
local animator: Animator = humanoid:WaitForChild("Animator") :: Animator

local AnimationService = {}
local animationCache = {}

function AnimationService.init(self: AnimationService)
	return
end

function AnimationService.playAnimation(self: AnimationService, animationId: string, speed: number)
	local animation = animationCache[animationId]
	if not animation then
		animation = Instance.new("Animation")
		animation.AnimationId = animationId
		animationCache[animationId] = animation
	end

	local track = animator:LoadAnimation(animation)
	track:Play()
	track:AdjustSpeed(speed)

	return track
end

type AnimationService = typeof(AnimationService) & {}

return AnimationService
