local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local atom: typeof(Charm.atom) = Charm.atom

local upgradeMenuOpen: Charm.Atom<boolean> = atom(false)
local selectedGuid: Charm.Atom<string> = atom("")

local actions = {
	setOpen = function(open: boolean)
		upgradeMenuOpen(open)
	end,
	setSelectedGuid = function(guid: string)
		selectedGuid(guid)
	end,
}

return {
	states = { upgradeMenuOpen = upgradeMenuOpen, selectedGuid = selectedGuid },
	actions = actions,
}
