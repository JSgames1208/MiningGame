local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local InventoryItem = require(ReplicatedStorage.Shared.ui.features.inventory.components.InventoryItem)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)
local e: typeof(React.createElement) = React.createElement

local function ScrollingInventory()
	local inventoryOpen = inventorySlice.states.inventoryOpen
	local tab = ReactCharm.useAtom(inventorySlice.states.tab)
	local equippedToolId = ReactCharm.useAtom(toolSlice.states.equipped)

	if not inventoryOpen() then
		return nil
	end

	local inventory = inventorySlice.states.inventory()
	local categoryMap = inventory[tab]

	local items = {}

	for id, entryAtom in categoryMap do
		table.insert(items, { id = id, atom = entryAtom })
	end

	table.sort(items, function(a, b)
		local aEntry = a.atom()
		local bEntry = b.atom()

		-- equipped tool goes first
		local aIsEquipped = aEntry.guid == equippedToolId
		local bIsEquipped = bEntry.guid == equippedToolId

		if aIsEquipped and not bIsEquipped then
			return true
		end
		if bIsEquipped and not aIsEquipped then
			return false
		end

		-- otherwise alphabetical
		return aEntry.id < bEntry.id
	end)

	local rendered = {}
	for index, data in ipairs(items) do
		table.insert(
			rendered,
			e(
				InventoryItem,
				{
					key = tab .. "_" .. data.id,
					tab = tab,
					entryAtom = data.atom,
					equippedToolId = equippedToolId,
					LayoutOrder = index, -- 👈 ADD THIS
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

return ScrollingInventory
