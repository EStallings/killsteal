
-- entities
function newEntity(x, y, radius, angle, team, health, ai)

	local entity        = {}

	entity.label        = "Entity"
	entity.damageRecord = {}
	entity.team         = team
	entity.health       = health
	entity.maxHealth    = health
	entity.body         = love.physics.newBody(physWorld, x, y, "dynamic")
	entity.shape        = love.physics.newCircleShape( radius )
	entity.fixture      = love.physics.newFixture(entity.body, entity.shape, 1)
	entity.ai           = ai
	entity.dqueued      = false --destruction queued - to prevent multiple deletion
	entity.id           = table.maxn(world.entities)+1
	entity.body:setFixedRotation(true)
	entity.body:setAngle(angle)
	entity.body:setLinearDamping(5)
	entity.fixture:setUserData({type="Entity", value=entity})

	entity.onDestroy = function() print("Entity destroyed") end
	entity.draw = function()
		if entity.dqueued then return end
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle("fill", entity.body:getX(), entity.body:getY(), entity.shape:getRadius())
	end

	entity.collisionStart = function(other, coll) end
	entity.collisionEnd = function(other, coll) end

	table.insert(world.entities, entity)
	return entity
end

function newBullet(x,y,angle, velocity,team, damage)
	local bullet = newEntity(x, y, 4, angle, team, 1, bulletAI)
	bullet.body:setBullet(true)
	bullet.fixture:setSensor(true)
	bullet.body:setLinearVelocity(velocity*math.cos(angle), velocity*math.sin(angle))
	bullet.body:setLinearDamping(0)
	bullet.damage = damage
	bullet.fixture:setUserData({type="Bullet", value=bullet})
	bullet.collisionStart = function(other, coll)
		if other.type ~= "Bullet" and other.value.team ~= bullet.team and (other.value.team == 0 or bullet.team == 0) then
			if other.value.health then
				other.value.health = other.value.health - bullet.damage
			end
			if not bullet.dqueued then
				bullet.dqueued = true;
				table.insert(world.deletequeue, bullet)
			end
		end
	end
	bullet.fixture:setGroupIndex(-1)
	return bullet
end
