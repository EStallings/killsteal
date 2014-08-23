
-- player
isTwoPlayers = false -- until proven otherwise
player1      = nil
player2      = nil

function playerAI(player)

end

function newPlayer(x, y, id)
	local player = newEntity(x, y, 32, 0, id, 100, playerAI)
	player.swarm = {}
	player.weapon = {}
	player.upgrades = {}

	return player
end

function setupPlayers(numPlayers)
	if numPlayers == 2 then isTwoPlayers = true else isTwoPlayers = false end
	player1 = newPlayer(100, 100, 1)
	if isTwoPlayers then player2 = newPlayer(200, 200, 2) else player2 = nil end

end
