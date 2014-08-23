
--[[========================================================================----
                     __ ________   __   _________________   __
                    / //_/  _/ /  / /  / __/_  __/ __/ _ | / /
                   / ,< _/ // /__/ /___\ \  / / / _// __ |/ /__
                  /_/|_/___/____/____/___/ /_/ /___/_/ |_/____/

----========================================================================]]--

require 'src/test'
require 'src/minion'
require 'src/utils'
require 'src/world'
require 'src/entity'


function love.load()
	love.joystick.open(1)
	love.joystick.open(2)

	love.physics.setMeter(64)
  physWorld = love.physics.newWorld(0, 0, true)
  physWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)

	player1 = newEntity(200, 200, 32, 0, nil)
	player2 = newEntity(400, 200, 32, 0, nil)


 --initial graphics setup
  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  minions = {}
  for i=1, 30 do
  	minions[i] = newMinion(i*13+100, 100, 1, 1)
  end

	text       = ""   -- we'll use this to put info text on the screen later
	persisting = 0    -- we'll use this to store the state of repeated callback calls

	--initial graphics setup
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue

	moth = love.graphics.newImage("res/player/003.png")
	mothQuad = love.graphics.newQuad(0,0,moth:getWidth(),moth:getHeight(),moth:getWidth(),moth:getHeight())

end

--------------------------------------------------------------------------------

function love.update(dt)
	physWorld:update(dt) --this puts the world into motion

--	for i=1,love.joystick.getNumButtons(1) do
--		print(i,love.joystick.isDown(1,i))
--	end

	if(love.joystick.isOpen(1))then lJoyX1,lJoyY1,lTrig1,rJoyX1,rJoyY1,rTrig1 = love.joystick.getAxes(1)end
	if(love.joystick.isOpen(2))then lJoyX2,lJoyY2,lTrig2,rJoyX2,rJoyY2,rTrig2 = love.joystick.getAxes(2)end
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
		love.graphics.drawq(moth,mothQuad,64,-64,math.pi/2)
	love.graphics.pop()

	love.graphics.push()
		love.graphics.translate(player2.body:getX(),player2.body:getY())
		love.graphics.rotate(player2.body:getAngle())
		love.graphics.setColor(255,0,0,255);
		love.graphics.drawq(moth,mothQuad,64,-64,math.pi/2)
	love.graphics.pop()

	for i=1, 30 do
  	love.graphics.setColor(100, 10, 10)
  	love.graphics.circle("fill", minions[i].body:getX(), minions[i].body:getY(), minions[i].shape:getRadius())
  end
love.graphics.print(text, 10, 10)
end

function beginContact(a, b, coll)
    x,y = coll:getNormal()
    print(a:getUserData().type)
    print(b:getUserData().type)
    if a:getUserData().type and b:getUserData().type then
	    text = text.."\n"..a:getUserData().type.." colliding with "..b:getUserData().type.." with a vector normal of: "..x..", "..y
	  end
end

function endContact(a, b, coll)
    persisting = 0
    if a:getUserData().type and b:getUserData().type then
	    text = text.."\n"..a:getUserData().type.." uncolliding with "..b:getUserData().type
	  end
end

function preSolve(a, b, coll)
    if persisting == 0 then    -- only say when they first start touching

			if a:getUserData().type and b:getUserData().type then
		   	text = text.."\n"..a:getUserData().type.." touching "..b:getUserData().type
		 	end
    elseif persisting < 20 then    -- then just start counting
        text = text.." "..persisting
    end
    persisting = persisting + 1    -- keep track of how many updates they've been touching for
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end



--------------------------------------------------------------------------------

function love.keyreleased(key, unicode) if key == 'escape' then love.event.push('quit') end end
