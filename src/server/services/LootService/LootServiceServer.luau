--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local InventoryServiceServer = require(ServerScriptService.Server.services.InventoryService.InventoryServiceServer)
local PlayerServiceServer = require(ServerScriptService.Server.services.PlayerService.PlayerServiceServer)
local ToolServiceServer = require(ServerScriptService.Server.services.ToolService.ToolServiceServer)
local LootTables = require(ReplicatedStorage.Shared.services.LootService.LootTables)

local LootServiceServer = {}

function LootServiceServer.init(self: LootServiceServer) end

function LootServiceServer.rollLoot(self: LootServiceServer, player: Player, maxChance: number, drops: LootTables.Drops)
	local items = {}

	for cName, c in drops do
		for _, drop in c do
			local chance = math.random() * maxChance
			if chance <= drop.chance then
				local amount = math.random(drop.min, drop.max)

				table.insert(items, { category = cName, id = drop.id, amount = amount })
			end
		end
	end

	return items
end

function LootServiceServer.giveLoot(self: LootServiceServer, player: Player, lootId: string)
	local lootTable = LootTables[lootId]
	if not lootTable then
		return
	end

	local rolled: { { category: string, id: string, amount: number } } = {}

	if lootTable.drops then
		rolled = self:rollLoot(player, lootTable.maxChance, lootTable.drops)
	end

	for _, item in rolled do
		if item.category == "tools" then
			local tool = ToolServiceServer:generateTool(player, item.id)
			InventoryServiceServer:addItem(player, item.category, tool)
		else
			InventoryServiceServer:addItem(player, item.category, { id = item.id, amount = item.amount })
		end
	end

	if lootTable.xp then
		PlayerServiceServer:addXP(player, lootTable.xp.player)
	end

	return rolled
end

type LootServiceServer = typeof(LootServiceServer) & {}

return LootServiceServer :: LootServiceServer
