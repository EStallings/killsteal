
function newCamera()
	local camera = {}
	camera.x    = 0
	camera.y    = 0
	camera.zoom = 1
	camera.goalX    = 0
	camera.goalY    = 0
	camera.goalZoom = 1
	return camera
end

function updateCamera(camera)
	local x0 = player1.body:getX()
	local y0 = player1.body:getY()
	local x1 = x0
	local y1 = y0
	if player2 then
		x1 = player2.body:getX()
		y1 = player2.body:getY()
	end
	local padding = 500
	local minX = math.min(x0,x1)-padding
	local minY = math.min(y0,y1)-padding
	local maxX = math.max(x0,x1)+padding
	local maxY = math.max(y0,y1)+padding

	camera.goalX = (minX+maxX)/2
	camera.goalY = (minY+maxY)/2
	local scaleX = love.graphics.getWidth() /(maxX-minX)
	local scaleY = love.graphics.getHeight()/(maxY-minY)
	camera.goalZoom = math.min(scaleX,scaleY)

	camera.x    = camera.x    + ((camera.goalX    - camera.x   ) * 0.04)
	camera.y    = camera.y    + ((camera.goalY    - camera.y   ) * 0.04)
	camera.zoom = camera.zoom + ((camera.goalZoom - camera.zoom) * 0.04)
end

function renderCamera(camera)
	love.graphics.translate(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
	love.graphics.scale(camera.zoom,camera.zoom)
	love.graphics.translate(-camera.x,-camera.y)
end
