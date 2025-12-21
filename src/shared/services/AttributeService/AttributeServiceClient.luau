--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local ModifierTypes = require(ReplicatedStorage.Shared.modules.core.types.ModifierTypes)
local modifierSlice = require(ReplicatedStorage.Shared.ui.features.modifiers.state.modifierSlice)

type Modifier = ModifierTypes.Modifier

local AttributeServiceClient = {}

function AttributeServiceClient.init(self: AttributeServiceClient)
	self.networker = Networker.client.new("AttributeService", self)
end

function AttributeServiceClient.addModifier(self: AttributeServiceClient, modifier: ModifierTypes.Modifier)
	modifierSlice.actions.addModifier(modifier)
end

function AttributeServiceClient.updateModifier(self: AttributeServiceClient, modifier: ModifierTypes.Modifier)
	modifierSlice.actions.updateModifier(modifier)
end

function AttributeServiceClient.removeModifier(self: AttributeServiceClient, modifierId: string)
	print("removing modifier", modifierId)
	modifierSlice.actions.removeModifier(modifierId)
end

export type AttributeServiceClient = typeof(AttributeServiceClient) & {
	networker: Networker.Client,
}

return AttributeServiceClient :: AttributeServiceClient
