local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ItemImage = require(ReplicatedStorage.Shared.ui.core.components.ItemImage)
local MenuScreen = require(ReplicatedStorage.Shared.ui.core.components.MenuScreen)
local tooltipThunk = require(ReplicatedStorage.Shared.ui.features.inventory.state.tooltipThunk)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)
local e: typeof(React.createElement) = React.createElement

local function UpgradeMenu()
	local shown = ReactCharm.useAtom(upgradeSlice.states.upgradeMenuOpen)
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
				e("Frame", {
					Size = UDim2.new(0.9, 0, 0.9, 0),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
				}, {
					e(
						ItemImage,
						{
							itemId = selectedTool.id,
							equipped = false,
							SizeConstraint = Enum.SizeConstraint.RelativeXX,
							Size = UDim2.new(1, 0, 1, 0),
							Position = UDim2.new(0.5, 0, 0, 0),
							AnchorPoint = Vector2.new(0.5, 0),
						} :: ItemImage.ItemImageProps
					),
				}),
			}),
		},
	})
end

return UpgradeMenu
