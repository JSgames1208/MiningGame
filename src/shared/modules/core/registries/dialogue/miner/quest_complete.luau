local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
local BASE = "dialogue.miner.quest_complete."

type DialogueNode = DialogueTypes.DialogueNode

local r = function(id: string, data: DialogueNode)
	return Registries.DIALOGUE_NODE:register(BASE .. id, Sift.Dictionary.join(data, { id = BASE .. id }))
end

local function registerAll()
	r("line_1", {
		id = "line_1",
		type = "line",
		speaker = "npc.miner",
		text = "Yo!!! You've finished your quest finally?",
		next = BASE .. "line_2",
	})

	r("line_2", {
		id = "line_2",
		type = "line",
		speaker = "npc.miner",
		text = "Congrats!",
		commands = {
			{
				type = "complete_quest",
				questId = "miner.quest_1",
			},
		},
		next = nil,
	})
end

return {
	registerAll = registerAll,
}
