--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)

local ToolServiceClient = {}

function ToolServiceClient.init(self: ToolServiceClient)
	self.networker = Networker.client.new("ToolService", self)

	local toolId: string = DataService:get({ "tools", "equipped" })
	toolSlice.actions.setEquipped(toolId)

	Charm.subscribe(toolSlice.states.equipped, function(toolId: string)
		print(DataService:get({ "inventory", "tools" }))
		local toolInstance = DataService:get({ "inventory", "tools", toolId })
		self.networker:fire("equipTool", toolInstance)
	end)
end

type ToolServiceClient = typeof(ToolServiceClient) & {
	networker: Networker.Client,
}

return ToolServiceClient :: ToolServiceClient
