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
	local function getHeight(children: { React.ReactElement<any> }): number
		local height = 0
		for _, child in pairs(children) do
			height += child.props.Size.Y.Offset + 6
		end
		return height
	end

	return e(Tooltip, {
		shown = props.shown,
		anchor = props.anchor,
		height = getHeight(props.children),
		children = {
			e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			table.unpack(props.children),
		},
	})
end

return ItemTooltip
