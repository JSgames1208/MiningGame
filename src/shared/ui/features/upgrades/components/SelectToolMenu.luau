local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local SwapToolMenu = require(ReplicatedStorage.Shared.ui.core.components.SwapToolMenu)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)
local e: typeof(React.createElement) = React.createElement

local function SelectToolMenu()
	local upgradesOpen = ReactCharm.useAtom(upgradeSlice.states.upgradeMenuOpen)
	local menuOpen = ReactCharm.useAtom(upgradeSlice.states.selectMenuOpen)

	local shown = upgradesOpen and menuOpen

	local setOpen = upgradeSlice.actions.setSelectMenuOpen

	return e(SwapToolMenu, {
		shown = shown,
		setOpen = setOpen,
		clickCallback = upgradeSlice.actions.setSelectedGuid,
	})
end

return SelectToolMenu
