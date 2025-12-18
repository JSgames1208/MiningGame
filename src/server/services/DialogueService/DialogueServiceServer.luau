--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DialogueFSM = require(ServerScriptService.Server.services.DialogueService.DialogueFSM)
local QuestQueryServer = require(ServerScriptService.Server.services.QuestService.QuestQueryServer)
local Networker = require(ReplicatedStorage.Packages.Networker)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)

type DialogueFSM = DialogueFSM.DialogueFSM

local DialogueServiceServer = {}

function DialogueServiceServer.init(self: DialogueServiceServer)
	self.networker = Networker.server.new("DialogueService", self, {})
end

function DialogueServiceServer.startDialogue(
	self: DialogueServiceServer,
	player: Player,
	npcId: string,
	entryId: string
)
	local entry = Registries.DIALOGUE_ENTRY:get(entryId)
	if not entry then
		return
	end

	local ctx = {
		player = player,
		npcId = npcId,
		entryId = entryId,
		currentNodeId = entry.start,
		startedAt = os.time(),

		services = {
			quest = QuestQueryServer,
		},

		runtime = {},
	}

	local fsm = DialogueFSM.new(ctx)
	self.activeDialogs[player.UserId] = fsm
end

export type DialogueServiceServer = typeof(DialogueServiceServer) & {
	networker: Networker.Server,
	activeDialogs: { [number]: DialogueFSM },
}

return DialogueServiceServer
