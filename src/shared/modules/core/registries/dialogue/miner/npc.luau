local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)

local registerAll = function()
	Registries.DIALOGUE_NODE:register("dialogue.miner.quest.main.turnin.line_1", {
		id = "dialogue.miner.quest.main.turnin.line_1",
		type = "line",
		speaker = "npc.miner",
		text = "Thanks for the help!",
		commands = {
			{
				type = "complete_quest",
			},
		},
		next = nil,
	})

	Registries.DIALOGUE_NODE:register("dialogue.miner.quest.main.offer.line_1", {
		id = "dialogue.miner.quest.main.offer.line_1",
		type = "line",
		speaker = "npc.miner",
		text = "Here's your quest!",
		commands = {
			{
				type = "grant_quest",
			},
		},
		next = nil,
	})
end

return {
	registerAll = registerAll,
}
