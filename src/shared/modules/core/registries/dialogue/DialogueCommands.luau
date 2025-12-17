local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
type DialogueCommand = DialogueTypes.DialogueCommand

local DialogueCommands = {}

local function register(id: string, data: DialogueCommand)
	return Registries.DIALOGUE_COMMAND:register(id, data)
end

function DialogueCommands.get(id: string): DialogueCommand?
	return Registries.DIALOGUE_COMMAND:get(id)
end

return DialogueCommands
