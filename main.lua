
--[[========================================================================----
                     __ ________   __   _________________   __
                    / //_/  _/ /  / /  / __/_  __/ __/ _ | / /
                   / ,< _/ // /__/ /___\ \  / / / _// __ |/ /__
                  /_/|_/___/____/____/___/ /_/ /___/_/ |_/____/

----========================================================================]]--

require 'src/test'
require 'src/entities'
require 'src/minion'
require 'src/utils'
require 'src/world'


function love.load()
	love.physics.setMeter(64)
  physWorld = love.physics.newWorld(0, 0, true)
  physWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)

  player = newEntity(200, 200, 32, 0, nil)

 --initial graphics setup
  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  minions = {}
  for i=1, 30 do
  	minions[i] = newMinion(i*13+100, 100, 1, 1)
  end

	text       = ""   -- we'll use this to put info text on the screen later
	persisting = 0    -- we'll use this to store the state of repeated callback calls
end

--------------------------------------------------------------------------------

function love.update(dt)
 physWorld:update(dt) --this puts the world into motion

  --here we are going to create some keyboard events
  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    player.body:applyForce(400, 0)
  elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    player.body:applyForce(-400, 0)
  elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
    player.body:applyForce(0, -400)
  elseif love.keyboard.isDown("down") then
  	player.body:applyForce(0, 400)
  end

  for i=1, 30 do
  	minions[i].ai(minions[i])
  end
	if string.len(text) > 768 then    -- cleanup when 'text' gets too long
		text = ""
	end

end

--------------------------------------------------------------------------------

function love.draw()
	love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  love.graphics.circle("fill", player.body:getX(), player.body:getY(), player.shape:getRadius())
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
