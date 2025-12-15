local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)

local QuestSignals = {}

QuestSignals.OreMined = Signal.new()

return QuestSignals
