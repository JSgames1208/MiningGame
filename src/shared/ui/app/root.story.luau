local HttpService = game:GetService("HttpService")
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
		local id = toolData.id
		local tool = {
			id = id,
			guid = HttpService:GenerateGUID(),
			data = {
				level = 1,
				xp = 0,
			},
			upgrades = {},
		}

		DataService:set({ "inventory", "tools", id }, tool)
		InventoryServiceClient:addItem("tools", tool)
	end

	local id = "stone_pickaxe"

	DataService:set({ "inventory", "items", id }, { id = id, amount = 1 })
	InventoryServiceClient:addItem("items", { id = id, amount = 1 })

	DataService:set({ "inventory", "potions", id }, { id = id, amount = 1 })
	InventoryServiceClient:addItem("potions", { id = id, amount = 1 })

	DataService:set({ "inventory", "materials", id }, { id = id, amount = 1 })
	InventoryServiceClient:addItem("materials", { id = id, amount = 1 })

	PlayerServiceClient:init()

	local root = ReactRoblox.createRoot(parent)
	root:render(e(RootUI))

	return function()
		root:unmount()
	end
end
