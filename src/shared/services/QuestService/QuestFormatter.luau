local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registries = require(ReplicatedStorage.Shared.modules.core.registries.Registries)
return function(type: string, target: any, amount: number)
	if type == "mine" then
		return "Mine " .. amount .. " " .. target
	elseif type == "collect" then
		return "Collect " .. amount .. " " .. target
	elseif type == "currency" then
		return "Collect " .. amount .. " " .. target
	elseif type == "talkTo" then
		local npcId = target :: string
		local npcEntry = Registries.NPC:get(npcId)
		if not npcEntry or not npcEntry.name then
			return "Talk to " .. target
		end

		return "Talk to " .. npcEntry.name
	else
		return type .. " " .. target .. (amount and " " .. amount or "")
	end
end
