local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ItemTooltip = require(ReplicatedStorage.Shared.ui.features.inventory.components.ItemTooltip)
local tooltipSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.tooltipSlice)

local e: typeof(React.createElement) = React.createElement

local function TooltipProvider()
	local tooltipAtom = ReactCharm.useAtom(tooltipSlice.states.tooltip)

	if not tooltipAtom.shown or not tooltipAtom.anchor or not tooltipAtom.anchor.current then
		return nil
	end

	return e(ItemTooltip, {
		shown = tooltipAtom.shown,
		anchor = tooltipAtom.anchor,
		title = tooltipAtom.title,
		description = tooltipAtom.description,
	})
end

return TooltipProvider
