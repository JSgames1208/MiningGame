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
local Items = require(ReplicatedStorage.Shared.modules.core.registries.Items)
local Upgrades = require(ReplicatedStorage.Shared.modules.core.registries.Upgrades)

local UpgradeServiceServer = {}

function UpgradeServiceServer.init(self: UpgradeServiceServer)
	self.networker = Networker.server.new("UpgradeService", self, {
		self.selectUpgradeRequest :: any,
		self.validateTool :: any,
		self.removeUpgradeRequest :: any,
	})
end

function UpgradeServiceServer.onPlayerAdded(self: UpgradeServiceServer, player: Player)
	local equippedGuid = DataService:get(player, { "tools", "equipped" })

	self.networker:fire(player, "selectTool", equippedGuid)
end

function UpgradeServiceServer.validateTool(self: UpgradeServiceServer, player: Player, guid: string)
	return DataService:get(player, { "inventory", "tool", guid }) ~= nil
end

function UpgradeServiceServer.canApplyUpgrade(
	self: UpgradeServiceServer,
	player: Player,
	toolGuid: string,
	upgrade: { slot: string, upgradeData: { id: string, level: number } }
)
	local tool: DataTemplate.InventoryEntry = DataService:get(player, { "inventory", "tool", toolGuid })
	if not tool then
		return false
	end
	local toolData = tool.toolData
	if not toolData then
		return false
	end

	for slot, upgradeData in pairs(toolData.upgrades) do
		if not upgradeData then
			continue
		end
		local existingId = upgradeData.id

		local upgradeEntry = Upgrades.get(existingId)
		if not upgradeEntry then
			continue
		end

		if Sift.Array.find(upgradeEntry.excludes, upgrade.upgradeData.id) then
			return false
		end
	end

	return true
end

function UpgradeServiceServer.applyUpgrade(
	self: UpgradeServiceServer,
	player: Player,
	toolGuid: string,
	upgrade: { slot: string, upgradeData: { id: string, level: number } }
): boolean
	local tool = DataService:get(player, { "inventory", "tool", toolGuid })
	if tool then
		if not self:canApplyUpgrade(player, toolGuid, upgrade) then
			return false
		end
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
							{ [upgrade.slot] = upgrade.upgradeData }
						),
					},
				} :: DataTemplate.InventoryEntry
			end
		)
		AttributeServiceServer:onToolEquipped(
			player,
			DataService:get(player, { "inventory", "tool", toolGuid }).toolData
		)
		return true
	end

	return false
end

function UpgradeServiceServer.removeUpgrade(
	self: UpgradeServiceServer,
	player: Player,
	toolGuid: string,
	slot: string
): boolean
	local tool = DataService:get(player, { "inventory", "tool", toolGuid })
	if tool then
		local toolData = tool.toolData
		if toolData then
			local upgrades = toolData.upgrades
			if upgrades then
				local upgrade = upgrades[slot]
				if upgrade then
					local upgradeId = upgrade.id
					local upgradeLevel = upgrade.level

					local upgradeEntry = Upgrades.get(upgradeId)
					if upgradeEntry then
						local itemId = upgradeEntry.levels[upgradeLevel]
						InventoryServiceServer:addItem(player, {
							amount = 1,
							id = itemId,
							type = "item",
							toolData = nil,
							guid = HttpService:GenerateGUID(),
						})
					end
				end
				upgrades[slot] = nil
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
								upgrades = upgrades,
							},
						} :: DataTemplate.InventoryEntry
					end
				)
				AttributeServiceServer:onToolEquipped(
					player,
					DataService:get(player, { "inventory", "tool", toolGuid }).toolData
				)
				return true
			end
		end
	end
	return false
end

function UpgradeServiceServer.removeUpgradeRequest(
	self: UpgradeServiceServer,
	player: Player,
	toolGuid: string,
	slot: string
): boolean
	if self:validateTool(player, toolGuid) then
		return self.removeUpgrade(self, player, toolGuid, slot)
	end
	return false
end

function UpgradeServiceServer.selectUpgradeRequest(
	self: UpgradeServiceServer,
	player: Player,
	toolGuid: string,
	upgrade: { slot: string, upgradeData: { id: string, level: number } }
): boolean
	local upgradeId = upgrade.upgradeData.id
	local upgradeLevel = upgrade.upgradeData.level

	local upgradeEntry = Upgrades.get(upgradeId)
	if not upgradeEntry then
		return false
	end

	local itemId = upgradeEntry.levels[upgradeLevel]
	if not itemId then
		return false
	end

	local itemEntry = Items.get(upgradeEntry.levels[upgradeLevel])

	if not itemEntry then
		return false
	end

	if DataService:get(player, { "inventory", "upgrade", itemId }) ~= nil then
		local tool = DataService:get(player, { "inventory", "tool", toolGuid })
		if not tool then
			return false
		end
		local existingUpgrade = tool.toolData.upgrades[upgrade.slot]
		if self:applyUpgrade(player, toolGuid, upgrade) then
			InventoryServiceServer:removeItem(player, itemId, 1)
			if tool then
				if existingUpgrade then
					local existingId = existingUpgrade.id
					local existingLevel = existingUpgrade.level

					local existingUpgradeEntry = Upgrades.get(existingId)
					if existingUpgradeEntry then
						local existingItemId = existingUpgradeEntry.levels[existingLevel]
						InventoryServiceServer:addItem(player, {
							amount = 1,
							id = existingItemId,
							type = "item",
							toolData = nil,
							guid = HttpService:GenerateGUID(),
						})
					end
				end
			end
			return true
		end
	end
	return false
end

type UpgradeServiceServer = typeof(UpgradeServiceServer) & {
	networker: Networker.Server,
}

return UpgradeServiceServer :: UpgradeServiceServer
