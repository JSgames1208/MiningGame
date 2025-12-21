local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local React = require(ReplicatedStorage.Packages.React)
local NumberFormatter = require(ReplicatedStorage.Shared.modules.math.NumberFormatter)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)

local e: typeof(React.createElement) = React.createElement

export type GateFrameProps = {
	name: string,
	cost: number,
}

local STROKE_THICKNESS = 7.5

local function GateFrame(props: GateFrameProps)
	local fCost = NumberFormatter(props.cost)
	local sizeVec2 = TextService:GetTextSize(fCost, 100, Enum.Font.FredokaOne, Vector2.new(0, 0))

	local size = UDim2.new(0, sizeVec2.X, 0, sizeVec2.Y)

	return e("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 0,
	}, {
		e("Frame", {
			Size = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			ZIndex = 0,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.6),
		}, {
			e(TextLabel, {
				Text = props.name,
				Font = Enum.Font.FredokaOne,
				Size = UDim2.new(1, 0, 0.3, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				TextSize = 100,
				TextScaled = false,
				TextWrapped = false,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Stroke = {
					Thickness = STROKE_THICKNESS,
					Color = Color3.fromRGB(0, 0, 0),
				},
				Children = {},
			}),
			e(TextLabel, {
				Text = fCost,
				Font = Enum.Font.FredokaOne,
				Size = size,
				--SizeConstraint = Enum.SizeConstraint.RelativeXX,
				Position = UDim2.new(0.5, 0, 0.6, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				TextWrapped = false,
				TextScaled = false,
				TextSize = 100,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Prefix = {
					Image = ImageIds.icons["coin"],
					Offset = -5,
					Size = UDim2.new(0.9, 0, 0.9, 0),
				},
				Stroke = {
					Thickness = STROKE_THICKNESS,
					Color = Color3.fromRGB(0, 0, 0),
				},
				Children = {},
			}),
		}),
	})
end

return GateFrame
