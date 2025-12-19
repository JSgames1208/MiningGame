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
	prompt = "What can I do for you?",
	choices = {
		{
			text = "Got any work for me?",
			next = "dialogue.miner.idle.line_work",
		},
		{
			text = "Goodbye!",
			next = "dialogue.miner.idle.line_bye_1",
		},
	},
})

register("dialogue.miner.idle.line_work", {
	id = "dialogue.miner.idle.line_work",
	type = "line",
	speaker = "npc.miner",
	text = "Come back later, I might.",
	next = "dialogue.miner.idle.choice_1",
})

register("dialogue.miner.idle.line_bye_1", {
	id = "dialogue.miner.idle.line_bye_1",
	type = "line",
	speaker = "npc.miner",
	text = "Aw, it's sad to see you go already!",
	next = "dialogue.miner.idle.line_bye_2",
})

register("dialogue.miner.idle.line_bye_2", {
	id = "dialogue.miner.idle.line_bye_2",
	type = "line",
	speaker = "npc.miner",
	text = "I hope you find what you're looking for!",
	next = "dialogue.miner.idle.line_bye_3",
})

register("dialogue.miner.idle.line_bye_3", {
	id = "dialogue.miner.idle.line_bye_3",
	type = "line",
	speaker = "npc.miner",
	text = "Anyways, now I'm just yapping because I don't want you to leave!",
	next = "dialogue.miner.idle.line_bye_4",
})

register("dialogue.miner.idle.line_bye_4", {
	id = "dialogue.miner.idle.line_bye_4",
	type = "choice",
	speaker = "npc.miner",
	prompt = "But at least we took our new dialogue system for a spin huh?",
	choices = {
		{
			text = "Of course!",
			next = "dialogue.miner.idle.line_bye_5",
		},
		{
			text = "I'm out of here!",
			next = "dialogue.miner.idle.line_bye_5",
		},
	},
})

register("dialogue.miner.idle.line_bye_5", {
	id = "dialogue.miner.idle.line_bye_5",
	type = "line",
	speaker = "npc.miner",
	text = "Bye!",
	next = nil,
})

function DialogueNodes.get(id: string): DialogueNode?
	return Registries.DIALOGUE_NODE:get(id)
end

return DialogueNodes
