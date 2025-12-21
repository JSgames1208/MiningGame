local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local React = require(ReplicatedStorage.Packages.React)
local TooltipProvider = require(ReplicatedStorage.Shared.ui.core.components.TooltipProvider)
local DialogueScreen = require(ReplicatedStorage.Shared.ui.features.dialogue.screens.DialogueScreen)
local HUD = require(ReplicatedStorage.Shared.ui.features.hud.screens.HUD)
local InventoryScreen = require(ReplicatedStorage.Shared.ui.features.inventory.screens.InventoryScreen)
local MiningScreen = require(ReplicatedStorage.Shared.ui.features.mining.screens.MiningScreen)
local ModifierScreen = require(ReplicatedStorage.Shared.ui.features.modifiers.screens.ModifierScreen)
local QuestScreen = require(ReplicatedStorage.Shared.ui.features.quests.screens.QuestScreen)
local UpgradeScreen = require(ReplicatedStorage.Shared.ui.features.upgrades.screens.UpgradeScreen)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local e = React.createElement

local function RootUI()
	return e(React.Fragment, nil, {
		App = e("ScreenGui", {
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
		}, {
			MiningScreen = e(MiningScreen),
			HUD = e(HUD),
			InventoryScreen = e(InventoryScreen),
			UpgradeScreen = e(UpgradeScreen),
			TooltipProvider = e(TooltipProvider),
			QuestScreen = e(QuestScreen),
			DialogueScreen = e(DialogueScreen),
			ModifierScreen = e(ModifierScreen),
		}),
	})
end

return RootUI
