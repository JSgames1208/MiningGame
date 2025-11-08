local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local HealthBar = require(ReplicatedStorage.Shared.ui.features.mining.components.HealthBar)
local MiningBottomBar = require(ReplicatedStorage.Shared.ui.features.mining.components.MiningBottomBar)
local TurningCircle = require(ReplicatedStorage.Shared.ui.features.mining.components.TurningCircle)

local e = React.createElement

return function()
	return e(React.Fragment, nil, {
		HealthBar = e(HealthBar),
		MiningBottomBar = e(MiningBottomBar),
		TurningCircle = ReactRoblox.createPortal({ e(TurningCircle) }, workspace.TurningCirclePart),
	})
end
