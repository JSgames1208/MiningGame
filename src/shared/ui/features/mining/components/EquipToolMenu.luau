local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local SwapToolMenu = require(ReplicatedStorage.Shared.ui.core.components.SwapToolMenu)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)
local e: typeof(React.createElement) = React.createElement

local function EquipToolMenu()
	local mining = ReactCharm.useAtom(miningSlice.states.mining)
	local equipMenuOpen = ReactCharm.useAtom(miningSlice.states.equipToolOpen)

	local shown = mining and equipMenuOpen

	return e(SwapToolMenu, {
		shown = shown,
		clickCallback = toolSlice.actions.setEquipped,
	})
end

return EquipToolMenu
