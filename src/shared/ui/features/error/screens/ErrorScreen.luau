local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ErrorFrame = require(ReplicatedStorage.Shared.ui.features.error.components.ErrorFrame)
local e: typeof(React.createElement) = React.createElement

return function()
	return e(React.Fragment, nil, {
		e(ErrorFrame),
	})
end
