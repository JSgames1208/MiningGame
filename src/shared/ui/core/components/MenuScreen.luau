local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local e: typeof(React.createElement) = React.createElement

local function MenuScreen()
	local shown = ReactCharm.useAtom(inventorySlice.states.inventoryOpen)

	return e(
		SlideOutFrame,
		{
			Shown = shown,
			Size = UDim2.new(0, 2000, 0, 1500),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(245, 245, 245),
			From = UDim2.new(0.5, 0, 0.5, 0),
			To = UDim2.new(0.5, 0, -0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Speed = 10,
			children = {
				e("UIStroke", {
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 10,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}),
				e("UICorner", {
					CornerRadius = UDim.new(0.05, 0),
				}),
			},
		} :: SlideOutFrame.SlideOutProps
	)
end

return MenuScreen
