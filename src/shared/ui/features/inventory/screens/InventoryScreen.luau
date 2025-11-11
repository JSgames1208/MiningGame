local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local MainInventory = require(ReplicatedStorage.Shared.ui.features.inventory.components.MainInventory)
local e: typeof(React.createElement) = React.createElement

return function()
	return e(React.Fragment, nil, {
		e(MainInventory),
	})
end
