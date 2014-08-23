local worldWidth  = 500; --in cells
local worldHeight = 500;

function newWorld(difficulty){
	local world = {}
	world.grid = new2DArray(worldWidth, worldHeight, 0);

	--todo generate environment
	world.difficulty = difficulty;
	world.entities = {}

	return world;
}