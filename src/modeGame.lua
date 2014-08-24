
modeGame = {}
modeGame.load = function()

	love.physics.setMeter(64)
	world = newWorld()
	physWorld = world.physics;
	cellularAutomata(world.grid,8)
	addPhysicsToWorld(world,world.grid)

	setupPlayers()

	-- TMPENEMY = newEnemy(500, 300, 1)
	-- TMPENEMY.target = player1

	--initial graphics setup
	love.graphics.setBackgroundColor(128, 128, 128) --set the background color to a nice blue

	camera = newCamera()
end

--------------------------------------------------------------------------------

modeGame.update = function(dt)
--	updateCamera(camera,player1.body:getX(),player1.body:getY(),player2.body:getX(),player2.body:getY())
	for _,i in pairs(world.bodies) do if i.saveOld then i.saveOld() end end
	updateCamera(camera)
	physWorld:update(dt) --this puts the world into motion
	for _,i in pairs(world.bodies) do if i.update then i.update() end end

	--queue things with zero health for destruction
	for _, j in pairs(world.bodies) do
		if j.health and j.health <= 0 then
			if j.die then j.die()else
				j.destroyed = true
				world.deletequeue[j] = j
			end
		end
	end
	--cleanup deleted objects
	for _,j in pairs(world.deletequeue) do
		if not j.destroyed then
			j.body:destroy()
			world.bodies[j] = nil
			if world.enemies[j] then world.enemies[j] = nil end
		end
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
	love.graphics.print(player1.health, 100, 100)
end
