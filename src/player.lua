
-- player
isTwoPlayers = false --until proven otherwise
player1      = nil
player2      = nil

function playerAI(player)


end


function newPlayer(x, y, id)
	local player = newEntity(x, y, 32, 0, id, 100, playerAI)
	player.swarm = {}
	player.weapon = {}
	player.upgrades = {}
	player.draw = function()
		love.graphics.push()
		love.graphics.translate(player.body:getX(),player.body:getY())
		love.graphics.rotate(player.body:getAngle())
		love.graphics.setColor(255,0,0,255);
		love.graphics.drawq(moth,mothQuad,32,-32,math.pi/2)
		love.graphics.pop()
	end
	return player
end


function setupPlayers(numPlayers)
	if numPlayers == 2 then isTwoPlayers = true else isTwoPlayers = false end
	player1 = newPlayer(256, 256, 1)
	if isTwoPlayers then player2 = newPlayer(256, 512, 2) else player2 = nil end

end