local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
type DialogueCondition = DialogueTypes.DialogueCondition

local DialogueConditions = {}

local function register(id: string, data: DialogueCondition)
	return Registries.DIALOGUE_CONDITION:register(id, data)
end

register("dialogue.miner.not_started", function(ctx: DialogueTypes.DialogueContext)
	return not ctx.services.quest:isStarted(ctx.player, "miner.quest_1")
end)

function DialogueConditions.get(id: string): DialogueCondition?
	return Registries.DIALOGUE_CONDITION:get(id)
end

return DialogueConditions
