local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local atom: typeof(Charm.atom) = Charm.atom

type Atom<T> = Charm.Atom<T>

local dialoguePlaying: Atom<boolean> = atom(false)

local actions = {
	setDialoguePlaying = function(playing: boolean)
		dialoguePlaying(playing)
	end,
}

return {
	states = {
		dialoguePlaying = dialoguePlaying,
	},
	actions = actions,
}
