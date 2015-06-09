Player = class('Player')

function Player:initialize(x, y)
	--self.maxHealth = 20
	--self.health = self.maxHealth
	self.damage = 1
	--self.defense = 1
	self.maxExp = 5
	self.exp = 0
	self.level = 1
	
	self.name = 'Hero'
end

function Player:keypressed(key)
	local dx, dy = 0, 0
	if key == 'right' then dx = 1 end
	if key == 'left' then dx = -1 end
	if key == 'up' then dy = -1 end
	if key == 'down' then dy = 1 end
	
	if dx ~= 0 or dy ~= 0 then
		game:movePlayer(dx, dy)
	end
	
	if key == ' ' then
		self:attack()
	end
end

function Player:mousepressed(button)
	if button == 'l' then
		self:attack()
	end
end

function Player:draw()
	local x, y = love.graphics.getWidth()/4-50, love.graphics.getHeight()/2
	
	love.graphics.setColor(0, 0, 255)
	love.graphics.print(self.name..'\nDamage: '..self.damage..'\nExp: '..self.exp..'/'..self.maxExp, x, y)
	love.graphics.rectangle('fill', x-150, y+100, 100, 100)
end


function Player:attack()
	local target = game:getTarget()
	if target.alive then
		--self.health = self.health - (target.damage - self.defense)
		target.health = target.health - (self.damage - target.defense)
		
		if target.health <= 0 then
			target:die()
			
			self.exp = self.exp + target.exp
			if self.exp >= self.maxExp then
				self.exp = self.exp - self.maxExp
				self:levelUp()
			end
		end
	end
end

function Player:levelUp()
	--self.maxHealth = self.maxHealth + math.random(1, 3)
	--self.health = self.maxHealth
	self.damage = self.damage + 1
	--self.defense = self.defense + math.random(0, 1)
	self.maxExp = self.maxExp + 5
	self.level = self.level + 1
end