local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local e: typeof(React.createElement) = React.createElement

local UPGRADE_LINE_HEIGHT = 30

export type UpgradesDisplayProps = {
	upgrades: { string },
}

local function UpgradesDisplay(props: UpgradesDisplayProps)
	local upgrades = props.upgrades

	if #upgrades == 0 then
		return nil
	end

	local upgradeElements = {}
	for _, upgrade in upgrades do
		upgradeElements[#upgradeElements + 1] = e(TextLabel, {
			Text = "- " .. upgrade,
			Size = UDim2.new(0.8, 0, 0, UPGRADE_LINE_HEIGHT),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Top,
			Position = UDim2.new(0, 0, 0, 0),
			Children = {},
			TextColor3 = Color3.fromRGB(150, 150, 150),
			Font = Enum.Font.FredokaOne,
			TextScaled = true,
			TextWrapped = false,
			RichText = false,
			LayoutOrder = 1 + #upgradeElements + 1,
			ZIndex = 50001,
		})
	end

	return e("Frame", {
		Size = UDim2.new(1, 0, 0, #upgrades * UPGRADE_LINE_HEIGHT),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 5,
	}, {
		e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 6),
		}),

		e("Frame", {
			Visible = #upgradeElements > 0,
			Size = UDim2.new(1, 0, 0, 0.25),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(100, 100, 100),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			ZIndex = 50002,
			LayoutOrder = 0,
		}),
		e(TextLabel, {
			Visible = #upgradeElements > 0,
			Text = "Upgrades",
			TextColor3 = Color3.fromRGB(125, 125, 125),
			Size = UDim2.new(0.8, 0, 0, UPGRADE_LINE_HEIGHT),
			TextXAlignment = Enum.TextXAlignment.Center,
			Position = UDim2.new(0, 0, 0, 0),
			ZIndex = 50002,
			LayoutOrder = 1,
			Children = {},
		}),

		upgradeElements,
	})
end

return UpgradesDisplay
