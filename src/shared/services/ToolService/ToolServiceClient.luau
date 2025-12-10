--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Networker = require(ReplicatedStorage.Packages.Networker)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)

local ToolServiceClient = {}

function ToolServiceClient.init(self: ToolServiceClient)
	self.networker = Networker.client.new("ToolService", self)

	DataService:waitForData()

	local toolId: string = DataService:get({ "tools", "equipped" })
	toolSlice.actions.setEquipped(toolId)

	Charm.subscribe(toolSlice.states.equipped, function(toolId: string)
		if not toolId then
			return
		end

		local toolInstance = DataService:get({ "inventory", "tool", toolId })
		self.networker:fire("equipTool", toolInstance)
	end)

	DataService:getChangedSignal({ "tools", "equipped" }):Connect(function(toolId: string)
		if toolId then
			toolSlice.actions.setEquipped(toolId)
		end
	end)
end

type ToolServiceClient = typeof(ToolServiceClient) & {
	networker: Networker.Client,
}

return ToolServiceClient :: ToolServiceClient
