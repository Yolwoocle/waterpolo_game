local Class = require "class"
local Tile = require "tile"

local TileMap = Class:inherit()

function TileMap:init(w,h)
	self.map = {}
	self.width = w
	self.height = h
	self.tile_size = 32

	for i=0,w-1 do
		self.map[i] = {}
		for j=0,h-1 do
			self.map[i][j] = Tile:new(i,j, self.tile_size)
		end
	end

	self:init_arena()
end

function TileMap:update(dt)
	self:for_all_tiles(function(tile)
		tile:update(dt)
	end)
end

function TileMap:draw()
	self:for_all_tiles(function(tile)
		tile:draw()
	end)
end


function TileMap:for_all_tiles(func)
	for i=0,self.width-1 do
		for j=0,self.height-1 do
			func(self.map[i][j])
		end
	end
end

function TileMap:get_tile(x,y)
	if not self:is_valid_tile(x,y) then   return   end
	return self.map[x][y]
end

function TileMap:set_tile(x,y,tile)
	if not self:is_valid_tile(x,y) then   return   end
	self.map[x][y] = tile
end

function TileMap:set_solid(x,y, val)
	if val then
		local tile = self:get_tile(x,y)
		self:get_tile(x,y).is_solid = true
		collision:add(tile, tile.x, tile.y, tile.w, tile.w)
	else
		self.map[x][y].is_solid = false
		collision:remove(self.map[x][y])	
	end
end

function TileMap:is_valid_tile(x,y)
	return x >= 0 and x < self.width and y >= 0 and y < self.height
end

function TileMap:init_arena()
	for i=0,self.width-1 do
		for j=0,self.height-1 do
			if i == 0 or i == self.width-1 or j == 0 or j == self.height-1 then
				self:set_solid(i,j,true)
			end
		end
	end
end

return TileMap