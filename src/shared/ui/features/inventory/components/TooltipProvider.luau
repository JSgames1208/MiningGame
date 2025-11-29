local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ItemToolTip = require(ReplicatedStorage.Shared.ui.features.inventory.components.ItemToolTip)
local tooltipSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.tooltipSlice)

local e: typeof(React.createElement) = React.createElement

local function TooltipProvider()
	local tooltipAtom = ReactCharm.useAtom(tooltipSlice.states.tooltip)

	if not tooltipAtom.shown or not tooltipAtom.anchor or not tooltipAtom.anchor.current then
		return nil
	end

	print(tooltipAtom.title)

	return e(ItemToolTip, {
		shown = tooltipAtom.shown,
		anchor = tooltipAtom.anchor,
		title = tooltipAtom.title,
		description = tooltipAtom.description,
	})
end

return TooltipProvider
