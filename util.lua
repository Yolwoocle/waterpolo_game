local utf8 = require "utf8"

function is_between(v, a, b)
	return a <= v and v <= b
end

function lighten_color(col, v)
	local ncol = {}
	for i,ch in pairs(col) do
		table.insert(ncol, ch+v)
	end
	return ncol
end

function rgb(r,g,b)
	return {r/255, g/255, b/255, 1}
end

function draw_centered_text(text, rect_x, rect_y, rect_w, rect_h, rot, sx, sy, font)
	rot = rot or 0
	sx = sx or 1
	sy = sy or sx
	local deffont = love.graphics.getFont()
	local font   = font or love.graphics.getFont()
	local text_w = font:getWidth(text)
	local text_h = font:getHeight(text)
	local x = math.floor(rect_x+rect_w/2)
	local y = math.floor(rect_y+rect_h/2)

	love.graphics.setFont(font)
	love.graphics.print(text, x, y, rot, sx, sy, math.floor(text_w/2), math.floor(text_h/2))
	love.graphics.setFont(deffont)
end

function print_centered(text, x, y, rot, sx, sy)
	rot = rot or 0
	sx = sx or 1
	sy = sy or sx
	local font   = love.graphics.getFont()
	local text_w = font:getWidth(text)
	local text_h = font:getHeight(text)
	love.graphics.print(text, x-text_w/2, y-text_h/2, rot, sx, sy)
end

function get_text_width(text, font)
	local font = font or love.graphics.getFont()
	return font:getWidth(text)
end

function get_text_height(text, font)
	local font = font or love.graphics.getFont()
	return font:getHeight(text)
end

function print_justify_right(text, x, y)
	local w = get_text_width(text)
	love.graphics.print(text, x-w, y)
	return x-w, y
end

function concat(...)
	local args = {...}
	local s = ""
	for _,v in pairs(args) do
		s = s..tostring(v)
	end
	return s
end

function concatsep(tab, sep)
	sep = sep or " "
	local s = tab[1]
	for i=2,#tab do
		s = s..sep..tostring(tab[i])
	end
	return s
end

function concat_keys(tab, sep)
	sep = sep or " "
	local s = ""
	for k,v in pairs(tab) do
		s = s..sep..tostring(k)
	end
	return utf8.sub(s, 2, -1)
end

function bool_to_int(b)
	if b then
		return 1
	end
	return 0
end

function clamp(val, lower, upper)
	assert(val and lower and upper, "One of the clamp values is not defined")
	if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
	return math.max(lower, math.min(upper, val))
end

function smooth_circle(type, x, y, r, col)
	love.graphics.setColor(col)
	love.graphics.setPointSize(r)
	love.graphics.setPointStyle("smooth")
	love.graphics.points(x,y)
	love.graphics.setColor(1,1,1)
end

function get_rank_color(rank, defcol)
	if rank == 1 then
		return rgb(255,206,33)
	elseif rank == 2 then
		return rgb(120,163,193)
	elseif rank == 3 then
		return rgb(218,75,29)
	else
		return defcol
	end
end

function split_str(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function draw_rank_medal(rank, defcol, x, y)
	--- Circle
	local rank_col = get_rank_color(rank, defcol)
	love.graphics.setColor(rank_col)
	love.graphics.draw(img.circle, x, y)
	--- Text
	love.graphics.setColor(1,1,1)
	print_centered(rank, x+16, y+16)
	--- 1"er", 2"e"...
	local e = rank==1 and "er" or "e"
	print_centered(e, x+32, y+12, 0, .75)
end

function tobool(str)
	return str ~= "false" -- Anything other than "false" returns as true
end

function random_neighbor(n)
	return love.math.random()*2*n - n
end

function random_range(a,b)
	return love.math.random()*(b-a) + a
end

function random_sample(t)
	return t[love.math.random(1,#t)]
end

--[[
function utf8.sub(str, i, j)
	local offseti = utf8.offset(str, i or 1)
	local offsetj = utf8.offset(str, j+1 or 0)-1
	if offseti and (offsetj or not j) then
		return str:sub(offseti, j and offsetj)
	end
	return str
end
function utf8.sub(str, i, j)
	if utf8.len(str) == 0 then  return ""  end
  local ii = utf8.offset(str, i)
  local jj = utf8.offset(str, j)-1
	return string.sub(str, ii, jj)
end

function utf8.sub(str, i, j)
	str = str or ""
	str = tostring(str)
	i = i or 1
	j = j or 1
	--if i < 0 then   i = uft8.len(str)-i+1   end
	--if j < 0 then   j = uft8.len(str)-j+1   end
	local len = utf8.len(str)
	if i > len then   i = len   end
	if j > len then   j = len   end
	if utf8.len(str) == 0 then  return ""  end
	print(str,i, j, len)
	local ii = utf8.offset(str, i)
  local jj = utf8.offset(str, j)+1
	return string.sub(ii, jj)
end
--]]

-- Thanks to "index five" on Discord
local utf8pos, utf8len = utf8.offset, utf8.len
local sub = string.sub
local max, min = math.max, math.min

function posrelat(pos, len)
	if pos >= 0 then return pos end
	if -pos > len then return 0 end
	return pos + len + 1
end

function utf8.sub(str, i, j)
	local len = utf8len(str)
	i, j = max(posrelat(i, len), 1), j and min(posrelat(j, len), len) or len
	if i <= j  then
		return sub(str, utf8pos(str, i), utf8pos(str, j + 1) - 1)
	end
	return ""
end


function sanitize_input(text)
	return text
end

function print_color(text, x, y, col)
	col = col or {1,1,1,1}
	love.graphics.setColor(col)
	love.graphics.print(text, x, y)
	love.graphics.setColor(1,1,1,1)
end

--[[
function utf8.sub(s, i, j)
	if #s == 0 then return "" end
	-- https://stackoverflow.com/questions/43138867/lua-unicode-using-string-sub-with-two-byted-chars
	i = math.max(i, 1)
	j = math.max(j, 1)
	return utf8.char(utf8.codepoint(s, i, j))
end
--]]