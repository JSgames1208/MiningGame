local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local useSpring = require(ReplicatedStorage.Shared.ui.core.hooks.useSpring)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local e: typeof(React.createElement) = React.createElement

local TAB_IMAGES = {
	tools = ImageIds.icons.stone_pickaxe,
	materials = ImageIds.icons.dirt,
	potions = ImageIds.icons.potion_red,
	items = ImageIds.icons.wooden_pickaxe,
}

export type Props = {
	tab: string,
}

local function TabButton(props: Props)
	local currentTab = ReactCharm.useAtom(inventorySlice.states.tab)

	local sizeSpring = useSpring(UDim2.new(0.3, 0, 0.1, 0), {
		speed = 10,
	})

	local colorSpring = useSpring(0, { speed = 4 })

	React.useEffect(function()
		if currentTab == props.tab then
			colorSpring.setGoal(1)
		else
			colorSpring.setGoal(0)
		end
	end, { currentTab })

	local color, setColor = React.useState(Color3.fromRGB(150, 150, 150))

	React.useEffect(function()
		setColor(Color3.fromRGB(150, 150, 150):Lerp(Color3.fromRGB(255, 255, 255), colorSpring.binding))
	end)

	React.useEffect(function()
		if currentTab == props.tab then
			sizeSpring.setGoal(UDim2.new(0.99, 0, 0.33, 0))
		else
			sizeSpring.setGoal(UDim2.new(0.81, 0, 0.27, 0))
		end
	end, { currentTab })

	return e("Frame", {
		Size = sizeSpring.binding,
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = color,
		ZIndex = 0,
	}, {
		Button = e(Button, {
			Size = UDim2.new(0.45, 0, 0.9, 0),
			spring = false,
			SizeConstraint = Enum.SizeConstraint.RelativeXY,
			Position = UDim2.new(0.05, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Image = TAB_IMAGES[props.tab] or ImageIds.icons.stone_pickaxe,
			ScaleType = Enum.ScaleType.Fit,
			ImageRectOffset = Vector2.zero,
			ImageRectSize = Vector2.new(1028, 1028),
			onClick = function()
				inventorySlice.actions.setTab(props.tab)
			end,
			ZIndex = 5,
		}),

		e("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
		e("UIStroke", {
			Color = Color3.fromRGB(0, 0, 0),
			Thickness = 10,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}),
	})
end

return TabButton
