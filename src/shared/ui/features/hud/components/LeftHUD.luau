local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local CoinLabel = require(ReplicatedStorage.Shared.ui.features.hud.components.CoinLabel)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)
local e: typeof(React.createElement) = React.createElement

local function LeftHud()
	local shown = ReactCharm.useAtom(hudSlice.states.shown)
	return e(
		SlideOutFrame,
		{
			Shown = shown,
			AnchorPoint = Vector2.new(0, 0.5),
			From = UDim2.new(0, 30, 0.5, 0),
			To = UDim2.new(-0.2, 0, 0.5, 0),
			Size = UDim2.new(0, 500, 0, 750),
			BackgroundTransparency = 1,
			Speed = 8,
			children = {
				e(CoinLabel),
			},
		} :: SlideOutFrame.SlideOutProps
	)
end

return LeftHud
