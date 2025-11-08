local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local MiningServiceClient = require(ReplicatedStorage.Shared.services.MiningService.MiningServiceClient)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)
local e = React.createElement

local function MiningBottomBar()
	local shown = ReactCharm.useAtom(miningSlice.states.mining)

	return e(
		SlideOutFrame,
		{
			Size = UDim2.new(0, 2500, 0, 400),
			AnchorPoint = Vector2.new(0.5, 1),
			From = UDim2.new(0.5, 0, 1, -25),
			To = UDim2.new(0.5, 0, 1.2, 0),
			Speed = 10,
			Shown = shown,
			children = {
				e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				e(
					Button,
					{
						Size = UDim2.new(1, 0, 1, 0),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
						Image = ImageIds.close,
						onClick = function()
							MiningServiceClient:stopMining()
						end,
						Children = {
							e(
								TextLabel,
								{
									Text = "Exit",
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0.3, 0),
									Position = UDim2.new(0.5, 0, 1, 0),
									AnchorPoint = Vector2.new(0.5, 1),
									TextColor3 = Color3.new(1, 1, 1),
									TextScaled = true,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Center,
									TextYAlignment = Enum.TextYAlignment.Center,
									Font = Enum.Font.FredokaOne,
									Stroke = {
										Color = Color3.new(0, 0, 0),
										Thickness = 12.5,
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

return MiningBottomBar
