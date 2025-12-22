local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local atom = Charm.atom

type Atom<T> = Charm.Atom<T>

local mining: Atom<boolean> = atom(false)
local equipToolOpen: Atom<boolean> = atom(false)
local mainOpen: Atom<boolean> = Charm.computed(function()
	return mining() and not equipToolOpen()
end)
local currentTarget: Atom<Model?> = atom(nil)
local currentHP: Atom<number> = atom(100)
local currentMaxHP: Atom<number> = atom(100)

local actions = {
	setMining = function(value: boolean)
		mining(value)
		equipToolOpen(false)
	end,
	setEquipToolOpen = function(value: boolean)
		equipToolOpen(value)
	end,
	setCurrentTarget = function(value: Model?)
		currentTarget(value)
	end,
	setCurrentHP = function(value: number)
		currentHP(value)
	end,
	setCurrentMaxHP = function(value: number)
		currentMaxHP(value)
	end,
}

return {
	states = {
		mining = mining,
		equipToolOpen = equipToolOpen,
		mainOpen = mainOpen,
		currentTarget = currentTarget,
		currentHP = currentHP,
		currentMaxHP = currentMaxHP,
	},
	actions = actions,
}
