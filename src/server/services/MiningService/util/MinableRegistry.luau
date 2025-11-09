local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MiningServiceUtil = require(ReplicatedStorage.Shared.services.MiningService.util.MiningServiceUtil)

type MinableData = MiningServiceUtil.MinableData

local MinableRegistry = {}

local minablesByInstance: { [Instance]: MinableData } = {}

function MinableRegistry.registerMinable(instance: Instance, minableData: MinableData)
	minablesByInstance[instance] = minableData
end

function MinableRegistry.updateMinableData(instance: Instance, health: number)
	local minableData = MinableRegistry.getMinableData(instance)
	if minableData then
		minableData.health = health
	end
end

function MinableRegistry.getMinableData(instance: Instance): MinableData?
	return minablesByInstance[instance]
end

function MinableRegistry.getHealth(instance: Instance): number?
	local minableData = MinableRegistry.getMinableData(instance)
	return minableData and minableData.health
end

function MinableRegistry.removeMinable(instance: Instance)
	minablesByInstance[instance] = nil
end

return MinableRegistry
