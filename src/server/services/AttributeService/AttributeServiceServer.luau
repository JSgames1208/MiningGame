--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local Networker = require(ReplicatedStorage.Packages.Networker)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
local AttributeTypes = require(ReplicatedStorage.Shared.modules.core.types.AttributeTypes)
local ModifierTypes = require(ReplicatedStorage.Shared.modules.core.types.ModifierTypes)

type Attribute = AttributeTypes.Attribute
type Modifier = ModifierTypes.Modifier

local AttributeServiceServer = {}

function AttributeServiceServer.init(self: AttributeServiceServer)
	self.networker = Networker.server.new("AttributeService", self, {})
	self.playerAttributes = {}

	self:startLoop()
end

function AttributeServiceServer.startLoop(self: AttributeServiceServer)
	local CHECK_INTERVAL = 0.5

	local timeAccumulator = 0

	RunService.Heartbeat:Connect(function(dt: number)
		timeAccumulator += dt

		if timeAccumulator < CHECK_INTERVAL then
			return
		end
		timeAccumulator -= CHECK_INTERVAL

		for userId, attributesState in pairs(self.playerAttributes) do
			local dirty = false

			local player = Players:GetPlayerByUserId(userId)

			for attrId, attrState in pairs(attributesState) do
				for modId, mod in pairs(attrState.modifiers) do
					if mod.expiresAt and os.time() > mod.expiresAt then
						self:removeModifier(player, modId)
					end
				end
			end

			if dirty then
				if player then
					self:recalculateAll(player)
				end
			end
		end
	end)
end

function AttributeServiceServer.getAttributeDefinition(self: AttributeServiceServer, attributeId: string): Attribute?
	return Registries.ATTRIBUTE:get(attributeId)
end

function AttributeServiceServer.getModifierDefinition(self: AttributeServiceServer, modifierId: string): Modifier?
	return Registries.MODIFIER:get(modifierId)
end

function AttributeServiceServer.onPlayerAdded(self: AttributeServiceServer, player: Player)
	self:initializePlayer(player)
end

function AttributeServiceServer.initializePlayer(self: AttributeServiceServer, player: Player)
	self.playerAttributes[player.UserId] = {}

	for attributeId, attributeDef in pairs(Registries.ATTRIBUTE.entries) do
		self.playerAttributes[player.UserId][attributeId] = {
			baseValue = attributeDef.defaultValue,
			modifiers = {},
			cachedValue = attributeDef.defaultValue,
			dirty = true,
		}
	end

	self:loadPlayer(player)
end

function AttributeServiceServer.loadPlayer(self: AttributeServiceServer, player: Player)
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		warn("AttributeServiceServer: loadPlayer called before initialization!")
		return
	end

	local dataAttributes: DataTemplate.Attributes = DataService:get(player, { "attributes" })

	if not dataAttributes or next(dataAttributes.baseValues or {}) == nil then
		local defaults = {
			baseValues = {},
			persistentModifiers = {},
		}

		for attrId, attrState in pairs(attributesState) do
			defaults.baseValues[attrId] = attrState.baseValue
		end

		DataService:set(player, { "attributes" }, defaults)
		dataAttributes = defaults
	end

	if dataAttributes.baseValues then
		for attrId, v in pairs(dataAttributes.baseValues) do
			local attr = attributesState[attrId]
			if attr then
				attr.baseValue = v
				attr.dirty = true
			else
				warn("AttributeServiceServer: saved baseValue for unknown attribute:", attrId)
			end
		end
	end

	if dataAttributes.persistentModifiers then
		for modId, mod in pairs(dataAttributes.persistentModifiers) do
			if type(mod) ~= "table" or type(mod.id) ~= "string" or type(mod.type) ~= "string" then
				warn("AttributeServiceServer: invalid saved modifier for:", player.Name, modId)
				continue
			end
			if mod.expiresAt and type(mod.expiresAt) == "number" then
				if os.time() > mod.expiresAt then
					continue
				end
			end

			local targetAttr = mod.attribute
			if not targetAttr then
				warn("AttributeServiceServer: saved modifier missing attribute:", player.Name, modId)
				continue
			end

			local attrState = attributesState[targetAttr]
			if not attrState then
				warn("AttributeServiceServer: saved modifier for unknown attribute:", player.Name, modId)
				continue
			end

			attrState.modifiers[mod.id] = mod :: Modifier

			attrState.dirty = true
		end
	end

	for _, attr in pairs(attributesState) do
		for _, mod in pairs(attr.modifiers) do
			self.networker:fire(player, "addModifier", mod)
		end
		attr.dirty = true
	end

	self.playerAttributes[player.UserId] = attributesState

	self:savePlayerAttributes(player)
