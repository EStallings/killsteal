
-- entities
local entityID = 1
function newEntity(x, y, radius, angle, team, health, ai)

	local entity        = {}

	entity.label        = "Entity"
	entity.damageRecord = {}
	entity.contacts     = {}
	entity.team         = team
	entity.health       = health
	entity.maxHealth    = health
	entity.body         = love.physics.newBody(physWorld, x, y, "dynamic")
	entity.shape        = love.physics.newCircleShape( radius )
	entity.fixture      = love.physics.newFixture(entity.body, entity.shape, 1)
	entity.ai           = ai
	entity.id           = entityID
	entityID = entityID + 1
	entity.body:setFixedRotation(true)
	entity.body:setAngle(angle)
	entity.body:setLinearDamping(5)
	entity.fixture:setUserData({type="Entity", value=entity})

	entity.onDestroy = function() print("Entity destroyed") end
	entity.draw = function()
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle("fill", entity.body:getX(), entity.body:getY(), entity.shape:getRadius())
	end
	table.insert(world.entities, entity)
	return entity
end

local bulletAI = function(bullet)
	for _, j in pairs(bullet.contacts) do
		print(j.type)
		if j.type ~= "Bullet" and j.value.team ~= bullet.team and (j.value.team == 0 or bullet.team == 0) then
			j.health = j.health - bullet.damage
		end
	end
end

function newBullet(x,y,angle, velocity,team, damage)
	local bullet = newEntity(x, y, 4, angle, team, 1, bulletAI)
	bullet.body:setBullet(true)
	bullet.fixture:setSensor(true)
	bullet.body:setLinearVelocity(velocity*math.cos(angle), velocity*math.sin(angle))
	bullet.damage = damage
	bullet.fixture:setUserData({type="Bullet", value=bullet})
	bullet.fixture:setGroupIndex(-1)
	return bullet
end
