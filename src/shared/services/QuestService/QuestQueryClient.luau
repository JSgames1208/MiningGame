local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestServiceClient = require(ReplicatedStorage.Shared.services.QuestService.QuestServiceClient)
local QuestQuery = {}

function QuestQuery:isStarted(player: Player, questId: string)
	return QuestServiceClient:isStarted(questId)
end

function QuestQuery:isCompleted(player: Player, questId: string)
	return QuestServiceClient:isCompleted(questId)
end

return QuestQuery
