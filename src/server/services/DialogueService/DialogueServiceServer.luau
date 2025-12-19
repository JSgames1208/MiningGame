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

	local npcFolder = workspace:FindFirstChild("NPCs")
	if not npcFolder then
		npcFolder = Instance.new("Folder", workspace)
		npcFolder.Name = "NPCs"
	end

	for _, npc in npcFolder:GetChildren() do
		local npcId = npc:GetAttribute("id")
		if not npcId then
			continue
		end

		local npcEntry = Registries.NPC:get(npcId)

		if not npcEntry then
			continue
		end

		local proxPrompt: ProximityPrompt? = npc:FindFirstChild("ProximityPrompt")

		if not proxPrompt then
			continue
		end

		proxPrompt.Triggered:Connect(function(player: Player)
			self:startDialogue(player, npcId, npcEntry.dialogues[1])
		end)
	end
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

	self.networker:fire(player, "startDialogue", npcId, entryId)

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

function DialogueServiceServer.sendSnapshot(self: DialogueServiceServer, player: Player)
	local fsm = self.activeDialogs[player.UserId]
	if not fsm then
		return
	end

	local snapshot = fsm:makeSnapshot()

	self.networker:fire(player, "snapshot", snapshot)
end

function DialogueServiceServer.advance(self: DialogueServiceServer, player: Player)
	local fsm: DialogueFSM = self.activeDialogs[player.UserId]
	if not fsm then
		return
	end

	fsm:advance()
	self:sendSnapshot(player)

	if fsm:isFinished() then
		self:finish(player)
	end
end

function DialogueServiceServer.selectChoice(self: DialogueServiceServer, player: Player, index: number)
	local fsm = self.activeDialogs[player.UserId]
	if not fsm then
		return
	end

	fsm:selectChoice(index)
	self:sendSnapshot(player)
end

function DialogueServiceServer.finish(self: DialogueServiceServer, player: Player)
	self.activeDialogs[player.UserId] = nil
end

export type DialogueServiceServer = typeof(DialogueServiceServer) & {
	networker: Networker.Server,
	activeDialogs: { [number]: DialogueFSM },
}

return DialogueServiceServer :: DialogueServiceServer
