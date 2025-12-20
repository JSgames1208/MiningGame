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
	idleDialogue = "dialogue.miner.idle",
	questTurninDialogue = "dialogue.miner.quest.turnin.line_1",
	questOfferDialogue = "dialogue.miner.quest.offer.line_1",
	questline = "miner.quest.main",
	dialogues = {},
})

function NPCs.get(id: string): NPCTypes.NPCData?
	return Registries.NPC:get(id)
end

return NPCs
