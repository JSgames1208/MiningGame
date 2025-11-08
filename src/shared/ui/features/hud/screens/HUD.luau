local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local LeftHUD = require(ReplicatedStorage.Shared.ui.features.hud.components.LeftHUD)
local e: typeof(React.createElement) = React.createElement

return function()
	return e(React.Fragment, nil, {
		e(LeftHUD),
	})
end
