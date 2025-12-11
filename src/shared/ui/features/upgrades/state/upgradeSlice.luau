local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local atom: typeof(Charm.atom) = Charm.atom

local upgradeMenuOpen: Charm.Atom<boolean> = atom(false)

local actions = {
	setOpen = function(open: boolean)
		upgradeMenuOpen(open)
	end,
}

return {
	states = { upgradeMenuOpen = upgradeMenuOpen },
	actions = actions,
}
