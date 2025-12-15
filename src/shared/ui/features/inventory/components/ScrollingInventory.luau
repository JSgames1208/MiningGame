local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ScrollingItemLayout = require(ReplicatedStorage.Shared.ui.features.inventory.components.ScrollingItemLayout)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)
local e: typeof(React.createElement) = React.createElement

local function ScrollingInventory()
	local inventoryOpen = ReactCharm.useAtom(inventorySlice.states.inventoryOpen)
	local tab = ReactCharm.useAtom(inventorySlice.states.tab)
	local equippedToolId = ReactCharm.useAtom(toolSlice.states.equipped)

	if not inventoryOpen then
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

	return e(ScrollingItemLayout, {
		tab = tab,
		items = items,
		exitOnPress = false,
		clickCallback = tab == "tool" and toolSlice.actions.setEquipped or nil,
		equippedToolId = equippedToolId,
	})
end

return ScrollingInventory
