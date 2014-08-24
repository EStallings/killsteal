modePaused = {}
modePaused.load = function()
	modePaused.menu = false
end
modePaused.update = function()
	if (joysticks[1] and joysticks[1].back) or (joysticks[2] and joysticks[2].back) then
		if modePaused.menu then
			changeMode(modeMenu)
		else
			MODE = modeGame
		end
	end
	if (joysticks[1] and joysticks[1].lJoyY ~= 0) or (joysticks[2] and joysticks[2].lJoyY ~= 0) then
		modePaused.menu = not modePaused.menu
	end
end


modePaused.draw = function()
	modeGame.draw()
	love.graphics.setColor(0,0,0,30)
	love.graphics.rectangle(0,0,love.graphics.getWidth(), love.graphics.getHeight())
	if modePaused.menu then
		love.graphics.setColor(20,20,20,100)
		love.graphics.rectangle(100, 200, 300, 45)
		love.graphics.setColor(20,80,20,100)
		love.graphics.rectangle(100, 250, 300, 45)
	else
		love.graphics.setColor(20,80,20,100)
		love.graphics.rectangle(100, 200, 300, 45)
		love.graphics.setColor(20,20,20,100)
		love.graphics.rectangle(100, 250, 300, 45)
	end

	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(love.graphics.newFont(30))
	love.graphics.printf("Resume", 100, 200, 'left')
	love.graphics.printf("Menu", 100, 250, 'left')
end
