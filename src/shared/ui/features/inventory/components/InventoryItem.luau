local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local RarityColors = require(ReplicatedStorage.Shared.modules.core.RarityColors)
local Items = require(ReplicatedStorage.Shared.modules.core.registries.Items)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local ImageLabel = require(ReplicatedStorage.Shared.ui.core.components.ImageLabel)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
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

	local isTool = props.tab == "tools"

	local itemId = entry.id
	local amount = entry.amount

	local isEquipped = props.equippedToolId == entry.guid

	local imageColor = Color3.fromRGB(210, 210, 210)

	if isTool and isEquipped then
		imageColor = Color3.fromRGB(0, 230, 0)
	else
		local itemEntry = Items.get(entry.id)
		if itemEntry then
			imageColor = RarityColors[itemEntry.rarity]
		else
			imageColor = RarityColors.fallback
		end
	end

	local amountLabel = nil

	if not isTool then
		amountLabel = e(
			TextLabel,
			{
				Text = amount .. "x",
				Size = UDim2.new(1, 0, 0.4, 0),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(0.85, 0.5),
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				TextScaled = true,
				TextWrapped = true,
				ZIndex = 3,
				Stroke = {
					Thickness = 7.5,
					Color = Color3.fromRGB(30, 30, 30),
				},
			} :: TextLabel.Props
		)
	end

	local anchorRef = React.useRef(nil)

	return e(Button, {
		ref = anchorRef,
		Size = UDim2.new(1, 0, 1, 0),
		Image = ImageIds.icons[itemId],
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(220, 220, 220),
		ZIndex = 2,
		onClick = function()
			if isTool and entry.guid then
				toolSlice.actions.setEquipped(entry.guid)
			end
			if exitOnPress then
				miningSlice.actions.setSwapToolOpen(false)
				inventorySlice.actions.setInventoryOpen(false)
			end
		end,
		onHover = function()
			local itemEntry = Items.get(entry.id)
			if itemEntry then
				tooltipSlice.actions.setTooltip(anchorRef, itemEntry.name, itemEntry.description)
			end
		end,
		onHoverEnded = function()
			tooltipSlice.actions.hideTooltip()
		end,
		LayoutOrder = props.LayoutOrder,
		Children = {
			e("UICorner", { CornerRadius = UDim.new(0.2, 0) }),
			e(ImageLabel, {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Image = ImageIds.icons.button_background,
				ImageColor3 = imageColor,
				ScaleType = Enum.ScaleType.Fit,
				BackgroundTransparency = 1,
				ImageRectOffset = Vector2.zero,
				ImageRectSize = Vector2.new(1028, 1028),
				ZIndex = 1,
			}),

			amountLabel,
		},
	})
end

return InventoryItem
