local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local Items = require(ReplicatedStorage.Shared.modules.core.registries.Items)
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
require(ReplicatedStorage.Shared.modules.core.RegistryLoader)
local InventoryServiceClient = require(ReplicatedStorage.Shared.services.InventoryService.InventoryServiceClient)
local PlayerServiceClient = require(ReplicatedStorage.Shared.services.PlayerService.PlayerServiceClient)
local RootUI = require(ReplicatedStorage.Shared.ui.app.RootUI)

local e = React.createElement

return function(parent: Instance)
	DataService:init(DataTemplate)

	DataService:waitForData()
	DataService:set({ "currency", "coins" }, 100)

	DataService:set({ "stats", "xp" }, 2.2e25)

	for i = 1, 10 do
		local toolData = i % 2 == 0 and Items.STONE_PICKAXE or Items.WOODEN_PICKAXE
		local id = Registries.ITEM:idOf(toolData)
		local tool = {
			id = id,
			guid = HttpService:GenerateGUID(),
			type = "tool",
			amount = 1,
			data = {
				level = 1,
				xp = 0,
			},
		}

		DataService:set({ "inventory", "tool", id }, tool)
		InventoryServiceClient:setItem("tool", tool)
	end

	local item1 = {
		id = "potion_yellow",
		amount = 10,
		type = "item",
		data = {},
		guid = nil,
	}

	DataService:set({ "inventory", "potion", item1.id }, item1)
	InventoryServiceClient:setItem("potion", item1)

	local item2 = {
		id = "potion_green",
		amount = 5,
		type = "item",
		data = {},
		guid = nil,
	}

	DataService:set({ "inventory", "potion", item2.id }, item2)
	InventoryServiceClient:setItem("potion", item2)

	local item3 = {
		id = "efficiency_i",
		amount = 10,
		type = "upgrade",
		data = {},
		guid = nil,
	}

	DataService:set({ "inventory", "upgrade", item3.id }, item3)
	InventoryServiceClient:setItem("upgrade", item3)

	local item4 = {
		id = "efficiency_ii",
		amount = 5,
		type = "upgrade",
		data = {},
		guid = nil,
	}

	DataService:set({ "inventory", "upgrade", item4.id }, item4)
	InventoryServiceClient:setItem("upgrade", item4)

	local item5 = {
		id = "efficiency_iii",
		amount = 1,
		type = "upgrade",
		data = {},
		guid = nil,
	}

	DataService:set({ "inventory", "upgrade", item5.id }, item5)
	InventoryServiceClient:setItem("upgrade", item5)

	PlayerServiceClient:init()

	local root = ReactRoblox.createRoot(parent)
	root:render(e(RootUI))

	return function()
		root:unmount()
	end
end
