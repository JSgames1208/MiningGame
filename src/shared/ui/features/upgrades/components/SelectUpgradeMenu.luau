local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local Items = require(ReplicatedStorage.Shared.modules.core.registries.Items)
local Upgrades = require(ReplicatedStorage.Shared.modules.core.registries.Upgrades)
local SelectItemMenu = require(ReplicatedStorage.Shared.ui.core.components.SelectItemMenu)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)
local e: typeof(React.createElement) = React.createElement

local function SelectUpgradeMenu()
	local inventory = ReactCharm.useAtom(inventorySlice.states.inventory)
	local shown = ReactCharm.useAtom(upgradeSlice.states.selectUpgradeMenuOpen)

	local upgradeSlot = ReactCharm.useAtom(upgradeSlice.states.upgradeSlot)

	local categoryMap = inventory["upgrade"]

	local items = {}

	for id, entryAtom in categoryMap do
		local insert = true
		for _, upgrade: { id: string, level: number } in upgradeSlice.states.selectedUpgrades() do
			local itemEntry = Items.get(id)
			if upgrade.id == itemEntry.upgrade.id then
				insert = false
			end
		end
		if insert then
			table.insert(items, { id = id, atom = entryAtom })
		end
	end

	table.sort(items, function(a, b) -- alphabetical
		local aEntry = a.atom()
		local bEntry = b.atom()

		return aEntry.id < bEntry.id
	end)

	return e(SelectItemMenu, {
		shown = shown,
		menuTitle = "Select Upgrade!",
		items = items,
		showAmount = true,
		setOpen = upgradeSlice.actions.setSelectUpgradeMenuOpen,
		clickCallback = function(id)
			local itemEntry = Items.get(id)
			if itemEntry.upgrade then
				local upgradeData = itemEntry.upgrade
				upgradeSlice.actions.attemptSelectUpgrade({
					slot = upgradeSlot,
					upgradeData = {
						id = upgradeData.id,
						level = upgradeData.level,
					},
				})
			end
		end,
	})
end

return SelectUpgradeMenu
