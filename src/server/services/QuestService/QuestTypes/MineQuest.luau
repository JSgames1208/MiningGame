--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local QuestSignals = require(ServerScriptService.Server.services.QuestService.QuestSignals)
local Base = require(ServerScriptService.Server.services.QuestService.QuestTypes._Base)
local QuestType = require(ReplicatedStorage.Shared.modules.core.types.QuestType)
type QuestData = QuestType.QuestData

local MineQuest = {} :: Base.QuestTypeModule

function MineQuest.supports(reqType: string): boolean
	return reqType == "mine"
end

function MineQuest.startRequirement(runtime: Base.Runtime)
	return QuestSignals.OreMined:Connect(function(player: Player, oreId)
		if player ~= runtime.player then
			return
		end
		if oreId ~= "coal" then
			return
		end

		local req = runtime.progress.requirements["coal"]
		req.current += 1

		if req.current >= req.target then
			req.current = req.target
			runtime.complete()
		end
	end)
end

function MineQuest.stopRequirement(conn: RBXScriptConnection?)
	if conn then
		conn:Disconnect()
	end
end

return MineQuest
