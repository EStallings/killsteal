
-- player
isTwoPlayers = false -- until proven otherwise
player1      = nil
player2      = nil



function setupPlayers()
	if numJoysticks == 2 then isTwoPlayers = true else isTwoPlayers = false end
	player1 = newPlayer(256, 356, 0, 32, nil, 100, joysticks[1])
	if isTwoPlayers then player2 = newPlayer(256, 512, 0, 32, nil, 100, joysticks[2]) else player2 = nil end

end