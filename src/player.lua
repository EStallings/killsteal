
-- player
isTwoPlayers = false -- until proven otherwise
player1      = nil
player2      = nil

function newPlayer(x, y, angle, radius, sprite, health)
	local player = newEntity(x,y,angle,sprite,health)
	attachCircleFixture(player,radius,4,7,false,function() end)
	for i=1, 10 do
		local minion = newMinion(i*13+256, 356, 0, 1, player.body)
		attachSpriteToEntity(minion,32,sss[math.random(1,8)])
	end
	return player
end

function setupPlayers(numPlayers)
	if numPlayers == 2 then isTwoPlayers = true else isTwoPlayers = false end
	player1 = newPlayer(256, 356, 0, 32, nil, 100)
	if isTwoPlayers then player2 = newPlayer(256, 512, 0, 32, nil, 100) else player2 = nil end
end
