--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local QuestTypeModules = require(ServerScriptService.Server.services.QuestService.QuestTypes.QuestTypeModules)
local Base = require(ServerScriptService.Server.services.QuestService.QuestTypes._Base)
local Networker = require(ReplicatedStorage.Packages.Networker)
local Sift = require(ReplicatedStorage.Packages.Sift)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local Quests = require(ReplicatedStorage.Shared.modules.core.registries.Quests)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local QuestType = require(ReplicatedStorage.Shared.modules.core.types.QuestType)

type QuestData = QuestType.QuestData
type Progress = Base.Progress
type Runtime = Base.Runtime
type RequirementRuntime = Base.RequirementRuntime
type QuestTypeModule = Base.QuestTypeModule

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
	self.networker = Networker.server.new("QuestService", self, {
		self.pinQuest :: any,
		self.unpinQuest :: any,
		self.isStarted :: any,
		self.isCompleted :: any,
		self.isFinished :: any,
	})
end

function QuestServiceServer.onPlayerAdded(self: QuestServiceServer, player: Player)
	Active[player.UserId] = {}

	local playerQuests: DataTemplate.Quests = DataService:get(player, { "quests" })
	if not playerQuests then
		return
	end

	--self.networker:fire(player, "setQuests", playerQuests)

	for questId, saved in pairs(playerQuests.active) do
		self:startQuest(player, questId, {
			completed = false,
			requirements = saved.progress,
		})
	end
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

function QuestServiceServer.getCurrentQuest(
	self: QuestServiceServer,
	player: Player,
	questline: QuestType.Questline
): string?
	for _, questId in ipairs(questline.quests) do
		if not self:isFinished(player, questId) then
			return questId
		end
	end
	return nil
end

function QuestServiceServer.getNextQuest(
	self: QuestServiceServer,
	player: Player,
	questline: QuestType.Questline
): string?
	for _, questId in ipairs(questline.quests) do
		if not self:isStarted(player, questId) and not self:isFinished(player, questId) then
			return questId
		end
	end
	return nil
end

function QuestServiceServer.pinQuest(self: QuestServiceServer, player: Player, questId: string)
	local playerQuests: DataTemplate.Quests = DataService:get(player, { "quests" })
	if not playerQuests then
		return
	end

	if not playerQuests.active[questId] then
		return
	end

	if playerQuests.pinned[questId] then
		return
	end

	playerQuests.pinned = Sift.Dictionary.join(playerQuests.pinned, { [questId] = true })

	DataService:set(player, { "quests" }, playerQuests)
end

function QuestServiceServer.unpinQuest(self: QuestServiceServer, player: Player, questId: string)
	local playerQuests: DataTemplate.Quests = DataService:get(player, { "quests" })
	if not playerQuests then
		return
	end

	if not playerQuests.pinned[questId] then
		return
	end

	playerQuests.pinned[questId] = nil

	DataService:set(player, { "quests" }, playerQuests)
end

local function buildRequirementMap(requirements: { { type: string, target: any, amount: number } })
	local map: { [string]: number } = {}
	for _, req in ipairs(requirements) do
		local reqId = req.type .. "_" .. tostring(req.target)
		map[reqId] = req.amount
	end

	return map
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

	local reqMap = buildRequirementMap(questData.requirements)
	local progress = savedProgress or Base.newProgress(reqMap)

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

	for _, req in ipairs(questData.requirements) do
		local reqId = req.type .. "_" .. tostring(req.target)

		local reqProg = progress.requirements[reqId]
		if not reqProg then
			progress.requirements[reqId] = { current = 0, target = req.amount }
			reqProg = progress.requirements[reqId]
		end

		local reqRuntime: RequirementRuntime = {
			id = reqId,
			data = req,
			progress = reqProg,
			complete = function()
				reqProg.current = reqProg.target
			end,
		}

		local pickedModule: QuestTypeModule? = nil

		if type(questData.questType) == "string" then
			pickedModule = QuestTypeModules[questData.questType]
		elseif type(questData.questType) == "table" then
			for _, moduleName in ipairs(questData.questType) do
				pickedModule = QuestTypeModules[moduleName]
				if pickedModule and pickedModule.supports(req.type) then
					break
				end
			end
		end

		if pickedModule then
			print(reqId, pickedModule)
			moduleMap[reqId] = pickedModule
			local conn = pickedModule.startRequirement(runtime, reqRuntime)
			requirementConnections[reqId] = conn
		else
			warn("unknown quest requirement type:", req.type)
		end
	end

	Active[player.UserId][questId] = {
		data = questData,
		progress = progress,
		moduleMap = moduleMap,
		requirementConnections = requirementConnections,
		runtime = runtime,
	}
end

function QuestServiceServer.grantQuest(self: QuestServiceServer, player: Player, questId: string)
	local playerQuests: DataTemplate.Quests = DataService:get(player, { "quests" })
	if not playerQuests then
		return false
	end

	if playerQuests.completed[questId] then
		return false
	end

	if playerQuests.active[questId] then
		return false
	end

	local questData = Quests.get(questId)
	if not questData then
		warn("unknown quest: " .. questId)
		return false
	end

	local reqMap = buildRequirementMap(questData.requirements)
	local progress = Base.newProgress(reqMap)

	playerQuests.active[questId] = { started = os.time(), progress = progress.requirements }

	DataService:set(player, { "quests" }, playerQuests)

	self:startQuest(player, questId)
	return true
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

	for reqId, conn in pairs(q.requirementConnections) do
		local mod = q.moduleMap[reqId]
		if mod then
			mod.stopRequirement(conn)
		elseif conn then
			conn:Disconnect()
		end
	end

	local playerQuests: DataTemplate.Quests = DataService:get(player, { "quests" })
	if not playerQuests then
		return
	end

	playerQuests.active[questId] = nil
	playerQuests.completed[questId] = true

	DataService:set(player, { "quests" }, playerQuests)

	-- TODO: rewards

	userQuests[questId] = nil
end

function QuestServiceServer.isStarted(self: QuestServiceServer, player: Player, questId: string): boolean
	return Active[player.UserId] and Active[player.UserId][questId] ~= nil
end

function QuestServiceServer.isCompleted(self: QuestServiceServer, player: Player, questId: string): boolean
	local playerQuests: DataTemplate.Quests = DataService:get(player, { "quests" })
	if not playerQuests then
		return false
	end

	if playerQuests.active and playerQuests.active[questId] then
		local quest = playerQuests.active[questId]

		for _, req in pairs(quest.progress) do
			if req.current < req.target then
				return false
			end
		end

		return true
	end

	return false
end

function QuestServiceServer.isFinished(self: QuestServiceServer, player: Player, questId: string): boolean
	local playerQuests: DataTemplate.Quests = DataService:get(player, { "quests" })
	if not playerQuests then
		return false
	end

	return playerQuests.completed and playerQuests.completed[questId]
end

export type QuestServiceServer = typeof(QuestServiceServer) & {
	networker: Networker.Server,
}

return QuestServiceServer :: QuestServiceServer
