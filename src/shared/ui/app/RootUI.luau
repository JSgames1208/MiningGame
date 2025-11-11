local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local React = require(ReplicatedStorage.Packages.React)
local HUD = require(ReplicatedStorage.Shared.ui.features.hud.screens.HUD)
local InventoryScreen = require(ReplicatedStorage.Shared.ui.features.inventory.screens.InventoryScreen)
local MiningScreen = require(ReplicatedStorage.Shared.ui.features.mining.screens.MiningScreen)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local e = React.createElement

local function RootUI()
	return e(React.Fragment, nil, {
		App = e("ScreenGui", {
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			ClipToDeviceSafeArea = false,
		}, {
			MiningScreen = e(MiningScreen),
			HUD = e(HUD),
			InventoryScreen = e(InventoryScreen),
		}),
	})
end

return RootUI
