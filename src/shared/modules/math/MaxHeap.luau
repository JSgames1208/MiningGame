--!strict

-- Simple binary max-heap for Luau
local MaxHeap = {}
MaxHeap.__index = MaxHeap

export type MaxHeap = {
	items: { { key: number, value: any } },
	push: (self: MaxHeap, key: number, value: any) -> (),
	pop: (self: MaxHeap) -> (number?, any?),
	isEmpty: (self: MaxHeap) -> boolean,
} & typeof(setmetatable({} :: MaxHeap, MaxHeap))

function MaxHeap.new(): MaxHeap
	return setmetatable({ items = {} }, MaxHeap) :: MaxHeap
end

function MaxHeap.push(self: MaxHeap, key, value)
	table.insert(self.items, { key = key, value = value })
	local i = #self.items
	while i > 1 do
		local parent = math.floor(i / 2)
		if self.items[parent].key >= self.items[i].key then
			break
		end
		self.items[parent], self.items[i] = self.items[i], self.items[parent]
		i = parent
	end
end

function MaxHeap.pop(self: MaxHeap): (number?, any?)
	local items = self.items
	if #items == 0 then
		return nil
	end
	local top = items[1]
	items[1] = items[#items]
	table.remove(items)
	local i = 1
	while true do
		local left = 2 * i
		local right = 2 * i + 1
		local largest = i
		if left <= #items and items[left].key > items[largest].key then
			largest = left
		end
		if right <= #items and items[right].key > items[largest].key then
			largest = right
		end
		if largest == i then
			break
		end
		items[i], items[largest] = items[largest], items[i]
		i = largest
	end
	return top.key, top.value
end

function MaxHeap:isEmpty()
	return #self.items == 0
end

return MaxHeap
