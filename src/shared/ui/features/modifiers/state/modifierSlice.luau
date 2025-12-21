local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local Sift = require(ReplicatedStorage.Packages.Sift)
local ModifierTypes = require(ReplicatedStorage.Shared.modules.core.types.ModifierTypes)
local atom: typeof(Charm.atom) = Charm.atom

-- TYPE DEFS
type Atom<T> = Charm.Atom<T>
type Modifier = ModifierTypes.Modifier

--STATES

local modifierIds: Atom<{ string }> = atom({})
local modifierById: { [string]: Atom<Modifier> } = {}

-- ACTIONS
local actions = {
	addModifier = function(modifier: Modifier)
		print("modifier", modifier)
		modifierById[modifier.id] = atom(modifier)
		modifierIds(function(list)
			return Sift.Array.push(list, modifier.id)
		end)
	end,
	updateModifier = function(modifier: Modifier)
		if modifierById[modifier.id] then
			modifierById[modifier.id](modifier)
		end
	end,
	removeModifier = function(modifierId: string)
		modifierById[modifierId] = nil
		modifierIds(function(list)
			return Sift.Array.filter(list, function(id)
				return id ~= modifierId
			end)
		end)
	end,
	getModifierById = function(modifierId: string)
		return modifierById[modifierId]
	end,
}

return {
	states = {
		modifierIds = modifierIds,
	},
	actions = actions,
}
