--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)

type DialogueContext = DialogueTypes.DialogueContext

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

	step: (self: DialogueFSM) -> (),
} & typeof(setmetatable({}, DialogueFSM))

function DialogueFSM.new(ctx: DialogueContext): DialogueFSM
	local self = setmetatable({}, DialogueFSM) :: DialogueFSM

	self.ctx = ctx
	self.state = states.idle
	self.currentNodeId = self.ctx.currentNodeId

	return self
end

function DialogueFSM.step(self: DialogueFSM)
	if self.state == states.idle then
		self.state = states.playingLine
	end

	if self.state == states.playingLine then
		local node = Registries.DIALOGUE_NODE:get(self.currentNodeId)
		if not node then
			self.state = states.finished
			return
		end

		if node.type ~= "line" then
			error("Expected line node, got " .. node.type)
		end

		print(node.speaker .. ": " .. node.text)

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
		local node = Registries.DIALOGUE_NODE:get(self.currentNodeId)
		if not node or node.type ~= "choice" then
			self.state = states.finished
			return
		end

		print("Choices: ")
		for i, choice in ipairs(node.choices) do
			print(i .. ") " .. choice.text)
		end

		local selected = node.choices[2]

		print(selected)

		print("Selected: ", selected.text)

		self.currentNodeId = selected.next
		self.state = states.playingLine
	end
end

function DialogueFSM:isFinished()
	return self.state == states.finished
end

return DialogueFSM
