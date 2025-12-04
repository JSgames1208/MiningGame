local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local e: typeof(React.createElement) = React.createElement

local UPGRADE_LINE_HEIGHT = 75

local function UpgradesDisplay(upgrades: { string })
	local children = {}

	local upgradeLineCount = #upgrades >= 3 and 3 or #upgrades

	for i = 1, upgradeLineCount do
		local upgrade = upgrades[i]
		children[upgrade] = e(
			TextLabel,
			{
				Size = UDim2.new(1, 0, 0, UPGRADE_LINE_HEIGHT),
				TextXAlignment = Enum.TextXAlignment.Center,
				Text = upgrade,
				TextColor3 = Color3.fromRGB(0, 0, 0),
				Font = Enum.Font.FredokaOne,
				TextScaled = true,
				TextWrapped = false,
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				ZIndex = 50001,
				LayoutOrder = 4 + #children,
				Children = {},
			} :: TextLabel.Props
		)
	end

	return e("Frame", {
		Size = UDim2.new(1, 0, 0, #children * UPGRADE_LINE_HEIGHT + (upgradeLineCount - 1) * 6),
		Position = UDim2.new(0, 0, 0, 0),
		ZIndex = 50001,
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
	}, {
		e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Children = children,
		}),
	})
end

return UpgradesDisplay
