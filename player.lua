local Class = require "class"
local Actor = require "actor"

local Player = Actor:inherit()

function Player:init(x,y)
	self:init_actor(x,y)
	self.is_player = true

	self.x = x or 0
	self.y = y or 0

	self.w = 32
	self.h = 32

	self.dx = 0
	self.dy = 0

	self.is_dashing = false
	self.cols = {}

	self.speed = 0
	self.speed_normal = 40
	self.speed_dash = 90
	self.friction = 0.9 -- This assumes that the game is running at 60FPS

	collision:add(self, self.x, self.y, self.w, self.h)
end

function Player:keypressed( key, scancode, isrepeat )
end

function Player:update(dt)
	self.is_dashing = love.keyboard.isDown("space")
	self.speed = self.is_dashing and self.speed_dash or self.speed_normal
	
	self.dt = dt
	self:move(dt)
	self:update_collision(dt)
end

function Player:draw()
	love.graphics.setColor(1,0,0)
	if self.is_dashing then   love.graphics.setColor(1,0,0,0.5) end
	love.graphics.rectangle("fill", self.x, self.y, 32, 32)
	love.graphics.setColor(1,1,1)

	if not self.dt then self.dt = 1 end
	love.graphics.print(string.format("x: %.6f",self.x), 0,20)
	love.graphics.print(string.format("y: %.6f",self.y), 0,40)

	if not self.cols then self.cols = {} end
	love.graphics.print(#self.cols, self.x,self.y-40)
	for i=1, #self.cols do
		local col = self.cols[i].itemRect
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("line", col.x, col.y, col.w, col.h)
		love.graphics.setColor(1,1,1,1)
	end
end

function Player:move(dt)
	-- compute movement dir
	local dir = {x=0, y=0}
	if love.keyboard.isScancodeDown('a') then   dir.x = dir.x - 1   end
	if love.keyboard.isScancodeDown('d') then   dir.x = dir.x + 1   end
	if love.keyboard.isScancodeDown('w') then   dir.y = dir.y - 1   end
	if love.keyboard.isScancodeDown('s') then   dir.y = dir.y + 1   end

	-- apply velocity 
	self.dx = self.dx + dir.x * self.speed 
	self.dy = self.dy + dir.y * self.speed 

	-- apply friction
	self.dx = self.dx * self.friction
	self.dy = self.dy * self.friction
	
	self:apply_movement(dt)
end

function Player:update_collision(dt)
	for i, col in pairs(self.cols) do
		if col.other.is_ball then
			col.other:on_kick(self)
		end
	end
end

return Player