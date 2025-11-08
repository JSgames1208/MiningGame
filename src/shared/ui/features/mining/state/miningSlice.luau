local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local atom = Charm.atom

type Atom<T> = Charm.Atom<T>

local mining: Atom<boolean> = atom(false)
local currentTarget: Atom<Part?> = atom(nil)
local currentHP: Atom<number> = atom(100)
local currentMaxHP: Atom<number> = atom(100)

local actions = {
	setMining = function(value: boolean)
		mining(value)
	end,
	setCurrentTarget = function(value: Part?)
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
	states = { mining = mining, currentTarget = currentTarget, currentHP = currentHP, currentMaxHP = currentMaxHP },
	actions = actions,
}
