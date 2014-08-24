
-- player
isTwoPlayers = false -- until proven otherwise
player1      = nil
player2      = nil

-- function playerAI(player)

-- 	if not player.alive then

-- 		if player.respawnTime == 0 then
-- 			player.alive = true
-- 			player.health = player.maxHealth
-- 			return
-- 		end
-- 		player.respawnTime = player.respawnTime - 1
-- 	end
-- end

-- function newPlayer(x, y, id)
-- 	local player = newEntity(x, y, 32, 0, id, 100, playerAI)
-- 	player.swarm = {}
-- 	player.weapon = {}
-- 	player.upgrades = {}
-- 	player.respawnTime = 0
-- 	player.alive = true
-- 	player.score = 0
-- 	player.draw = function()
-- 		if not player.alive then return end
-- 		love.graphics.push()
-- 		love.graphics.translate(player.body:getX(),player.body:getY())
-- 		love.graphics.rotate(player.body:getAngle())
-- 		love.graphics.setColor(255,0,0,255);
-- 		love.graphics.drawq(moth,mothQuad,32,-32,math.pi/2)
-- 		love.graphics.pop()
-- 	end

-- 	player.die = function()
-- 		if not player.alive then return end
-- 		player.alive = false
-- 		player.respawnTime = 1000 --todo make this climb with difficulty?
-- 	end
-- 	return player
-- end

function setupPlayers(numPlayers)
	if numPlayers == 2 then isTwoPlayers = true else isTwoPlayers = false end
	player1 = newPlayer(256, 256, 0, 32, nil, 100)
	if isTwoPlayers then player2 = newPlayer(256, 512, 0, 32, nil, 100) else player2 = nil end

end
