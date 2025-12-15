local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ores = require(ReplicatedStorage.Shared.modules.core.registries.Ores)
local OreType = require(ReplicatedStorage.Shared.modules.core.types.OreType)

type OreData = OreType.OreData
type OreInstance = OreType.OreInstance

type OreStoreEntry = {
	id: string,
}

local OreStore = {}

local oresByInstance: { [Instance]: OreInstance } = {}

function OreStore.add(instance: Instance, id: string)
	local oreEntry = Ores.get(id)
	if not oreEntry then
		return
	end

	local guid = HttpService:GenerateGUID()

	local oreInstance = {
		id = id,
		guid = guid,
		health = oreEntry.maxHealth,
		oreData = oreEntry,
	}
	oresByInstance[instance] = oreInstance
end

function OreStore.updateOreData(instance: Instance, health: number)
	local oreInstance = OreStore.getOreInstance(instance)
	if oreInstance then
		oreInstance.health = health
	end
end

function OreStore.getOreInstance(instance: Instance): OreInstance?
	return oresByInstance[instance]
end

function OreStore.getHealth(instance: Instance): number?
	local oreInstance = OreStore.getOreInstance(instance)
	return oreInstance and oreInstance.health
end

function OreStore.removeOre(instance: Instance)
	oresByInstance[instance] = nil
end

return OreStore
