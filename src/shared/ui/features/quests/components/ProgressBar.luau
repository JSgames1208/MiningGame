local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local useSpring = require(ReplicatedStorage.Shared.ui.core.hooks.useSpring)
local e: typeof(React.createElement) = React.createElement

export type ProgressBarProps = {
	text: string,
	showNumbers: boolean?,
	current: number?,
	target: number?,
	LayoutOrder: number?,
}

local function ProgressBar(props: ProgressBarProps)
	local initialSize = 0

	if props.current and props.target then
		initialSize = props.current / props.target
	end

	local sizeSpring = useSpring(initialSize, { speed = 12.5 })

	React.useEffect(function()
		if not props.current or not props.target then
			return
		end
		sizeSpring.setGoal(props.current / props.target)
	end, { props.current, props.target })

	local text = props.text
	if props.showNumbers then
		if not props.current or not props.target then
			return
		end
		local suffix = ""
		if props.current == props.target then
			suffix = ": completed"
		else
			suffix = ": " .. props.current .. "/" .. props.target
		end
		text = text .. suffix
	end

	return e("Frame", {
		Size = UDim2.new(0.9, 0, 0.075, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(200, 50, 50),
		BorderSizePixel = 0,
		ZIndex = 5,
	}, {
		e("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
		e("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXY,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(200, 50, 50),
			BorderSizePixel = 0,
			ZIndex = 10,
		}, {
			e("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
			e("UIStroke", {
				Color = Color3.fromRGB(0, 0, 0),
				Thickness = 7.5,
			}),
		}),
		e("Frame", {
			Size = UDim2.new(sizeSpring.binding, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(19, 211, 115),
			BorderSizePixel = 0,
			ZIndex = 6,
		}, {
			e("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		}),
		e(TextLabel, {
			LayoutOrder = props.LayoutOrder or 0,
			Text = text,
			TextColor3 = Color3.fromRGB(245, 245, 245),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Font = Enum.Font.FredokaOne,
			TextScaled = true,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 10,
			Children = {},
		}),
	})
end

return ProgressBar
