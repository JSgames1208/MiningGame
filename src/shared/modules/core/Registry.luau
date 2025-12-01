--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)

local Registry = {}
Registry.__index = Registry

type Dict<T> = { [string]: T }

export type Registry<T> = {
	entries: Dict<T>,
	reverse: { [any]: string },

	register: (self: Registry<T>, id: string, entry: T) -> T,
	get: (self: Registry<T>, id: string) -> T?,
	idOf: (self: Registry<T>, value: T) -> string?,

	exists: (self: Registry<T>, id: string) -> boolean,
	values: (self: Registry<T>) -> { T },
	keys: (self: Registry<T>) -> { string },
	raw: (self: Registry<T>) -> Dict<T>,

	forEach: (self: Registry<T>, fn: (id: string, value: T) -> ()) -> (),
	size: (self: Registry<T>) -> number,
	sortedValues: (self: Registry<T>, sortFn: (a: T, b: T) -> boolean) -> { T },
} & typeof(setmetatable({} :: Registry<T>, Registry))

function Registry.new<T>(): Registry<T>
	local self = setmetatable({}, Registry) :: Registry<T>

	self.entries = {} :: Dict<T>
	self.reverse = {} :: { [any]: string }

	return self
end

function Registry.register<T>(self: Registry<T>, id: string, value: T): T
	if Sift.Dictionary.has(self.entries, id) then
		error("ID already exists in registry! " .. id)
	end

	self.entries = Sift.Dictionary.set(self.entries, id, value) :: Dict<T>
	self.reverse[value] = id

	return value
end

function Registry.get<T>(self: Registry<T>, id: string): T?
	return self.entries[id]
end

function Registry.idOf<T>(self: Registry<T>, value: T): string?
	return self.reverse[value]
end

function Registry.exists<T>(self: Registry<T>, id: string): boolean
	return Sift.Dictionary.has(self.entries, id)
end

function Registry.values<T>(self: Registry<T>): { T }
	return Sift.Dictionary.values(self.entries)
end

function Registry.keys<T>(self: Registry<T>): { string }
	return Sift.Dictionary.keys(self.entries)
end

function Registry.raw<T>(self: Registry<T>): Dict<T>
	return self.entries
end

function Registry.forEach<T>(self: Registry<T>, fn: (id: string, value: T) -> ()): ()
	for id, value in self.entries :: Dict<T> do
		fn(id, value)
	end
end

function Registry.size<T>(self: Registry<T>): number
	return Sift.Dictionary.count(self.entries)
end

function Registry.sortedValues<T>(self: Registry<T>, sortFn: (a: T, b: T) -> boolean): { T }
	local values = self:values()
	return Sift.Array.sort(values, sortFn)
end

return Registry
