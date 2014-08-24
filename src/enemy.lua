newEnemyFns = {

	function(x, y, angle, sprite)
		local entity = newEntity(x, y, angle, sprite, 100)
		entity.target = nil;
		entity.team = 0
		attachCircleFixture(entity,10,1,1,false,function()end)
		-- attachAlignmentAI  (entity,100,2,1)
		-- attachCohesionAI   (entity,100,0.6,1)
		-- attachSeparationAI (entity,40,2.3,1)
		attachTargetDetectionAI(entity, 400, 1, targetUnpopular)
		attachAttackAI(entity, 300, 2, 100)
		attachGoalPointAI  (entity,dist1,0.000000005)
		entity.moveRandTimeout = 0
		entity.shootTimeout = 0
		entity.subUpdate = function()
			if not entity.target then
				if entity.moveRandTimeout == 0 then
					entity.moveRandTimeout = math.random(500,5000)
					local angle = math.random(0, 360)/180 * math.pi
					entity.body:setAngle(angle)
					local speed = 250
					entity.body:setLinearVelocity(math.cos(angle)*250, math.sin(angle)*250)
				else
					entity.moveRandTimeout = entity.moveRandTimeout - 1
				end
			end
		end
		table.insert(world.bodies,entity)
		return entity
	end

}