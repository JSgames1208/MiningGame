local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local NumberFormatter = require(ReplicatedStorage.Shared.modules.math.NumberFormatter)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local ImageLabel = require(ReplicatedStorage.Shared.ui.core.components.ImageLabel)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local useSpring = require(ReplicatedStorage.Shared.ui.core.hooks.useSpring)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)
local e: typeof(React.createElement) = React.createElement

local function BottomHUD()
	local shown = ReactCharm.useAtom(hudSlice.states.shown)

	local level = ReactCharm.useAtom(hudSlice.states.level)
	local xp = ReactCharm.useAtom(hudSlice.states.xp)
	local maxXP = ReactCharm.useAtom(hudSlice.states.maxXP)

	local sizeSpring = useSpring(0, { speed = 7.5 })
	local xpSpring = useSpring(0, { speed = 7.5 })

	React.useEffect(function()
		sizeSpring.setGoal(xp / maxXP)
	end, { xp, maxXP })

	React.useEffect(function()
		xpSpring.setGoal(xp)
	end, { xp })

	return e(
		SlideOutFrame,
		{
			Shown = shown,
			AnchorPoint = Vector2.new(0.5, 0.5),
			From = UDim2.new(0.5, 0, 1, -30),
			To = UDim2.new(0.5, 0, 1.5, -30),
			Size = UDim2.new(0, 1800, 0, 60),
			BackgroundTransparency = 1,
			Speed = 8,
			children = {
				e(ImageLabel, {
					Image = ImageIds.xpbarback,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					ImageTransparency = 0.3,
					ZIndex = 0,
					ClipsDescendants = true,
					Children = {
						e("UICorner", {
							CornerRadius = UDim.new(1, 0),
						}),
						e("Frame", {
							BackgroundColor3 = Color3.fromRGB(74, 203, 139),
							BackgroundTransparency = 0.15,
							BorderSizePixel = 0,
							Size = UDim2.new(sizeSpring.binding, -4, 1, -16),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 8, 0.5, 0),
							ZIndex = 2,
						}, {
							e("UICorner", {
								CornerRadius = UDim.new(1, 0),
							}),
						}),
					},
				}),
				e(ImageLabel, {
					Image = ImageIds.xpbaroverlay,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					ZIndex = 3,
				}),
				e(
					TextLabel,
					{
						Text = "Lvl " .. level .. "  ",
						Font = Enum.Font.FredokaOne,
						Position = UDim2.new(0, 0, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						Size = UDim2.new(0.25, 0, 1.5, 0),
						TextScaled = true,
						TextWrapped = false,
						TextXAlignment = Enum.TextXAlignment.Right,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						ZIndex = 4,
						Stroke = {
							Thickness = 7.5,
							Color = Color3.fromRGB(0, 0, 0),
						},
					} :: TextLabel.Props
				),
				e(
					TextLabel,
					{
						Text = "  " .. (level + 1),
						Font = Enum.Font.FredokaOne,
						Position = UDim2.new(1, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						Size = UDim2.new(0.25, 0, 1.5, 0),
						TextScaled = true,
						TextWrapped = false,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						ZIndex = 4,
						Stroke = {
							Thickness = 7.5,
							Color = Color3.fromRGB(0, 0, 0),
						},
					} :: TextLabel.Props
				),
				e(
					TextLabel,
					{
						Text = NumberFormatter(math.round(xpSpring.binding)) .. " / " .. NumberFormatter(maxXP),
						Font = Enum.Font.FredokaOne,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = UDim2.new(0.5, 0, 1, 0),
						TextScaled = true,
						TextWrapped = false,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						ZIndex = 4,
					} :: TextLabel.Props
				),
			},
		} :: SlideOutFrame.SlideOutProps
	)
end

return BottomHUD
