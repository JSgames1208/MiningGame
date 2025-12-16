--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local questSlice = require(ReplicatedStorage.Shared.ui.features.quests.state.questSlice)

type Quests = DataTemplate.Quests

local QuestServiceClient = {}

function QuestServiceClient.init(self: QuestServiceClient)
	self.networker = Networker.client.new("QuestService", self)

	DataService:getChangedSignal({ "quests" }):Connect(function(newQuests: Quests)
		self:setQuests(newQuests)
	end)
end

function QuestServiceClient.setQuests(self: QuestServiceClient, quests: Quests)
	print(quests)
	questSlice.actions.setQuets(quests)
end

export type QuestServiceClient = typeof(QuestServiceClient) & {
	networker: Networker.Client,
}

return QuestServiceClient :: QuestServiceClient
