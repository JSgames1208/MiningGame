local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ToolTip = require(ReplicatedStorage.Shared.ui.features.inventory.components.ToolTip)
local e: typeof(React.createElement) = React.createElement

export type ItemToolTipProps = {
	shown: boolean,
	title: string,
	description: string,
	anchor: React.Ref<GuiObject>,
}

local function ItemToolTip(props: ItemToolTipProps)
	local toolTipProps = {
		shown = props.shown,
		anchor = props.anchor,
		children = {
			e(
				TextLabel,
				{
					Text = props.title,
					Font = Enum.Font.FredokaOne,
					Size = UDim2.new(0.98, 0, 0.24, 0),
					Position = UDim2.new(0.5, 0, 0.005, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Top,
					ZIndex = 50001,
					Stroke = {
						Thickness = 3,
						Color = Color3.fromRGB(0, 0, 0),
					},
				} :: TextLabel.Props
			),
			e(
				TextLabel,
				{
					Text = props.description,
					Font = Enum.Font.FredokaOne,
					Size = UDim2.new(1, 0, 0.75, 0),
					Position = UDim2.new(0, 0, 0.25, 0),
					AnchorPoint = Vector2.new(0, 0),
					TextColor3 = Color3.fromRGB(0, 0, 0),
					TextScaled = true,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Top,
					ZIndex = 50001,
				} :: TextLabel.Props
			),
		},
	}

	return e(ToolTip, toolTipProps)
end

return ItemToolTip
