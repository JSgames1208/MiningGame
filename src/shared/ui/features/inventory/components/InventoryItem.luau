local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local Items = require(ReplicatedStorage.Shared.modules.core.registries.Items)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local ItemImage = require(ReplicatedStorage.Shared.ui.core.components.ItemImage)
local ItemWithAmount = require(ReplicatedStorage.Shared.ui.core.components.ItemWithAmount)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)
local tooltipSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.tooltipSlice)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)

local e: typeof(React.createElement) = React.createElement

type InventoryEntry = DataTemplate.InventoryEntry
type Atom<T> = Charm.Atom<T>

export type InventoryItemProps = {
	key: string,
	tab: string,
	entryAtom: Atom<InventoryEntry>,
	equippedToolId: string?,
	LayoutOrder: number,
	exitOnPress: boolean?,
}

local function InventoryItem(props: InventoryItemProps)
	local exitOnPress = props.exitOnPress ~= nil and props.exitOnPress or false

	local entry = ReactCharm.useAtom(props.entryAtom)

	local isTool = props.tab == "tool"

	local itemId = entry.id
	local amount = entry.amount

	local isEquipped = props.equippedToolId == entry.guid
	local anchorRef = React.useRef(nil)

	return e(Button, {
		ref = anchorRef,
		Size = UDim2.new(1, 0, 1, 0),
		Image = "",
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(220, 220, 220),
		ZIndex = 2,
		onClick = function()
			if isTool and entry.guid then
				toolSlice.actions.setEquipped(entry.guid)
			end

			local itemEntry = Items.get(entry.id)
			if itemEntry.upgrade then
				print(itemEntry.upgrade.id, itemEntry.upgrade.level)
			end

			if exitOnPress then
				miningSlice.actions.setSwapToolOpen(false)
				inventorySlice.actions.setInventoryOpen(false)
			end
		end,
		onHover = function()
			local itemEntry = Items.get(entry.id)
			if itemEntry then
				tooltipSlice.actions.setTooltip(
					anchorRef,
					itemEntry.name,
					itemEntry.description,
					itemEntry.type,
					entry.guid
				)
			end
		end,
		onHoverEnded = function()
			tooltipSlice.actions.hideTooltip()
		end,
		LayoutOrder = props.LayoutOrder,
		Children = {
			e("UICorner", { CornerRadius = UDim.new(0.2, 0) }),
			if not isTool
				then e(ItemWithAmount, { itemId = itemId, equipped = isEquipped, amount = amount })
				else e(ItemImage, { itemId = itemId, equipped = isEquipped }),
		},
	})
end

return InventoryItem
