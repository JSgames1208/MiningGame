--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)

type DialogueContext = DialogueTypes.DialogueContext

local states = {
	idle = "idle",
	playingLine = "playingLine",
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
			warn("Node not found: " .. tostring(self.currentNodeId))
			return
		end

		if node.type == "line" then
			print(node.speaker .. ": " .. node.text)

			if node.next then
				self.currentNodeId = node.next
			else
				self.state = states.finished
			end
		end
	end
end

function DialogueFSM:isFinished()
	return self.state == states.finished
end

return DialogueFSM
