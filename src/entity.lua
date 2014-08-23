--Entities
function newEntity(x, y, radius, angle, team, health, ai)
	local entity = {}
	entity.label = "Entity"
	entity.damageRecord = {}
	entity.team = team
	entity.health = health
	entity.maxHealth = health
	entity.body = love.physics.newBody(physWorld, x, y, "dynamic")
  entity.shape = love.physics.newCircleShape( radius )
  entity.fixture = love.physics.newFixture(entity.body, entity.shape, 1)
  entity.body:setAngle(angle)
  entity.ai = ai
  entity.fixture:setUserData({type="Entity", value=entity})
  return entity
end
