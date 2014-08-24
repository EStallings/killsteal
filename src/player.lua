
-- player
isTwoPlayers = false -- until proven otherwise
player1      = nil
player2      = nil

function newPlayer(x, y, angle, radius, sprite, health, controller, team)
	local player = newEntity(x,y,angle,sprite,health)
	player.body:setFixedRotation(true)
	player.team = team
	player.fireTimeout = 0
	player.damage = 10
	player.body:setMass(1000000)
	attachSpriteToEntity(player,256,moth)
	attachCircleFixture(player,radius,4,7,false,function()
		local speed = 10
		player.body:applyLinearImpulse(controller.lJoyX*speed,controller.lJoyY*speed)
		if(controller.rJoyX*controller.rJoyX+controller.rJoyY*controller.rJoyY>0.1)then
			player.body:setAngle(-math.atan2(controller.rJoyY,controller.rJoyX) + math.pi/2)
		end
		if controller.start then
			changeMode(modePaused)
		end
		if controller.rBtn and player.fireTimeout <= 0 then
			newBullet(player.body:getX()+20*math.cos(player.body:getAngle()), player.body:getY()+20*math.sin(player.body:getAngle()), player.body:getAngle(), 5000, player.damage, player.team)
			player.fireTimeout = 50
		end
		player.fireTimeout = player.fireTimeout - 1

	end)
	for i=1, 30 do
		--local minion = newMinion(i*13+256, 356, 0, 1, player.body)
		--attachSpriteToEntity(minion,32,sss[math.random(1,8)])
	end
	return player
end

function setupPlayers()
	if numJoysticks == 2 then isTwoPlayers = true else isTwoPlayers = false end
	player1 = newPlayer(256, 356, 0, 25, nil, 100, joysticks[1], 1)
	if isTwoPlayers then player2 = newPlayer(256, 512, 0, 25, nil, 100, joysticks[2], 2) else player2 = nil end

end
