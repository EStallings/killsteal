modeHelp = {}
modeHelp.load = function()

	modeHelp.text = "Kill the enemy with your swarm and weapons. Try to steal kills from your teammate."

end

modeHelp.update = function()
	if joysticks[1].b then
		changeMode(modeMenu)
	end
end


modeHelp.draw = function()
	local width  = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill",0,0,width, height)

	local textWidth = width-100
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(love.graphics.newFont(30))
	love.graphics.printf( modeHelp.text, (width-textWidth)/2, 100, textWidth, "center" )
end