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
	self.networker = Networker.server.new("DialogueService", self, {
		self.startDialogue :: any,
		self.advance :: any,
		self.selectChoice :: any,
		self.finish :: any,
	})

	self.activeDialogs = {}
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

	local snapshot = fsm:makeSnapshot()

	self.networker:fire(player, "snapshot", snapshot)
end

function DialogueServiceServer.advance(self: DialogueServiceServer, player: Player)
	local fsm = self.activeDialogs[player.UserId]
	if not fsm then
		return
	end

	local snapshot = fsm:advance():makeSnapshot()

	print(snapshot)

	self.networker:fire(player, "snapshot", snapshot)
end

function DialogueServiceServer.selectChoice(self: DialogueServiceServer, player: Player, index: number)
	local fsm = self.activeDialogs[player.UserId]
	if not fsm then
		return
	end

	local snapshot = fsm:selectChoice(index):makeSnapshot()

	self.networker:fire(player, "snapshot", snapshot)
end

function DialogueServiceServer.finish(self: DialogueServiceServer, player: Player)
	self.activeDialogs[player.UserId] = nil
end

export type DialogueServiceServer = typeof(DialogueServiceServer) & {
	networker: Networker.Server,
	activeDialogs: { [number]: DialogueFSM },
}

return DialogueServiceServer :: DialogueServiceServer
