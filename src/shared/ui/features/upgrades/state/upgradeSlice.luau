local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local upgradeThunk = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeThunk)
local atom: typeof(Charm.atom) = Charm.atom

local upgradeMenuOpen: Charm.Atom<boolean> = atom(false)
local selectToolMenuOpen: Charm.Atom<boolean> = atom(false)
local selectUpgradeMenuOpen: Charm.Atom<boolean> = atom(false)
local selectedGuid: Charm.Atom<string> = atom("")
local mainMenuOpen = Charm.computed(function()
	return not selectToolMenuOpen() and not selectUpgradeMenuOpen() and upgradeMenuOpen()
end)

local selectedUpgrades: Charm.Atom<{ [number]: { id: string, level: number } }> = atom({})
local upgradeSlot: Charm.Atom<number> = atom(1)

local setOpen = function(open: boolean)
	upgradeMenuOpen(open)

	if not open then
		selectToolMenuOpen(false)
	end
end
local setSelectedGuid = function(guid: string)
	selectedGuid(guid)
end
local setSelectToolMenuOpen = function(open: boolean)
	selectToolMenuOpen(open)
end
local setSelectUpgradeMenuOpen = function(open: boolean)
	selectUpgradeMenuOpen(open)
end
local setSelectedUpgrade = function(upgrade: { slot: number, upgradeData: { id: string, level: number } })
	local upgrades = selectedUpgrades()
	upgrades[upgrade.slot] = upgrade.upgradeData
	selectedUpgrades(upgrades)
end
local attemptSelectUpgrade = function(upgrade: { slot: number, upgradeData: { id: string, level: number } })
	if upgradeThunk.actions.setUpgrade(selectedGuid(), upgrade) then
		setSelectedUpgrade(upgrade)
	end
end
local setUpgradeSlot = function(slot: number)
	upgradeSlot(slot)
end

local actions = {
	setOpen = setOpen,
	setSelectedGuid = setSelectedGuid,
	setSelectToolMenuOpen = setSelectToolMenuOpen,
	setSelectUpgradeMenuOpen = setSelectUpgradeMenuOpen,
	setSelectedUpgrade = setSelectedUpgrade,
	attemptSelectUpgrade = attemptSelectUpgrade,
	setUpgradeSlot = setUpgradeSlot,
}

return {
	states = {
		upgradeMenuOpen = upgradeMenuOpen,
		selectedGuid = selectedGuid,
		selectToolMenuOpen = selectToolMenuOpen,
		selectUpgradeMenuOpen = selectUpgradeMenuOpen,
		mainMenuOpen = mainMenuOpen,
		selectedUpgrades = selectedUpgrades,
		upgradeSlot = upgradeSlot,
	},
	actions = actions,
}
