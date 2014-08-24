
-- entities
function newEntity(x, y, radius, angle, team, health, ai)

	local entity        = {}

	entity.damageRecord = {}
	entity.team         = team
	entity.health       = health
	entity.maxHealth    = health
	entity.body:setFixedRotation(true)
	entity.body:setAngle(angle)
	entity.body:setLinearDamping(5)
	entity.fixture:setUserData({type="Entity", value=entity})

	entity.die = function()
		entity.dqueued = true
		table.insert(world.deletequeue, entity)
	end --default tbd
	entity.draw = function()
		if entity.dqueued then return end
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle("fill", entity.body:getX(), entity.body:getY(), entity.shape:getRadius())
	end

	entity.collisionStart = function(other, coll) end
	entity.collisionEnd = function(other, coll) end

	world.entities[entity] = entity
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
				bullet.health = 0
			end
		end
	end
	bullet.fixture:setGroupIndex(-1)
	return bullet
end
