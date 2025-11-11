local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local InventoryServiceClient = require(ReplicatedStorage.Shared.services.InventoryService.InventoryServiceClient)
local PlayerServiceClient = require(ReplicatedStorage.Shared.services.PlayerService.PlayerServiceClient)
local ToolRegistry = require(ReplicatedStorage.Shared.services.ToolService.util.ToolRegistry)
local RootUI = require(ReplicatedStorage.Shared.ui.app.RootUI)
local e = React.createElement

return function(parent: Instance)
	DataService:init(DataTemplate)

	DataService:waitForData()
	DataService:set({ "currency", "coins" }, 100)

	for i = 1, 10 do
		local toolData = i % 2 == 0 and ToolRegistry["stone_pickaxe"] or ToolRegistry["wooden_pickaxe"]
		local id = `tool_{tostring(i)}`
		local tool = {
			id = id,
			data = toolData,
			upgrades = {},
		}
		DataService:set({ "inventory", "tools", id }, tool)
		InventoryServiceClient:addItem(tool)
	end

	PlayerServiceClient:init()

	local root = ReactRoblox.createRoot(parent)
	root:render(e(RootUI))

	return function()
		root:unmount()
	end
end
