
function newController(id)

	local controller = {}

	controller.lJoyX = 0
	controller.lJoyY = 0
	controller.lTrig = 0
	controller.lBtn  = false
	controller.rJoyX = 0
	controller.rJoyY = 0
	controller.rTrig = 0
	controller.rBtn  = false
	controller.x     = false
	controller.y     = false
	controller.a     = false
	controller.b     = false
	controller.back  = false
	controller.start = false

	return controller
end

function initControls()
--	for i=1,love.joystick.getNumButtons(1) do
--		print(i,love.joystick.isDown(1,i))
--	end
	numJoysticks = love.joystick.getNumJoysticks()
	joysticks = {}
	for i=1,numJoysticks do
		table.insert(joysticks,newController(i))
	end
end

function updateControls()
	if(joysticks[1])then joysticks[1].lJoyX,joysticks[1].lJoyY,joysticks[1].lTrig,joysticks[1].rJoyX,joysticks[1].rJoyY,joysticks[1].rTrig = love.joystick.getAxes(1)end
	if(joysticks[2])then joysticks[2].lJoyX,joysticks[2].lJoyY,joysticks[2].lTrig,joysticks[2].rJoyX,joysticks[2].rJoyY,joysticks[2].rTrig = love.joystick.getAxes(2)end
	if(joysticks[1])then
		if(joysticks[1].lJoyX*joysticks[1].lJoyX+joysticks[1].lJoyY*joysticks[1].lJoyY<0.01)then
		 joysticks[1].lJoyX = 0;joysticks[1].lJoyY = 0
		end
		joysticks[1].a = love.joystick.isDown(1,1)
		joysticks[1].b = love.joystick.isDown(1,2)
		joysticks[1].x = love.joystick.isDown(1,3)
		joysticks[1].y = love.joystick.isDown(1,4)
		joysticks[1].lBtn = love.joystick.isDown(1,5)
		joysticks[1].rBtn = love.joystick.isDown(1,6)
		joysticks[1].back = love.joystick.isDown(1,7)
		joysticks[1].start = love.joystick.isDown(1,8)
	end
	if(joysticks[2])then
		if(joysticks[2].lJoyX*joysticks[2].lJoyX+joysticks[2].lJoyY*joysticks[2].lJoyY<0.01)then
		 joysticks[2].lJoyX = 0;joysticks[2].lJoyY = 0
		end
		joysticks[2].a = love.joystick.isDown(2,1)
		joysticks[2].b = love.joystick.isDown(2,2)
		joysticks[2].x = love.joystick.isDown(2,3)
		joysticks[2].y = love.joystick.isDown(2,4)
		joysticks[2].lBtn = love.joystick.isDown(2,5)
		joysticks[2].rBtn = love.joystick.isDown(2,6)
		joysticks[2].back = love.joystick.isDown(2,7)
		joysticks[2].start = love.joystick.isDown(2,8)
	end
end
