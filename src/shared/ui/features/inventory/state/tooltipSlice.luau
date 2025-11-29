local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local React = require(ReplicatedStorage.Packages.React)
local atom: typeof(Charm.atom) = Charm.atom

type Tooltip = {
	shown: boolean,
	anchor: React.Ref<GuiObject>,
	title: string,
	description: string,
}

local tooltip: Charm.Atom<Tooltip> = atom({
	shown = false,
	anchor = nil,
	title = "",
	description = "",
})

actions = {
	setTooltip = function(anchor: React.Ref<GuiObject>, title: string, description: string)
		tooltip({
			shown = true,
			anchor = anchor,
			title = title,
			description = description,
		})
	end,
	hideTooltip = function()
		tooltip({
			shown = false,
			anchor = nil,
			title = "",
			description = "",
		})
	end,
}

return {
	states = { tooltip = tooltip },
	actions = actions,
}
