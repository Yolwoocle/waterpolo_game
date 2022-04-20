local Class = require "class"
local Actor = require "actor"

local Ball = Actor:inherit()

function Ball:init(x,y)
	self:init_actor(x,y)
	self.z = 0
	self.w = 32
	self.h = 32
	self.is_ball = true

	self.dx = 0
	self.dy = 0
	self.dz = 0

	self.radius = 10
	collision:add(self)
end

function Ball:update(dt)
	self:apply_movement(dt)
end

function Ball:draw()
	love.graphics.print("Ball", self.x, self.y)
	love.graphics.print(string.format("xy: %d, %d", self.x, self.y), 60,0)
end

function Ball:on_kick(other)
	if other.is_player then
		self.dx = self.dx + other.dx
		self.dy = self.dy + other.dy
	end
end

return Ball