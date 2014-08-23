
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

	return controller
end

function initControls()
--	for i=1,love.joystick.getNumButtons(1) do
--		print(i,love.joystick.isDown(1,i))
--	end
	local numJoysticks = love.joystick.getNumJoysticks()
	joysticks = {}
	for i=1,numJoysticks do
		table.insert(joysticks,newController(i))
	end
end

function updateControls()

end
