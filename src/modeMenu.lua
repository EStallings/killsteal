local menu = {}
modeMenu = {}
modeMenu.load = function()
	--see if we have a saved game
	menu = {}
	menu.options  = {"Continue", "New", "Help"}
	menu.modes    = {modeGame, modeGame, modeHelp}
	menu.modeData = {nil, nil, nil, nil}
	menu.enabled  = {false, true, true}
	menu.selectedIndex = 2
	menu.maxIndex = table.maxn(menu.options)
	menu.minIndex = 2
	menu.optionSelected = false
	menu.startTimeout = 10
	menu.resetFlag = true

	if love.filesystem.exists("savedgame.lua") then
		local chunk = love.filesystem.load( "savedgame.lua" )
	  chunk()  -- this runs the code -> makes a table named savedgame
	  menu.modeData[1] = savedgame
	  print(savedgame)
	  menu.enabled[1] = true
	  menu.selectedIndex = 1
	  menu.minIndex = 1
	end
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	modeMenu.canvas = love.graphics.newCanvas(width, height)

  love.graphics.setCanvas(modeMenu.canvas)
    modeMenu.canvas:clear()
    bgIMG = love.graphics.newImage("res/menu-bg.png")
		love.graphics.draw( bgIMG, -(1920/2)+(width/2), -(1280/2)+(height/2))

		ksIMG = love.graphics.newImage("res/ks.png")
		love.graphics.draw( ksIMG, 70, -60, .2, 1, 1)
  love.graphics.setCanvas()
end


modeMenu.update = function()
	if joysticks[1] then
		if joysticks[1].lJoyY < 0 then
			menu.selectedIndex = menu.selectedIndex - 1
			if menu.selectedIndex < menu.minIndex then menu.selectedIndex = menu.minIndex end
		elseif joysticks[1].lJoyY > 0 then
			menu.selectedIndex = menu.selectedIndex + 1
			if menu.selectedIndex > menu.maxIndex then menu.selectedIndex = menu.maxIndex end
		end

		if joysticks[1].a and not menu.resetFlag then
			menu.optionSelected = true
		elseif not joysticks[1].a then menu.resetFlag = false end
	end
	if menu.optionSelected then
		menu.startTimeout = menu.startTimeout - 1
	end

	if menu.startTimeout <= 0 then
		changeMode(menu.modes[menu.selectedIndex], menu.modeData[menu.selectedIndex])
	end
end

local scrolloffset = love.graphics.getWidth()/2
modeMenu.draw = function()
	local width  = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	scrolloffset = scrolloffset - 2
	if scrolloffset < -360 then scrolloffset = width end
	--draw background
	--love.graphics.setColor(0,0,100,255)
	--love.graphics.rectangle("fill",  0, 0, width, height)

	love.graphics.draw(modeMenu.canvas)
	--draw options
	local yoffset    = 80
	local lineHeight = 72
	local padding    = 10
	local bigfont    = love.graphics.newFont( "res/DIN.ttf", 48)
	local smallfont  = love.graphics.newFont( "res/DIN.ttf", 24)
	love.graphics.setFont(bigfont)
	for i,j in pairs(menu.options) do
		if i == menu.selectedIndex then
			love.graphics.setColor(0, 0, 0, 150)
			love.graphics.rectangle("fill", 100, i*lineHeight + yoffset, 200, lineHeight-padding)
 			love.graphics.setColor(255, 255, 255, 200)
 			love.graphics.printf( j, 100+padding, i*lineHeight + yoffset + padding/3, 200, "left" )
		elseif menu.enabled[i] then
 			love.graphics.setColor(100, 0, 50, 150)
 			love.graphics.rectangle("fill", 100, i*lineHeight + yoffset, 200, lineHeight-padding)
 			love.graphics.setColor(255, 255, 255, 200)
 			love.graphics.printf( j, 100+padding, i*lineHeight + yoffset + padding/3, 200, "left" )
	 	end
	end
	--draw attach additional controller overlay for 2 player if only one controller found
	love.graphics.setFont(smallfont)
	if numJoysticks < 1 then
		love.graphics.setColor(200, 10, 10, 100)
		love.graphics.rectangle("fill", 0, height - 80, width, lineHeight/2)
		love.graphics.setColor(200, 200, 200, 255)
		love.graphics.printf( "No Controllers Found", scrolloffset, height-76, 400, "left" )
	elseif numJoysticks < 2 then
		love.graphics.setColor(200, 200, 10, 100)
		love.graphics.rectangle("fill", 0, height - 80, width, lineHeight/2)
		love.graphics.setColor(200, 200, 200, 255)
		love.graphics.printf( "Attach A Second Controller for 2-player", scrolloffset, height-76, 400, "left" )
	end

	--draw fade effect
	if menu.optionSelected then
		love.graphics.setColor(0,0,0,200-(menu.startTimeout*4))
		love.graphics.rectangle("fill",0,0,width,height)
	end
end
