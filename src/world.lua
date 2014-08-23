
local worldWidth  = 30
local worldHeight = 20
local cellSize    = 128

function newWorld(difficulty)

	local world = {}

	world.grid = new2DArray(worldWidth, worldHeight, 3, true)
	world.difficulty = difficulty
	world.entities = {}
	world.walls = {}
	world.deletequeue = {}
	world.physics = love.physics.newWorld(0, 0, true)
	world.physics:setCallbacks(beginContact, endContact, preSolve, postSolve)

	cellularAutomata(world.grid,8)
	addPhysicsToWorld(world,world.grid)

	return world
end

function renderWorld(world)
	love.graphics.setColor(0,0,0,64)
	for i = 1,worldWidth do for j = 1,worldHeight do
		if world[i][j] == 0 then
			love.graphics.rectangle("fill",i*cellSize,j*cellSize,cellSize,cellSize)
		end
	end end
end

function cellularAutomata(world,genIterations)
	local width  = table.maxn(world)
	local height = table.maxn(world[1])
	for gen = 1,genIterations do
		local oldState = copyGrid(world)
		for i = 2,width-1 do
			for j = 2,height-1 do
				local neighboors = oldState[i-1][j-1]+
				                   oldState[i-1][j  ]+
				                   oldState[i-1][j+1]+
				                   oldState[i  ][j-1]+
				                   oldState[i  ][j+1]+
				                   oldState[i+1][j-1]+
				                   oldState[i+1][j  ]+
				                   oldState[i+1][j+1]
				if world[i][j] == 0 and 6 <= neighboors and neighboors <= 8 then world[i][j] = 1
				elseif world[i][j] == 1 and (3 > neighboors or neighboors > 8) then world[i][j] = 0
				end
			end
		end
	end

	for i = 1, width do for _, j in pairs({1, height}) do world[i][j] = 0 end end
	for _, i in pairs({1, width}) do for j = 1, height do world[i][j] = 0 end end
end

function addPhysicsToWorld(world,physicsGrid)
	for i = 1,table.maxn(physicsGrid) do
		for j = 1,table.maxn(physicsGrid[i]) do
			if physicsGrid[i][j] == 0 then
				local wall = {}
				wall.body    = love.physics.newBody(world.physics,i*cellSize,j*cellSize,"static")
				wall.shape   = love.physics.newRectangleShape(cellSize/2,cellSize/2,cellSize,cellSize)
				wall.fixture = love.physics.newFixture(wall.body,wall.shape)
				wall.fixture:setUserData({type="Wall", value=wall})
				wall.fixture:setRestitution(1)
				table.insert(world.walls,wall)
			end
		end
	end
end
