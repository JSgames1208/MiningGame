local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)
local modifierSlice = require(ReplicatedStorage.Shared.ui.features.modifiers.state.modifierSlice)
local e: typeof(React.createElement) = React.createElement

local MODIFIER_SIZE = 200
local PADDING = 30

local function ModifierFrame()
	local shown = ReactCharm.useAtom(hudSlice.states.shown)
	local modifierIds = ReactCharm.useAtom(modifierSlice.states.modifierIds)

	local modifierTimes, setModifierTimes = React.useState({})

	React.useEffect(function()
		local conn = RunService.RenderStepped:Connect(function(dt)
			local times = {}
			for _, modifierId in modifierIds do
				local modifier = modifierSlice.actions.getModifierById(modifierId)()
				if modifier and modifier.icon then
					local timeLeft = modifier.expiresAt and modifier.expiresAt - os.time()
					if timeLeft < 0 then
						timeLeft = 0
					end

					local fTimeLeft = timeLeft and string.format("%02d:%02d", math.floor(timeLeft / 60), timeLeft % 60)
					times[modifierId] = fTimeLeft
				end
			end

			setModifierTimes(times)
		end)

		return function()
			conn:Disconnect()
		end
	end)

	local modifierIcons = {}

	for _, modifierId in modifierIds do
		local modifier = modifierSlice.actions.getModifierById(modifierId)()

		if not modifier or not modifier.icon then
			continue
		end

		local timeLeft = modifierTimes and modifierTimes[modifierId]

		local icon = e("ImageLabel", {
			Image = modifier.icon,
			Size = UDim2.new(0, MODIFIER_SIZE, 0, MODIFIER_SIZE),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			children = {
				e(TextLabel, {
					Text = timeLeft,
					Font = Enum.Font.FredokaOne,
					Size = UDim2.new(1, 0, 0.35, 0),
					Position = UDim2.new(0.5, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.75),
					TextScaled = true,
					TextWrapped = false,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					ZIndex = 10,
					Stroke = {
						Thickness = 2,
						Color = Color3.fromRGB(0, 0, 0),
					},
					Children = {},
				}),
			},
		})

		table.insert(modifierIcons, icon)
	end

	return e(SlideOutFrame, {
		Shown = shown,
		From = UDim2.new(0, 0, 1, 0),
		To = UDim2.new(0, 0, 1.5, 0),
		Size = UDim2.new(0, 800, 0, 500),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Speed = 8,
		children = {
			e("UIPadding", {
				PaddingLeft = UDim.new(0, PADDING),
				PaddingRight = UDim.new(0, PADDING),
				PaddingTop = UDim.new(0, PADDING),
				PaddingBottom = UDim.new(0, PADDING),
			}),
			e("UIGridLayout", {
				CellSize = UDim2.new(0, MODIFIER_SIZE, 0, MODIFIER_SIZE),
				CellPadding = UDim2.new(0, MODIFIER_SIZE / 10, 0, MODIFIER_SIZE / 10),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				StartCorner = Enum.StartCorner.BottomLeft,
			}),
			unpack(modifierIcons),
		},
	})
end

return ModifierFrame
