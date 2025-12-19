local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)

type DialogueLoader = {
	registerAll: () -> (),
}
type DialogueNode = DialogueTypes.DialogueNode

local DialogueNodes = {}

local dialogueFolder = ReplicatedStorage.Shared.modules.core.registries.dialogue

for _, file in pairs(dialogueFolder:GetChildren()) do
	if file:IsA("Folder") then
		for _, v in file:GetChildren() do
			if v:IsA("ModuleScript") then
				local module = require(v) :: DialogueLoader
				module:registerAll()
			end
		end
	end
end

function DialogueNodes.get(id: string): DialogueNode?
	return Registries.DIALOGUE_NODE:get(id)
end

return DialogueNodes
