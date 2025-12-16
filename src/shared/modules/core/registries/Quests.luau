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

Quests.MINE_COAL_1 = register("mine_coal_1", {
	name = "Mine Coal 1",
	questType = { "MineQuest" },
	requirements = {
		{ type = "mine", target = "stone", amount = 3 },
		{ type = "mine", target = "coal", amount = 1 },
	},
	rewards = { items = { { id = "coal", amount = 3 } } },
})

Quests.MINE_COAL_2 = register("mine_coal_2", {
	name = "Mine Coal 2",
	questType = { "MineQuest" },
	requirements = {
		{ type = "mine", target = "stone", amount = 25 },
		{ type = "mine", target = "coal", amount = 10 },
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
