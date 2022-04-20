local Class = require "class"

local Actor = Class:inherit()

function Actor:init_actor(x,y)
	self.type = "actor"
	self.name = "actor"
	self.x = x or 0
	self.y = y or 0
	self.cols = {}
end

function Actor:apply_movement(dt)
	-- Apply position
	self.cols = {}
	local goal_x = self.x + self.dx * dt
	local goal_y = self.y + self.dy * dt

	local actual_x, actual_y, cols, len = collision:move(self, goal_x, goal_y)
	self.cols = cols
	self.x = actual_x
	self.y = actual_y
end

function Actor:update()
	error("update not implemented")
end

function Actor:draw()
	error("draw not implemented")
end

return Actor