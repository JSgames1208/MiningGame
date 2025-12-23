local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local MenuScreen = require(ReplicatedStorage.Shared.ui.core.components.MenuScreen)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local errorSlice = require(ReplicatedStorage.Shared.ui.features.error.state.errorSlice)
local e: typeof(React.createElement) = React.createElement

local function ErrorFrame()
	local shown = ReactCharm.useAtom(errorSlice.states.errorOpen)
	local message = ReactCharm.useAtom(errorSlice.states.errorMessage)

	return e(MenuScreen, {
		shown = shown,
		menuTitle = "Error",
		setOpen = errorSlice.actions.setErrorOpen,
		addCloseButton = false,
		children = {
			e(TextLabel, {
				Text = message,
				Font = Enum.Font.FredokaOne,
				Position = UDim2.new(0.5, 0, 0.15, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(0.9, 0, 0.5, 0),
				TextScaled = true,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Stroke = {
					Thickness = 10,
					Color = Color3.fromRGB(0, 0, 0),
				},
				Children = {},
			}),

			e(
				Button,
				{
					Size = UDim2.new(0.5, 0, 0.15, 0),
					Position = UDim2.new(0.5, 0, 0.9, 0),
					AnchorPoint = Vector2.new(0.5, 1),
					BackgroundColor3 = Color3.fromRGB(230, 0, 0),
					BackgroundTransparency = 0,
					hoverScale = 1.05,
					onClick = function()
						errorSlice.actions.setErrorOpen(false)
					end,
					Children = {
						e("UICorner", {
							CornerRadius = UDim.new(0.1, 0),
						}),
						e("UIStroke", {
							Color = Color3.fromRGB(100, 0, 0),
							Thickness = 10,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						}),
						e(TextLabel, {
							Text = "Close",
							Font = Enum.Font.FredokaOne,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0.9, 0, 0.9, 0),
							TextScaled = true,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							Stroke = {
								Thickness = 10,
								Color = Color3.fromRGB(0, 0, 0),
							},
							Children = {},
						}),
					},
				} :: Button.ButtonProps
			),
		},
	})
end

return ErrorFrame
