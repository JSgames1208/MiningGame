local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ThemedFrame = require(ReplicatedStorage.Shared.ui.core.components.ThemedFrame)
local dialogueSlice = require(ReplicatedStorage.Shared.ui.features.dialogue.state.dialogueSlice)
local e: typeof(React.createElement) = React.createElement

local function DialogueFrame()
	local shown = ReactCharm.useAtom(dialogueSlice.states.dialoguePlaying)
	local speaker = ReactCharm.useAtom(dialogueSlice.states.dialogueSpeaker)
	local text = ReactCharm.useAtom(dialogueSlice.states.dialogueText)

	local choices = ReactCharm.useAtom(dialogueSlice.states.choices)

	local choiceFrame = nil
	if choices then
		local choiceButtons = {}

		for i, choice in ipairs(choices) do
			choiceButtons[i] = e(
				Button,
				{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0.25, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					Position = UDim2.new(0, 0, 0, 0),
					AnchorPoint = Vector2.new(0, 0),
					ZIndex = 5,
					onClick = function()
						dialogueSlice.signals.selectChoiceSignal:Fire(i)
					end,
					Children = {
						e(TextLabel, {
							Text = choice.text,
							Font = Enum.Font.FredokaOne,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0.8, 0, 0.8, 0),
							TextScaled = true,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextColor3 = Color3.fromRGB(0, 0, 0),
							ZIndex = 10,
							Children = {
								e("UIStroke", {
									Thickness = 5,
									Color = Color3.fromRGB(0, 0, 0),
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								}),
								e("UICorner", {
									CornerRadius = UDim.new(0.2, 0),
								}),
							},
						}),
					},
				} :: Button.ButtonProps
			)
		end

		choiceFrame = e("Frame", {
			Size = UDim2.new(0.4, 0, 1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			ZIndex = 5,
		}, {
			choiceButtons,
			e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDim.new(0, 10),
			}),
		})
	end

	local paddingVertical = 15
	local paddingHorizontal = 30

	return e(ThemedFrame, {
		shown = shown,
		Size = UDim2.new(0, 2400, 0, 600),
		From = UDim2.new(0.5, 0, 0.98, 0),
		To = UDim2.new(0.5, 0, 1.5, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		Speed = 10,
		children = {
			e("UIPadding", {
				PaddingTop = UDim.new(0, paddingVertical),
				PaddingBottom = UDim.new(0, paddingVertical),
				PaddingLeft = UDim.new(0, paddingHorizontal),
				PaddingRight = UDim.new(0, paddingHorizontal),
			}),
			choiceFrame,
			e(TextLabel, {
				Text = speaker,
				Font = Enum.Font.FredokaOne,
				Position = UDim2.new(0, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0.5, 0, 0.2, 0),
				TextScaled = true,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 5,
				Stroke = {
					Thickness = 10,
					Color = Color3.fromRGB(0, 0, 0),
				},
				Children = {},
			}),
			e(TextLabel, {
				Text = text,
				Font = Enum.Font.FredokaOne,
				Position = UDim2.new(0, 0, 0.2, 0),
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0.5, 0, 0.8, 0),
				TextScaled = true,
				TextWrapped = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = Color3.fromRGB(0, 0, 0),
				ZIndex = 5,
				Children = { e("UITextSizeConstraint", {
					MaxTextSize = 40,
				}) },
			}),
		},
	})
end

return DialogueFrame
