local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local BottomHUD = require(ReplicatedStorage.Shared.ui.features.hud.components.BottomHUD)
local LeftHUD = require(ReplicatedStorage.Shared.ui.features.hud.components.LeftHUD)
local XpBar = require(ReplicatedStorage.Shared.ui.features.hud.components.XpBar)
local e: typeof(React.createElement) = React.createElement

return function()
	return e(React.Fragment, nil, {
		e(LeftHUD),
		e(BottomHUD),
		e(XpBar),
	})
end
