local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local atom: typeof(Charm.atom) = Charm.atom

type Atom<T> = Charm.Atom<T>

local inventoryOpen: Atom<boolean> = atom(false)
local inventoryItems: Atom<{ [string]: Atom<{ tool: DataTemplate.ToolInstance, amount: number }> }> = atom({})

local actions = {
	setInventoryOpen = function(value: boolean)
		inventoryOpen(value)
	end,
	setItem = function(tool: DataTemplate.ToolInstance, amount: number)
		local items = inventoryItems()
		if items[tool.id] then
			local itemAtom = items[tool.id]
			itemAtom({ tool = tool, amount = amount })
		else
			items[tool.id] = atom({ tool = tool, amount = amount })
			inventoryItems(items)
		end
	end,
}

return {
	states = {
		inventoryOpen = inventoryOpen,
		inventoryItems = inventoryItems,
	},
	actions = actions,
}
