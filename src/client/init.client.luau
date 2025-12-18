local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
require(ReplicatedStorage.Shared.modules.core.RegistryLoader)
local AnimationService = require(ReplicatedStorage.Shared.services.AnimationService.AnimationService)
local DialogueServiceClient = require(ReplicatedStorage.Shared.services.DialogueService.DialogueServiceClient)
local InventoryServiceClient = require(ReplicatedStorage.Shared.services.InventoryService.InventoryServiceClient)
local MiningServiceClient = require(ReplicatedStorage.Shared.services.MiningService.MiningServiceClient)
local PlayerServiceClient = require(ReplicatedStorage.Shared.services.PlayerService.PlayerServiceClient)
local QuestServiceClient = require(ReplicatedStorage.Shared.services.QuestService.QuestServiceClient)
local ToolServiceClient = require(ReplicatedStorage.Shared.services.ToolService.ToolServiceClient)
local UpgradeServiceClient = require(ReplicatedStorage.Shared.services.UpgradeService.UpgradeServiceClient)
local RootUI = require(ReplicatedStorage.Shared.ui.app.RootUI)
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local e = React.createElement

DataService:init()

MiningServiceClient:init()
PlayerServiceClient:init()
InventoryServiceClient:init()
AnimationService:init()
ToolServiceClient:init()
UpgradeServiceClient:init()
QuestServiceClient:init()
DialogueServiceClient:init()

local uiFolder = Instance.new("Folder")
uiFolder.Name = "ReactUI"
uiFolder.Parent = playerGui

local root = ReactRoblox.createRoot(uiFolder)
root:render(e(RootUI))
