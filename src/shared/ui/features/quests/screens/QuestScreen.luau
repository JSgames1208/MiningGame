local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local QuestMenu = require(ReplicatedStorage.Shared.ui.features.quests.components.QuestMenu)
local e: typeof(React.createElement) = React.createElement

return function()
	return e(React.Fragment, nil, {
		e(QuestMenu),
	})
end
