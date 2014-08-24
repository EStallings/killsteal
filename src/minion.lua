minionSprites = {

}

newMinionFns = {

function(x, y, angle, sprite, goal)
	local entity = newEntity(x, y, angle, sprite, 100)
	attachCircleFixture(entity,10,1,1,false,function()end)
	attachAlignmentAI  (entity,100,2,1)
	attachCohesionAI   (entity,100,0.6,1)
	attachSeparationAI (entity,40,2.3,1)
	attachGoalPointAI  (entity, goal,0.000000005)
	table.insert(world.bodies,entity)
end

}