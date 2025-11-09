--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MinableGenerator = require(ServerScriptService.Server.services.MiningService.util.MinableGenerator)
local MinableRegistry = require(ServerScriptService.Server.services.MiningService.util.MinableRegistry)
local MiningFXServer = require(ServerScriptService.Server.services.MiningService.util.MiningFXServer)
local PlayerServiceServer = require(ServerScriptService.Server.services.PlayerService.PlayerServiceServer)
local Networker = require(ReplicatedStorage.Packages.Networker)

MiningFXServer:init()
MinableGenerator:init()

local MiningServiceServer = {}

local lastMined: { [number]: number } = {}

function MiningServiceServer.init(self: MiningServiceServer)
	self.networker = Networker.server.new("MiningService", self, {
		self.attemptMine :: any,
		self.startMining :: any,
	})
end

function MiningServiceServer.startMining(self: MiningServiceServer, player: Player, target: BasePart)
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp: BasePart = character:WaitForChild("HumanoidRootPart") :: BasePart
	if (hrp.Position - target.Position).Magnitude > 40 then
		return
	end

	local minableData = MinableRegistry.getMinableData(target)

	if not minableData then
		return
	end

	self.networker:fire(player, "startMining", target, minableData)
end

function MiningServiceServer.attemptMine(self: MiningServiceServer, player: Player, target: BasePart)
	if not lastMined[player.UserId] or lastMined[player.UserId] + 1 < tick() then
		lastMined[player.UserId] = tick()

		local minableData = MinableRegistry.getMinableData(target)

		if not minableData then
			return
		end

		minableData.health -= 25

		self.networker:fire(player, "mine", target, minableData.health)

		if minableData.health <= 0 then
			MinableRegistry.removeMinable(target)

			task.delay(0.75, function()
				self.networker:fire(player, "stopMining")
				target:Destroy()

				PlayerServiceServer:addCurrency(player, 100)
			end)
		end
	end
end

type MiningServiceServer = typeof(MiningServiceServer) & {
	networker: Networker.Server,
}

return MiningServiceServer :: MiningServiceServer
