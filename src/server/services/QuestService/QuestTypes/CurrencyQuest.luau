local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ReplicatedStorage.Packages.DataService).server
local QuestSignals = require(ServerScriptService.Server.services.QuestService.QuestSignals)
local Base = require(ServerScriptService.Server.services.QuestService.QuestTypes._Base)

local CurrencyQuest = {} :: Base.QuestTypeModule

function CurrencyQuest.supports(reqType: string): boolean
	return reqType == "currency"
end

function CurrencyQuest.startRequirement(runtime: Base.Runtime, reqRuntime: Base.RequirementRuntime): RBXScriptConnection
	local conn
	conn = QuestSignals.CurrencyAdded:Connect(function(player: Player, currencyType: string, amount: number)
		assert(player, "Player is missing from CurrencyAdded signal")

		if player ~= runtime.player then
			return
		end

		if currencyType ~= reqRuntime.data.target then
			return
		end

		local req = runtime.progress.requirements[reqRuntime.id]
		if not req then
			return
		end

		req.current = req.current + amount
		if req.current > req.target then
			req.current = req.target
		end

		local playerQuests = DataService:get(player, { "quests" })
		if playerQuests and playerQuests.active[runtime.questId] then
			playerQuests.active[runtime.questId].progress[reqRuntime.id] = {
				current = req.current,
				target = req.target,
			}
		end

		DataService:set(player, { "quests" }, playerQuests)

		if req.current >= req.target then
			reqRuntime.complete()
		end
	end)

	return conn
end

function CurrencyQuest.stopRequirement(conn: RBXScriptConnection?)
	if conn then
		conn:Disconnect()
		conn = nil
	end
end

return CurrencyQuest
