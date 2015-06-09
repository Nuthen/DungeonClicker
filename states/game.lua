game = {}

function game:enter()
	love.graphics.setBackgroundColor(186, 222, 208)

    self:restart()
end

function game:update(dt)
	self.map:update(dt)
end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
	
	self.player:keypressed(key)
	self.map:keypressed(key)
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
	
	self.player:mousepressed(mbutton)
end

function game:draw()
    self.map:draw()
	self.player:draw()
	self.enemy:draw()
end


function game:getMapSize()
	return self.map.width, self.map.height
end

function game:movePlayer(dx, dy)
	if not self.enemy.alive then
		moved = self.map:movePlayer(dx, dy)
		if moved then
			self.enemy:spawn()
		end
	end
end

function game:getTarget()
	return self.enemy
end

function game:restart()
	self.map = Map:new(10, 10)
	self.player = Player:new()
	self.enemy = Enemy:new()
end