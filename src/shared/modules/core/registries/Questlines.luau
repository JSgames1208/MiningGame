local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)

local function register(id: string, data: any)
	return Registries.QUESTLINE:register(id, data)
end

register("miner.quest.main", {
	id = "miner.quest.main",
	quests = {
		"miner.quest_1",
		"miner.quest_2",
		"miner.quest_3",
		"miner.quest_4",
		"miner.quest_5",
	},
})

register("blacksmith.quest.main", {
	id = "blacksmith.quest.main",
	quests = {
		"blacksmith.quest_1",
		"blacksmith.quest_2",
		"blacksmith.quest_3",
		"blacksmith.quest_4",
		"blacksmith.quest_5",
	},
})

return {}
