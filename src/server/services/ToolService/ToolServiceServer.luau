--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local Networker = require(ReplicatedStorage.Packages.Networker)
local ToolRegistry = require(ReplicatedStorage.Shared.services.ToolService.util.ToolRegistry)

local ToolServiceServer = {}

function ToolServiceServer.init(self: ToolServiceServer)
	self.networker = Networker.server.new("ToolService", self, {})
end

function ToolServiceServer.onPlayerAdded(self: ToolServiceServer, player: Player)
	DataService:waitForData(player)

	local toolId: ToolRegistry.ToolData = DataService:get(player, { "tools", "equipped" })
	self:equipTool(player, toolId)
end

function ToolServiceServer.equipTool(self: ToolServiceServer, player: Player, toolData: ToolRegistry.ToolData)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid: Humanoid = character:WaitForChild("Humanoid") :: Humanoid

	humanoid:UnequipTools()

	for _, v in player.Backpack:GetChildren() do
		v:Destroy()
	end

	DataService:set(player, { "tools", "equipped" }, toolData)

	local toolId = toolData.id
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