end

function AttributeServiceServer.get(self: AttributeServiceServer, player: Player, attributeId: string): number
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		warn("AttributeServiceServer: get called before initialization!")
		return 0
	end

	local attrState = attributesState[attributeId]
	if not attrState then
		warn("AttributeServiceServer: get called for unknown attribute:", attributeId)
		return 0
	end

	if not attrState.dirty then
		return attrState.cachedValue
	else
		local attribute = self:recalculateAttribute(player, attributeId)
		if attribute then
			attrState.cachedValue = attribute
			attrState.dirty = false
			return attrState.cachedValue
		end
	end

	return 0
end

function AttributeServiceServer.savePlayerAttributes(self: AttributeServiceServer, player: Player)
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		warn("AttributeServiceServer: savePlayerAttributes called before initialization!")
		return
	end

	local baseValues = {}
	local persistentModifiers = {}

	for attrId, attrState in pairs(attributesState) do
		local attrDef = Registries.ATTRIBUTE:get(attrId)
		local default = attrDef and attrDef.defaultValue or 0

		if attrState.baseValue ~= default then
			baseValues[attrId] = attrState.baseValue
		else
			baseValues[attrId] = default
		end

		for modId, mod in pairs(attrState.modifiers) do
			if mod.persistent then
				if mod.expiresAt and type(mod.expiresAt) == "number" and os.time() > mod.expiresAt then
				else
					persistentModifiers[modId] = mod
				end
			end
		end
	end

	local toSave = {
		baseValues = baseValues,
		persistentModifiers = persistentModifiers,
	}

	DataService:set(player, { "attributes" }, toSave)
end

function AttributeServiceServer.clampAttribute(
	self: AttributeServiceServer,
	player: Player,
	attributeId: string,
	value: number
)
	local def = self:getAttributeDefinition(attributeId)
	if def then
		local minV = def.minValue
		local maxV = def.maxValue
		if type(minV) == "number" then
			value = math.max(minV, value)
		end
		if type(maxV) == "number" then
			value = math.min(maxV, value)
		end
	end

	return value
end

function AttributeServiceServer.recalculateAttribute(self: AttributeServiceServer, player: Player, attributeId: string)
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		warn("AttributeServiceServer: recalculateAttribute called before initialization!")
		return 0
	end

	local attrState = attributesState[attributeId]
	if not attrState then
		warn("AttributeServiceServer: recalculateAttribute called for unknown attribute:", attributeId)
		return 0
	end

	if not attrState.dirty then
		return attrState.cachedValue
	end

	local base = attrState.baseValue

	local total: number = base
	for _, mod in pairs(attrState.modifiers) do
		if mod.type == "ADD" then
			total += (mod.value or 0)
		end
	end

	for _, mod in pairs(attrState.modifiers) do
		if mod.type == "MULTIPLY_BASE" then
			local v = mod.value or 0
			total = total + base * v
		end
	end

	for _, mod in pairs(attrState.modifiers) do
		if mod.type == "MULTIPLY_TOTAL" then
			local v = mod.value or 0
			total += (1 * v)
		end
	end

	total = self:clampAttribute(player, attributeId, total)

	attrState.cachedValue = total
	attrState.dirty = false

	if attrState.dirty then
		self:savePlayerAttributes(player)
	end

	return total
end

function AttributeServiceServer.hasActiveModifier(self: AttributeServiceServer, player: Player, modifierId: string)
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		return false
	end

	for _, attrState in pairs(attributesState) do
		if attrState.modifiers[modifierId] then
			return true
		end
	end

	return false
end

function AttributeServiceServer.updateModifier(
	self: AttributeServiceServer,
	player: Player,
	modifierId: string,
	newModifier: Modifier
)
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		warn("AttributeServiceServer: updateModifier called before initialization!")
		return
	end

	for _, attrState in pairs(attributesState) do
		local oldModifier = attrState.modifiers[modifierId]
		if oldModifier then
			local oldExpiresAt = oldModifier.expiresAt or 0

			local newExpiresAt = newModifier.duration and oldExpiresAt + newModifier.duration
				or newModifier.expiresAt
				or oldExpiresAt

			if newExpiresAt and os.time() > newExpiresAt then
				return
			end

			newModifier.expiresAt = newExpiresAt
			attrState.modifiers[modifierId] = newModifier
			attrState.dirty = true

			if newModifier.persistent then
				self:savePlayerAttributes(player)
			end

			self.networker:fire(player, "updateModifier", newModifier)

			return
		end
	end
