local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local ImageLabel = require(ReplicatedStorage.Shared.ui.core.components.ImageLabel)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local useSpring = require(ReplicatedStorage.Shared.ui.core.hooks.useSpring)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)
local e: typeof(React.createElement) = React.createElement

local COLORS = {
	green = Color3.fromRGB(19, 211, 115),
	yellow = Color3.fromRGB(246, 201, 0),
	red = Color3.fromRGB(200, 50, 50),
}

local function HealthBar()
	local adornee = ReactCharm.useAtom(miningSlice.states.currentTarget)
	local shown = ReactCharm.useAtom(miningSlice.states.mining)
	local currentHP = ReactCharm.useAtom(miningSlice.states.currentHP)
	local currentMaxHP = ReactCharm.useAtom(miningSlice.states.currentMaxHP)

	local currentSize = useSpring(1, { speed = 10 })
	local colorSpring = useSpring(0, { speed = 4 })

	local currentHPspring = useSpring(100, { speed = 6 })

	React.useEffect(function()
		if currentMaxHP == 0 then
			return
		end
		local percent = currentHP / currentMaxHP * 100

		colorSpring.setGoal(1 - percent / 100)
		currentSize.setGoal(percent / 100)
		currentHPspring.setGoal(currentHP)
	end, { currentHP, currentMaxHP })

	React.useEffect(function()
		if adornee then
			task.defer(function()
				colorSpring.snap(0)
				currentSize.snap(1)
				currentHPspring.snap(currentHP)
				colorSpring.setGoal(0)
				currentSize.setGoal(1)
				currentHPspring.setGoal(currentHP)
			end)
		end
	end, { adornee })

	if currentMaxHP == 0 or not shown then
		return
	end

	local scale = 1 / 6

	local blend = colorSpring.binding
	local color
	do
		-- smoothly blend: green → yellow → red
		if blend < 0.5 then
			-- green -> yellow
			local t = blend / 0.5
			color = COLORS.green:Lerp(COLORS.yellow, t)
		else
			-- yellow > red
			local t = (blend - 0.5) / 0.5
			color = COLORS.yellow:Lerp(COLORS.red, t)
		end
	end

	return e("BillboardGui", {
		Adornee = adornee,
		Size = UDim2.new(0, 3940 * scale, 0, 1080 * scale),
		StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0),
		SizeOffset = Vector2.new(0, 0),
		ClipsDescendants = false,
	}, {
		HealthDisplay = e(
			ImageLabel,
			{
				Image = ImageIds.healthdisplay,
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.new(0, 1074 * scale, 0, 1075 * scale),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, -1500 * scale, 0.5, 0),
				ZIndex = 3,
				Children = {
					e(
						TextLabel,
						{
							Text = math.round(currentHPspring.binding),
							Font = Enum.Font.Jura,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0.5, 0, 0.5, 0),
							TextScaled = true,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							ZIndex = 4,
						} :: TextLabel.Props
					),
				},
			} :: ImageLabel.Props
		),
		HealthBarHolder = e("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 2750 * scale, 0, 90 * scale),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0.5, -1079 * scale, 0.5, 0),
		}, {
			HealthBar = e("Frame", {
				BackgroundColor3 = color,
				BorderSizePixel = 0,
				Size = UDim2.new(currentSize.binding, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				ZIndex = 2,
			}, {
				e("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			}),
		}),
		HealthBarBackground = e(
			ImageLabel,
			{
				Image = ImageIds.healthbar,
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.new(0, 3194 * scale, 0, 400 * scale),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 373 * scale, 0.5, 0),
				ZIndex = 1,
				Children = {},
			} :: ImageLabel.Props
		),
	})
end

return HealthBar
