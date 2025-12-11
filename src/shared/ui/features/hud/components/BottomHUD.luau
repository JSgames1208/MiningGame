local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)
local tooltipThunk = require(ReplicatedStorage.Shared.ui.features.inventory.state.tooltipThunk)
local upgradeSlice = require(ReplicatedStorage.Shared.ui.features.upgrades.state.upgradeSlice)
local e: typeof(React.createElement) = React.createElement

local function BottomHUD()
	local shown = ReactCharm.useAtom(hudSlice.states.shown)
	local equippedToolGuid = ReactCharm.useAtom(toolSlice.states.equipped)

	local function getToolId(guid: string)
		local id = tooltipThunk.actions.getToolInstance(guid) and tooltipThunk.actions.getToolInstance(guid).id or nil

		return id
	end

	return e(
		SlideOutFrame,
		{
			Shown = shown,
			AnchorPoint = Vector2.new(0.5, 1),
			From = UDim2.new(0.5, 0, 1, -55),
			To = UDim2.new(0.5, 0, 1.5, -55),
			Size = UDim2.new(0, 750, 0, 400),
			BackgroundTransparency = 1,
			Speed = 8,
			children = {
				e("UIListLayout", {
					Padding = UDim.new(0, 25),
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				e(
					Button,
					{
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 1),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
						Image = getToolId(equippedToolGuid) and ImageIds.icons[getToolId(equippedToolGuid)]
							or ImageIds.icons.wooden_pickaxe,
						ImageRectOffset = Vector2.zero,
						ImageRectSize = Vector2.new(1028, 1028),
						Mirror = true,
						onClick = function()
							inventorySlice.actions.setInventoryOpen(true)
						end,
						Children = {
							e(
								TextLabel,
								{
									Text = "Inventory",
									Font = Enum.Font.FredokaOne,
									Position = UDim2.new(0.5, 0, 1, 0),
									AnchorPoint = Vector2.new(0.5, 0.75),
									Size = UDim2.new(1, 0, 0.5, 0),
									TextScaled = true,
									TextWrapped = false,
									TextXAlignment = Enum.TextXAlignment.Center,
									TextYAlignment = Enum.TextYAlignment.Center,
									TextColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									ZIndex = 2,
									Stroke = {
										Color = Color3.fromRGB(0, 0, 0),
										Thickness = 10,
									},
								} :: TextLabel.Props
							),
						},
					} :: Button.ButtonProps
				),
				e(
					Button,
					{
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
						Image = ImageIds.icons.potion_red,
						ImageRectOffset = Vector2.zero,
						ImageRectSize = Vector2.new(1028, 1028),
						Mirror = true,
						onClick = function()
							upgradeSlice.actions.setOpen(true)
						end,
						Children = {
							e(
								TextLabel,
								{
									Text = "Upgrades",
									Font = Enum.Font.FredokaOne,
									Position = UDim2.new(0.5, 0, 1, 0),
									AnchorPoint = Vector2.new(0.5, 0.75),
									Size = UDim2.new(1, 0, 0.5, 0),
									TextScaled = true,
									TextWrapped = false,
									TextXAlignment = Enum.TextXAlignment.Center,
									TextYAlignment = Enum.TextYAlignment.Center,
									TextColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									ZIndex = 2,
									Stroke = {
										Color = Color3.fromRGB(0, 0, 0),
										Thickness = 10,
									},
								} :: TextLabel.Props
							),
						},
					} :: Button.ButtonProps
				),
			},
		} :: SlideOutFrame.SlideOutProps
	)
end

return BottomHUD
