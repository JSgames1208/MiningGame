local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local NumberFormatter = require(ReplicatedStorage.Shared.modules.math.NumberFormatter)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local MenuScreen = require(ReplicatedStorage.Shared.ui.core.components.MenuScreen)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local zoneSlice = require(ReplicatedStorage.Shared.ui.features.zones.state.zoneSlice)
local e: typeof(React.createElement) = React.createElement

local function ConfirmZoneUnlock()
	local shown = ReactCharm.useAtom(zoneSlice.states.confirmMenuOpen)
	local zoneId = ReactCharm.useAtom(zoneSlice.states.confirmMenuZoneId)

	local zoneAtom = nil
	local zone = nil
	local zoneName = ""
	local zoneCost = ""
	local fCost = ""

	if zoneId then
		zoneAtom = zoneSlice.actions.getZoneById(zoneId)

		if zoneAtom then
			zone = zoneAtom()

			if zone then
				zoneName = zone.name
				zoneCost = zone.cost

				fCost = NumberFormatter(zoneCost)
			end
		end
	end

	return e(React.Fragment, nil, {
		e(
			MenuScreen,
			{
				shown = shown,
				menuTitle = "",
				setOpen = zoneSlice.actions.setConfirmMenuOpen,
				addCloseButton = false,
				children = {
					e(TextLabel, {
						Text = `Unlock {zoneName}?`,
						Position = UDim2.new(0.5, 0, 0.075, 0),
						AnchorPoint = Vector2.new(0.5, 0),
						Size = UDim2.new(0.9, 0, 0.35, 0),
						TextScaled = true,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Stroke = {
							Thickness = 10,
							Color = Color3.fromRGB(0, 0, 0),
						},
						Children = {},
					}),
					e(TextLabel, {
						Text = `This costs {fCost} coins.`,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0),
						Size = UDim2.new(0.7, 0, 0.2, 0),
						TextScaled = true,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Stroke = {
							Thickness = 10,
							Color = Color3.fromRGB(0, 0, 0),
						},
						Children = {},
					}),

					e(
						Button,
						{
							hoverScale = 1.05,
							Position = UDim2.new(0.255, 0, 0.825, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0.45, 0, 0.15, 0),
							BackgroundColor3 = Color3.fromRGB(0, 230, 0),
							BackgroundTransparency = 0,
							onClick = function()
								-- fire signal, unlock zone in server

								zoneSlice.actions.setConfirmMenuOpen(false)
							end,
							Children = {
								e("UICorner", {
									CornerRadius = UDim.new(0.1, 0),
								}),
								e("UIStroke", {
									Color = Color3.fromRGB(0, 0, 0),
									Thickness = 10,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								}),
								e(TextLabel, {
									Text = "Unlock",
									Font = Enum.Font.FredokaOne,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5),
									Size = UDim2.new(0.9, 0, 0.9, 0),
									TextScaled = true,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Center,
									TextYAlignment = Enum.TextYAlignment.Center,
									ZIndex = 10,
									Children = {},
									TextColor3 = Color3.fromRGB(255, 255, 255),
									Stroke = {
										Thickness = 10,
										Color = Color3.fromRGB(0, 0, 0),
									},
								}),
							},
						} :: Button.ButtonProps
					),

					e(
						Button,
						{
							hoverScale = 1.05,
							Position = UDim2.new(0.745, 0, 0.825, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0.45, 0, 0.15, 0),
							BackgroundColor3 = Color3.fromRGB(230, 0, 0),
							BackgroundTransparency = 0,
							onClick = function()
								zoneSlice.actions.setConfirmMenuOpen(false)
							end,
							Children = {
								e("UICorner", {
									CornerRadius = UDim.new(0.1, 0),
								}),
								e("UIStroke", {
									Color = Color3.fromRGB(0, 0, 0),
									Thickness = 10,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								}),
								e(TextLabel, {
									Text = "Cancel",
									Font = Enum.Font.FredokaOne,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5),
									Size = UDim2.new(0.9, 0, 0.9, 0),
									TextScaled = true,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Center,
									TextYAlignment = Enum.TextYAlignment.Center,
									ZIndex = 10,
									Children = {},
									TextColor3 = Color3.fromRGB(255, 255, 255),
									Stroke = {
										Thickness = 10,
										Color = Color3.fromRGB(0, 0, 0),
									},
								}),
							},
						} :: Button.ButtonProps
					),
				},
			} :: MenuScreen.MenuScreenProps
		),
	})
end

return ConfirmZoneUnlock
