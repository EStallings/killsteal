
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
		local px = parent.x or parent:getX()
		local py = parent.y or parent:getY()

		local vx = px-entity.body:getX()
		local vy = py-entity.body:getY()
		local dist2 = math.abs(vx*vx*vx+vy*vy*vy)
		local mag = multiplier*dist2
		mag = mag - 0.02
			table.insert(entity.velocityAcc,{x=vx*mag,y=vy*mag})

	end)
end