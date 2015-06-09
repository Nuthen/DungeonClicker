game = {}

function game:enter()
	love.graphics.setBackgroundColor(186, 222, 208)

    self.map = Map:new(40, 40)
end

function game:update(dt)
	self.map:update(dt)
end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
	
	self.map:keypressed(key)
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
end

function game:draw()
    self.map:draw()
end