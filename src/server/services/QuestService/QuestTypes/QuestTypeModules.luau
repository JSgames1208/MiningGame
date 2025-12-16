local ServerScriptService = game:GetService("ServerScriptService")
local MineQuest = require(ServerScriptService.Server.services.QuestService.QuestTypes.MineQuest)
return {
	["MineQuest"] = MineQuest,
}
