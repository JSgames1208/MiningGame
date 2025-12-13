local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local ItemImage = require(ReplicatedStorage.Shared.ui.core.components.ItemImage)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)
local e: typeof(React.createElement) = React.createElement

export type SelectedToolFrameProps = {
	selectedTool: any,
}

local function SelectedToolFrame(props: SelectedToolFrameProps)
	return e("Frame", {
		Size = UDim2.new(0.9, 0, 0.9, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
	}, {
		e(
			ItemImage,
			{
				itemId = props.selectedTool.id,
				equipped = false,
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
			} :: ItemImage.ItemImageProps
		),
		e(
			Button,
			{
				hoverScale = 1.05,
				Size = UDim2.new(0.95, 0, 0.2, 0),
				Position = UDim2.new(0.5, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(0, 225, 0),
				onClick = function()
					upgradeSlice.actions.setSelectToolMenuOpen(true)
				end,
				Children = {
					e("UICorner", { CornerRadius = UDim.new(0.2, 0) }),
					e("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 10 }),
					e(TextLabel, {
						Text = "Swap Tool!",
						Font = Enum.Font.FredokaOne,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = UDim2.new(0.9, 0, 0.9, 0),
						TextScaled = true,
						TextYAlignment = Enum.TextYAlignment.Center,
						Children = {},
					}),
				},
			} :: Button.ButtonProps
		),
	})
end

return SelectedToolFrame
