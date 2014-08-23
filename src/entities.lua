--Entities
function newEntity(x,y,radius,angle,ai)
	local entity = {}
	entity.damageRecord = {}
	entity.body = love.physics.newBody(physWorld, x, y, "dynamic")
  entity.shape = love.physics.newCircleShape( radius )
  entity.fixture = love.physics.newFixture(entity.body, entity.shape, 1)
  entity.body:setAngle(angle)
  entity.ai = ai
  return entity
end


--minion
function newMinion(x, y, type, player)


end
