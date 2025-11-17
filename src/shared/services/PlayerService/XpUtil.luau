-- XP Formula Constants
local A = 30
local C = 0.85
local B = 1.07

-- XP required FOR a specific level (your formula)
local function getXPForLevel(level)
	level += 1
	return math.floor(A * (level ^ C) * (B ^ level))
end

-- Total XP required TO REACH a given level (sum of all previous levels)
local function getTotalXPForLevel(level)
	local total = 0
	for i = 0, level do
		total = total + getXPForLevel(i)
	end
	return total
end

-- Determine level from total XP (works for ANY future rebalance)
local function getLevelFromTotalXP(totalXP)
	local level = 0
	local accumulated = 0

	while true do
		local req = getXPForLevel(level)
		if totalXP < accumulated + req then
			return level, accumulated, req -- also returns helper info
		end
		accumulated = accumulated + req
		level += 1
	end
end

-- Returns useful data for XP bars:
-- current level
-- xp into the current level
-- xp needed to complete current level
local function getLevelProgress(totalXP)
	local level, accumulated, req = getLevelFromTotalXP(totalXP)

	local xpIntoLevel = totalXP - accumulated
	local xpNeededThisLevel = req

	return {
		level = level,
		xpIntoLevel = xpIntoLevel,
		xpNeeded = xpNeededThisLevel,
	}
end

return {
	getXPForLevel = getXPForLevel,
	getTotalXPForLevel = getTotalXPForLevel,
	getLevelFromTotalXP = getLevelFromTotalXP,
	getLevelProgress = getLevelProgress,
}
