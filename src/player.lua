
-- player
isTwoPlayers = false -- until proven otherwise
player1      = nil
player2      = nil



function setupPlayers(numPlayers)
	if numPlayers == 2 then isTwoPlayers = true else isTwoPlayers = false end
	player1 = newPlayer(256, 356, 0, 32, nil, 100)
	if isTwoPlayers then player2 = newPlayer(256, 512, 0, 32, nil, 100) else player2 = nil end

end