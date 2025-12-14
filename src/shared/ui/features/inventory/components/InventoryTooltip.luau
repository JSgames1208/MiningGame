local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Intersection = require(ReplicatedStorage.Shared.ui.core.components.Intersection)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ItemTooltip = require(ReplicatedStorage.Shared.ui.features.inventory.components.ItemTooltip)
local e: typeof(React.createElement) = React.createElement

export type InventoryTooltipProps = {
	shown: boolean,
	anchor: React.Ref<GuiObject>,
	title: string,
	description: string,
	children: { React.ReactElement<any> },
}

local function InventoryTooltip(props: InventoryTooltipProps)
	return e(ItemTooltip, {
		shown = props.shown,
		anchor = props.anchor,
		children = {
			-- Title
			e(TextLabel, {
				Text = props.title,
				Size = UDim2.new(0.95, 0, 0, 50),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Position = UDim2.new(0, 0, 0, 0),
				Children = {},
				TextColor3 = Color3.fromRGB(25, 25, 25),
				--Stroke = {
				--Color = Color3.fromRGB(0, 0, 0),
				--Thickness = 2,
				--},
				Font = Enum.Font.FredokaOne,
				TextScaled = true,
				LayoutOrder = 1,
				ZIndex = 50001,
			}),

			e(Intersection, {
				LayoutOrder = 2,
				ZIndex = 50002,
				shown = true,
			}),

			-- Description
			e(TextLabel, {
				Text = '"' .. props.description .. '"',
				Size = UDim2.new(0.875, 0, 0, 40),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Position = UDim2.new(0, 0, 0, 0),
				TextColor3 = Color3.fromRGB(110, 110, 110),
				Children = {},
				TextScaled = true,
				LayoutOrder = 3,
				ZIndex = 50001,
			}),

			e("Frame", {
				Size = UDim2.new(1, 0, 0, 5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				ZIndex = 50002,
				LayoutOrder = 4,
			}),

			table.unpack(props.children),
		},
	})
end

return InventoryTooltip
