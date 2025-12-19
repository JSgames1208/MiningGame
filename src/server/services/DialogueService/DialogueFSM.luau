--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)

type DialogueContext = DialogueTypes.DialogueContext
type DialogueSnapshot = DialogueTypes.DialogueSnapshot

local states = {
	idle = "idle",
	playingLine = "playingLine",
	awaitingChoice = "awaitingChoice",
	finished = "finished",
}

local DialogueFSM = {}
DialogueFSM.__index = DialogueFSM

export type DialogueFSM = {
	ctx: DialogueContext,
	state: string,
	currentNodeId: string,

	advance: (self: DialogueFSM) -> DialogueFSM,
	selectChoice: (self: DialogueFSM, index: number) -> DialogueFSM,
	isFinished: (self: DialogueFSM) -> boolean,
	makeSnapshot: (self: DialogueFSM) -> DialogueSnapshot,
} & typeof(setmetatable({}, DialogueFSM))

function DialogueFSM.new(ctx: DialogueContext): DialogueFSM
	local self = setmetatable({}, DialogueFSM) :: DialogueFSM

	self.ctx = ctx
	self.state = states.idle
	self.currentNodeId = self.ctx.currentNodeId

	return self
end

function DialogueFSM.advance(self: DialogueFSM)
	if self.state == states.idle then
		self.state = states.playingLine
	end

	if self.state == states.playingLine then
		local node = Registries.DIALOGUE_NODE:get(self.currentNodeId)
		if not node then
			self.state = states.finished
			return
		end

		self:runCommands(node)

		if node.type ~= "line" then
			error("Expected line node, got " .. node.type)
		end

		if node.next then
			self.currentNodeId = node.next
			local nextNode = Registries.DIALOGUE_NODE:get(self.currentNodeId)
			if nextNode and nextNode.type == "choice" then
				self.state = states.awaitingChoice
			end
		else
			self.state = states.finished
		end
	end

	if self.state == states.awaitingChoice then
		return self
	end

	return self
end

function DialogueFSM.selectChoice(self: DialogueFSM, index: number): DialogueFSM
	if self.state ~= states.awaitingChoice then
		error("Cannot select choice when not awaitingChoice!")
	end

	local node = Registries.DIALOGUE_NODE:get(self.currentNodeId)
	if node then
		self:runCommands(node)
	end
	if not node or node.type ~= "choice" then
		error("Current node is not a choice node!")
	end

	local choice = node.choices[index]
	if not choice then
		error("Invalid choice index: " .. index)
	end

	self.currentNodeId = choice.next
	self.state = states.playingLine

	return self
end

function DialogueFSM.runCommands(self: DialogueFSM, node: DialogueTypes.DialogueNode): DialogueFSM
	if node.type ~= "line" then
		return self
	end

	if not node.commands then
		return self
	end

	for _, command in node.commands do
		local fn = Registries.DIALOGUE_COMMAND:get(command.type)
		if not fn then
			warn("Unknown dialogue command: " .. command.type)
			continue
		end

		fn(self.ctx, command)
	end

	return self
end

function DialogueFSM.isFinished(self: DialogueFSM)
	return self.state == states.finished
end

function DialogueFSM.makeSnapshot(self: DialogueFSM): DialogueSnapshot
	if self.state == states.finished then
		return {
			npcId = self.ctx.npcId,
			nodeType = "end",
		}
	end

	local node = Registries.DIALOGUE_NODE:get(self.currentNodeId)
	if not node then
		return {
			npcId = self.ctx.npcId,
			nodeType = "end",
		}
	end

	if node.type == "line" then
		return {
			npcId = self.ctx.npcId,
			nodeType = "line",
			speaker = node.speaker,
			text = node.text,
		}
	end

	if node.type == "choice" then
		return {
			npcId = self.ctx.npcId,
			prompt = node.prompt,
			nodeType = "choice",
			choices = node.choices,
		}
	end

	error("Unknown node type: " .. node.type)
end

return DialogueFSM
