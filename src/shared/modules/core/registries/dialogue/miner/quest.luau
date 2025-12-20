local ReplicatedStorage = game:GetService("ReplicatedStorage")
local registerQuestDialogue = require(ReplicatedStorage.Shared.modules.core.registries.dialogue.registerQuestDialogue)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)

type DialogueNode = DialogueTypes.DialogueNode

local function registerAll()
	registerQuestDialogue({
		npcId = "npc.miner",
		questId = "miner.quest_1",
		stage = "offer",
	})

	registerQuestDialogue({
		npcId = "npc.miner",
		questId = "miner.quest_1",
		stage = "complete",
	})
end

return {
	registerAll = registerAll,
}
