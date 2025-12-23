local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local atom: typeof(Charm.atom) = Charm.atom

-- TYPES

type Atom<T> = Charm.Atom<T>

-- STATES

local errorOpen: Atom<boolean> = atom(false)
local errorMessage: Atom<string> = atom("")

-- ACTIONS

local actions = {
	setErrorOpen = function(boolean: boolean)
		errorOpen(boolean)
	end,
	setErrorMessage = function(message: string)
		errorMessage(message)
	end,
}

return {
	states = {
		errorOpen = errorOpen,
		errorMessage = errorMessage,
	},
	actions = actions,
}
