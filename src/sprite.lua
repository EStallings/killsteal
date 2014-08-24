function initSprites()

	moth = love.graphics.newImage("res/player/003.png")
	mothQuad = love.graphics.newQuad(0,0,moth:getWidth()/2,moth:getHeight()/2,moth:getWidth()/2,moth:getHeight()/2)

	ant = love.graphics.newImage("res/player/100.png")
	antQuad = love.graphics.newQuad(0,0,ant:getWidth()/2,ant:getHeight()/2,ant:getWidth()/2,ant:getHeight()/2)

	sssImg = love.graphics.newImage("res/swarm-spec-sheet.png")
	sss = {}
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
