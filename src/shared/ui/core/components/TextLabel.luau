local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local UiTypes = require(ReplicatedStorage.Shared.ui.core.UiTypes)

local e = React.createElement

export type Props = UiTypes.TextLabelProps

local function TextLabel(props: Props)
	props.Children = props.Children or {}
	props.TextSize = props.TextSize or 14
	props.TextScaled = props.TextScaled or true
	props.TextWrapped = props.TextWrapped or false
	props.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	props.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Top
	props.BackgroundTransparency = props.BackgroundTransparency or 1
	props.BorderSizePixel = props.BorderSizePixel or 0
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	props.Stroke = props.Stroke or nil
	props.Font = props.Font or Enum.Font.FredokaOne

	local safeProps = Sift.Dictionary.removeKeys(props, "Stroke", "Children")

	if props.Stroke then
		props.Stroke.Color = props.Stroke.Color or Color3.new(0, 0, 0)
		props.Stroke.Thickness = props.Stroke.Thickness or 1

		local stroke: React.Element<any> = e("UIStroke", {
			Color = props.Stroke.Color,
			Thickness = props.Stroke.Thickness,
		})

		props.Children = (props.Children or {}) :: { React.Element<any> }

		table.insert(props.Children, stroke)
	end

	return e("TextLabel", safeProps, props.Children)
end

return TextLabel
