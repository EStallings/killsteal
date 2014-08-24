menu = {}
modeMenu = {}
modeMenu.load = function()
	--see if we have a saved game
	menu.options = {"Continue", "New", "Help"}
	menu.enabled = {false, true, true}
	menu.selectedIndex = 2
	menu.numControllers = 0

	if love.filesystem.exists("savedgame.lua") then
		local chunk = love.filesystem.load( "savedgame.lua" )
	  chunk()  -- this runs the code -> makes a table named savedgame
	  print(savedgame)
	  menu.enabled[0] = true
	  menu.selectedIndex = 1
	end

	initControls()
	menu.numControllers = table.maxn(joysticks)
end

modeMenu.update = function()
end

local scrolloffset = 0
modeMenu.draw = function()
	local width  = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	scrolloffset = scrolloffset - 1
	if scrolloffset < -360 then scrolloffset = width end
	--draw background
	love.graphics.setColor(0,0,100,255)
	love.graphics.rectangle("fill",  0, 0, width, height)

	--draw options
	local yoffset    = 100
	local lineHeight = 40
	local bigfont    = love.graphics.newFont(30)
	local smallfont  = love.graphics.newFont(15)
	love.graphics.setFont(bigfont)
	for i,j in pairs(menu.options) do
		if i == menu.selectedIndex then
			love.graphics.setColor(50, 100, 50, 150)
			love.graphics.rectangle("fill", 100, i*lineHeight + yoffset, 200, lineHeight-4)
 			love.graphics.setColor(200, 200, 200, 255)
 			love.graphics.printf( j, 100, i*lineHeight + yoffset, 200, "left" )
		elseif menu.enabled[i] then
 			love.graphics.setColor(50, 50, 50, 150)
 			love.graphics.rectangle("fill", 100, i*lineHeight + yoffset, 200, lineHeight-4)
 			love.graphics.setColor(200, 200, 200, 255)
 			love.graphics.printf( j, 100, i*lineHeight + yoffset, 200, "left" )
	 	end
	end

	--draw attach additional controller overlay for 2 player if only one controller found
	love.graphics.setFont(smallfont)
	if menu.numControllers < 1 then
		love.graphics.setColor(200, 10, 10, 150)
		love.graphics.rectangle("fill", 0, height - 80, width, lineHeight/2)
		love.graphics.setColor(200, 200, 200, 255)
		love.graphics.printf( "No Controllers Found", scrolloffset, height-80, 400, "left" )
	elseif menu.numControllers < 2 then
		love.graphics.setColor(200, 200, 10, 150)
		love.graphics.rectangle("fill", 0, height - 80, width, lineHeight/2)
		love.graphics.setColor(200, 200, 200, 255)
		love.graphics.printf( "Attach A Second Controller for 2-player", scrolloffset, height-80, 400, "left" )
	end
end