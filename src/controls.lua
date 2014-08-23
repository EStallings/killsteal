function newController(id)
	local controller = {}
	controller.lJoyX = 0
	controller.lJoyY = 0
	controller.lTrig = 0
	controller.rJoyX = 0
	controller.rJoyY = 0
	controller.rTrig = 0
	return controller
end

function initControls()
	local numJoysticks = love.joystick.getNumJoysticks()
	joysticks = {}
	for i=1,numJoysticks do
		table.insert(joysticks,newController(i))
	end
end
