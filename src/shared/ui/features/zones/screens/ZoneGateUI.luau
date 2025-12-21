local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local Sift = require(ReplicatedStorage.Packages.Sift)
local GateFrame = require(ReplicatedStorage.Shared.ui.features.zones.components.GateFrame)
local zoneSlice = require(ReplicatedStorage.Shared.ui.features.zones.state.zoneSlice)

local e: typeof(React.createElement) = React.createElement

return function()
	local lockedIds = ReactCharm.useAtom(zoneSlice.states.lockedZoneIds)

	local children = {}

	local gatesFolder = workspace:FindFirstChild("ZoneGates")
	if not gatesFolder then
		return nil
	end

	for _, gate in ipairs(gatesFolder:GetChildren()) do
		local id = gate:GetAttribute("unlocks")
		if id and Sift.Array.contains(lockedIds, id) then
			local zone = zoneSlice.actions.getZoneById(id)()

			children[gate] = ReactRoblox.createPortal(
				e("SurfaceGui", {
					Adornee = gate,
					ZIndexBehavior = Enum.ZIndexBehavior.Global,
					LightInfluence = 0,
					Face = Enum.NormalId.Front,
					PixelsPerStud = 15,
					SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
				}, {
					Gate = e(GateFrame, {
						name = zone.name,
						cost = zone.cost,
					}),
				}),
				gate
			)
		end
	end

	return e(React.Fragment, nil, children)
end
