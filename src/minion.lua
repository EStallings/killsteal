
-- minion
local minionSetupData = {
	{
		AI = function(minion)end,
		BaseHealth = 1,
		MinDist    = 50,
		SightRange = 300,
		Damage     = 1,
		Speed      = 1,
		Range      = 1,
		RegenRate  = 1,
		Mass       = 0.1
	}
}

local minionSize = 12 -- XXX: should this be in setupData?

function newMinion(x, y, type, team)
	local data = minionSetupData[type]
	local minion = newEntity(x, y, minionSize/2, 0, team, data.BaseHealth, data.AI) -- TODO: give correct ai and health
	minion.label = "Minion"
	minion.type = type
	minion.minionContacts = {}

	minion.sensorShape = love.physics.newCircleShape( data.MinDist )
	minion.sensorFixture = love.physics.newFixture(minion.body, minion.sensorShape, 1)
	minion.sensorFixture:setSensor(true)
	minion.sensorFixture:setGroupIndex(-1);

	minion.sensorFixture:setUserData({type="MinionSensor", value=minion})
	minion.fixture:setUserData({type="Minion", value=minion})

	minion.body:setMass(data.Mass)
	return minion
end

