local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local atom: typeof(Charm.atom) = Charm.atom

type Atom<T> = Charm.Atom<T>

local inventoryOpen: Atom<boolean> = atom(false)

local actions = {
	setInventoryOpen = function(value: boolean)
		inventoryOpen(value)
	end,
}

return {
	states = {
		inventoryOpen = inventoryOpen,
	},
	actions = actions,
}
