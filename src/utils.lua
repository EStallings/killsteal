
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
