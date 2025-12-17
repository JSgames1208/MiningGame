local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)
type DialogueNode = DialogueTypes.DialogueNode

local DialogueNodes = {}

local function register(id: string, data: DialogueNode)
	return Registries.DIALOGUE_NODE:register(id, data)
end

register("dialogue.miner.idle.line_1", {
	id = "dialogue.miner.idle.line_1",
	type = "line",
	speaker = "npc.miner",
	text = "Just a miner. Nothing special.",
	next = "dialogue.miner.idle.line_2",
})

register("dialogue.miner.idle.line_2", {
	id = "dialogue.miner.idle.line_2",
	type = "line",
	speaker = "npc.miner",
	text = "It's a boring day today in the mines.",
	next = "dialogue.miner.idle.line_3",
})

register("dialogue.miner.idle.line_3", {
	id = "dialogue.miner.idle.line_3",
	type = "line",
	speaker = "npc.miner",
	text = "I hope a fellow miner comes by soon.",
	next = nil,
})

function DialogueNodes.get(id: string): DialogueNode?
	return Registries.DIALOGUE_NODE:get(id)
end

return DialogueNodes
