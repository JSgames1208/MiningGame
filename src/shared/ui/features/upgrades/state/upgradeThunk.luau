local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Upgrades = require(ReplicatedStorage.Shared.modules.core.registries.Upgrades)

local ownsUpgrade = function(upgradeData: { id: string, level: number })
	local upgradeEntry = Upgrades.get(upgradeData.id)
	if not upgradeEntry then
		return false
	end
	local itemId = upgradeEntry.levels[upgradeData.level]
	if DataService:get({ "inventory", "upgrade", itemId }) ~= nil then
		return true
	end
	return false
end
local setUpgrade = function(toolGuid: string, upgrade: { slot: number, upgradeData: { id: string, level: number } })
	local ownsUpgrade = ownsUpgrade(upgrade.upgradeData)

	if ownsUpgrade then
	end
end

local actions = { ownsUpgrade = ownsUpgrade, setUpgrade = setUpgrade }

return { actions = actions }
