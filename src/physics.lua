function newMinion(x, y, angle, type, goal)
	return newMinionFns[type](x, y, angle, sprite, goal)
end

function newEnemy(x, y, angle, type)
	return newEnemyFns[type](x, y, angle, sprite)
end

function newBullet(x, y, angle, speed)
	local bullet = newBody(x, y, angle, nil)
	bullet.body:setLinearDamping(0)
	bullet.body:setLinearVelocity(speed*math.cos(angle), speed*math.sin(angle))

	return bullet
end

function newWall(x, y, sprite)
	x = x * cellSize
	y = y * cellSize
	local wall = newBody(x, y, 0, sprite)
	wall.body:setType("static")
	wall.shape   = love.physics.newRectangleShape(cellSize/2,cellSize/2,cellSize,cellSize)
	wall.fixture = love.physics.newFixture(wall.body,wall.shape)
	wall.fixture:setRestitution(0)
	wall.fixture:setGroupIndex(-2)
	wall.render = function()

	end
	table.insert(world.walls,wall)
	return wall
end

function newEntity(x, y, angle, sprite, health)
	local entity = newBody(x, y, angle)
	entity.oldX = 0
	entity.oldY = 0
	entity.AIProcessors = {}
	entity.velocityAcc  = {}
	entity.health = health
	entity.baseHealth = health
	entity.targetingMe = 0

	entity.saveOld = function()
		entity.oldX = entity.body:getX()
		entity.oldY = entity.body:getY()
	end

	entity.update = function()
		entity.velocityAcc = {}
		for _,i in pairs(entity.AIProcessors) do i() end
		local vx = 0
		local vy = 0
		for _,i in pairs(entity.velocityAcc) do
			vx = vx+i.x
			vy = vy+i.y
		end
		local mult = 1000
		entity.body:applyForce(mult * vx,mult * vy)
		vx, vy = entity.body:getLinearVelocity()
		local speed = math.sqrt(vx*vx+vy*vy)
		if speed > 150 then
			vx = 150*vx/speed
			vy = 150*vy/speed
		end
		if entity.subUpdate then entity.subUpdate() end
	end

	entity.render = function()
		love.graphics.setColor(0,255,255,255)
		love.graphics.circle("fill",entity.body:getX(),entity.body:getY(),10,20)
	end
	return entity
end


function newBody(x,y,angle, sprite)
	local body = {}
	body.body = love.physics.newBody(physWorld,x,y,"dynamic")
	body.body:setLinearDamping(0.8)
	body.body:setFixedRotation(true)

	body.render = function()
		love.graphics.setColor(255,0,255,255)
		love.graphics.circle("fill",body.body:getX(),body.body:getY(),10,20)
	end

	world.bodies[body] = body
 	return body
end

---------------------------------------------

function attachCircleFixture(body,radius,category,mask,isSensor,func) -- TODO only add to sensedLs if isSensor
	local shape   = love.physics.newCircleShape(radius)
	local fixture = love.physics.newFixture(body.body,shape,1)
	local sensedLs = {}
	fixture:setUserData({isBullet = false,
	                     ref   = body,
	                     reg   = function(e)sensedLs[e] = e   end,
	                     unReg = function(e)sensedLs[e] = nil end,
	                     cat   = category,
	                     msk   = mask})
	fixture:setSensor(isSensor)
	if isSensor then fixture:setGroupIndex(-1) end
	table.insert(body.AIProcessors,function()func(sensedLs)end)
end

---------------------------------------------

function beginContact(af,bf,_)
	local a = af:getUserData()
	local b = bf:getUserData()
	if (not a) or (not b) then return end
	if a.isBullet then
		b.ref.health = b.ref.health - a.ref.damage
		world.deletequeue[a.ref] = a.ref
	end
	if b.isBullet then
		a.ref.health = a.ref.health - b.ref.damage
		world.deletequeue[b.ref] = b.ref
	end
	if bit.bor(a.msk,b.cat) ~= 0 then a.reg(b.ref) end
	if bit.bor(b.msk,a.cat) ~= 0 then b.reg(a.ref) end
end

function endContact(af,bf,_)
	local a = af:getUserData()
	local b = bf:getUserData()
	if (not a) or (not b) then return end
	if bit.bor(a.msk,b.cat) ~= 0 then a.unReg(b.ref) end
	if bit.bor(b.msk,a.cat) ~= 0 then b.unReg(a.ref) end
end

