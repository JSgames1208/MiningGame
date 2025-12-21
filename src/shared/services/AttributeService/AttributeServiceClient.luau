--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)

local AttributeServiceClient = {}

function AttributeServiceClient.init(self: AttributeServiceClient)
	self.networker = Networker.client.new("AttributeService", self)
end

export type AttributeServiceClient = typeof(AttributeServiceClient) & {
	networker: Networker.Client,
}

return AttributeServiceClient :: AttributeServiceClient
