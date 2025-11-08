local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)

local part = workspace:WaitForChild("TurningCirclePart")

local function TurningCircle()
	local shown = ReactCharm.useAtom(miningSlice.states.mining)

	local rotation, setRotation = React.useState(0)
	React.useEffect(function()
		local connection = RunService.RenderStepped:Connect(function(dt)
			setRotation((rotation + dt * 50) % 360)
		end)

		return function()
			connection:Disconnect()
		end
	end, { rotation })

	return React.createElement("SurfaceGui", {
		Adornee = part,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		Face = Enum.NormalId.Top,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = 50,
	}, {
		React.createElement("ImageLabel", {
			Visible = shown,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=16576540930",
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 0.3,
			Rotation = rotation,
		}),
	})
end

return TurningCircle
