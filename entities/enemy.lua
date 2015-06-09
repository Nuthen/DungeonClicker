Enemy = class('Enemy')

function Enemy:initialize()
	self:spawn()
end

function Enemy:spawn()
	self.maxHealth = math.random(2, 6) * game.player.level
	self.health = self.maxHealth
	self.damage = 2 * game.player.level
	self.defense = game.player.level
	self.exp = math.random(1, 3) * game.player.level
	self.name = 'ugly square'
	self.alive = true
end

function Enemy:draw()
	if self.alive then
		local x, y = love.graphics.getWidth()*3/4-50, love.graphics.getHeight()/2
		
		love.graphics.setColor(255, 0, 0)
		love.graphics.print(self.name..'\nHealth: '..self.health..'/'..self.maxHealth..'\nDamage: '..self.damage..'\nDefense: '..self.defense, x, y)
		love.graphics.rectangle('fill', x-150, y+100, 100, 100)
	end
end


function Enemy:die()
	self.alive = false
end