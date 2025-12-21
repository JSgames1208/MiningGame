--!strict

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local AttributeServiceServer = require(ServerScriptService.Server.services.AttributeService.AttributeServiceServer)
local InventoryServiceServer = require(ServerScriptService.Server.services.InventoryService.InventoryServiceServer)
local Networker = require(ReplicatedStorage.Packages.Networker)
local Sift = require(ReplicatedStorage.Packages.Sift)
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
		InventoryServiceServer:addItem(player, tool)

		--self:applyUpgrade(player, tool.guid, "power", 10)

		self:equipTool(player, tool)
	else
		local tool = DataService:get(player, { "inventory", "tool", toolId })

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

	if not DataService:get(player, { "inventory", "tool", toolGuid }) then
		return
	end

	humanoid:UnequipTools()

	for _, v in player.Backpack:GetChildren() do
		v:Destroy()
	end

	DataService:set(player, { "tools", "equipped" }, toolGuid)

	local toolData = toolEntry.toolData
	if toolData then
		AttributeServiceServer:onToolEquipped(player, toolData)
	end

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

-- DEPRECATED, MOVED TO UpgradeServiceServer.luau
function ToolServiceServer.applyUpgrade(
	self: ToolServiceServer,
	player: Player,
	toolGuid: string,
	upgradeId: string,
	level: number
)
	local tool = DataService:get(player, { "inventory", "tool", toolGuid })
	if tool then
		DataService:update(
			player,
			{ "inventory", "tool", toolGuid },
			function(currentValue: DataTemplate.InventoryEntry)
				return {
					guid = tool.guid,
					id = tool.id,
					amount = 1,
					type = "tool",
					toolData = {
						level = (currentValue.toolData :: any).level,
						xp = (currentValue.toolData :: any).xp,
						upgrades = Sift.Dictionary.join(
							(currentValue.toolData :: any).upgrades,
							{ [upgradeId] = level }
						),
					},
				} :: DataTemplate.InventoryEntry
			end
		)
	end
end

-- DEPRECATED
function ToolServiceServer.incrementUpgrade(
	self: ToolServiceServer,
	player: Player,
	toolGuid: string,
	upgradeId: string
)
	local tool = DataService:get(player, { "inventory", "tool", toolGuid })
	if tool then
		local upgradeLevel = (tool.toolData :: any).upgrades[upgradeId]
		self:applyUpgrade(player, toolGuid, upgradeId, upgradeLevel and upgradeLevel + 1 or 1)
	end
end

function ToolServiceServer.addXP(self: ToolServiceServer, player: Player, xp: number)
	local toolId: string = DataService:get(player, { "tools", "equipped" })
	local tool = DataService:get(player, { "inventory", "tool", toolId })
	if tool then
		DataService:update(player, { "inventory", "tool", toolId }, function(currentValue: DataTemplate.InventoryEntry)
			return {
				amount = 1,
				guid = tool.guid,
				id = tool.id,
				type = "tool",
				toolData = {
					level = (currentValue.toolData :: any).level,
					xp = ((currentValue.toolData :: any).xp or 0) + xp,
					upgrades = (currentValue.toolData :: any).upgrades,
				},
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
		toolData = {
			level = 1,
			xp = 0,
			upgrades = {
				["1"] = nil,
				["2"] = nil,
				["3"] = nil,
			},
		},
	}

	return tool
end

type ToolServiceServer = typeof(ToolServiceServer) & {
	networker: Networker.Server,
}

return ToolServiceServer :: ToolServiceServer
