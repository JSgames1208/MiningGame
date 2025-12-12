local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local TabNames = require(ReplicatedStorage.Shared.services.InventoryService.TabNames)
local MenuScreen = require(ReplicatedStorage.Shared.ui.core.components.MenuScreen)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ScrollingInventory = require(ReplicatedStorage.Shared.ui.features.inventory.components.ScrollingInventory)
local TabButton = require(ReplicatedStorage.Shared.ui.features.inventory.components.TabButton)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local e: typeof(React.createElement) = React.createElement

local function MainInventory()
	local shown = ReactCharm.useAtom(inventorySlice.states.inventoryOpen)
	local tab = ReactCharm.useAtom(inventorySlice.states.tab)

	return e(MenuScreen, {
		shown = shown,
		menuTitle = "Inventory!",
		setOpen = inventorySlice.actions.setInventoryOpen,
		children = {
			e(TextLabel, {
				Text = TabNames[tab],
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
					tab = "tool",
				}),
				e(TabButton, {
					tab = "item",
				}),
				e(TabButton, {
					tab = "upgrade",
				}),
				e(TabButton, {
					tab = "potion",
				}),
				e("UIListLayout", {
					Padding = UDim.new(0, 30),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
			}),

			e(ScrollingInventory, {}),
		},
	})
end

return MainInventory
