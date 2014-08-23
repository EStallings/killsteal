
-- enemy
local enemySetupData = {
	{
		AI = function(enemy)
			if enemy.target == nil then return end

			--if within range, attack and don't move closer
			if distance(enemy.target, enemy) < enemySetupData[enemy.type].Range then
				--insert logic here
				return
			end
			--otherwise, move towards target
			enemy.body:

		end,
		BaseHealth = 1,
		SightRange = 300,
		Damage     = 1,
		Speed      = 1,
		Range      = 1,
		RegenRate  = 1,
		Mass       = 0.1
	}
}

local enemySize = 32 -- XXX: should this be in setupData?

function newEnemy(x, y, type)
	local data = enemySetupData[type]
	local enemy = newEntity(x, y, enemySize/2, 0, team, data.BaseHealth, data.AI) -- TODO: give correct ai and health
	enemy.label = "Enemy"
	enemy.type = type
	enemy.enemyContacts = {}

	enemy.target = nil

	enemy.sensorShape = love.physics.newCircleShape( data.SightRange )
	enemy.sensorFixture = love.physics.newFixture(enemy.body, enemy.sensorShape, 1)
	enemy.sensorFixture:setSensor(true)
	enemy.sensorFixture:setGroupIndex(-1);

	enemy.sensorFixture:setUserData({type="EnemySensor", value=enemy})
	enemy.fixture:setUserData({type="Enemy", value=enemy})

	enemy.body:setMass(data.Mass)
	return enemy
end
