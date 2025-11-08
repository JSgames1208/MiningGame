local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local AnimationService = require(ReplicatedStorage.Shared.services.AnimationService.AnimationService)
local MiningServiceClient = require(ReplicatedStorage.Shared.services.MiningService.MiningServiceClient)
local PlayerServiceClient = require(ReplicatedStorage.Shared.services.PlayerService.PlayerServiceClient)
local RootUI = require(ReplicatedStorage.Shared.ui.app.RootUI)
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local e = React.createElement

MiningServiceClient:init()
PlayerServiceClient:init()
AnimationService:init()

local root = ReactRoblox.createRoot(playerGui)
root:render(e(RootUI))
