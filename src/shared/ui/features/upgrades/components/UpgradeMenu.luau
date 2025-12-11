local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local MenuScreen = require(ReplicatedStorage.Shared.ui.core.components.MenuScreen)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)
local e: typeof(React.createElement) = React.createElement

local function UpgradeMenu()
	local shown = ReactCharm.useAtom(upgradeSlice.states.upgradeMenuOpen)

	return e(MenuScreen, {
		shown = shown,
		menuTitle = "Upgrades!",
		setOpen = upgradeSlice.actions.setOpen,
		children = {},
	})
end

return UpgradeMenu
