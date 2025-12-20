local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
type DialogueCondition = DialogueTypes.DialogueCondition

local DialogueConditions = {}

local function register(id: string, data: DialogueCondition)
	return Registries.DIALOGUE_CONDITION:register(id, data)
end

register("quest.not_started", function(ctx: DialogueTypes.DialogueQueryContext, data)
	return not ctx.services.quest:isActive(ctx.player, data.questId)
		and not ctx.services.quest:isCompleted(ctx.player, data.questId)
		and not ctx.services.quest:isFinished(ctx.player, data.questId)
end)

register("quest.completed", function(ctx: DialogueTypes.DialogueQueryContext, data)
	return ctx.services.quest:isCompleted(ctx.player, data.questId)
end)

function DialogueConditions.get(id: string): DialogueCondition?
	return Registries.DIALOGUE_CONDITION:get(id)
end

return DialogueConditions
