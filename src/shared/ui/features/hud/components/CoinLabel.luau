local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local NumberFormatter = require(ReplicatedStorage.Shared.modules.math.NumberFormatter)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local useLinear = require(ReplicatedStorage.Shared.ui.core.hooks.useLinear)
local useSpring = require(ReplicatedStorage.Shared.ui.core.hooks.useSpring)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)
local e: typeof(React.createElement) = React.createElement

local function CoinLabel()
	local coins = ReactCharm.useAtom(hudSlice.states.currency)

	local exp = true
	local coinAnim

	if exp then
		coinAnim = useSpring(coins, { speed = 7.5 })
	else
		coinAnim = useLinear(coins, { speed = 2 })
	end

	React.useEffect(function()
		coinAnim.setGoal(coins)
	end, { coins })

	return e(TextLabel, {
		Text = NumberFormatter(math.round(coinAnim.binding)),
		Font = Enum.Font.FredokaOne,
		Position = UDim2.new(0.7, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0.9, 0, 0.25, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		TextScaled = true,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Prefix = {
			Image = ImageIds.icons.coin,
			Mirror = true,
			ImageRectOffset = Vector2.zero,
			ImageRectSize = Vector2.new(883, 978),
			Offset = -10,
			Size = UDim2.new(1.2, 0, 1.2, 0),
		},
		Stroke = {
			Color = Color3.fromRGB(0, 0, 0),
			Thickness = 10,
		},
		Children = {},
	})
end

return CoinLabel
