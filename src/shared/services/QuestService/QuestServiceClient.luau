--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local Sift = require(ReplicatedStorage.Packages.Sift)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local questSlice = require(ReplicatedStorage.Shared.ui.features.quests.state.questSlice)

type Quests = DataTemplate.Quests

local QuestServiceClient = {}

function QuestServiceClient.init(self: QuestServiceClient)
	self.networker = Networker.client.new("QuestService", self)

	local prevQuests: Quests = {
		active = {},
		completed = {},
	}

	local function progressEquals(
		_a: { [string]: { current: number, target: number } }?,
		_b: { [string]: { current: number, target: number } }?
	)
		if _a == _b then
			return true
		end

		local a = _a or {}
		local b = _b or {}

		local aCount = Sift.Dictionary.count(a)
		local bCount = Sift.Dictionary.count(b)

		if aCount ~= bCount then
			return false
		end

		for key, av in pairs(a) do
			local bv = b[key]
			if not bv then
				return false
			end
			if av.current ~= bv.current or av.target ~= bv.target then
				return false
			end
		end

		return true
	end

	local function onQuestsChanged(_newQuests: Quests?)
		if not _newQuests then
			_newQuests = { active = {}, completed = {} }
		end

		local newQuests: Quests = _newQuests :: Quests

		newQuests.active = newQuests.active or {}
		newQuests.completed = newQuests.completed or {}

		for questId, saved in pairs(newQuests.active) do
			local prevSaved = prevQuests.active[questId]

			if not prevSaved then
				self:addQuest(questId, saved)
			else
				if not progressEquals(prevSaved.progress, saved.progress) then
					self:updateQuest(questId, saved)
				end
			end
		end

		for questId, prevSaved in pairs(prevQuests.active) do
			if not newQuests.active[questId] then
				self:removeQuest(questId)
			end
		end

		for questId, _ in pairs(prevQuests.completed) do
			if not newQuests.completed[questId] then
				self:removeQuest(questId)
			end
		end

		prevQuests = {
			active = newQuests.active,
			completed = newQuests.completed,
		}
	end

	local initialQuests: Quests = DataService:get({ "quests" }) :: Quests
	if initialQuests then
		onQuestsChanged(initialQuests)
	end

	DataService:getChangedSignal({ "quests" }):Connect(function(newVal: Quests)
		task.defer(function()
			onQuestsChanged(newVal)
		end)
	end)
end

function QuestServiceClient.addQuest(self: QuestServiceClient, questId: string, quest: DataTemplate.SavedQuestProgress)
	questSlice.actions.addQuest(questId, quest)
end

function QuestServiceClient.updateQuest(
	self: QuestServiceClient,
	questId: string,
	quest: DataTemplate.SavedQuestProgress
)
	questSlice.actions.updateQuest(questId, quest)
end

function QuestServiceClient.removeQuest(self: QuestServiceClient, questId: string)
	questSlice.actions.removeQuest(questId)
end

export type QuestServiceClient = typeof(QuestServiceClient) & {
	networker: Networker.Client,
}

return QuestServiceClient :: QuestServiceClient
