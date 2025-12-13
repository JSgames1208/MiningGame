local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local ItemImage = require(ReplicatedStorage.Shared.ui.core.components.ItemImage)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)
local e: typeof(React.createElement) = React.createElement

export type SelectedUpgradeFrameProps = {
	slot: number,
}

local function SelectedUpgradeFrame(props: SelectedUpgradeFrameProps)
	local selectedUpgrades = ReactCharm.useAtom(upgradeSlice.states.selectedUpgrades)

	return e("Frame", {
		Size = UDim2.new(1, 0, 0.25, 0),
		BackgroundTransparency = 1,
		LayoutOrder = props.slot,
	}, {
		e("UICorner", { CornerRadius = UDim.new(0.1, 0) }),
		e("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 10 }),
		e("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0.015, 0),
		}),
		e("Frame", {
			Size = UDim2.new(0.25, 0, 0.9, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXY,
			BackgroundTransparency = 1,
		}, {
			e(
				Button,
				{
					hoverScale = 1.05,
					Size = UDim2.new(0.95, 0, 0.2, 0),
					Position = UDim2.new(0.5, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 1),
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(0, 225, 0),
					onClick = function()
						upgradeSlice.actions.setSelectUpgradeMenuOpen(true)
						upgradeSlice.actions.setUpgradeSlot(props.slot)
					end,
					Children = {
						e("UICorner", { CornerRadius = UDim.new(0.2, 0) }),
						e("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 10 }),
						e(TextLabel, {
							Text = selectedUpgrades[props.slot] ~= nil and "Swap" or "Equip",
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							Font = Enum.Font.FredokaOne,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0.9, 0, 0.9, 0),
							TextScaled = true,
							Children = {},
						}),
					},
				} :: Button.ButtonProps
			),
			e(ItemImage, {
				itemId = selectedUpgrades[props.slot] or "",
				equipped = false,
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
			}),
		}),
		e("Frame", {
			Size = UDim2.new(0.7, 0, 0.9, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXY,
		}),
	})
end

return SelectedUpgradeFrame
