Map = class('Map')

function Map:initialize(width, height)
	self.width = width
	self.height = height
	
	--self.tiles = self:generate(self.tiles)
	
	self.search = 6
	
	self:start()
	
	self.playerX, self.playerY = 2, 2
end

function Map:update(dt)
	if self.generating then
		self:generate()
		if #self.cells == 0 then
			self.generating = false
		end
	else -- run other game stuff
	
	end
end

function Map:keypressed(key)
	local number = tonumber(key)
	if number and number <= 6 then
		self.search = number
		self:start()
	end
end

function Map:draw()
	local width, height = self.width, self.height
	local w, h = 32, 32
	
	for iy = 1, height do
		for ix = 1, width do
			local tile = self.tiles[iy][ix]
			if tile.check == 1 or tile.checking == 1 then
				local x, y = w*(ix-1)+w/2, h*(iy-1)+h/2
				love.graphics.setColor(255, 255, 255)
				if tile.checking == 1 then love.graphics.setColor(245, 95, 95) end
				if ix == self.playerX and iy == self.playerY then love.graphics.setColor(0, 0, 255) end
				love.graphics.rectangle('fill', x-w/2, y-h/2, w, h)
				
				love.graphics.setColor(0, 0, 0)
				for i = 1, #tile.doors do
					if tile.doors[i] == 0 then
						local dir = i
						local dx, dy = self:getMove(dir)
						dx, dy = dx*w/2, dy*h/2
						local nx, ny = x + dx, y + dy
						love.graphics.line(nx-dy, ny-dx, nx+dy, ny+dx)
						
					end
				end
			end
		end
	end
end


function Map:start()
	self.tiles = {}
	for iy = 1, self.height do
		self.tiles[iy] = {}
		for ix = 1, self.width do
			self.tiles[iy][ix] = {check = 0, checking = 0, doors = {0,0,0,0}}
		end
	end
	
	self.cells = {}
	
	local startX, startY = math.random(self.width), math.random(self.height)
	table.insert(self.cells, {startX, startY})
	self.tiles[startY][startX].checking = 1
	
	self.generating = true
end

function Map:generate(tiles)
	--[[cells = {}
	
	local startX, startY = math.random(self.width), math.random(self.height)
	table.insert(self.cells, {startX, startY})

	repeat]]
	
	if #self.cells > 0 then
		local index = self:getIndex(#self.cells) -- change to modify generation search preference
		local x, y = self.cells[index][1], self.cells[index][2]
		
		local dirs = {1,2,3,4}
		while #dirs > 0 do
			local dirIndex = math.random(#dirs)
			local dir = dirs[dirIndex]
			local dx, dy = self:getMove(dir)
			
			local nx, ny = x + dx, y + dy
			
			if nx >= 1 and ny >= 1 and nx <= self.width and ny <= self.height and self.tiles[ny][nx].check == 0 and self.tiles[ny][nx].checking == 0 then
				--tiles[y][x].doors[dir] = 1
				self.tiles[y][x].doors[dir] = 1
				
				local dir2 = dir + 2
				if dir2 > 4 then dir2 = dir2-4 end
				--tiles[ny][nx].doors[dir2] = 1
				self.tiles[ny][nx].doors[dir2] = 1
				
				table.insert(self.cells, {nx, ny})
				self.tiles[ny][nx].checking = 1
				index = nil
				break
			else
				table.remove(dirs, dirIndex)
			end
		end
		
		if index then
			--tiles[y][x].check = 1
			self.tiles[y][x].check = 1
			self.tiles[y][x].checking = 0
			table.remove(self.cells, index)
		end
	end
	
	--until #cells == 0
	
	--return tiles
end

function Map:getIndex(cellCount)
	local index = 1
	if self.search == 1 then -- searches oldest first
		index = 1
	elseif self.search == 2 then -- searches newest first
		index = cellCount
	elseif self.search == 3 then -- searches at random
		index = math.random(cellCount)
	elseif self.search == 4 then -- searches in the middle
		index = math.ceil(cellCount/2)
	elseif self.search == 5 then -- picks between oldest and newest
		local chance = math.random(2)
		if chance == 1 then
			index = 1
		else
			index = cellCount
		end
	elseif self.search == 6 then -- picks between oldest, newest, middle, random
		local chance = math.random(4)
		if chance == 1 then
			index = 1
		elseif chance == 2 then
			index = math.ceil(cellCount/2)
		elseif chance == 3 then
			index = cellCount
		else
			index = math.random(cellCount)
		end
	end
	
	return index
end

function Map:getMove(dir)
	local dx, dy = 0, 0
	if dir == 1 then
		dx, dy = 0, 1
	elseif dir == 2 then
		dx, dy = 1, 0
	elseif dir == 3 then
		dx, dy = 0, -1
	elseif dir == 4 then
		dx, dy = -1, 0
	end
	
	return dx, dy
end

function Map:movePlayer(dx, dy)
	if not self.generating then
		local x, y = self.playerX, self.playerY
		local nx, ny = x+dx, y+dy
		if nx >= 1 and ny >= 1 and nx <= self.width and ny <= self.height then
			local dir = 1
			if dy == 1 then dir = 1 end
			if dx == 1 then dir = 2 end
			if dy == -1 then dir = 3 end
			if dx == -1 then dir = 4 end
			
			local tile = self.tiles[y][x]
			if tile.doors[dir] == 1 then
				self.playerX, self.playerY = nx, ny
				
				return true
			end
		end
	end
end