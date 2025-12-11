local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)
local atom: typeof(Charm.atom) = Charm.atom

local screenCovered = Charm.computed(function()
	return miningSlice.states.mining() or inventorySlice.states.inventoryOpen() or upgradeSlice.states.upgradeMenuOpen()
end)

local shown = Charm.computed(function()
	return not screenCovered()
end)

local currency: Charm.Atom<number> = atom(0)
local level: Charm.Atom<number> = atom(0)
local xp: Charm.Atom<number> = atom(0)
local maxXP: Charm.Atom<number> = atom(0)

local actions = {
	setCurrency = function(value: number)
		currency(value)
	end,
	setLevel = function(value: number)
		level(value)
	end,
	setXP = function(value: number)
		xp(value)
	end,
	setMaxXP = function(value: number)
		maxXP(value)
	end,
}

return {
	states = {
		screenCovered = screenCovered,
		shown = shown,
		currency = currency,
		level = level,
		xp = xp,
		maxXP = maxXP,
	},
	actions = actions,
}
