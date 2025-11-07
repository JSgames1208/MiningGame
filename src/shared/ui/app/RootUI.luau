local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local MiningScreen = require(ReplicatedStorage.Shared.ui.features.mining.screens.MiningScreen)

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
		}),
	})
end

return RootUI
