local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local QuestSignals = require(ServerScriptService.Server.services.QuestService.QuestSignals)
local Base = require(ServerScriptService.Server.services.QuestService.QuestTypes._Base)

local TalkToQuest = {} :: Base.QuestTypeModule

function TalkToQuest.supports(reqType: string): boolean
	return reqType == "talkTo"
end

function TalkToQuest.startRequirement(runtime: Base.Runtime, reqRuntime: Base.RequirementRuntime): RBXScriptConnection
	local conn
	conn = QuestSignals.TalkedTo:Connect(function(player: Player, npcId: string)
		if player ~= runtime.player then
			return
		end

		if npcId ~= reqRuntime.data.target then
			return
		end

		local req = runtime.progress.requirements[reqRuntime.id]
		if not req then
			return
		end

		req.current = 1

		local playerQuests = DataService:get(player, { "quests" })
		if playerQuests and playerQuests.active[runtime.questId] then
			playerQuests.active[runtime.questId].progress[reqRuntime.id] = {
				current = req.current,
				target = req.target,
			}
		end

		DataService:set(player, { "quests" }, playerQuests)

		reqRuntime.complete()
	end)

	return conn
end

function TalkToQuest.stopRequirement(conn: RBXScriptConnection?)
	if conn then
		conn:Disconnect()
		conn = nil
	end
end

return TalkToQuest
