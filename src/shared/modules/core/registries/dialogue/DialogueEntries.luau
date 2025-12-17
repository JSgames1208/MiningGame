local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
type DialogueEntry = DialogueTypes.DialogueEntry

local DialogueEntries = {}

local function register(id: string, data: DialogueEntry)
	return Registries.DIALOGUE_ENTRY:register(id, data)
end

register("dialogue.miner.idle", {
	start = "dialogue.miner.idle.line_1",
	conditions = nil,
})

function DialogueEntries.get(id: string): DialogueEntry?
	return Registries.DIALOGUE_ENTRY:get(id)
end

return DialogueEntries
