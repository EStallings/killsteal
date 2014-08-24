function initSprites()

	mothImg = love.graphics.newImage("res/player/003.png")
	moth = {img=mothImg,quad=love.graphics.newQuad(0,0,mothImg:getWidth(),mothImg:getHeight(),mothImg:getWidth(),mothImg:getHeight()),
	        width=128,height=128}

	ant = love.graphics.newImage("res/player/100.png")
	antQuad = love.graphics.newQuad(0,0,ant:getWidth()/2,ant:getHeight()/2,ant:getWidth()/2,ant:getHeight()/2)

	sssImg = love.graphics.newImage("res/swarm-spec-sheet.png")
	sss = {}

	explosion32 = love.graphics.newImage("res/explosion_32.png")
	explosion32Quad = love.graphics.newQuad(0,0,explosion32:getWidth()/2,explosion32:getHeight()/2,explosion32:getWidth()/2,explosion32:getHeight()/2)

	for i=1,8 do
		sss[i] = {img=sssImg,quad=love.graphics.newQuad((i-1)*32,0,32,32,sssImg:getWidth(),sssImg:getHeight()),width=32,height=32}
	end
end

function attachSpriteToEntity(entity,radius,sprite)
	entity.render = function()
		love.graphics.push()
		love.graphics.translate(entity.body:getX(),entity.body:getY())
		love.graphics.rotate(entity.body:getAngle())
		love.graphics.setColor(255,255,255)
		love.graphics.drawq(sprite.img,sprite.quad,sprite.width/2,-sprite.height/2,math.pi/2)
		love.graphics.pop()
	end
end
