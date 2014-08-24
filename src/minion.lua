newMinion = {

function(x, y)
	local body = newBody(x, y, 0)
	attachCircleFixture(body,10,1,1,false,function()end)
	attachAlignmentAI  (body,100,2,1)
	attachCohesionAI   (body,100,0.6,1)
	attachSeparationAI (body,40,2.3,1)
	attachGoalPointAI  (body,GOALPOINT,0.000000005)
	table.insert(bodies,body)
end

}