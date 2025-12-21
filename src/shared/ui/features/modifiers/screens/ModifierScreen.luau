local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ModifierFrame = require(ReplicatedStorage.Shared.ui.features.modifiers.components.ModifierFrame)
local e: typeof(React.createElement) = React.createElement

return function()
	return e(React.Fragment, nil, {
		e(ModifierFrame),
	})
end
