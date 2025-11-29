--!strict

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local InventoryServiceServer = require(ServerScriptService.Server.services.InventoryService.InventoryServiceServer)
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

	if not toolId then
		-- Generate starter tool

		local tool = self:generateTool(player, "wooden_pickaxe")
		InventoryServiceServer:addItem(player, "tools", tool)

		self:equipTool(player, tool)
	else
		local tool = DataService:get(player, { "inventory", "tools", toolId })
		if tool then
			self:equipTool(player, tool)
		end
	end
end

function ToolServiceServer.equipTool(self: ToolServiceServer, player: Player, toolEntry: DataTemplate.InventoryEntry)
	local toolGuid = toolEntry.guid
	if not toolGuid then
		warn("Tool has no guid")
		return
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid: Humanoid = character:WaitForChild("Humanoid") :: Humanoid

	if not DataService:get(player, { "inventory", "tools", toolGuid }) then
		return
	end

	humanoid:UnequipTools()

	for _, v in player.Backpack:GetChildren() do
		v:Destroy()
	end

	DataService:set(player, { "tools", "equipped" }, toolGuid)

	local toolId = toolEntry.id
	if not toolId then
		warn("Tool has no id: " .. toolEntry.id)
	end
	local tool = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Tools"):WaitForChild(toolId)

	if not tool then
		warn("Tool not found: " .. toolId)
		tool = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Tools"):WaitForChild("wooden_pickaxe")
	end
	tool = tool:Clone()

	humanoid:EquipTool(tool)
end

function ToolServiceServer.addXP(self: ToolServiceServer, player: Player, xp: number)
	local toolId: string = DataService:get(player, { "tools", "equipped" })
	local tool = DataService:get(player, { "inventory", "tools", toolId })
	if tool then
		DataService:update(player, { "inventory", "tools", toolId }, function(currentValue)
			return {
				guid = tool.guid,
				id = tool.id,
				data = {
					level = currentValue.data.level,
					xp = (currentValue.data.xp or 0) + xp,
				},
				upgrades = currentValue.upgrades,
			}
		end)
	end
end

function ToolServiceServer.generateTool(
	self: ToolServiceServer,
	player: Player,
	toolId: string
): DataTemplate.InventoryEntry
	local tool: DataTemplate.InventoryEntry = {
		amount = 1,
		guid = HttpService:GenerateGUID(),
		id = toolId,
		type = "tool",
		data = {
			level = 1,
			xp = 0,
		},
	}

	return tool
end

type ToolServiceServer = typeof(ToolServiceServer) & {
	networker: Networker.Server,
}

return ToolServiceServer :: ToolServiceServer
