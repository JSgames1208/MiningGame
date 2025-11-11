local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local e: typeof(React.createElement) = React.createElement

local function BottomHUD()
	local shown = ReactCharm.useAtom(hudSlice.states.shown)

	return e(
		SlideOutFrame,
		{
			Shown = shown,
			AnchorPoint = Vector2.new(0.5, 1),
			From = UDim2.new(0.5, 0, 1, -25),
			To = UDim2.new(0.5, 0, 1.5, 0),
			Size = UDim2.new(0, 1000, 0, 400),
			BackgroundTransparency = 1,
			Speed = 8,
			children = {
				e(
					Button,
					{
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
						Image = ImageIds.icons.stone_pickaxe,
						ImageRectOffset = Vector2.zero,
						ImageRectSize = Vector2.new(1028, 1028),
						Mirror = true,
						onClick = function()
							inventorySlice.actions.setInventoryOpen(true)
						end,
						Children = {
							e(
								TextLabel,
								{
									Text = "Inventory",
									Font = Enum.Font.FredokaOne,
									Position = UDim2.new(0.5, 0, 1, 0),
									AnchorPoint = Vector2.new(0.5, 0.75),
									Size = UDim2.new(1, 0, 0.5, 0),
									TextScaled = true,
									TextWrapped = false,
									TextXAlignment = Enum.TextXAlignment.Center,
									TextYAlignment = Enum.TextYAlignment.Center,
									TextColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									ZIndex = 2,
									Stroke = {
										Color = Color3.fromRGB(0, 0, 0),
										Thickness = 10,
									},
								} :: TextLabel.Props
							),
						},
					} :: Button.ButtonProps
				),
			},
		} :: SlideOutFrame.SlideOutProps
	)
end

return BottomHUD
