local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)
local atom: typeof(Charm.atom) = Charm.atom

local screenCovered = Charm.computed(function()
	return miningSlice.states.mining()
end)

local shown = Charm.computed(function()
	return not screenCovered()
end)

local currency: Charm.Atom<number> = atom(0)

local actions = {
	setCurrency = function(value: number)
		currency(value)
	end,
}

return {
	states = { screenCovered = screenCovered, shown = shown, currency = currency },
	actions = actions,
}
