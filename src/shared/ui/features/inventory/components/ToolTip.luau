local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local e: typeof(React.createElement) = React.createElement

type TooltipProps = {
	children: { React.ReactElement<any> },
	anchor: React.Ref<GuiObject>,
	shown: boolean,
}

local function Tooltip(props: TooltipProps)
	if not props.shown then
		return
	end

	local ref = props.anchor :: { current: GuiObject? }
	local anchor = ref.current

	if not anchor then
		return nil
	end

	local absPos = anchor.AbsolutePosition
	local absSize = anchor.AbsoluteSize

	local contentSize, setContentSize = React.useState(Vector2.new(200, 20))

	return e("Frame", {
		Size = UDim2.new(0, contentSize.X, 0, contentSize.Y),
		Position = UDim2.fromOffset(
			absPos.X + absSize.X + 15,
			absPos.Y + absSize.Y / 2 - 35 + GuiService:GetGuiInset().Y
		),
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 50000,
	}, {
		e("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
		e("UIStroke", {
			Color = Color3.fromRGB(50, 50, 50),
			Thickness = 3,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}),
		e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -12, 1, -12),
			Position = UDim2.fromOffset(6, 6),
		}, {
			e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 6),

				[React.Change.AbsoluteContentSize] = function(rbx)
					setContentSize(Vector2.new(220, rbx.AbsoluteContentSize.Y + 12))
				end,
			}),
			props.children,
		}),
	})
end

return Tooltip
