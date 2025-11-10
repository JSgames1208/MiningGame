--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)

local ToolServiceClient = {}

function ToolServiceClient.init(self: ToolServiceClient)
	self.networker = Networker.client.new("ToolService", self)
end

type ToolServiceClient = typeof(ToolServiceClient) & {
	networker: Networker.Client,
}

return ToolServiceClient :: ToolServiceClient
