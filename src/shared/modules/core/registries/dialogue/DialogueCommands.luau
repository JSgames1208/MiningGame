local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
type DialogueCommand = DialogueTypes.DialogueCommand

local DialogueCommands = {}

local function register(id: string, data: DialogueCommand)
	return Registries.DIALOGUE_COMMAND:register(id, data)
end

register("grant_quest", function(ctx: DialogueTypes.DialogueRuntimeContext, data: DialogueTypes.CommandData)
	ctx.services.quest:grantQuest(ctx.player, data.questId)
end)

register("complete_quest", function(ctx: DialogueTypes.DialogueRuntimeContext, data: DialogueTypes.CommandData)
	ctx.services.quest:completeQuest(ctx.player, data.questId)
end)

function DialogueCommands.get(id: string): DialogueCommand?
	return Registries.DIALOGUE_COMMAND:get(id)
end

return DialogueCommands
