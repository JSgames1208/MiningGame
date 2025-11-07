local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)

-- A lightweight, smooth spring-like interpolator
local function useSpring(initialGoal: number | UDim2, config: { speed: number }?)
	local speed = (config and config.speed) or 12.5
	local value, setValue = React.useState(initialGoal)
	local goal, setGoal = React.useState(initialGoal)

	local callbacksRef = React.useRef({}) -- store onComplete callbacks
	local completedRef = React.useRef(false)

	-- Heartbeat spring update
	React.useEffect(function()
		local connection
		connection = RunService.Heartbeat:Connect(function(dt)
			local newValue = value
			local done = false

			if typeof(value) == "number" and typeof(goal) == "number" then
				if math.abs(value - goal) < 0.001 then
					newValue = goal
					done = true
				else
					local factor = math.clamp(dt * speed, 0, 1)
					newValue = value + (goal - value) * factor
				end
			elseif typeof(value) == "UDim2" and typeof(goal) == "UDim2" then
				local dxScale = goal.X.Scale - value.X.Scale
				local dyScale = goal.Y.Scale - value.Y.Scale
				local dxOffset = goal.X.Offset - value.X.Offset
				local dyOffset = goal.Y.Offset - value.Y.Offset

				local factor = math.clamp(dt * speed, 0, 1)
				local newXScale = value.X.Scale + dxScale * factor
				local newYScale = value.Y.Scale + dyScale * factor
				local newXOffset = value.X.Offset + dxOffset * factor
				local newYOffset = value.Y.Offset + dyOffset * factor

				newValue = UDim2.new(newXScale, newXOffset, newYScale, newYOffset)

				done = math.abs(dxScale) < 0.001
					and math.abs(dyScale) < 0.001
					and math.abs(dxOffset) < 0.5
					and math.abs(dyOffset) < 0.5
			else
				-- fallback: different types, snap
				newValue = goal
				done = true
			end

			setValue(newValue)

			-- handle callbacks
			if done and not completedRef.current then
				completedRef.current = true
				for _, fn in ipairs(callbacksRef.current) do
					fn()
				end
				callbacksRef.current = {} -- clear after firing
			elseif not done then
				completedRef.current = false
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { goal, speed, value })

	-- onComplete registration
	local function onComplete(fn)
		table.insert(callbacksRef.current, fn)
	end

	-- snap immediately to goal
	local function snap()
		setValue(goal)
		completedRef.current = true
		for _, fn in ipairs(callbacksRef.current) do
			fn()
		end
		callbacksRef.current = {}
	end

	return {
		binding = value,
		setGoal = setGoal,
		onComplete = onComplete,
		snap = snap,
	}
end

return useSpring
