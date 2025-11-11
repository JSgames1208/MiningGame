local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local atom: typeof(Charm.atom) = Charm.atom

local equipped: Charm.Atom<string> = atom("")

local actions = {
	setEquipped = function(toolId: string)
		equipped(toolId)
	end,
}

return {
	states = { equipped = equipped },
	actions = actions,
}
