
-- make an NxM array with Default
function new2DArray(n, m, d)
	local grid = {}
	for i = 1, n do
		grid[i] = {}
		for j = 1, m do
			grid[i][j] = d
		end
	end
	return grid;
end
