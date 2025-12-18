local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local Signal = require(ReplicatedStorage.Packages.Signal)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
local atom: typeof(Charm.atom) = Charm.atom

type Choice = DialogueTypes.Choice

type Atom<T> = Charm.Atom<T>

-- STATE
local dialoguePlaying: Atom<boolean> = atom(false)
local dialogueText: Atom<string> = atom("")
local dialogueSpeaker: Atom<string> = atom("")
local choices: Atom<{ Choice }?> = atom(nil :: { Choice }?)

-- SIGNALS

local selectChoiceSignal = Signal.new()

-- ACTIONS
local actions = {
	setDialoguePlaying = function(playing: boolean)
		dialoguePlaying(playing)
	end,
	setDialogueText = function(text: string)
		dialogueText(text)
	end,
	setDialogueSpeaker = function(speaker: string)
		dialogueSpeaker(speaker)
	end,
	setChoices = function(_choices: { Choice }?)
		choices(_choices)
	end,
}

return {
	states = {
		dialoguePlaying = dialoguePlaying,
		dialogueText = dialogueText,
		dialogueSpeaker = dialogueSpeaker,
		choices = choices,
	},
	signals = {
		selectChoiceSignal = selectChoiceSignal,
	},
	actions = actions,
}
