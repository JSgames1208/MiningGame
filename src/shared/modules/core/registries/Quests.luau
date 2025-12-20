local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local QuestType = require(ReplicatedStorage.Shared.modules.core.types.QuestType)

type QuestData = QuestType.QuestData

export type Quests = {
	MINE_COAL_1: QuestData,
	MINE_COAL_2: QuestData,

	get: (id: string) -> QuestData?,
	idOf: (questData: QuestData) -> string?,
}

local Quests = {} :: Quests

local function register(id: string, data: QuestData): QuestData
	return Registry.register(Registries.QUEST, id, data)
end

Quests.MINE_COAL_1 = register("miner.quest_1", {
	name = "Miner quest #1",
	questType = { "MineQuest" },
	requirements = {
		{ type = "mine", target = "dirt", amount = 1 },
	},
	rewards = { items = { { id = "efficiency_i", amount = 1 } } },
})

Quests.MINE_COAL_1 = register("miner.quest_2", {
	name = "Miner quest #2",
	questType = { "MineQuest" },
	requirements = {
		{ type = "mine", target = "dirt", amount = 1 },
	},
	rewards = { items = { { id = "power_ii", amount = 1 } } },
})

Quests.MINE_COAL_2 = register("miner.quest_3", {
	name = "Miner quest #3",
	questType = { "MineQuest" },
	requirements = {
		{ type = "mine", target = "dirt", amount = 1 },
	},
	rewards = { items = { { id = "coal", amount = 25 } } },
})

Quests.MINE_COAL_2 = register("miner.quest_4", {
	name = "Miner quest #4",
	questType = { "MineQuest" },
	requirements = {
		{ type = "mine", target = "dirt", amount = 1 },
	},
	rewards = { items = { { id = "coal", amount = 25 } } },
})

Quests.MINE_COAL_2 = register("miner.quest_5", {
	name = "Miner quest #5",
	questType = { "MineQuest" },
	requirements = {
		{ type = "mine", target = "dirt", amount = 1 },
	},
	rewards = { items = { { id = "coal", amount = 25 } } },
})

function Quests.get(id: string): QuestData?
	return Registries.QUEST:get(id)
end

function Quests.idOf(questData: QuestData): string?
	return Registries.QUEST:idOf(questData)
end

return Quests
