local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local e: typeof(React.createElement) = React.createElement

type ToolTipProps = {
	children: { React.ReactElement<any> },
	anchor: React.Ref<GuiObject>,
	shown: boolean,
}

local function ToolTip(props: ToolTipProps)
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

	return e("Frame", {
		Visible = true,
		Size = UDim2.new(0, 200, 0, 150),
		Position = UDim2.fromOffset(
			absPos.X + absSize.X + 15,
			absPos.Y + absSize.Y / 2 - 35 + GuiService:GetGuiInset().Y
		),
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 50000,
	}, {
		props.children,
		e("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
		e("UIStroke", {
			Color = Color3.fromRGB(50, 50, 50),
			Thickness = 3,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}),
	})
end

return ToolTip
