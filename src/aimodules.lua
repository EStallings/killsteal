
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

function attachTargetDetectionAI(entity,radius,mask,func)
	attachCircleFixture(entity,radius,0,mask,true,function(entityLs) func(entity, entityLs) end)
end

function attachGoalPointAI(entity, distfunc, multiplier)
	table.insert(entity.AIProcessors,function()
		if not entity.target then return end
		local px = entity.target.x or entity.target:getX()
		local py = entity.target.y or entity.target:getY()

		local vx = px-entity.body:getX()
		local vy = py-entity.body:getY()
		local mag = distfunc(multiplier, vx, vy)
			table.insert(entity.velocityAcc,{x=vx*mag,y=vy*mag})

	end)
end
-----Distance Functions --

function dist1(m, vx, vy)
	return (m*math.abs(vx*vx*vx+vy*vy*vy)) - 0.02
end

function dist2(m, vx, vy)
	return (m*math.abs(vx*vx+vy*vy))
end

function dist3(m, vx, vy)
	return (m*(vx*vx+vy*vy))
end

function dist4(m, vy, vy)
	if (vx*vx+vy*vy) < m then return dist2(1, vx, vy) else return 0 end
end

--Target prioritization functions--

function targetWeakest(entity, entityLs)
	if entity.target and entity.target.targetingMe then entity.target.targetingMe = entity.target.targetingMe - 1 end
	local minhealth = 10000000
	local mintarget = nil
	for _,i in pairs(entityLs) do
		if i.team ~= entity.team and i.health < minhealth then
			mintarget = i
			minhealth = i.health
		end
	end
	if not mintarget then return end
	entity.target = mintarget.body
	mintarget.targetingMe = mintarget.targetingMe + 1
end

function targetUnpopular(entity, entityLs)
	if entity.target and entity.target.targetingMe then entity.target.targetingMe = entity.target.targetingMe - 1 end
	local mintargeting = 10000000
	local mintarget = nil
	for _,i in pairs(entityLs) do
		if i.team ~= entity.team and i.targetingMe and i.targetingMe < mintargeting then
			mintarget = i
			mintargeting = i.targetingMe
		end
	end
	if not mintarget then return end
	entity.target = mintarget.body
	mintarget.targetingMe = mintarget.targetingMe + 1
end