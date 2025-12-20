local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
local BASE = "dialogue.blacksmith.idle."

type DialogueNode = DialogueTypes.DialogueNode

local r = function(id: string, data: DialogueNode)
	return Registries.DIALOGUE_NODE:register(BASE .. id, Sift.Dictionary.join(data, { id = BASE .. id }))
end

local function registerAll()
	r("line_1", {
		id = "line_1",
		type = "line",
		speaker = "npc.blacksmith",
		text = "Ah, hello there!",
		next = "dialogue.blacksmith.idle.choice_1",
	})

	r("choice_1", {
		id = "choice_1",
		type = "choice",
		prompt = "What can I do for you?",
		choices = {
			{
				text = "Goodbye!",
				next = "dialogue.blacksmith.idle.line_bye_1",
			},
		},
	})

	r("line_quest", {
		id = "line_quest",
		type = "line",
		speaker = "npc.blacksmith",
		text = "Sure, here is your quest!",
		commands = {
			{
				type = "grant_quest",
				questId = "blacksmith.quest_1",
			},
		},
		next = nil,
	})

	r("line_work", {
		id = "line_work",
		type = "line",
		speaker = "npc.blacksmith",
		text = "Come back later, I might.",
		next = "dialogue.blacksmith.idle.choice_1",
	})

	r("line_bye_1", {
		id = "dialogue.blacksmith.idle.line_bye_1",
		type = "line",
		speaker = "npc.blacksmith",
		text = "Aw, it's sad to see you go already!",
		next = "dialogue.blacksmith.idle.line_bye_2",
	})

	r("line_bye_2", {
		id = "dialogue.blacksmith.idle.line_bye_2",
		type = "line",
		speaker = "npc.blacksmith",
		text = "I hope you find what you're looking for!",
		next = "dialogue.blacksmith.idle.line_bye_3",
	})

	r("line_bye_3", {
		id = "dialogue.blacksmith.idle.line_bye_3",
		type = "line",
		speaker = "npc.blacksmith",
		text = "Anyways, now I'm just yapping because I don't want you to leave!",
		next = "dialogue.blacksmith.idle.line_bye_4",
	})

	r("line_bye_4", {
		id = "dialogue.blacksmith.idle.line_bye_4",
		type = "choice",
		speaker = "npc.blacksmith",
		prompt = "But at least we took our new dialogue system for a spin huh?",
		choices = {
			{
				text = "Of course!",
				next = "dialogue.blacksmith.idle.line_bye_5",
			},
			{
				text = "I'm out of here!",
				next = "dialogue.blacksmith.idle.line_bye_5",
			},
		},
	})

	r("line_bye_5", {
		id = "dialogue.blacksmith.idle.line_bye_5",
		type = "line",
		speaker = "npc.blacksmith",
		text = "Bye!",
		next = nil,
	})
end

return {
	registerAll = registerAll,
}
