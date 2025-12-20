--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DialogueFSM = require(ServerScriptService.Server.services.DialogueService.DialogueFSM)
local QuestQueryServer = require(ServerScriptService.Server.services.QuestService.QuestQueryServer)
local Networker = require(ReplicatedStorage.Packages.Networker)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)

local DEBUG = false

local function dprint(...)
	if DEBUG then
		print(...)
	end
end

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
			local entry = self:pickEntry(player, npcId)

			if entry then
				self:startDialogue(player, npcId, entry)
			end
		end)
	end
end

function DialogueServiceServer.checkConditions(
	self: DialogueServiceServer,
	player: Player,
	npcId: string,
	conditions: { DialogueTypes.DialogueConditionBlock }?
): boolean
	if not conditions then
		return true
	end

	local ctx: DialogueTypes.DialogueQueryContext = {
		player = player,
		npcId = npcId,
		services = {
			quest = QuestQueryServer,
		},
	}

	for _, cond in conditions do
		local fn = Registries.DIALOGUE_CONDITION:get(cond.type)

		if not fn then
			warn("Missing dialogue condition:", cond.type)
			continue
		end

		if not fn(ctx, cond.data) then
			return false
		end
	end

	return true
end

function DialogueServiceServer.resolveEntryStart(
	self: DialogueServiceServer,
	player: Player,
	npcId: string,
	entry: DialogueTypes.DialogueEntry
): (string?, number, number?)
	local function passes(conds: { DialogueTypes.DialogueConditionBlock }?): boolean
		return self:checkConditions(player, npcId, conds)
	end

	if (entry :: any).start then
		dprint("simple")
		local simple = entry :: {
			start: string,
			conditions: { DialogueTypes.DialogueConditionBlock }?,
			priority: number?,
			weight: number?,
		}
		if not passes(simple.conditions) then
			return nil, -math.huge, nil
		end

		return simple.start, simple.priority or 0, simple.weight
	end

	dprint("staged")

	local staged = entry :: { stages: { DialogueTypes.DialogueStage } }
	if not staged.stages then
		return nil, -math.huge, nil
	end

	local bestStage: DialogueTypes.DialogueStage? = nil
	local bestPriority: number = -math.huge
	local fallbackStage: DialogueTypes.DialogueStage? = nil

	for _, stage in ipairs(staged.stages) do
		if not stage.when or (#stage.when == 0) then
			fallbackStage = stage
		end

		if passes(stage.when) then
			local p = stage.priority or 0
			if p > bestPriority then
				bestPriority = p
				bestStage = stage
			end
		end
	end

	if bestStage then
		return bestStage.start, bestPriority, bestStage.weight
	end

	if fallbackStage then
		return fallbackStage.start, fallbackStage.priority or 0, fallbackStage.weight
	end

	return nil, -math.huge, nil
end

function DialogueServiceServer.pickEntry(self: DialogueServiceServer, player: Player, npcId: string): string?
	local npcEntry = Registries.NPC:get(npcId)
	if not npcEntry then
		return
	end

	if npcEntry.questline then
		local questline = Registries.QUESTLINE:get(npcEntry.questline)
		dprint(questline)
		if questline and questline.quests and #questline.quests > 0 then
			local currentQuest = QuestQueryServer:getCurrentQuest(player, questline)

			dprint(currentQuest)

			if not currentQuest then
				if npcEntry.idleDialogue then
					return npcEntry.idleDialogue
				end
			else
				if QuestQueryServer:isCompleted(player, currentQuest) then
					local questTurninEntry = ("dialogue.%s.turnin"):format(questline.id)
					if Registries.DIALOGUE_ENTRY:exists(questTurninEntry) then
						return questTurninEntry
					end

					if npcEntry.questTurninDialogue then
						return npcEntry.questTurninDialogue
					end

					local questMeta = Registries.QUEST:get(currentQuest)
					if questMeta and questMeta.turninDialogue then
						return questMeta.turninDialogue
					end
				elseif QuestQueryServer:isActive(player, currentQuest) then
					if npcEntry.idleDialogue then
						return npcEntry.idleDialogue
					end
				else
					local questOfferEntry = ("dialogue.%s.offer"):format(questline.id)
					dprint(questOfferEntry)
					if Registries.DIALOGUE_ENTRY:exists(questOfferEntry) then
						dprint("exists")
						return questOfferEntry
					end

					if npcEntry.questOfferDialogue then
						return npcEntry.questOfferDialogue
					end
				end
			end
		end
	end

	local bestId: string? = nil
	local bestPriority: number = -math.huge
	local bestWeight = nil

	for _, entryId in ipairs(npcEntry.dialogues or {}) do
		local entry = Registries.DIALOGUE_ENTRY:get(entryId)
		if not entry then
			continue
		end

		local startNode, priority, weight = self:resolveEntryStart(player, npcId, entry)
		if not startNode then
			continue
		end

		priority = priority or 0
		if priority > bestPriority then
			bestPriority = priority
			bestId = entryId
			bestWeight = weight
		elseif priority == bestPriority then
			local w1 = bestWeight or 0
			local w2 = weight or 0
			if w2 > w1 then
				bestId = entryId
				bestWeight = weight
			end
		end
	end

	if bestId then
		return bestId
	end

	if npcEntry.idleDialogue then
		return npcEntry.idleDialogue
	end

	return nil
end

function DialogueServiceServer.startDialogue(
	self: DialogueServiceServer,
	player: Player,
	npcId: string,
	entryId: string
)
	local entry = Registries.DIALOGUE_ENTRY:get(entryId)

	dprint("starting dialogue: ", entry)

	if not entry then
		return
	end

	local startNode, priority = self:resolveEntryStart(player, npcId, entry)

	dprint("startNode: ", startNode)

	if not startNode then
		return
	end

	self.networker:fire(player, "startDialogue", npcId, entryId)

	local ctx = {
		player = player,
		npcId = npcId,
		entryId = entryId,
		currentNodeId = startNode,
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
