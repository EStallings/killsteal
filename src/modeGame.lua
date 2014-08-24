
modeGame = {}
modeGame.load = function()

	love.physics.setMeter(64)
	world = newWorld()
	physWorld = world.physics;
	cellularAutomata(world.grid,8)
	addPhysicsToWorld(world,world.grid)

	setupPlayers(2)

	--initial graphics setup
	player1minions = {}
	for i=1, 30 do
		player1minions[i] = newMinion(i*13+256, 356, 0, 1, player1.body)
	end
	-- TMPENEMY = newEnemy(500, 300, 1)
	-- TMPENEMY.target = player1

	--initial graphics setup
	love.graphics.setBackgroundColor(100, 36, 78) --set the background color to a nice blue

	moth = love.graphics.newImage("res/player/003.png")
	mothQuad = love.graphics.newQuad(0,0,moth:getWidth()/2,moth:getHeight()/2,moth:getWidth()/2,moth:getHeight()/2)

	ant = love.graphics.newImage("res/player/100.png")
	antQuad = love.graphics.newQuad(0,0,ant:getWidth()/2,ant:getHeight()/2,ant:getWidth()/2,ant:getHeight()/2)

	camera = newCamera()
end

--------------------------------------------------------------------------------

modeGame.update = function(dt)
	updateCamera(camera)
	physWorld:update(dt) --this puts the world into motion
	for _,i in pairs(world.bodies) do if i.update then i.update() end end
	--temporary stop-the-crash fix
	-- if love.joystick.getNumJoysticks() ~= 2 then return end

	-- if(love.joystick.isOpen(1))then lJoyX1,lJoyY1,lTrig1,rJoyX1,rJoyY1,rTrig1 = love.joystick.getAxes(1)end
	-- if(love.joystick.isOpen(2))then lJoyX2,lJoyY2,lTrig2,rJoyX2,rJoyY2,rTrig2 = love.joystick.getAxes(2)end
	-- if(lJoyX1*lJoyX1+lJoyY1*lJoyY1<0.01)then lJoyX1 = 0;lJoyY1 = 0 end
	-- if(lJoyX2*lJoyX2+lJoyY2*lJoyY2<0.01)then lJoyX2 = 0;lJoyY2 = 0 end
	-- local speed = 10
	-- player1.body:applyLinearImpulse(lJoyX1*speed,lJoyY1*speed)
	-- player2.body:applyLinearImpulse(lJoyX2*speed,lJoyY2*speed)
	-- if(rJoyX1*rJoyX1+rJoyY1*rJoyY1>0.1)then player1.body:setAngle(math.atan2(rJoyY1,rJoyX1))end
	-- if(rJoyX2*rJoyX2+rJoyY2*rJoyY2>0.1)then player2.body:setAngle(math.atan2(rJoyY2,rJoyX2))end

	--queue things with zero health for destruction
	for _, j in pairs(world.bodies) do
		if j.health and j.health <= 0 then
			j.die()
		end
	end
	--cleanup deleted objects
	for _,j in pairs(world.deletequeue) do
		j.body:destroy()
		world.bodies[j] = nil
	end
	world.deletequeue = {}

end

--------------------------------------------------------------------------------

modeGame.draw = function()
	love.graphics.push()
		renderCamera(camera)
		renderWorld(world.grid)
		for _, j in pairs(world.bodies) do
			j.render()
		end

	love.graphics.pop()
end
