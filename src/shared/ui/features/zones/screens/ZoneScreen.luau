local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ConfirmZoneUnlock = require(ReplicatedStorage.Shared.ui.features.zones.components.ConfirmZoneUnlock)
local e: typeof(React.createElement) = React.createElement

return function()
	return e(React.Fragment, nil, {
		e(ConfirmZoneUnlock),
	})
end
