local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local React = require(ReplicatedStorage.Packages.React)
local HUD = require(ReplicatedStorage.Shared.ui.features.hud.screens.HUD)
local MiningScreen = require(ReplicatedStorage.Shared.ui.features.mining.screens.MiningScreen)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local e = React.createElement

local function RootUI()
	return e(React.Fragment, nil, {
		App = e("ScreenGui", {
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ClipToDeviceSafeArea = false,
		}, {
			MiningScreen = e(MiningScreen),
			HUD = e(HUD),
		}),
	})
end

return RootUI
