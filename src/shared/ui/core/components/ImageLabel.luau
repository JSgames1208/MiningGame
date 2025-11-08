local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local UiTypes = require(ReplicatedStorage.Shared.ui.core.UiTypes)

local e = React.createElement

export type Props = UiTypes.ImageLabelProps

local function ImageLabel(props: Props)
	props.BackgroundTransparency = props.BackgroundTransparency or 1
	props.BorderSizePixel = props.BorderSizePixel or 0
	props.Size = props.Size or UDim2.new(1, 0, 1, 0)
	props.Position = props.Position or UDim2.new(0, 0, 0, 0)
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	props.SizeConstraint = props.SizeConstraint or Enum.SizeConstraint.RelativeXY
	props.ZIndex = props.ZIndex or 1
	props.ClipsDescendants = props.ClipsDescendants or true

	local safeProps = Sift.Dictionary.removeKeys(props, "Children")

	return e("ImageLabel", safeProps, props.Children)
end

return ImageLabel
