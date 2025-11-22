local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ScrollingItemLayout = require(ReplicatedStorage.Shared.ui.features.inventory.components.ScrollingItemLayout)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)
local e: typeof(React.createElement) = React.createElement

local function SwapToolMenu()
	local shown = ReactCharm.useAtom(miningSlice.states.swapToolOpen)
	local mining = ReactCharm.useAtom(miningSlice.states.mining)

	local equippedToolId = ReactCharm.useAtom(toolSlice.states.equipped)

	local inventory = inventorySlice.states.inventory()
	local categoryMap = inventory["tools"]

	local items = {}

	for id, entryAtom in categoryMap do
		table.insert(items, { id = id, atom = entryAtom })
	end

	table.sort(items, function(a, b)
		local aEntry = a.atom()
		local bEntry = b.atom()

		-- equipped tool goes first
		local aIsEquipped = aEntry.guid == equippedToolId
		local bIsEquipped = bEntry.guid == equippedToolId

		if aIsEquipped and not bIsEquipped then
			return true
		end
		if bIsEquipped and not aIsEquipped then
			return false
		end

		-- otherwise alphabetical
		return aEntry.id < bEntry.id
	end)

	return e(
		SlideOutFrame,
		{
			Shown = shown and mining,
			Size = UDim2.new(0, 2000, 0, 1500),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(230, 230, 230),
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
					Text = "Swap Tool!",
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
						miningSlice.actions.setSwapToolOpen(false)
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
				e(
					"Frame",
					{
						Size = UDim2.new(0.4, 0, 0.75, 0),
						Position = UDim2.new(0, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(220, 220, 220),
						ZIndex = 0,
					},
					e("UIListLayout", {
						Padding = UDim.new(0, 30),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					})
				),
				e(ScrollingItemLayout, {
					items = items,
					equippedToolId = equippedToolId,
					exitOnPress = true,
					tab = "tools",
				}),
			},
		} :: SlideOutFrame.SlideOutProps
	)
end

return SwapToolMenu
