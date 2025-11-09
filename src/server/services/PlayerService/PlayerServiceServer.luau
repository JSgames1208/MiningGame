--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)

local PlayerServiceServer = {}

function PlayerServiceServer.init(self: PlayerServiceServer)
	self.networker = Networker.server.new("PlayerService", self, {})
end

function PlayerServiceServer.addCurrency(self: PlayerServiceServer, player: Player, amount: number)
	self.networker:fire(player, "updateCurrency", amount)
end

function PlayerServiceServer.onPlayerAdded(self: PlayerServiceServer, player: Player)
	local tool = ReplicatedStorage:WaitForChild("Pickaxe"):Clone()

	local character = player.Character or player.CharacterAdded:Wait()

	local humanoid: Humanoid = character:WaitForChild("Humanoid") :: Humanoid
	humanoid:EquipTool(tool)
end

type PlayerServiceServer = typeof(PlayerServiceServer) & {
	networker: Networker.Server,
}

return PlayerServiceServer :: PlayerServiceServer
