
-- in cells
local worldWidth  = 500;
local worldHeight = 500;

-- TODO generate environment
function newWorld(difficulty)

	local world = {}

	world.grid = new2DArray(worldWidth, worldHeight, 0);
	world.difficulty = difficulty;
	world.entities = {}

	return world;
end
