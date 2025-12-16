--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local QuestSignals = require(ServerScriptService.Server.services.QuestService.QuestSignals)
local Base = require(ServerScriptService.Server.services.QuestService.QuestTypes._Base)
local QuestType = require(ReplicatedStorage.Shared.modules.core.types.QuestType)
type QuestData = QuestType.QuestData

local MineQuest = {} :: Base.QuestTypeModule

function MineQuest.supports(reqType: string): boolean
	return reqType == "mine"
end

function MineQuest.startRequirement(runtime: Base.Runtime, reqRuntime: Base.RequirementRuntime)
	local conn
	conn = QuestSignals.OreMined:Connect(function(player: Player, oreId: string)
		if player ~= runtime.player then
			return
		end

		if oreId ~= reqRuntime.data.target then
			return
		end

		local req = runtime.progress.requirements[reqRuntime.id]
		if not req then
			return
		end

		req.current = req.current + 1
		if req.current > req.target then
			req.current = req.target
		end

		local playerQuests = DataService:get(player, { "quests" })
		if playerQuests and playerQuests.active[runtime.questId] then
			playerQuests.active[runtime.questId].progress[reqRuntime.id] = {
				current = req.current,
				target = req.target,
			}
		end

		DataService:set(player, { "quests" }, playerQuests)

		if req.current >= req.target then
			reqRuntime.complete()
		end
	end)

	return conn
end

function MineQuest.stopRequirement(conn: RBXScriptConnection?)
	if conn then
		conn:Disconnect()
	end
end

return MineQuest
