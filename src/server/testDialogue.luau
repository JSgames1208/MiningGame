local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DialogueFSM = require(ServerScriptService.Server.services.DialogueService.DialogueFSM)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)

local function runTestDialogue()
	local entryId = "dialogue.miner.idle"

	local entry = Registries.DIALOGUE_ENTRY:get(entryId)
	local ctx: DialogueTypes.DialogueContext = {
		entryId = entryId,
		currentNodeId = entry.start,
		startedAt = os.time(),
	}

	local fsm = DialogueFSM.new(ctx)

	while not fsm:isFinished() do
		wait(1)
		fsm:step()
	end
end

return runTestDialogue
