local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local UiTypes = require(ReplicatedStorage.Shared.ui.core.UiTypes)
local ImageLabel = require(ReplicatedStorage.Shared.ui.core.components.ImageLabel)

local e = React.createElement

export type Props = UiTypes.TextLabelProps

local function TextLabel(props: Props)
	props.Children = props.Children or {}
	props.TextSize = props.TextSize or 14
	props.TextScaled = if props.TextScaled == nil then true else props.TextScaled
	props.TextWrapped = if props.TextWrapped == nil then false else props.TextWrapped
	props.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	props.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Top
	props.BackgroundTransparency = props.BackgroundTransparency or 1
	props.BorderSizePixel = props.BorderSizePixel or 0
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	props.Stroke = props.Stroke or nil
	props.Prefix = props.Prefix or nil
	props.Font = props.Font or Enum.Font.FredokaOne

	local safeProps = Sift.Dictionary.removeKeys(props, "Prefix", "Stroke", "Children")

	-- Add stroke if present
	if props.Stroke then
		props.Stroke.Color = props.Stroke.Color or Color3.new(0, 0, 0)
		props.Stroke.Thickness = props.Stroke.Thickness or 1

		table.insert(
			props.Children,
			e("UIStroke", {
				Color = props.Stroke.Color,
				Thickness = props.Stroke.Thickness,
			})
		)
	end

	-- Add prefix and optional reflection
	if props.Prefix then
		local prefixImage = props.Prefix.Image
		local prefixSize = props.Prefix.Size
		local offset = props.Prefix.Offset or 0
		local mirrorEnabled = props.Prefix.Mirror or false

		-- Normal prefix
		local prefix = e(ImageLabel, {
			Image = prefixImage,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Fit,
			Size = prefixSize,
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Position = UDim2.new(0, offset, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			ZIndex = 2,
		})

		table.insert(props.Children, prefix)

		-- Mirrored reflection
		if mirrorEnabled then
			local mirrorHeightFrac = 1

			-- Calculate mirror size
			local mirrorSize = UDim2.new(
				prefixSize.X.Scale,
				prefixSize.X.Offset,
				prefixSize.Y.Scale * mirrorHeightFrac,
				prefixSize.Y.Offset * mirrorHeightFrac
			)

			-- Mirror position directly below the original image
			local mirrorPos = UDim2.new(0, offset, 1, -10)

			local mirror = e("ImageLabel", {
				Image = prefixImage,
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Size = mirrorSize,
				Position = mirrorPos,
				AnchorPoint = Vector2.new(1, 0),
				ZIndex = 1,
				-- Flip using ImageRectSize
				ImageRectOffset = Vector2.new(0, prefixSize.Y.Offset),
				ImageRectSize = Vector2.new(prefixSize.X.Offset, -prefixSize.Y.Offset),
			}, {
				e("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.7),
						NumberSequenceKeypoint.new(0.3, 1),
						NumberSequenceKeypoint.new(1, 1),
					}),
				}),
			})

			table.insert(props.Children, mirror)
		end
	end

	return e("TextLabel", safeProps, props.Children)
end

return TextLabel
