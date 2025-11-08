local ServerScriptService = game:GetService("ServerScriptService")
local MiningServiceServer = require(ServerScriptService.Server.services.MiningService.MiningServiceServer)
local PlayerServiceServer = require(ServerScriptService.Server.services.PlayerService.PlayerServiceServer)

MiningServiceServer:init()
PlayerServiceServer:init()