end

function AttributeServiceServer.addModifier(self: AttributeServiceServer, player: Player, modifier: Modifier)
	assert(type(modifier) == "table" and type(modifier.id) == "string", "invalid modifier")
	assert(modifier.attribute, "modifier must target attribute")

	if self:hasActiveModifier(player, modifier.id) then
		self:updateModifier(player, modifier.id, modifier)
		return
	end

	local attributeId = modifier.attribute
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		warn("AttributeServiceServer: addModifier called before initialization!")
		return
	end

	local attrState = attributesState[attributeId]
	if not attrState then
		warn("AttributeServiceServer: addModifier called for unknown attribute:", attributeId)
		return
	end

	if modifier.expiresAt and type(modifier.expiresAt) == "number" and os.time() > modifier.expiresAt then
		return
	end

	if modifier.duration then
		modifier.expiresAt = os.time() + modifier.duration
	end

	attrState.modifiers[modifier.id] = modifier
	attrState.dirty = true

	if modifier.persistent then
		self:savePlayerAttributes(player)
	end

	self.networker:fire(player, "addModifier", modifier)
end

function AttributeServiceServer.removeModifier(self: AttributeServiceServer, player: Player, modifierId: string)
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		warn("AttributeServiceServer: removeModifier called before initialization!")
		return
	end

	for attrId, attrState in pairs(attributesState) do
		if attrState.modifiers[modifierId] then
			attrState.modifiers[modifierId] = nil
			attrState.dirty = true
		end
	end

	self:savePlayerAttributes(player)

	self.networker:fire(player, "removeModifier", modifierId)
end

function AttributeServiceServer.setBaseValue(
	self: AttributeServiceServer,
	player: Player,
	attributeId: string,
	value: number
)
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		warn("AttributeServiceServer: setBaseValue called before initialization!")
		return
	end

	local attrState = attributesState[attributeId]
	if not attrState then
		warn("AttributeServiceServer: setBaseValue called for unknown attribute:", attributeId)
		return
	end

	attrState.baseValue = value
	attrState.dirty = true

	self:savePlayerAttributes(player)
end

function AttributeServiceServer.recalculateAll(self: AttributeServiceServer, player: Player)
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		warn("AttributeServiceServer: recalculateAll called before initialization!")
		return
	end

	for attrId, attrState in pairs(attributesState) do
		self:recalculateAttribute(player, attrId)
	end

	self:savePlayerAttributes(player)
end

function AttributeServiceServer.applyToolUpgrades(self: AttributeServiceServer, player: Player, toolData: any)
	local attributesState = self.playerAttributes[player.UserId]
	if not attributesState then
		warn("AttributeServiceServer: applyToolUpgrades called before initialization!")
		return
	end

	for _, attrState in pairs(attributesState) do
		for modId, mod in pairs(attrState.modifiers) do
			if not mod.persistent then
				attrState.modifiers[modId] = nil
				attrState.dirty = true
			end
		end
	end

	if not toolData or not toolData.upgrades then
		self:recalculateAll(player)
		return
	end

	for _, upgradeInstance in pairs(toolData.upgrades) do
		local upgradeId = upgradeInstance.id
		local upgradeDef = Registries.UPGRADE:get(upgradeId)
		if upgradeDef then
			local effect = upgradeDef.effect
			if effect.stats then
				for statName, value: number in pairs(effect.stats) do
					local modifier: Modifier = {
						id = upgradeId,
						attribute = statName,
						type = "ADD",
						value = value * upgradeInstance.level,
						persistent = false,
					}

					print("add tool modifier: ", modifier)

					self:addModifier(player, modifier)
				end
			end
		end
	end

	self:recalculateAll(player)
end

function AttributeServiceServer.onToolEquipped(self: AttributeServiceServer, player: Player, toolData: any)
	print(toolData)
	self:applyToolUpgrades(player, toolData)
end

export type AttributeServiceServer = typeof(AttributeServiceServer) & {
	networker: Networker.Server,
	playerAttributes: {
		[number]: {
			[string]: {
				baseValue: number,
				modifiers: { [string]: Modifier },
				cachedValue: number,
				dirty: boolean,
			},
		},
	},
}

return AttributeServiceServer :: AttributeServiceServer
