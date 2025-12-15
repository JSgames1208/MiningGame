--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Base = require(ServerScriptService.Server.services.QuestService.QuestTypes._Base)
local Networker = require(ReplicatedStorage.Packages.Networker)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local QuestType = require(ReplicatedStorage.Shared.modules.core.types.QuestType)

type QuestData = QuestType.QuestData
type Progress = Base.Progress
type Runtime = Base.Runtime
type RequirementRuntime = Base.RequirementRuntime

local QuestServiceServer = {}

--[[
    runtime only (NOT SAVED)
    [player] = {
        [questId] = {
            data: QuestData,
            progress: Progress,
        }
    }
]]
local Active: {
	[number]: {
		[string]: {
			data: QuestData,
			progress: Progress,
			moduleMap: { [string]: Base.QuestTypeModule },
			requirementConnections: { [string]: RBXScriptConnection? },
			runtime: Runtime,
		},
	},
} =
	{}

function QuestServiceServer.init(self: QuestServiceServer)
	self.networker = Networker.server.new("QuestService", self, {})
end

function QuestServiceServer.onPlayerAdded(self: QuestServiceServer, player: Player)
	Active[player.UserId] = {}

	-- TODO: load saved quests
end

function QuestServiceServer.onPlayerRemoving(self: QuestServiceServer, player: Player)
	local quests = Active[player.UserId]
	if not quests then
		return
	end

	for _, q in quests do
		for reqId, conn in pairs(q.requirementConnections) do
			local mod = q.moduleMap[reqId]
			if mod and conn then
				mod.stopRequirement(conn)
			elseif conn then
				conn:Disconnect()
			end
		end
	end

	Active[player.UserId] = nil
end

function QuestServiceServer.startQuest(
	self: QuestServiceServer,
	player: Player,
	questId: string,
	savedProgress: Progress?
)
	local questData = Registries.QUEST:get(questId)
	if not questData then
		warn("unknown quest:", questId)
		return
	end

	local questModule = require(questData.questType) :: Base.QuestTypeModule
	local progress = savedProgress
		or Base.newProgress(Sift.Dictionary.map(questData.requirements, function(acc, req)
			acc[req.type .. "_" .. tostring(req.target)] = req.amount
			return acc
		end))

	local runtime: Runtime
	runtime = {
		player = player,
		questId = questId,
		data = questData,
		progress = progress,
		complete = function()
			self:completeQuest(player, questId)
		end,
		_conn = nil,
	}

	local requirementConnections: { [string]: RBXScriptConnection? } = {}
	local moduleMap: { [string]: Base.QuestTypeModule } = {}

	for _, req in pairs(progress.requirements) do
		local reqId = req.type .. "_" .. tostring(req.target)
		local reqRuntime: RequirementRuntime = {
			id = reqId,
			data = questData,
			progress = reqProg,
			complete = function()
				reqProg.current = reqProg.target

				local allDone = true
				for _, r in progress.requirements do
					if r.current < r.target then
						allDone = false
						break
					end
				end
				if allDone then
					runtime.complete()
				end
			end,
		}

		if questModule.supports(reqType) then
			requirementConnections[reqType] = questModule.startRequirement(runtime, reqRuntime)
		end
	end

	Active[player.UserId][questId] = {
		data = questData,
		progress = progress,
		module = questModule,
		requirementConnections = requirementConnections,
		runtime = runtime,
	}
end

function QuestServiceServer.completeQuest(self: QuestServiceServer, player: Player, questId: string)
	local userQuests = Active[player.UserId]
	if not userQuests then
		return
	end

	local q = userQuests[questId]
	if not q then
		return
	end

	q.progress.completed = true

	for _, conn in q.requirementConnections do
		if conn then
			q.module.stopRequirement(conn)
		end
	end

	-- TODO: rewards
	-- TODO: save completed quest id

	userQuests[questId] = nil
end

export type QuestServiceServer = typeof(QuestServiceServer) & {
	networker: Networker.Server,
}

return QuestServiceServer
