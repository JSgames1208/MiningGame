local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local DialogueFrame = require(ReplicatedStorage.Shared.ui.features.dialogue.components.DialogueFrame)
local e: typeof(React.createElement) = React.createElement

return function()
	return e(React.Fragment, nil, {
		e(DialogueFrame),
	})
end
