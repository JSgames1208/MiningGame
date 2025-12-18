local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local dialogueSlice = require(ReplicatedStorage.Shared.ui.features.dialogue.state.dialogueSlice)
local e: typeof(React.createElement) = React.createElement

local function DialogueFrame()
	local shown = ReactCharm.useAtom(dialogueSlice.states.dialoguePlaying)

	return e(SlideOutFrame, {
		Shown = shown,
		From = UDim2.new(0.5, 0, 0.98, 0),
		To = UDim2.new(0.5, 0, 1.5, 0),
		Size = UDim2.new(0, 2400, 0, 600),
		Speed = 8,
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(245, 245, 245),
		BorderSizePixel = 0,
		children = {},
	})
end

return DialogueFrame
