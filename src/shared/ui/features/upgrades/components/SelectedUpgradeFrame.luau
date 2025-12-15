local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local Upgrades = require(ReplicatedStorage.Shared.modules.core.registries.Upgrades)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local Intersection = require(ReplicatedStorage.Shared.ui.core.components.Intersection)
local ItemImage = require(ReplicatedStorage.Shared.ui.core.components.ItemImage)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)
local e: typeof(React.createElement) = React.createElement

export type SelectedUpgradeFrameProps = {
	slot: number,
}

local function SelectedUpgradeFrame(props: SelectedUpgradeFrameProps)
	local selectedUpgrades = ReactCharm.useAtom(upgradeSlice.states.selectedUpgrades)

	local upgradeId = selectedUpgrades[props.slot] and selectedUpgrades[props.slot].id
	local upgradeEntry = Upgrades.get(upgradeId)
	local upgradeName = upgradeEntry and upgradeEntry.name .. " " .. selectedUpgrades[props.slot].level or ""
	local upgradeDescription = upgradeEntry and upgradeEntry.description or ""

	local upgradeSelected: boolean = selectedUpgrades[props.slot] ~= nil

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
					BackgroundColor3 = upgradeSelected and Color3.fromRGB(225, 0, 0) or Color3.fromRGB(0, 225, 0),
					ZIndex = 5,
					onClick = function()
						if upgradeSelected then
							upgradeSlice.actions.attemptRemoveUpgrade(props.slot)
						else
							upgradeSlice.actions.setSelectUpgradeMenuOpen(true)
							upgradeSlice.actions.setUpgradeSlot(props.slot)
						end
					end,
					Children = {
						e("UICorner", { CornerRadius = UDim.new(0.2, 0) }),
						e("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 10 }),
						e(TextLabel, {
							Text = upgradeSelected and "Remove" or "Equip",
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							Font = Enum.Font.FredokaOne,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0.9, 0, 0.9, 0),
							TextScaled = true,
							ZIndex = 6,
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
			BackgroundTransparency = 1,
		}, {
			e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.015, 0),
			}),
			e(TextLabel, {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0.4, 0),
				TextScaled = true,
				Text = upgradeName,
				Font = Enum.Font.FredokaOne,
				LayoutOrder = 0,
				ZIndex = 10,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextXAlignment = Enum.TextXAlignment.Center,
				Stroke = {
					Thickness = 7.5,
					Color = Color3.fromRGB(0, 0, 0),
				},
				Children = {},
			}),
			e(Intersection, {
				ZIndex = 10,
				LayoutOrder = 1,
				shown = upgradeName ~= "" and upgradeDescription ~= "",
			}),
			e(TextLabel, {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 0.3, 0),
				TextScaled = true,
				Text = upgradeDescription,
				Font = Enum.Font.FredokaOne,
				LayoutOrder = 2,
				ZIndex = 10,
				TextColor3 = Color3.fromRGB(50, 50, 50),
				TextYAlignment = Enum.TextYAlignment.Center,
				TextXAlignment = Enum.TextXAlignment.Center,
				Children = {},
			}),
		}),
	})
end

return SelectedUpgradeFrame
