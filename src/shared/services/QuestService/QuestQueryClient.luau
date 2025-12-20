local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestServiceClient = require(ReplicatedStorage.Shared.services.QuestService.QuestServiceClient)
local QuestQuery = {}

function QuestQuery:isStarted(player: Player, questId: string)
	return QuestServiceClient:isStarted(questId)
end

function QuestQuery:isCompleted(player: Player, questId: string)
	return QuestServiceClient:isCompleted(questId)
end

function QuestQuery:isFinished(player: Player, questId: string)
	return QuestServiceClient:isFinished(questId)
end

function QuestQuery:grantQuest(player, questId: string)
	warn("Can't grant quests from client!")
end

function QuestQuery:completeQuest(player, questId: string)
	warn("Can't complete quests from client!")
end

return QuestQuery
