local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Tooltip = require(ReplicatedStorage.Shared.ui.features.inventory.components.Tooltip)
local e: typeof(React.createElement) = React.createElement

export type ItemTooltipProps = {
	shown: boolean,
	anchor: React.Ref<GuiObject>,
	children: { React.ReactElement<any> },
}

local function ItemTooltip(props: ItemTooltipProps)
	return e(Tooltip, {
		shown = props.shown,
		anchor = props.anchor,
		children = {
			e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			table.unpack(props.children),
		},
	})
end

return ItemTooltip
