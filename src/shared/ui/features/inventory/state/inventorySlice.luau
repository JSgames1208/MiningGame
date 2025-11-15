local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local atom: typeof(Charm.atom) = Charm.atom

type Atom<T> = Charm.Atom<T>
type Category = "tools" | "materials" | "potions" | "items"
type ToolInstance = DataTemplate.ToolInstance
type Item = ToolInstance | { id: string }

local inventoryOpen: Atom<boolean> = atom(false)
local inventory: Atom<{
	tools: { [string]: Atom<{ ToolInstance }> },
	materials: { [string]: Atom<{ item: Item, amount: number }> },
	potions: { [string]: Atom<{ item: Item, amount: number }> },
	items: { [string]: Atom<{ item: Item, amount: number }> },
}> =
	atom({
		tools = {},
		materials = {},
		potions = {},
		items = {},
	})

local tab: Atom<string> = atom("tools")

local VALID_CATEGORIES = {
	tools = true,
	materials = true,
	potions = true,
	items = true,
}

local actions = {
	setInventoryOpen = function(value: boolean)
		inventoryOpen(value)
	end,

	-- category: "tools" | "materials" | "potions" | "items"
	-- item: ToolInstance | Material | Item | Potion
	setItem = function(category: string, item: Item, amount: number)
		if not VALID_CATEGORIES[category] then
			warn("[inventorySlice] Invalid category: " .. category)
			return
		end

		local inv = inventory()
		local categoryMap = inv[category]

		local id = item.id

		if category == "tools" then
			local i = item :: ToolInstance
			id = i.guid
		end

		local existingAtom = categoryMap[id]

		if existingAtom then
			existingAtom({
				item = item,
				amount = amount,
			})
		else
			categoryMap[id] = atom({
				item = item,
				amount = amount,
			})
		end

		inventory(inv)
	end,

	setTab = function(value: string)
		if not VALID_CATEGORIES[value] then
			warn("[inventorySlice] Invalid tab: " .. value)
			return
		end
		tab(value)
	end,
}

return {
	states = {
		inventoryOpen = inventoryOpen,
		inventory = inventory,
		tab = tab,
	},
	actions = actions,
}
