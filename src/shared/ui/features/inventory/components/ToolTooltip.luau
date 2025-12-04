local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local ToolUtil = require(ReplicatedStorage.Shared.services.ToolService.util.ToolUtil)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local InventoryTooltip = require(ReplicatedStorage.Shared.ui.features.inventory.components.InventoryTooltip)
local UpgradesDisplay = require(ReplicatedStorage.Shared.ui.features.inventory.components.UpgradesDisplay)
local e: typeof(React.createElement) = React.createElement

type ToolInstance = ToolUtil.ToolInstance

export type ToolTooltipProps = {
	shown: boolean,
	anchor: React.Ref<GuiObject>,
	title: string,
	description: string,
	toolInstance: ToolInstance,
}

local UPGRADE_LINE_HEIGHT = 75

local function ToolTooltip(props: ToolTooltipProps)
	local toolInstance = props.toolInstance
	local upgrades

	local children = {}
	local upgradeLineCount

	if toolInstance then
		upgrades = props.toolInstance.toolData.upgrades

		for upgradeId, level in upgrades do
			upgrades[upgradeId] = upgradeId .. " " .. level
		end

		local upgradeArray = Sift.Dictionary.values(upgrades)

		upgradeLineCount = #upgradeArray >= 3 and 3 or #upgradeArray

		for i = 1, upgradeLineCount do
			local upgrade = upgradeArray[i]
			children[upgrade] = e(
				TextLabel,
				{
					Size = UDim2.new(1, 0, 0, UPGRADE_LINE_HEIGHT),
					TextXAlignment = Enum.TextXAlignment.Center,
					Text = upgrade,
					TextColor3 = Color3.fromRGB(0, 0, 0),
					Font = Enum.Font.FredokaOne,
					TextScaled = true,
					TextWrapped = false,
					Position = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,
					ZIndex = 50002,
					LayoutOrder = 4 + #children,
					Children = {},
				} :: TextLabel.Props
			)
		end
	end

	upgradeLineCount = upgradeLineCount or 0

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
			e(
				TextLabel,
				{
					Text = "Upgrades:",
					Size = UDim2.new(0.8, 0, 0, 75),
					AnchorPoint = Vector2.new(0.5, 0),
					TextXAlignment = Enum.TextXAlignment.Center,
					Position = UDim2.new(0, 0, 0, 0),
					TextColor3 = Color3.fromRGB(111, 111, 111),
					TextScaled = true,
					TextWrapped = false,
					LayoutOrder = 4,
					ZIndex = 50001,
					Children = {},
				} :: TextLabel.Props
			),
			table.unpack(children),
		},
	})
end

return ToolTooltip
