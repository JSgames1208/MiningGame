local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ToolUtil = require(ReplicatedStorage.Shared.services.ToolService.util.ToolUtil)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local InventoryTooltip = require(ReplicatedStorage.Shared.ui.features.inventory.components.InventoryTooltip)
local e: typeof(React.createElement) = React.createElement

type ToolInstance = ToolUtil.ToolInstance

export type ToolTooltipProps = {
	shown: boolean,
	anchor: React.Ref<GuiObject>,
	title: string,
	description: string,
	toolInstance: ToolInstance,
}

local function ToolTooltip(props: ToolTooltipProps)
	return e(InventoryTooltip, {
		shown = props.shown,
		anchor = props.anchor,
		title = props.title,
		description = props.description,
		children = {
			e("Frame", {
				Size = UDim2.new(1, 0, 0, 0.5),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				ZIndex = 50001,
				LayoutOrder = 3,
			}),
			e("Frame", {
				Size = UDim2.new(1, 0, 0, 200),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 50001,
				LayoutOrder = 4,
			}),
		},
	})
end

return ToolTooltip
