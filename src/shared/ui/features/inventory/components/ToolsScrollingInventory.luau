local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)
local e: typeof(React.createElement) = React.createElement

local function ToolsScrollingInventory()
	local inventoryOpen = inventorySlice.states.inventoryOpen
	local tab = ReactCharm.useAtom(inventorySlice.states.tab)
	local equippedToolId = ReactCharm.useAtom(toolSlice.states.equipped)

	if tab ~= "tools" then
		return nil
	end

	if not inventoryOpen() then
		return nil
	end

	local inventory = inventorySlice.states.inventory()

	local toolCategory = inventory.tools or {}

	local items = {}

	for id, itemAtom in toolCategory do
		local stack = itemAtom()

		local toolId = stack.item.data.id
		local toolGuid = stack.item.id

		local equipped: boolean = equippedToolId == id

		table.insert(
			items,
			e(
				Button,
				{
					Size = UDim2.new(1, 0, 1, 0),
					Image = ImageIds.icons[toolId],
					BackgroundTransparency = 0,
					BackgroundColor3 = equipped and Color3.fromRGB(0, 230, 0) or Color3.fromRGB(210, 210, 210),
					onClick = function()
						toolSlice.actions.setEquipped(toolGuid)
					end,
					Children = {
						e("UICorner", {
							CornerRadius = UDim.new(0.2, 0),
						}),
						e("UIStroke", {
							Color = Color3.fromRGB(0, 0, 0),
							Thickness = 10,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						}),
					},
				} :: Button.ButtonProps
			)
		)
	end

	return e("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0.95, 0),
		Position = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(1, 1),
		ScrollBarThickness = 20,
		CanvasSize = UDim2.new(0, 0, 2, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarImageTransparency = 0,
		ClipsDescendants = true,
		ZIndex = 4,
	}, {
		e("UIGridLayout", {
			CellPadding = UDim2.new(0, 30, 0, 30),
			CellSize = UDim2.new(0, 200, 0, 200),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		e("UIPadding", {
			PaddingBottom = UDim.new(0, 30),
			PaddingLeft = UDim.new(0, 30),
			PaddingRight = UDim.new(0, 30),
			PaddingTop = UDim.new(0, 30),
		}),
		items,
	})
end

return ToolsScrollingInventory
