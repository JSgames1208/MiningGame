--!strict
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local Items = require(ReplicatedStorage.Shared.modules.core.registries.Items)
local LootTableType = require(ReplicatedStorage.Shared.modules.core.types.LootTableType)
local InventoryServiceServer = require(ServerScriptService.Server.services.InventoryService.InventoryServiceServer)
local PlayerServiceServer = require(ServerScriptService.Server.services.PlayerService.PlayerServiceServer)
local ToolServiceServer = require(ServerScriptService.Server.services.ToolService.ToolServiceServer)

type InventoryCategory = DataTemplate.InventoryCategory
type InventoryEntry = DataTemplate.InventoryEntry

local LootServiceServer = {}

function LootServiceServer.init(self: LootServiceServer) end

function LootServiceServer.rollLoot(
	self: LootServiceServer,
	player: Player,
	maxChance: number,
	drops: { LootTableType.Drop }
)
	local items = {}

	for _, drop in drops do
		local chance = math.random() * maxChance
		if chance <= drop.chance then
			local amount = math.random(drop.min, drop.max)

			table.insert(items, { id = drop.id, amount = amount })
		end
	end

	return items
end

function LootServiceServer.giveLoot(self: LootServiceServer, player: Player, lootTable: LootTableType.LootTable)
	if not lootTable then
		return
	end

	local rolled: { { id: string, amount: number } } = {}

	if lootTable.drops then
		rolled = self:rollLoot(player, lootTable.maxChance, lootTable.drops)
	end

	for _, item in rolled do
		local itemEntry = Items.get(item.id)
		if not itemEntry then
			continue
		end
		if itemEntry.type == "tool" then
			local tool = ToolServiceServer:generateTool(player, item.id)
			InventoryServiceServer:addItem(player, tool)
		else
			local entry: InventoryEntry = {
				amount = item.amount,
				id = item.id,
				type = "item",
				data = {},
				guid = HttpService:GenerateGUID(),
			}
			InventoryServiceServer:addItem(player, entry)
		end
	end

	if lootTable.currency then
		for currencyType, amount in pairs(lootTable.currency) do
			PlayerServiceServer:addCurrency(player, currencyType, amount)
		end
	end

	if lootTable.xp then
		task.delay(1, function()
			PlayerServiceServer:addXP(player, lootTable.xp.player)
		end)

		if lootTable.xp.mining then
			ToolServiceServer:addXP(player, lootTable.xp.mining)
		end
	end

	return rolled
end

type LootServiceServer = typeof(LootServiceServer) & {}

return LootServiceServer :: LootServiceServer
