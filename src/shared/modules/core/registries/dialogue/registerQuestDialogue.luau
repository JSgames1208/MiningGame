local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)

return function(params: { npcId: string, questId: string, stage: string })
	local npcId = params.npcId
	local questId = params.questId
	local stage = params.stage

	local BASE = ("dialogue.%s.%s.%s"):format(npcId, questId, stage)

	local r = function(id: string, data: DialogueTypes.DialogueNode)
		return Registries.DIALOGUE_NODE:register(BASE .. id, Sift.Dictionary.join(data, { id = BASE .. id }))
	end

	r("line_1", {
		type = "line",
		speaker = npcId,
		text = "Ah, hello there!",
		next = BASE .. "line_2",
	})

	r("line_2", {
		type = "line",
		speaker = npcId,
		text = "Oh, so you want a quest?",
		next = BASE .. "line_3",
	})

	r("line_3", {
		type = "line",
		speaker = npcId,
		text = "Sure, here is your quest!",
		commands = {
			{
				type = "grant_quest",
				questId = questId,
			},
		},
	})
end
