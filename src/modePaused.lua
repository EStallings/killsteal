modePaused = {}
modePaused.load = function()
	modePaused.menu = false
	modePaused.moved = false
end
modePaused.update = function()
	if (joysticks[1] and joysticks[1].a) or (joysticks[2] and joysticks[2].a) then
		if modePaused.menu then
			changeMode(modeMenu)
		else
			MODE = modeGame
		end
	end
	if ((joysticks[1] and joysticks[1].lJoyY ~= 0) or (joysticks[2] and joysticks[2].lJoyY ~= 0)) and not modePaused.moved then
		modePaused.menu = not modePaused.menu
		modePaused.moved = true;
	elseif (joysticks[1] and joysticks[1].lJoyY == 0) or (joysticks[2] and joysticks[2].lJoyY == 0) then
		modePaused.moved = false
	end
end


modePaused.draw = function()
	modeGame.draw()
	love.graphics.setColor(0,0,0,30)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())
	if modePaused.menu then
		love.graphics.setColor(20,20,20,100)
		love.graphics.rectangle("fill",100, 200, 300, 45)
		love.graphics.setColor(20,80,20,100)
		love.graphics.rectangle("fill",100, 250, 300, 45)
	else
		love.graphics.setColor(20,80,20,100)
		love.graphics.rectangle("fill",100, 200, 300, 45)
		love.graphics.setColor(20,20,20,100)
		love.graphics.rectangle("fill",100, 250, 300, 45)
	end

	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(love.graphics.newFont(30))
	love.graphics.printf("Resume", 100, 200, 300,'left')
	love.graphics.printf("Menu", 100, 250, 300,'left')
end
