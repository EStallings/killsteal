minionSprites = {

}

newMinionFns = {

	function(x, y, angle, sprite, parent)
		local entity = newEntity(x, y, angle, sprite, 100)
		entity.target = parent;
		entity.body:setMass(0)
		entity.health = 10
		entity.passiveMode = true
		entity.team = parent.team
		attachCircleFixture(entity,10,1,1,false,function()end)
		attachAlignmentAI  (entity,100,2,1)
		attachCohesionAI   (entity,100,0.6,1)
		attachSeparationAI (entity,40,2.3,1)
		attachTargetDetectionAI(entity, 80, 1, targetWeakest)
		attachAttackAI(entity, 200, 5, 300)
		attachGoalPointAI  (entity,dist1,0.000000005)
		entity.subUpdate = function()
			entity.body:setAngle(math.atan2(entity.body:getY()-entity.oldY,
		                                entity.body:getX()-entity.oldX))
		end
		table.insert(world.bodies,entity)
		return entity
	end

}
