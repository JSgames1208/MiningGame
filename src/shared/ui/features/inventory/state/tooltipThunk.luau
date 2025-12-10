local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Packages.DataService).client

local actions = {
	getToolInstance = function(guid: string)
		return DataService:get({ "inventory", "tool", guid })
	end,
}

return {
	actions = actions,
}
