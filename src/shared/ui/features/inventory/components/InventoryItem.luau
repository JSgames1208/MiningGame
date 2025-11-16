local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local ItemRegistry = require(ReplicatedStorage.Shared.modules.core.ItemRegistry)
local RarityColors = require(ReplicatedStorage.Shared.modules.core.RarityColors)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local ImageLabel = require(ReplicatedStorage.Shared.ui.core.components.ImageLabel)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)

local e: typeof(React.createElement) = React.createElement

type InventoryEntry = DataTemplate.InventoryEntry
type Atom<T> = Charm.Atom<T>

export type InventoryItemProps = {
	key: string,
	tab: string,
	entryAtom: Atom<InventoryEntry>,
	equippedToolId: string,
	LayoutOrder: number,
}

local function InventoryItem(props: InventoryItemProps)
	local entry = ReactCharm.useAtom(props.entryAtom)

	local isTool = props.tab == "tools"

	local itemId = entry.id
	local amount = entry.amount

	local isEquipped = props.equippedToolId == entry.guid

	local imageColor = Color3.fromRGB(210, 210, 210)

	if isTool and props.equippedToolId == entry.guid then
		imageColor = Color3.fromRGB(0, 230, 0)
	else
		imageColor = RarityColors[ItemRegistry[entry.id].rarity]
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

	return e(Button, {
		Size = UDim2.new(1, 0, 1, 0),
		Image = ImageIds.icons[itemId],
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(220, 220, 220),
		ZIndex = 2,
		onClick = function()
			if isTool and entry.guid then
				toolSlice.actions.setEquipped(entry.guid)
			end
		end,
		--springTrigger = props.LayoutOrder,
		LayoutOrder = props.LayoutOrder,
		Children = {
			e("UICorner", { CornerRadius = UDim.new(0.2, 0) }),

			--[[e("UIStroke", {
				Color = Color3.fromRGB(0, 0, 0),
				Thickness = 10,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}),]]

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
