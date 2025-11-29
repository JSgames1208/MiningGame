local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ScrollingInventory = require(ReplicatedStorage.Shared.ui.features.inventory.components.ScrollingInventory)
local TabButton = require(ReplicatedStorage.Shared.ui.features.inventory.components.TabButton)
local TooltipProvider = require(ReplicatedStorage.Shared.ui.features.inventory.components.TooltipProvider)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local e: typeof(React.createElement) = React.createElement

local function MainInventory()
	local shown = ReactCharm.useAtom(inventorySlice.states.inventoryOpen)
	local tab = ReactCharm.useAtom(inventorySlice.states.tab)

	return e(
		SlideOutFrame,
		{
			Shown = shown,
			Size = UDim2.new(0, 2000, 0, 1500),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(240, 240, 240),
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
				e(TextLabel, {
					Text = "Inventory!",
					Font = Enum.Font.FredokaOne,
					Position = UDim2.new(0.05, 0, 0, 0),
					AnchorPoint = Vector2.new(0, 0.75),
					Size = UDim2.new(0.5, 0, 0.1, 0),
					TextScaled = true,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Children = {},
					TextColor3 = Color3.fromRGB(255, 255, 255),
					ZIndex = 5,
					Stroke = {
						Thickness = 10,
						Color = Color3.fromRGB(0, 0, 0),
					},
				}),
				e(Button, {
					Size = UDim2.new(0.1, 0, 0.1, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					Position = UDim2.new(1, 0, 0, 0),
					AnchorPoint = Vector2.new(0.8, 0.2),
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(225, 0, 0),
					onClick = function()
						inventorySlice.actions.setInventoryOpen(false)
					end,
					ZIndex = 5,
					Children = {
						e(TextLabel, {
							Text = "X",
							Font = Enum.Font.FredokaOne,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0.8, 0, 0.8, 0),
							TextScaled = true,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							ZIndex = 10,
							Children = {},
						}),
						e("UICorner", {
							CornerRadius = UDim.new(0.2, 0),
						}),
						e("UIStroke", {
							Color = Color3.fromRGB(0, 0, 0),
							Thickness = 10,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						}),
					},
				}),
				e(TextLabel, {
					Text = string.gsub(tab, "^%l", function(c)
						return string.upper(c)
					end),
					Font = Enum.Font.FredokaOne,
					Position = UDim2.new(0.025, 0, 0.06, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0.5, 0, 0.075, 0),
					TextScaled = true,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Bottom,
					Children = {},
					TextColor3 = Color3.fromRGB(255, 255, 255),
					ZIndex = 5,
					Stroke = {
						Thickness = 10,
						Color = Color3.fromRGB(0, 0, 0),
					},
				}),

				e("Frame", {
					Size = UDim2.new(0.4, 0, 0.75, 0),
					Position = UDim2.new(0, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(220, 220, 220),
					ZIndex = 0,
				}, {
					e(TabButton, {
						tab = "tools",
					}),
					e(TabButton, {
						tab = "items",
					}),
					e(TabButton, {
						tab = "materials",
					}),
					e(TabButton, {
						tab = "potions",
					}),
					e("UIListLayout", {
						Padding = UDim.new(0, 30),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),
				}),

				e(ScrollingInventory),
			},
		} :: SlideOutFrame.SlideOutProps
	)
end

return MainInventory
