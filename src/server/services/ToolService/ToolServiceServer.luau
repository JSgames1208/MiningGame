--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)

local ToolServiceServer = {}

function ToolServiceServer.init(self: ToolServiceServer)
	self.networker = Networker.server.new("ToolService", self, {
		self.equipTool :: any,
	})
end

function ToolServiceServer.onPlayerAdded(self: ToolServiceServer, player: Player)
	DataService:waitForData(player)

	local toolId: string = DataService:get(player, { "tools", "equipped" })
	local tool = DataService:get(player, { "inventory", "tools", toolId })
	if tool then
		self:equipTool(player, tool)
	end
end

function ToolServiceServer.equipTool(self: ToolServiceServer, player: Player, toolInstance: DataTemplate.ToolInstance)
	print("EQUIP")

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid: Humanoid = character:WaitForChild("Humanoid") :: Humanoid

	if not DataService:get(player, { "inventory", "tools", toolInstance.id }) then
		return
	end

	humanoid:UnequipTools()

	for _, v in player.Backpack:GetChildren() do
		v:Destroy()
	end

	DataService:set(player, { "tools", "equipped" }, toolInstance.id)

	local toolId = toolInstance.data.id
	if not toolId then
		warn("Tool has no id: " .. toolInstance.id)
	end
	local tool = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Tools"):WaitForChild(toolId)

	if not tool then
		warn("Tool not found: " .. toolId)
		tool = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Tools"):WaitForChild("wooden_pickaxe")
	end
	tool = tool:Clone()

	humanoid:EquipTool(tool)
end

type ToolServiceServer = typeof(ToolServiceServer) & {
	networker: Networker.Server,
}

return ToolServiceServer :: ToolServiceServer
