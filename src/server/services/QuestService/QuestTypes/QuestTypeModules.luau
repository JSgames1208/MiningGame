local ServerScriptService = game:GetService("ServerScriptService")
local CollectQuest = require(ServerScriptService.Server.services.QuestService.QuestTypes.CollectQuest)
local CurrencyQuest = require(ServerScriptService.Server.services.QuestService.QuestTypes.CurrencyQuest)
local MineQuest = require(ServerScriptService.Server.services.QuestService.QuestTypes.MineQuest)
local TalkToQuest = require(ServerScriptService.Server.services.QuestService.QuestTypes.TalkToQuest)
return {
	["MineQuest"] = MineQuest,
	["CollectQuest"] = CollectQuest,
	["CurrencyQuest"] = CurrencyQuest,
	["TalkToQuest"] = TalkToQuest,
}
