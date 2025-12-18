local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
type DialogueNode = DialogueTypes.DialogueNode

local DialogueNodes = {}

local function register(id: string, data: DialogueNode)
	return Registries.DIALOGUE_NODE:register(id, data)
end

register("dialogue.miner.idle.line_1", {
	id = "dialogue.miner.idle.line_1",
	type = "line",
	speaker = "npc.miner",
	text = "Ah, hello there!",
	next = "dialogue.miner.idle.choice_1",
})

register("dialogue.miner.idle.choice_1", {
	id = "dialogue.miner.idle.choice_1",
	type = "choice",
	choices = {
		{
			text = "Got any work for me?",
			next = "dialogue.miner.idle.line_work",
		},
		{
			text = "Goodbye!",
			next = "dialogue.miner.idle.line_bye",
		},
	},
})

register("dialogue.miner.idle.line_work", {
	id = "dialogue.miner.idle.line_work",
	type = "line",
	speaker = "npc.miner",
	text = "Come back later, I might.",
	next = nil,
})

register("dialogue.miner.idle.line_bye", {
	id = "dialogue.miner.idle.line_bye",
	type = "line",
	speaker = "npc.miner",
	text = "Goodbye!",
	next = nil,
})

function DialogueNodes.get(id: string): DialogueNode?
	return Registries.DIALOGUE_NODE:get(id)
end

return DialogueNodes
