local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local MenuScreen = require(ReplicatedStorage.Shared.ui.core.components.MenuScreen)
local tooltipThunk = require(ReplicatedStorage.Shared.ui.features.inventory.state.tooltipThunk)
local SelectedToolFrame = require(ReplicatedStorage.Shared.ui.features.upgrades.components.SelectedToolFrame)
local SelectedUpgradeFrame = require(ReplicatedStorage.Shared.ui.features.upgrades.components.SelectedUpgradeFrame)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)
local e: typeof(React.createElement) = React.createElement

local function UpgradeMenu()
	local shown = ReactCharm.useAtom(upgradeSlice.states.mainMenuOpen)
	local selectedGuid = ReactCharm.useAtom(upgradeSlice.states.selectedGuid)
	local selectedTool = tooltipThunk.actions.getToolInstance(selectedGuid) or { id = "" }

	return e(MenuScreen, {
		shown = shown,
		menuTitle = "Upgrades!",
		setOpen = upgradeSlice.actions.setOpen,
		children = {
			e("Frame", {
				Size = UDim2.new(0.3, 0, 0.6, 0),
				Position = UDim2.new(0.04, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				ClipsDescendants = false,
			}, {
				e("UICorner", { CornerRadius = UDim.new(0.05, 0) }),
				e("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 10 }),
				e(SelectedToolFrame, { selectedTool = selectedTool }),
			}),
			e("Frame", {
				Size = UDim2.new(0.58, 0, 0.95, 0),
				Position = UDim2.new(0.96, 0, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				ClipsDescendants = false,
			}, {
				e("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 50),
				}),
				e(SelectedUpgradeFrame, { slot = "1" }),
				e(SelectedUpgradeFrame, { slot = "2" }),
				e(SelectedUpgradeFrame, { slot = "3" }),
			}),
		},
	})
end

return UpgradeMenu
