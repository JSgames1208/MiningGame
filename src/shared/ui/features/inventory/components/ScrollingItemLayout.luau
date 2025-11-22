local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local React = require(ReplicatedStorage.Packages.React)
local InventoryItem = require(ReplicatedStorage.Shared.ui.features.inventory.components.InventoryItem)
local e: typeof(React.createElement) = React.createElement

local function ScrollingItemLayout(props: {
	tab: string | Charm.Atom<string>,
	items: { { id: string, atom: any } },
	exitOnPress: boolean?,
	equippedToolId: string?,
})
	local rendered = {}

	local exitOnPress = props.exitOnPress ~= nil and props.exitOnPress or false

	for index, data in ipairs(props.items) do
		table.insert(
			rendered,
			e(
				InventoryItem,
				{
					key = props.tab .. "_" .. data.id,
					tab = props.tab,
					entryAtom = data.atom,
					equippedToolId = props.equippedToolId,
					exitOnPress = exitOnPress,
					LayoutOrder = index,
				} :: InventoryItem.InventoryItemProps
			)
		)
	end

	return e("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0.9, 0),
		Position = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(1, 1),
		ScrollBarThickness = 20,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromOffset(0, 0),
		ScrollBarImageTransparency = 0,
		ClipsDescendants = true,
		ZIndex = 4,
	}, {
		e("UIGridLayout", {
			CellPadding = UDim2.fromOffset(30, 30),
			CellSize = UDim2.fromOffset(200, 200),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		e("UIPadding", {
			PaddingBottom = UDim.new(0, 50),
			PaddingLeft = UDim.new(0, 50),
			PaddingRight = UDim.new(0, 50),
			PaddingTop = UDim.new(0, 50),
		}),
		table.unpack(rendered),
	})
end

return ScrollingItemLayout
