--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

	if dataAttributes then
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
	end

	for _, attr in pairs(attributesState) do
		attr.dirty = true
	end
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
		return
	end

	local attrState = attributesState[attributeId]
	if not attrState then
		warn("AttributeServiceServer: recalculateAttribute called for unknown attribute:", attributeId)
		return
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

	return total
end

function AttributeServiceServer.addModifier(self: AttributeServiceServer, player: Player, modifier: Modifier)
	assert(type(modifier) == "table" and type(modifier.id) == "string", "invalid modifier")
	assert(modifier.attribute, "modifier must target attribute")

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

	attrState.modifiers[modifier.id] = modifier
	attrState.dirty = true
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
