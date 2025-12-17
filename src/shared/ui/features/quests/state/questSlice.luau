local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Signal = require(ReplicatedStorage.Packages.Signal)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local atom: typeof(Charm.atom) = Charm.atom

-- TYPE DEFS

type Atom<T> = Charm.Atom<T>
type Quests = DataTemplate.Quests

type Quest = DataTemplate.SavedQuestProgress

-- STATE

local questsOpen: Atom<boolean> = atom(false)

local activeQuestIds: Atom<{ string }> = atom({})
local pinnedQuestIds: Atom<{ string }> = atom({})
local questById = {} :: { [string]: Atom<Quest> }

-- SIGNALS

local pinSignal = Signal.new()
local unpinSignal = Signal.new()

return {
	states = {
		questsOpen = questsOpen,
		activeQuestIds = activeQuestIds,
		pinnedQuestIds = pinnedQuestIds,
	},
	signals = {
		pinSignal = pinSignal,
		unpinSignal = unpinSignal,
	},
	actions = {
		pinQuest = function(questId: string)
			pinSignal:Fire(questId)
			pinnedQuestIds(function(list)
				return Sift.Array.push(list, questId)
			end)
		end,
		unpinQuest = function(questId: string)
			unpinSignal:Fire(questId)
			pinnedQuestIds(function(list)
				return Sift.Array.filter(list, function(id)
					return id ~= questId
				end)
			end)
		end,
		addQuest = function(questId: string, quest: Quest)
			questById[questId] = atom(quest)
			activeQuestIds(function(list)
				return Sift.Array.push(list, questId)
			end)
		end,
		updateQuest = function(questId: string, quest: Quest)
			local q = questById[questId]
			if q then
				q(function(prev)
					return Sift.Dictionary.merge(prev, quest)
				end)
			end
		end,
		removeQuest = function(questId: string)
			activeQuestIds(function(list)
				return Sift.Array.filter(list, function(id)
					return id ~= questId
				end)
			end)
		end,
		getQuestById = function(id: string)
			return questById[id]
		end,
		setQuestsOpen = function(open: boolean)
			questsOpen(open)
		end,
	},
}
