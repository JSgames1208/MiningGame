--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Networker = require(ReplicatedStorage.Packages.Networker)
local NPCs = require(ReplicatedStorage.Shared.modules.core.registries.NPCs)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
local dialogueSlice = require(ReplicatedStorage.Shared.ui.features.dialogue.state.dialogueSlice)

type DialogueSnapshot = DialogueTypes.DialogueSnapshot

local DialogueServiceClient = {}

function DialogueServiceClient.init(self: DialogueServiceClient)
	self.networker = Networker.client.new("DialogueService", self)

	--self.startDialogue(self, "npc.miner", "dialogue.miner.idle")

	self.clickConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not dialogueSlice.states.dialoguePlaying() then
				return
			end
			self:advance()
		end
	end)

	dialogueSlice.signals.selectChoiceSignal:Connect(function(index: number)
		self:selectChoice(index)
	end)
end

function DialogueServiceClient.startDialogue(self: DialogueServiceClient, npcId: string, entryId: string)
	dialogueSlice.actions.setDialoguePlaying(true)
end

function DialogueServiceClient.advance(self: DialogueServiceClient)
	self.networker:fire("advance")
end

function DialogueServiceClient.selectChoice(self: DialogueServiceClient, index: number)
	self.networker:fire("selectChoice", index)
end

function DialogueServiceClient.snapshot(self: DialogueServiceClient, snapshot: DialogueSnapshot)
	local npcEntry = NPCs.get(snapshot.npcId)
	if not npcEntry then
		return
	end

	dialogueSlice.actions.setDialogueSpeaker(npcEntry.name)

	if snapshot.nodeType == "line" then
		-- render line
		dialogueSlice.actions.setDialogueText(snapshot.text)
		dialogueSlice.actions.setChoices(nil)
	elseif snapshot.nodeType == "choice" then
		-- render choices
		dialogueSlice.actions.setDialogueText(snapshot.prompt)
		dialogueSlice.actions.setChoices(snapshot.choices)
	elseif snapshot.nodeType == "end" then
		-- clear dialogue
		self:finish()
	end
end

function DialogueServiceClient.finish(self: DialogueServiceClient)
	dialogueSlice.actions.setDialoguePlaying(false)
	dialogueSlice.actions.setDialogueSpeaker("")
	dialogueSlice.actions.setDialogueText("")
	dialogueSlice.actions.setChoices(nil)
end

export type DialogueServiceClient = typeof(DialogueServiceClient) & {
	networker: Networker.Client,
	clickConn: RBXScriptConnection?,
}

return DialogueServiceClient :: DialogueServiceClient
