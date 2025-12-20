local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
type DialogueCommand = DialogueTypes.DialogueCommand

local DialogueCommands = {}

local function register(id: string, data: DialogueCommand)
	return Registries.DIALOGUE_COMMAND:register(id, data)
end

register("grant_quest", function(ctx: DialogueTypes.DialogueRuntimeContext)
	assert(ctx.player, "Dialogue command missing player!")

	local questService = ctx.services.quest
	local npcId = ctx.npcId

	local npcEntry = Registries.NPC:get(npcId)
	local questline = npcEntry and npcEntry.questline
	assert(questline, "No questline for NPC: " .. npcId)

	local questlineEntry = Registries.QUESTLINE:get(questline)

	if not questlineEntry then
		warn("No questline entry for questline: " .. questline)
		return
	end

	local nextQuest = questService:getNextQuest(ctx.player, questlineEntry)

	if not nextQuest then
		warn("No next quest for questline: " .. questline)
		return
	end

	ctx.services.quest:grantQuest(ctx.player, nextQuest)
end)

register("complete_quest", function(ctx: DialogueTypes.DialogueRuntimeContext)
	assert(ctx.player, "Dialogue command missing player!")

	local questService = ctx.services.quest
	local npcId = ctx.npcId

	local npcEntry = Registries.NPC:get(npcId)
	local questline = npcEntry and npcEntry.questline
	assert(questline, "No questline for NPC: " .. npcId)

	local questlineEntry = Registries.QUESTLINE:get(questline)

	if not questlineEntry then
		warn("No questline entry for questline: " .. questline)
		return
	end

	local currentQuest = questService:getCurrentQuest(ctx.player, questlineEntry)
	if not currentQuest then
		warn("No current quest for questline: " .. questline)
		return
	end

	ctx.services.quest:completeQuest(ctx.player, currentQuest)
end)

function DialogueCommands.get(id: string): DialogueCommand?
	return Registries.DIALOGUE_COMMAND:get(id)
end

return DialogueCommands
