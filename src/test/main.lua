require 'bit'

function attachCircleFixture(entity,radius,category,mask,isSensor,func) -- TODO only add to sensedLs if isSensor
	local shape   = love.physics.newCircleShape(radius)
	local fixture = love.physics.newFixture(entity.body,shape,1)
	local sensedLs = {}
	fixture:setUserData({ref   = entity,
	                     reg   = function(e)sensedLs[e] = e   end,
	                     unReg = function(e)sensedLs[e] = nil end,
	                     cat   = category,
	                     msk   = mask})
	fixture:setSensor(isSensor)
	if isSensor then fixture:setGroupIndex(-1) end
	table.insert(entity.AIProcessors,function()func(sensedLs)end)
end

function newBody(x,y,angle)
	local entity = {}

	entity.AIProcessors = {}
	entity.velocityAcc = {}
	entity.body = love.physics.newBody(world,x,y,"dynamic")
	entity.body:setLinearDamping(0.8)

	entity.update = function()
		entity.velocityAcc = {}
		for _,i in pairs(entity.AIProcessors) do i() end
		local vx = 0
		local vy = 0
		for _,i in pairs(entity.velocityAcc) do
			vx = vx+i.x
			vy = vy+i.y
		end
		-- local mag = math.sqrt(vx*vx+vy*vy)
		-- if mag > 100 then
		-- 	vx = vx * 100/mag
		-- 	vy = vy * 100/mag
		-- end
		local mult = 1000
		entity.body:applyForce(mult * vx,mult * vy)
	end

	entity.render = function()
		love.graphics.setColor(255,255,255,255)
		love.graphics.circle("fill",entity.body:getX(),entity.body:getY(),10,20)
	end

	return entity
end

--------------------------------------------------------------------------------

function beginContact(af,bf,_)
	local a = af:getUserData()
	local b = bf:getUserData()
	if bit.bor(a.msk,b.cat) ~= 0 then a.reg(b.ref) end
	if bit.bor(b.msk,a.cat) ~= 0 then b.reg(a.ref) end
end

function endContact(af,bf,_)
	local a = af:getUserData()
	local b = bf:getUserData()
	if bit.bor(a.msk,b.cat) ~= 0 then a.unReg(b.ref) end
	if bit.bor(b.msk,a.cat) ~= 0 then b.unReg(a.ref) end
end

--------------------------------------------------------------------------------

function attachAlignmentAI(entity,radius,multiplier,mask)
	attachCircleFixture(entity,radius,0,mask,true,function(entityLs)
		local vx = 0
		local vy = 0
		local count = 0
		for _,i in pairs(entityLs) do
			local bx,by = i.body:getLinearVelocity();
			if bx ~= bx or by ~= by then
				bx = 0
				by = 0
			end
			vx = vx+bx
			vy = vy+by
			count = count+1
		end
		local dist = math.sqrt(vx*vx+vy*vy)
		if count > 1 and dist ~= 0 then
			local invMag = multiplier/dist
			vx = vx*invMag
			vy = vy*invMag
			table.insert(entity.velocityAcc,{x=vx,y=vy})
		end
	end)
end

function attachCohesionAI(entity,radius,multiplier,mask)
	attachCircleFixture(entity,radius,0,mask,true,function(entityLs)
		local vx = 0
		local vy = 0
		local count = 0
		for _,i in pairs(entityLs) do
			vx = vx+i.body:getX()
			vy = vy+i.body:getY()
			count = count+1
		end

		local dist = math.sqrt(vx*vx+vy*vy)
		if count > 1 and dist ~= 0 then
			local invMag = multiplier/dist
			vx = vx/count
			vy = vy/count
			vx = vx-entity.body:getX()
			vy = vy-entity.body:getY()
			vx = vx*invMag
			vy = vy*invMag
			table.insert(entity.velocityAcc,{x=vx,y=vy})
		end
	end)
end

function attachSeparationAI(entity,radius,multiplier,mask)
	attachCircleFixture(entity,radius,0,mask,true,function(entityLs)
		local vx = 0
		local vy = 0
		local count = 0
		for _,i in pairs(entityLs) do
			vx = vx+entity.body:getX()-i.body:getX()
			vy = vy+entity.body:getY()-i.body:getY()
			count = count+1
		end

		local dist = math.sqrt(vx*vx+vy*vy)
		if count > 1 and dist ~= 0 then
			local invMag = multiplier/dist
			vx = vx*invMag
			vy = vy*invMag
			table.insert(entity.velocityAcc,{x=vx,y=vy})
		end
	end)
end

function attachGoalPointAI(entity,parent,multiplier)
	table.insert(entity.AIProcessors,function()
		local vx = parent.x-entity.body:getX()
		local vy = parent.y-entity.body:getY()
		local dist2 = math.abs(vx*vx*vx+vy*vy*vy)
		local mag = multiplier*dist2
		mag = mag - 0.02
			table.insert(entity.velocityAcc,{x=vx*mag,y=vy*mag})

	end)
end

--------------------------------------------------------------------------------
GOALPOINT = {x=320, y=240}
function love.load()
	love.physics.setMeter(64)
	world = love.physics.newWorld(0,0,true)
	world:setCallbacks(beginContact, endContact)

	bodies = {}
	for i=1,50 do
		local body = newBody(math.random(100,500),math.random(100,400),0)
		attachCircleFixture(body,10,1,1,false,function()end)
		attachAlignmentAI  (body,100,2,1)
		attachCohesionAI   (body,100,0.6,1)
		attachSeparationAI (body,40,2.3,1)
		attachGoalPointAI  (body,GOALPOINT,0.000000005)
		table.insert(bodies,body)
	end
end

--------------------------------------------------------------------------------

function love.update(dt)
	world:update(dt)
	for _,i in pairs(bodies) do i.update() end
end

--------------------------------------------------------------------------------

function love.draw()
	love.graphics.setColor(255,0  ,0  ,255)
	love.graphics.circle("fill",GOALPOINT.x,GOALPOINT.y,10,20)
	for _,i in pairs(bodies) do i.render() end
end

--------------------------------------------------------------------------------

function love.keyreleased(key, unicode) if key == 'escape' then love.event.push('quit') end end
