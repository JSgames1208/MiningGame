local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local MiningBottomBar = require(ReplicatedStorage.Shared.ui.features.mining.components.MiningBottomBar)

local e = React.createElement

return function()
	return e(React.Fragment, nil, {
		MiningBottomBar = e(MiningBottomBar),
	})
end
