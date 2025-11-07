local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local UiTypes = require(ReplicatedStorage.Shared.ui.core.UiTypes)
local useHover = require(ReplicatedStorage.Shared.ui.core.hooks.useHover)
local useSpring = require(ReplicatedStorage.Shared.ui.core.hooks.useSpring)

local e = React.createElement

local DEFAULT_HOVER_SCALE = 1.15

export type ButtonProps = UiTypes.ImageLabelProps & {
	hoverScale: number?,
	Children: { React.Element<any> },
	onClick: (any?) -> any?,
}

local function Button(props)
	local children = props.Children
	local hoverScale = props.hoverScale or DEFAULT_HOVER_SCALE
	local isHovering, hoverEvents = useHover()
	local spring = useSpring(1, { speed = 10 })

	React.useEffect(function()
		if isHovering then
			spring.setGoal(hoverScale)
		else
			spring.setGoal(1)
		end
	end, { isHovering, hoverScale })

	-- preserve onClick if provided
	if props.onClick then
		props[React.Event.MouseButton1Click] = props.onClick
	end

	local safeProps = Sift.Dictionary.removeKeys(props, "Children", "hoverScale", "onClick")
	local buttonProps = Sift.Dictionary.join(safeProps, {
		[React.Event.MouseEnter] = hoverEvents.onMouseEnter,
		[React.Event.MouseLeave] = hoverEvents.onMouseLeave,
	})

	return e("ImageButton", buttonProps, {
		children,
		e("UIScale", {
			Scale = spring.binding,
		}),
	})
end

return Button
