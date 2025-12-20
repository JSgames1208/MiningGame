return function(type: string, target: any, amount: number)
	if type == "mine" then
		return "Mine " .. amount .. " " .. target
	elseif type == "collect" then
		return "Collect " .. amount .. " " .. target
	elseif type == "currency" then
		return "Collect " .. amount .. " " .. target
	else
		return type .. " " .. target .. (amount and " " .. amount or "")
	end
end
