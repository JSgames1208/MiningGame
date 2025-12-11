local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local UpgradeMenu = require(ReplicatedStorage.Shared.ui.features.upgrades.components.UpgradeMenu)
local e: typeof(React.createElement) = React.createElement

return function()
	return e(React.Fragment, nil, {
		e(UpgradeMenu),
	})
end
