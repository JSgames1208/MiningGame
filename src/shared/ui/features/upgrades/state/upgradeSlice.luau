local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local Signal = require(ReplicatedStorage.Packages.Signal)
local atom: typeof(Charm.atom) = Charm.atom

--state atoms

local upgradeMenuOpen: Charm.Atom<boolean> = atom(false)
local selectToolMenuOpen: Charm.Atom<boolean> = atom(false)
local selectUpgradeMenuOpen: Charm.Atom<boolean> = atom(false)
local selectedGuid: Charm.Atom<string> = atom("")
local mainMenuOpen = Charm.computed(function()
	return not selectToolMenuOpen() and not selectUpgradeMenuOpen() and upgradeMenuOpen()
end)

local selectedUpgrades: Charm.Atom<{ [string]: { id: string, level: number } }> = atom({})
local upgradeSlot: Charm.Atom<string> = atom("1")

--signals
local selectToolRequest = Signal.new()
local selectUpgradeRequest = Signal.new()
local removeUpgradeRequest = Signal.new()

--setters
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
local setSelectedUpgrade = function(upgrade: { slot: string, upgradeData: { id: string, level: number } })
	local current = selectedUpgrades()
	local next = table.clone(current)

	next[upgrade.slot] = upgrade.upgradeData

	selectedUpgrades(next)
end
local setSelectedUpgrades = function(upgrades: { [string]: { id: string, level: number } })
	local next = table.clone(upgrades)

	selectedUpgrades(next)
end
local attemptSelectTool = function(guid: string)
	selectToolRequest:Fire(guid)
end
local attemptSelectUpgrade = function(upgrade: { slot: string, upgradeData: { id: string, level: number } })
	selectUpgradeRequest:Fire(upgrade)
end
local setUpgradeSlot = function(slot: string)
	upgradeSlot(slot)
end
local attemptRemoveUpgrade = function(slot: string)
	removeUpgradeRequest:Fire(slot)
end

local actions = {
	setOpen = setOpen,
	setSelectedGuid = setSelectedGuid,
	setSelectToolMenuOpen = setSelectToolMenuOpen,
	setSelectUpgradeMenuOpen = setSelectUpgradeMenuOpen,
	setSelectedUpgrade = setSelectedUpgrade,
	setSelectedUpgrades = setSelectedUpgrades,
	attemptSelectTool = attemptSelectTool,
	attemptSelectUpgrade = attemptSelectUpgrade,
	setUpgradeSlot = setUpgradeSlot,
	attemptRemoveUpgrade = attemptRemoveUpgrade,
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
	signals = {
		selectToolRequest = selectToolRequest,
		selectUpgradeRequest = selectUpgradeRequest,
		removeUpgradeRequest = removeUpgradeRequest,
	},
}
