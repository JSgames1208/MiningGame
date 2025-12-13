local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local atom: typeof(Charm.atom) = Charm.atom

local upgradeMenuOpen: Charm.Atom<boolean> = atom(false)
local selectMenuOpen: Charm.Atom<boolean> = atom(false)
local selectedGuid: Charm.Atom<string> = atom("")
local mainMenuOpen = Charm.computed(function()
	return not selectMenuOpen() and upgradeMenuOpen()
end)

local actions = {
	setOpen = function(open: boolean)
		upgradeMenuOpen(open)

		if not open then
			selectMenuOpen(false)
		end
	end,
	setSelectedGuid = function(guid: string)
		selectedGuid(guid)
	end,
	setSelectMenuOpen = function(open: boolean)
		selectMenuOpen(open)
	end,
}

return {
	states = {
		upgradeMenuOpen = upgradeMenuOpen,
		selectedGuid = selectedGuid,
		selectMenuOpen = selectMenuOpen,
		mainMenuOpen = mainMenuOpen,
	},
	actions = actions,
}
