local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ToolUtil = require(ReplicatedStorage.Shared.services.ToolService.util.ToolUtil)
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

local function ToolTooltip(props: ToolTooltipProps)
	local toolInstance = props.toolInstance
	local upgrades = {}

	local upgradesArray = {}

	if toolInstance then
		upgrades = props.toolInstance.toolData.upgrades or {}

		if upgrades then
			for upgrade, level in upgrades do
				upgradesArray[#upgradesArray + 1] = upgrade .. " " .. level
			end
		end
	end

	return e(InventoryTooltip, {
		shown = props.shown,
		anchor = props.anchor,
		title = props.title,
		description = props.description,
		children = {
			e(UpgradesDisplay, {
				upgrades = upgradesArray,
			}),
		},
	})
end

return ToolTooltip
