local ServerScriptService = game:GetService("ServerScriptService")
local CollectQuest = require(ServerScriptService.Server.services.QuestService.QuestTypes.CollectQuest)
local CurrencyQuest = require(ServerScriptService.Server.services.QuestService.QuestTypes.CurrencyQuest)
local MineQuest = require(ServerScriptService.Server.services.QuestService.QuestTypes.MineQuest)
return {
	["MineQuest"] = MineQuest,
	["CollectQuest"] = CollectQuest,
	["CurrencyQuest"] = CurrencyQuest,
}
