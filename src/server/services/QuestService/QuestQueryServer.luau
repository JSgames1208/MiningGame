local ServerScriptService = game:GetService("ServerScriptService")
local QuestServiceServer = require(ServerScriptService.Server.services.QuestService.QuestServiceServer)
local QuestQuery = {}

function QuestQuery:isActive(player: Player, questId: string): boolean
	return QuestServiceServer:isStarted(player, questId)
end

function QuestQuery:isCompleted(player: Player, questId: string): boolean
	return QuestServiceServer:isCompleted(player, questId)
end

function QuestQuery:grantQuest(player: Player, questId: string)
	QuestServiceServer:grantQuest(player, questId)
end

return QuestQuery
