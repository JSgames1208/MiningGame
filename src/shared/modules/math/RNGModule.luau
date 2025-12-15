local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)
export type ChanceTable = {
	[string]: number,
}

local RNGModule = {}

local function sum(nums: { number })
	local s = 0
	for _, v in nums do
		if typeof(v) ~= "number" then
			continue
		end
		s += v
	end
	return s
end

function RNGModule.pickWeighted(weights: ChanceTable): string?
	local total = sum(Sift.Dictionary.values(weights))
	if total <= 0 then
		return nil
	end

	local rand = math.random() * total
	local cumulative = 0

	for key, weight in pairs(weights) do
		cumulative += weight
		if rand <= cumulative then
			return key
		end
	end
	return nil
end

return RNGModule
