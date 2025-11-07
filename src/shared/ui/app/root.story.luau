local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RootUI = require(ReplicatedStorage.Shared.ui.app.RootUI)
local e = React.createElement

return function(parent: Instance)
	local root = ReactRoblox.createRoot(parent)
	root:render(e(RootUI))

	return function()
		root:unmount()
	end
end
