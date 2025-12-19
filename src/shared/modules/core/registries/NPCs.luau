local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local NPCTypes = require(ReplicatedStorage.Shared.modules.core.types.NPCTypes)

type NPCData = NPCTypes.NPCData

local NPCs = {}

local function register(id: string, data: NPCData)
	return Registries.NPC:register(id, data)
end

register("npc.miner", {
	name = "Miner",
	dialogues = {
		"dialogue.miner.idle",
		"dialogue.miner.quest",
	},
})

function NPCs.get(id: string): NPCTypes.NPCData?
	return Registries.NPC:get(id)
end

return NPCs
