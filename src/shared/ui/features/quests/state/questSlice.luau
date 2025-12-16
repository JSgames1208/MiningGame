local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local atom: typeof(Charm.atom) = Charm.atom
type Atom<T> = Charm.Atom<T>
type Quests = DataTemplate.Quests

local questsOpen: Atom<boolean> = atom(false)

local quests: Atom<Quests> = atom({
	active = {},
	completed = {},
})

return {
	states = {
		questsOpen = questsOpen,
		quests = quests,
	},
	actions = {
		setQuestsOpen = function(value: boolean)
			questsOpen(value)
		end,
		setQuets = function(_quests: Quests)
			quests(_quests)
		end,
	},
}
