--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local ItemType = require(ReplicatedStorage.Shared.modules.core.types.ItemType)
local UpgradeType = require(ReplicatedStorage.Shared.modules.core.types.UpgradeType)

local ToolUtil = {}

type ToolStats = ItemType.ToolStats
type UpgradeEffect<T> = UpgradeType.UpgradeEffect<T>
type UpgradeData<T> = UpgradeType.UpgradeData<T>

export type ToolInstance = {
	id: string,
	guid: string,
	toolData: { level: number, xp: number, upgrades: { [string]: { id: string, level: number } }? },
}

function ToolUtil.getStats(baseStats: ToolStats, upgrades: { [string]: { id: string, level: number } }?): ToolStats
	local final = {} :: ToolStats

	for k, v in baseStats do
		final[k] = v
	end

	if upgrades == nil then
		return final
	end

	for slot, upgradeData in upgrades do
		local level = upgradeData.level
		local upgradeId = upgradeData.id

		if type(level) ~= "number" or level <= 0 then
			continue
		end

		local upgrade = Registries.UPGRADE:get(upgradeId) :: UpgradeData<any>
		if upgrade == nil then
			continue
		end

		local eff = upgrade.effect
		if eff and eff.stats then
			if eff.scaleType == "add" then
				for statName, deltaPerLevel in eff.stats do
					local add = (deltaPerLevel :: number) * level
					final[statName] = (final[statName] or 0) + add
				end
			elseif eff.scaleType == "multiply" then
				for statName, deltaPerLevel in eff.stats do
					local add = (deltaPerLevel :: number) * level
					final[statName] = (final[statName] or 1) * (1 + add)
				end
			end
		end
	end

	return final
end

--DEPRECATED
--[[
function ToolUtil.onMine(toolInstance: ToolInstance, ore: any, player: Player)
	local upgrades = toolInstance.toolData.upgrades
	if upgrades == nil then
		return
	end

	for slot, upgradeData in upgrades do
		if type(level) ~= "number" or level <= 0 then
			continue
		end

		local upgrade = Registries.UPGRADE:get(upgradeId) :: UpgradeData<any>
		if upgrade == nil then
			continue
		end

		local eff = upgrade.effect
		if eff and eff.onMine then
			eff.onMine(toolInstance, ore, player)
		end
	end
end]]

return ToolUtil
