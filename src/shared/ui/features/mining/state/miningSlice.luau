local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local atom = Charm.atom

type Atom<T> = Charm.Atom<T>

local mining: Atom<boolean> = atom(false)

local actions = {
	setMining = function(value: boolean)
		mining(value)
	end,
}

return {
	states = { mining = mining },
	actions = actions,
}
