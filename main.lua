
--[[========================================================================----
                     __ ________   __   _________________   __
                    / //_/  _/ /  / /  / __/_  __/ __/ _ | / /
                   / ,< _/ // /__/ /___\ \  / / / _// __ |/ /__
                  /_/|_/___/____/____/___/ /_/ /___/_/ |_/____/

----========================================================================]]--

require 'src/minion'
require 'src/utils'
require 'src/world'
require 'src/entity'
require 'src/camera'
require 'src/enemy'

function love.load()
	love.joystick.open(1)
	love.joystick.open(2)

	love.physics.setMeter(64)
	world = newWorld()
	physWorld = world.physics;


	player1 = newEntity(256, 256, 32, 0, nil)
	player2 = newEntity(256, 512, 32, 0, nil)

	--initial graphics setup
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
	minions = {}
	for i=1, 30 do
		minions[i] = newMinion(i*13+100, 100, 1, 1)
	end
	TMPENEMY = newEnemy(500, 300, 1)
	TMPENEMY.target = player1

	--initial graphics setup
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue

	moth = love.graphics.newImage("res/player/003.png")
	mothQuad = love.graphics.newQuad(0,0,moth:getWidth()/2,moth:getHeight()/2,moth:getWidth()/2,moth:getHeight()/2)

	ant = love.graphics.newImage("res/player/100.png")
	antQuad = love.graphics.newQuad(0,0,ant:getWidth()/2,ant:getHeight()/2,ant:getWidth()/2,ant:getHeight()/2)

	camera = newCamera()
end

--------------------------------------------------------------------------------

function love.update(dt)
	updateCamera(camera,player1.body:getX(),player1.body:getY(),player2.body:getX(),player2.body:getY())
	physWorld:update(dt) --this puts the world into motion
	for _, j in pairs(world.entities) do
		if j.ai then j.ai(j) end
	end
	--temporary stop-the-crash fix
	if love.joystick.getNumJoysticks() ~= 2 then return end

	if(love.joystick.isOpen(1))then lJoyX1,lJoyY1,lTrig1,rJoyX1,rJoyY1,rTrig1 = love.joystick.getAxes(1)end
	if(love.joystick.isOpen(2))then lJoyX2,lJoyY2,lTrig2,rJoyX2,rJoyY2,rTrig2 = love.joystick.getAxes(2)end
	if(lJoyX1*lJoyX1+lJoyY1*lJoyY1<0.01)then lJoyX1 = 0;lJoyY1 = 0 end
	if(lJoyX2*lJoyX2+lJoyY2*lJoyY2<0.01)then lJoyX2 = 0;lJoyY2 = 0 end
	local speed = 10
	player1.body:applyLinearImpulse(lJoyX1*speed,lJoyY1*speed)
	player2.body:applyLinearImpulse(lJoyX2*speed,lJoyY2*speed)
	if(rJoyX1*rJoyX1+rJoyY1*rJoyY1>0.1)then player1.body:setAngle(math.atan2(rJoyY1,rJoyX1))end
	if(rJoyX2*rJoyX2+rJoyY2*rJoyY2>0.1)then player2.body:setAngle(math.atan2(rJoyY2,rJoyX2))end

end

--------------------------------------------------------------------------------

function love.draw()
	love.graphics.push()
		renderCamera(camera)


	renderWorld(world.grid)
	for _, j in pairs(world.entities) do
		j.draw()
	end

		love.graphics.push()
			love.graphics.translate(player1.body:getX(),player1.body:getY())
			love.graphics.rotate(player1.body:getAngle())
			love.graphics.setColor(255,0,0,255);
			love.graphics.drawq(moth,mothQuad,32,-32,math.pi/2)
		love.graphics.pop()

		love.graphics.push()
			love.graphics.translate(player2.body:getX(),player2.body:getY())
			love.graphics.rotate(player2.body:getAngle())
			love.graphics.setColor(255,0,0,255);
			love.graphics.drawq(ant,antQuad,32,-32,math.pi/2)
		love.graphics.pop()
	love.graphics.pop()
end

function beginContact(a, b, coll)
	x,y = coll:getNormal()
	local au = a:getUserData()
	local bu = a:getUserData()
	if au.value.contacts and bu.value.contacts then
		if bu.type ~= "" then
			au.value.contacts[bu.value.id] = bu
		end
		if au.type ~= "" then
			bu.value.contacts[au.value.id] = au
		end
	end
end

function endContact(a, b, coll)
	local au = a:getUserData()
	local bu = a:getUserData()
	if au.value.contacts and bu.value.contacts then
		au.value.contacts[bu.value.id] = nil
		bu.value.contacts[au.value.id] = nil
	end
end

function preSolve(a, b, coll)
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

--------------------------------------------------------------------------------

function love.keyreleased(key, unicode) if key == 'escape' then love.event.push('quit') end end
