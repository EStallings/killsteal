
-- enemy
local enemySetupData = {
	{
		AI = function(enemy)
			enemy.fireTimer = enemy.fireTimer - 1
			if enemy.fireTimer < 0 then enemy.fireTimer = 0 end

			if enemy.target == nil then return end
			local eX = enemy.body:getX()
			local eY = enemy.body:getY()
			local tX = enemy.target.body:getX()
			local tY = enemy.target.body:getY()
			enemy.body:setAngle(math.atan2(tY - eY, tX - eX))
			--if within range, attack and don't move closer
			if distance(enemy.target, enemy) < enemy.range then
				--insert logic here
				if enemy.fireTimer == 0 then
					enemy.fireTimer = enemy.fireRate
					newBullet(eX, eY, enemy.body:getAngle(), 800, 0, enemy.damage)
				end
				return
			end
			--otherwise, move towards target
			local v = normalize({x=tX-eX,y=tX-eX})
			enemy.body:applyLinearImpulse(v.x * 0.2, v.y * 0.2)

		end,
		BaseHealth = 1,
		SightRange = 300,
		Damage     = 5,
		Speed      = 1,
		Range      = 300,
		RegenRate  = 1,
		Mass       = 0.1,
		FireRate   = 100 --higher is slower
	}
}

local enemySize = 32 -- XXX: should this be in setupData?

function newEnemy(x, y, type)
	local data = enemySetupData[type]
	local enemy = newEntity(x, y, enemySize/2, 0, 0, data.BaseHealth, data.AI) -- TODO: give correct ai and health
	enemy.label = "Enemy"
	enemy.type = type
	enemy.enemyContacts = {}
	enemy.range = data.Range
	enemy.target = nil
	enemy.fireTimer = 0 --0 means can fire
	enemy.fireRate = data.FireRate
	enemy.damage = data.Damage


	enemy.sensorShape = love.physics.newCircleShape( data.SightRange )
	enemy.sensorFixture = love.physics.newFixture(enemy.body, enemy.sensorShape, 1)
	enemy.sensorFixture:setSensor(true)
	enemy.sensorFixture:setGroupIndex(-1);

	enemy.sensorFixture:setUserData({type="", value=enemy}) --left empty: means it won't be visible to AIs
	enemy.fixture:setUserData({type="Enemy", value=enemy})

	enemy.body:setMass(data.Mass)
	return enemy
end
