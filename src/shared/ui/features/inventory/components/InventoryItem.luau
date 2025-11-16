local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)

local e: typeof(React.createElement) = React.createElement

type Atom<T> = Charm.Atom<T>

export type InventoryItemProps = {
	id: string,
	itemAtom: Atom<{ id: string, amount: number }> | Atom<DataTemplate.ToolInstance>,
	tab: string,
	equippedToolId: string,
}

local function InventoryItem(props: InventoryItemProps)
	local stack = ReactCharm.useAtom(props.itemAtom)
	print(props.itemAtom(), stack)

	local isTool = props.tab == "tools"

	local item = stack.item
	local itemId = item.guid

	-- TOOL RENDER ------------------------------------
	if isTool then
		local toolGuid = item.guid
		local equipped = props.equippedToolId == toolGuid

		return e(Button, {
			Size = UDim2.new(1, 0, 1, 0),
			Image = ImageIds.icons[itemId],
			BackgroundTransparency = 0,
			BackgroundColor3 = equipped and Color3.fromRGB(0, 230, 0) or Color3.fromRGB(210, 210, 210),
			hoverScale = 1.075,
			onClick = function()
				toolSlice.actions.setEquipped(toolGuid)
			end,
			Children = {
				e("UICorner", { CornerRadius = UDim.new(0.2, 0) }),
				e("UIStroke", {
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 10,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}),
			},
		})
	end

	-- STACKABLES --------------------------------------
	return e(Button, {
		Size = UDim2.new(1, 0, 1, 0),
		Image = ImageIds.icons[itemId],
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(210, 210, 210),
		onClick = function() end,
		Children = {
			e("UICorner", { CornerRadius = UDim.new(0.2, 0) }),
			e("UIStroke", {
				Color = Color3.fromRGB(0, 0, 0),
				Thickness = 10,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}),
			e(
				TextLabel,
				{
					Text = stack.amount .. "x",
					Size = UDim2.new(1, 0, 0.5, 0),
					Position = UDim2.new(1, 0, 1, 0),
					AnchorPoint = Vector2.new(0.85, 0.5),
					TextXAlignment = Enum.TextXAlignment.Right,
					TextYAlignment = Enum.TextYAlignment.Bottom,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					TextScaled = true,
					TextWrapped = true,
					ZIndex = 2,
					Stroke = {
						Thickness = 10,
						Color = Color3.fromRGB(0, 0, 0),
					},
				} :: TextLabel.Props
			),
		},
	})
end

return InventoryItem
