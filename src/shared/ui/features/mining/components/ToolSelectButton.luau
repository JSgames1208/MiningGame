local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)
local e: typeof(React.createElement) = React.createElement

local function ToolSelectButton()
	local equippedToolGuid = ReactCharm.useAtom(toolSlice.states.equipped)
	local inventory = ReactCharm.useAtom(inventorySlice.states.inventory)

	local equippedToolEntryAtom = inventory.tool[equippedToolGuid]
	local equippedToolId = equippedToolEntryAtom and equippedToolEntryAtom().id or nil

	return e(
		Button,
		{
			Size = UDim2.new(0.8, 0, 0.8, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			BackgroundTransparency = 1,
			Image = ImageIds.icons[equippedToolId] or ImageIds.icons.wooden_pickaxe,
			onClick = function()
				miningSlice.actions.setEquipToolOpen(true)
			end,
			Children = {
				e(
					TextLabel,
					{
						Text = "Swap tool",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0.25, 0),
						Position = UDim2.new(0.5, 0, 1, 0),
						AnchorPoint = Vector2.new(0.5, 1),
						TextColor3 = Color3.new(1, 1, 1),
						TextScaled = true,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						Font = Enum.Font.FredokaOne,
						Stroke = {
							Color = Color3.new(0, 0, 0),
							Thickness = 10,
						},
					} :: TextLabel.Props
				),
			},
		} :: Button.ButtonProps
	)
end

return ToolSelectButton
