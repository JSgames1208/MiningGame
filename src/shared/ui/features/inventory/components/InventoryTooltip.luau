local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ItemTooltip = require(ReplicatedStorage.Shared.ui.features.inventory.components.ItemTooltip)
local e: typeof(React.createElement) = React.createElement

export type InventoryTooltipProps = {
	shown: boolean,
	anchor: React.Ref<GuiObject>,
	title: string,
	description: string,
	children: { React.ReactElement<any> },
}

local function InventoryTooltip(props: InventoryTooltipProps)
	return e(ItemTooltip, {
		shown = props.shown,
		anchor = props.anchor,
		children = {
			-- Title
			e(TextLabel, {
				Text = props.title,
				Size = UDim2.new(1, 0, 0, 75),
				TextXAlignment = Enum.TextXAlignment.Center,
				Position = UDim2.new(0, 0, 0, 0),
				Children = {},
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Stroke = {
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 2,
				},
				Font = Enum.Font.FredokaOne,
				TextScaled = true,
				LayoutOrder = 1,
				ZIndex = 50001,
			}),

			-- Description
			e(TextLabel, {
				Text = props.description,
				Size = UDim2.new(1, 0, 0, 40),
				TextXAlignment = Enum.TextXAlignment.Center,
				Position = UDim2.new(0, 0, 0, 0),
				TextColor3 = Color3.fromRGB(0, 0, 0),
				Children = {},
				TextScaled = true,
				LayoutOrder = 2,
				ZIndex = 50001,
			}),

			table.unpack(props.children),
		},
	})
end

return InventoryTooltip
