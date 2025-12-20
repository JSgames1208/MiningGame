local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)

local QuestSignals = {}

QuestSignals.OreMined = Signal.new()
QuestSignals.ItemCollected = Signal.new()
QuestSignals.CurrencyAdded = Signal.new()

return QuestSignals
