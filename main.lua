
--[[========================================================================----
                     __ ________   __   _________________   __
                    / //_/  _/ /  / /  / __/_  __/ __/ _ | / /
                   / ,< _/ // /__/ /___\ \  / / / _// __ |/ /__
                  /_/|_/___/____/____/___/ /_/ /___/_/ |_/____/

----========================================================================]]--

require 'src/test'
require 'src/entities'


function love.load()
	love.physics.setMeter(64)
  physWorld = love.physics.newWorld(0, 0, true)

  player = newEntity(200, 200, 32, 0, nil)

 --initial graphics setup
  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue

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
end

--------------------------------------------------------------------------------

function love.draw()
	love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
	  love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  love.graphics.circle("fill", player.body:getX(), player.body:getY(), player.shape:getRadius())

end

--------------------------------------------------------------------------------

function love.keyreleased(key, unicode) if key == 'escape' then love.event.push('quit') end end
