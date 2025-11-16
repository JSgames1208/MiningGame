local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local atom: typeof(Charm.atom) = Charm.atom

type Atom<T> = Charm.Atom<T>
type Category = "tools" | "materials" | "potions" | "items"
type ToolInstance = DataTemplate.ToolInstance
type Item = ToolInstance | { id: string }
type InventoryEntry = DataTemplate.InventoryEntry
type InventoryCategory = DataTemplate.InventoryCategory

local inventoryOpen: Atom<boolean> = atom(false)
local tab = atom("tools")

local inventory: Atom<{
	tools: { [string]: Atom<InventoryEntry> },
	materials: { [string]: Atom<InventoryEntry> },
	potions: { [string]: Atom<InventoryEntry> },
	items: { [string]: Atom<InventoryEntry> },
}> =
	atom({
		tools = {},
		materials = {},
		potions = {},
		items = {},
	})

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
	setItem = function(category: InventoryCategory, entry: InventoryEntry)
		if not VALID_CATEGORIES[category] then
			warn("[inventorySlice] Invalid category: " .. category)
			return
		end

		local inv = inventory()
		local categoryMap = inv[category]

		local key = if entry.type == "tool" then entry.guid else entry.id

		if not key then
			warn("[inventorySlice] Invalid item: " .. entry.id)
			return
		end

		local existingAtom = categoryMap[key]
		if existingAtom then
			existingAtom(entry) -- just update that item
		else
			-- make a new category table so React re-renders the tab properly
			local newCategoryMap = table.clone(categoryMap)
			newCategoryMap[key] = atom(entry)
			inv[category] = newCategoryMap
			inventory(inv)
		end
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
