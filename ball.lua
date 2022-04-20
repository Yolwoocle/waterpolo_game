local Class = require "class"
local Actor = require "actor"

local Ball = Actor:inherit()

function Ball:init(x,y)
	self:init_actor(x,y)
	self.z = 0
	self.w = 32
	self.h = 32
	self.is_ball = true
	self.is_boucy = true

	self.dx = 0
	self.dy = 0
	self.dz = 0

	self.radius = 10
	collision:add(self)
end

function Ball:update(dt)
	self:apply_movement(dt)
	self:apply_bounce(dt)
end

function Ball:draw()
	love.graphics.print("Ball", self.x, self.y)
	love.graphics.print(string.format("xy: %d, %d", self.x, self.y), 60,0)

	local w2 = self.w/2
	local x,y,r = self.x + w2, self.y + w2, math.sqrt(w2*w2 + w2*w2)
	love.graphics.setColor(0,0,1)
	love.graphics.circle("fill",x,y,r)
	love.graphics.setColor(1,1,1)

	for i, col in pairs(self.cols) do
		love.graphics.setColor(1,0,0)
		local x,y = col.touch.x, col.touch.y
		love.graphics.line(x,y, x+col.normal.x*30, y+col.normal.y*30)
	end
end

function Ball:on_kick(other)
	if other.is_player then
		self.dx = self.dx + other.dx
		self.dy = self.dy + other.dy
	end
end

function Ball:apply_bounce(dt)
	for i, col in pairs(self.cols) do
		if col.other.is_solid then
			-- Bounce
			if col.normal.x ~= 0 then   self.dx = self.dx * col.normal.x   end
			if col.normal.y ~= 0 then   self.dy = self.dy * col.normal.y   end
		end
	end
end

return Ball