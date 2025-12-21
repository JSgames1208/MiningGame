--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)

local ZoneServiceServer = {}

function ZoneServiceServer.init(self: ZoneServiceServer)
	self.networker = Networker.server.new("ZoneService", self)
end

export type ZoneServiceServer = typeof(ZoneServiceServer) & {
	networker: Networker.Server,
}

return ZoneServiceServer :: ZoneServiceServer
