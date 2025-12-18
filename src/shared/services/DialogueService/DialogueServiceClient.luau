--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)

type DialogueSnapshot = DialogueTypes.DialogueSnapshot

local DialogueServiceClient = {}

function DialogueServiceClient.init(self: DialogueServiceClient)
	self.networker = Networker.client.new("DialogueService", self)
end

function DialogueServiceClient.startDialogue(self: DialogueServiceClient, npcId: string, entryId: string)
	self.networker:fire("startDialogue", npcId, entryId)
end

function DialogueServiceClient.snapshot(self: DialogueServiceClient, snapshot: DialogueSnapshot) end

export type DialogueServiceClient = typeof(DialogueServiceClient) & {
	networker: Networker.Client,
}

return DialogueServiceClient :: DialogueServiceClient
