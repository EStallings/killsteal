
-- make an NxM array with Default
function new2DArray(n, m, d, rand)
	local grid = {}
	for i = 1, n do
		grid[i] = {}
		for j = 1, m do
			if(rand)then grid[i][j] = math.min(math.random(0,d),1)
			else grid[i][j] = d end
		end
	end
	return grid;
end

function copyGrid(grid)
	local copy = {}
	for i = 1, table.maxn(grid) do
		copy[i] = {}
		for j = 1, table.maxn(grid[i]) do
			copy[i][j] = grid[i][j]
		end
	end
	return copy
end

--distance between two entities
function distance(e1, e2)
	local x1 = e1.body:getX()
	local y1 = e1.body:getY()
	local x2 = e2.body:getX()
	local y2 = e2.body:getY()

	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end


function normalize(vec)
	local len = math.sqrt(vec.x*vec.x + vec.y*vec.y)
	return {x=vec.x/len, y=vec.y/len}
end