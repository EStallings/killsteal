
--[[========================================================================----
                     __ ________   __   _________________   __
                    / //_/  _/ /  / /  / __/_  __/ __/ _ | / /
                   / ,< _/ // /__/ /___\ \  / / / _// __ |/ /__
                  /_/|_/___/____/____/___/ /_/ /___/_/ |_/____/

----========================================================================]]--

require 'src/test'
require 'src/entity'


function love.load()
	love.joystick.open(1)
	love.joystick.open(2)

	love.physics.setMeter(64)
	physWorld = love.physics.newWorld(0, 0, true)

	player1 = newEntity(200, 200, 32, 0, nil)
	player2 = newEntity(400, 200, 32, 0, nil)

	--initial graphics setup
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
end

--------------------------------------------------------------------------------

function love.update(dt)
	physWorld:update(dt) --this puts the world into motion

	lJoyX1,lJoyY1,lTrig1,rJoyX1,rJoyY1,rTrig1 = love.joystick.getAxes(1)
	lJoyX2,lJoyY2,lTrig2,rJoyX2,rJoyY2,rTrig2 = love.joystick.getAxes(2)
	if(lJoyX1*lJoyX1+lJoyY1*lJoyY1<0.01)then lJoyX1 = 0;lJoyY1 = 0 end
	if(lJoyX2*lJoyX2+lJoyY2*lJoyY2<0.01)then lJoyX2 = 0;lJoyY2 = 0 end
	local speed = 30
	player1.body:applyLinearImpulse(lJoyX1*speed,lJoyY1*speed)
	player2.body:applyLinearImpulse(lJoyX2*speed,lJoyY2*speed)
	if(rJoyX1*rJoyX1+rJoyY1*rJoyY1>0.1)then player1.body:setAngle(math.atan2(rJoyY1,rJoyX1))end
	if(rJoyX2*rJoyX2+rJoyY2*rJoyY2>0.1)then player2.body:setAngle(math.atan2(rJoyY2,rJoyX2))end
end

--------------------------------------------------------------------------------

function love.draw()
	love.graphics.push()
		love.graphics.translate(player1.body:getX(),player1.body:getY())
		love.graphics.rotate(player1.body:getAngle())
		love.graphics.setColor(255,0,0,255);
		love.graphics.rectangle("fill",-32,-32,64,64)
		love.graphics.setColor(255,255,255,255);
		love.graphics.rectangle("fill",0,-8,128*(rTrig1+1),16)
		love.graphics.rectangle("fill",-8,-64*(lTrig1+1),16,128*(lTrig1+1))
	love.graphics.pop()

	love.graphics.push()
		love.graphics.translate(player2.body:getX(),player2.body:getY())
		love.graphics.rotate(player2.body:getAngle())
		love.graphics.setColor(255,0,0,255);
		love.graphics.rectangle("fill",-32,-32,64,64)
		love.graphics.setColor(255,255,255,255);
		love.graphics.rectangle("fill",0,-8,128*(rTrig2+1),16)
		love.graphics.rectangle("fill",-8,-64*(lTrig2+1),16,128*(lTrig2+1))
	love.graphics.pop()
end

--------------------------------------------------------------------------------

function love.keyreleased(key, unicode) if key == 'escape' then love.event.push('quit') end end
