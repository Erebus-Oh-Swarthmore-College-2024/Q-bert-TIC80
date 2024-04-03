-- title:   Q*Bert
-- author:  game developer, email, etc.
-- desc:    Tic80 Adaptation of Q*bert. Character Q must change all yellow tiles to blue to win the game. Tomato (villain) tries to change tiles back to yellow.
-- site:    website link
-- license: MIT License 
-- version: 0.1
-- script:  lua


-- Sprite IDs
QBERTID = 28
VILLID = 30
LOWQ = 71
HIGHQ = 76

blueCubeTileIDs = {
	upperLeftTop = 24,
	lowerLeftTop = 39,
	upperRightTop = 25,
	lowerRightTop = 42,
	upperLeft = 18,
	lowerLeft = 33,
	upperRight = 19,
	lowerRight = 36,
	solid = 34
}

yellowCubeTileIDs = {
	upperLeftTop = 155,
	lowerLeftTop = 170,
	upperRightTop = 156,
	lowerRightTop = 173,
	upperLeft = 148,
	lowerLeft = 163,
	upperRight = 149,
	lowerRight = 166,
	solid = 164
}

local changeCube = 0 --used later to change when villain lands on cube
-- Pyramid cube class
-- put cube platform information in class, linked list
cube = {}
-- create cube at coords
function cube:new(x1, y1, x2, y2, t, color1)
	local o = {mx = x1, my = y1, qx = x2, qy = y2, 
	upright = nil, upleft = nil, downright = nil, downleft = nil, changed = false, cubeType = t, color = color1}
	setmetatable(o, {__index = cube})
	return o
end
-- update cube colors when Q*bert lands on them
function cube:change()
	if self.color == "yellow" then -- cube is currently yellow, change to blue
		if self.cubeType == "top" then
			-- left side
			mset(self.mx, self.my, blueCubeTileIDs.upperLeftTop)
			mset(self.mx - 1, self.my + 1, blueCubeTileIDs.lowerLeftTop)
			-- right side
			mset(self.mx + 1, self.my, blueCubeTileIDs.upperRightTop)
			mset(self.mx + 2, self.my + 1, blueCubeTileIDs.lowerRightTop)
		elseif self.cubeType == "left" then -- left edge of pyramid
			-- left side
			mset(self.mx, self.my, blueCubeTileIDs.upperLeftTop)
			mset(self.mx - 1, self.my + 1, blueCubeTileIDs.lowerLeftTop)
			--right side
			mset(self.mx + 1, self.my, blueCubeTileIDs.upperRight)
			mset(self.mx + 2, self.my + 1, blueCubeTileIDs.lowerRight)
		elseif self.cubeType == "right" then -- right edge of pyramid
			-- left side
			mset(self.mx, self.my, blueCubeTileIDs.upperLeft)
			mset(self.mx - 1, self.my + 1, blueCubeTileIDs.lowerLeft)
			--right side
			mset(self.mx + 1, self.my, blueCubeTileIDs.upperRightTop)
			mset(self.mx + 2, self.my + 1, blueCubeTileIDs.lowerRightTop)

		else -- normal middle cube
			-- left side
			mset(self.mx, self.my, blueCubeTileIDs.upperLeft)
			mset(self.mx - 1, self.my + 1, blueCubeTileIDs.lowerLeft)
			--right side
			mset(self.mx + 1, self.my, blueCubeTileIDs.upperRight)
			mset(self.mx + 2, self.my + 1, blueCubeTileIDs.lowerRight)
		end

		-- change solid
		mset(self.mx, self.my + 1, blueCubeTileIDs.solid)
		mset(self.mx + 1, self.my + 1, blueCubeTileIDs.solid)
		self.color = "blue"

	else -- cube is currently blue, change back to yellow
		if self.cubeType == "top" then
			-- left side
			mset(self.mx, self.my, yellowCubeTileIDs.upperLeftTop)
			mset(self.mx - 1, self.my + 1, yellowCubeTileIDs.lowerLeftTop)
			-- right side
			mset(self.mx + 1, self.my, yellowCubeTileIDs.upperRightTop)
			mset(self.mx + 2, self.my + 1, yellowCubeTileIDs.lowerRightTop)
		elseif self.cubeType == "left" then -- left edge of pyramid
			-- left side
			mset(self.mx, self.my, yellowCubeTileIDs.upperLeftTop)
			mset(self.mx - 1, self.my + 1, yellowCubeTileIDs.lowerLeftTop)
			--right side
			mset(self.mx + 1, self.my, yellowCubeTileIDs.upperRight)
			mset(self.mx + 2, self.my + 1, yellowCubeTileIDs.lowerRight)
		elseif self.cubeType == "right" then -- right edge of pyramid
			-- left side
			mset(self.mx, self.my, yellowCubeTileIDs.upperLeft)
			mset(self.mx - 1, self.my + 1, yellowCubeTileIDs.lowerLeft)
			--right side
			mset(self.mx + 1, self.my, yellowCubeTileIDs.upperRightTop)
			mset(self.mx + 2, self.my + 1, yellowCubeTileIDs.lowerRightTop)

		else -- normal middle cube
			-- left side
			mset(self.mx, self.my, yellowCubeTileIDs.upperLeft)
			mset(self.mx - 1, self.my + 1, yellowCubeTileIDs.lowerLeft)
			--right side
			mset(self.mx + 1, self.my, yellowCubeTileIDs.upperRight)
			mset(self.mx + 2, self.my + 1, yellowCubeTileIDs.lowerRight)
		end

		-- change solid
		mset(self.mx, self.my + 1, yellowCubeTileIDs.solid)
		mset(self.mx + 1, self.my + 1, yellowCubeTileIDs.solid)

		self.color = "yellow"
		self.changed = false
	end
end
-- TODO write more
function cube:update()
	if self.changed and self.color == "yellow" then
		self:change()
	elseif not self.changed and self.color == "blue" then
		self:change()
	end
end

-- create linked list
-- first
local c1 = cube:new(13, 2, 105, 17, "top", "yellow")

-- second
local c2 = cube:new(11, 4, 89, 33, "left", "yellow")
local c3 = cube:new(15, 4, 121, 33, "right", "yellow")

-- third
local c4 = cube:new(9, 6, 73, 49, "left", "yellow")
local c5 = cube:new(13, 6, 105, 49, "middle", "yellow")
local c6 = cube:new(17, 6, 137, 49, "right", "yellow")

-- fourth
local c7 = cube:new(7, 8, 57, 65, "left", "yellow")
local c8 = cube:new(11, 8, 89, 65, "middle", "yellow")
local c9 = cube:new(15, 8, 121, 65, "middle", "yellow")
local c10 = cube:new(19, 8, 153, 65, "right", "yellow")

-- ffth
local c11 = cube:new(5, 10, 41, 81, "left", "yellow")
local c12 = cube:new(9, 10, 73, 81, "middle", "yellow")
local c13 = cube:new(13, 10, 105, 81, "middle", "yellow")
local c14 = cube:new(17, 10, 137, 81, "middle", "yellow")
local c15 = cube:new(21, 10, 169, 81, "right", "yellow")

-- build linked list pyramid
c1.downleft = c2
c1.downright = c3

c2.upright = c1
c2.downleft = c4
c2.downright = c5

c3.upleft = c1
c3.downleft = c5
c3.downright = c6

c4.upright = c2
c4.downleft = c7
c4.downright = c8

c5.upleft = c2
c5.upright = c3
c5.downleft = c8
c5.downright = c9

c6.upleft = c3
c6.downleft = c9
c6.downright = c10

c7.upright = c4
c7.downleft = c11
c7.downright = c12

c8.upleft = c4
c8.upright = c5
c8.downleft = c12
c8.downright = c13

c9.upleft = c5
c9.upright = c6
c9.downleft = c13
c9.downright = c14

c10.upleft = c6
c10.downleft = c14
c10.downright = c15

c11.upright = c7

c12.upleft = c7
c12.upright = c8

c13.upleft = c8
c13.upright = c9

c14.upleft = c9
c14.upright = c10

c15.upleft = c10

-- list of all cubes
local pyramid = {c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15}

-- qbert class info
character = {}
function character:new(init)
	local o = {x = init.qx, y = init.qy, vx = 0, vy = 0, flip = 0, falling = 0, oncube = init}
	setmetatable(o, {__index = character})
	return o
end

function character:update(newcube)
	self.x = newcube.qx
	self.y = newcube.qy
	self.oncube = newcube
	self.oncube.changed = true
end

local qbert = character:new(c1) --can use similar code to draw evil tomato
local villain = character:new(c5)
local timer_current = 0
local timer_delay = 100

function drawVil() -- need to do on a timer
	spr(VILLID, villain.x, villain.y, 11, 1, 0, 0, 2, 2)
	-- if villain.oncube.color == "blue" and qbert.oncube ~= villain.oncube then -- TRISHA COME BACK HERE
	-- 	villain.oncube:change()
	-- end
		
end

function moveVill()
	timer_current = timer_current + 1
	movecube = villain.oncube
	if timer_current > timer_delay then
		movecube = randomCube()
		villain.oncube = movecube
		timer_current = 0
		if villain.oncube.color == "blue" then
			villain.oncube:change()
		end
	end
	
	--movecube:change()
	villain.x = movecube.qx
	villain.y = movecube.qy
	--want to move villain to new randomly picked cube then set villain x and y to newcube's x and y
end

function randomCube()
	local r = math.random(1,15)
	--pyramid[r]:change()
	changeCube = r
	return pyramid[r]
end

function drawQ()
	spr(QBERTID, qbert.x, qbert.y, 11, 1, qbert.flip, 0, 2, 2)
	--still trying to implement an actual jump animation
	moveQ()
end

--sprite placement code

local next_x = 0
local next_y = 0


local state_var = "default" -- default, jumping, gameover(fell off)
local nextcube = qbert.oncube

function resetGame()
	qbert = character:new(c1)
	for i in pairs(pyramid) do
		pyramid[i].changed = false
		pyramid[i].color = "yellow"
		pyramid[i]:change()
		pyramid[i]:change()
	end
	map(0,0,30,20)
end

function checkWin()
	for i in pairs(pyramid) do
		if not pyramid[i].changed then
			return false
		end
	end

	return true
end

function TIC()

	-- draw map
	map(0,0,30,20)
	-- moveQ()
	-- stayOnScreen()

	-- define state transitions
	if state_var == "jumping" then
		-- when reach destination, change state to default
	elseif state_var == "default" then
		-- change to jumping when key pressed
		if qbert.falling == true or checkWin() then
			state_var = "gameover"
			sfx(0, 'B-3', 80)
		end
	elseif state_var == "gameover" then
		if btnp(4) then -- z button
			state_var = "default"
			resetGame()
		end
	else
		print("unknown state")
	end

	-- define what to do in each state
	if state_var == "jumping" then
		-- todo make hm jump?
		-- qbert on previous cube
		-- nextcube has next x/y
		-- continue drawing/animating qberts jump

	elseif state_var == "gameover" then
		if checkWin() then
			print("You Won!", 0, 0, 2)
			drawQ()
			--timer.Create("villainTimer", 7, 100, drawVil())
			drawVil()
		else
			print("You fell off! Game Over :(", 0, 0, 2)
		end
		print("Press Z to restart", 0, 10, 2)
	else
			-- map input to qbert movement
			nextcube = qbert.oncube

		if btnp(0) then -- up = up right
			nextcube = qbert.oncube.upright
			-- state_var = "jumping"
			sfx(1, 'F-4', 10)
		end
		if btnp(1) then -- down = down left
			nextcube = qbert.oncube.downleft
			-- state_var = "jumping"
			sfx(1, 'F-4', 10)
		end
		if btnp(2) then -- left = up left
			nextcube = qbert.oncube.upleft
			-- state_var = "jumping"
			sfx(1, 'F-4', 10)
		end
		if btnp(3) then --right = down right
			nextcube = qbert.oncube.downright
			-- state_var = "jumping"
			sfx(1, 'F-4', 10)
		end

		if nextcube == nil then
			qbert.falling = true
			-- print("qbert fell :(", 0, 0, 2)
			nextcube = qbert.oncube -- temporary, prevent crashing
		else
			qbert:update(nextcube)
			qbert.oncube:update()
			drawQ()
			drawVil()
			--TODO: call moveVill on a timer:
			moveVill()
			
			
		end

	end

	


	
	-- local statetext = "State: " .. state_var
	-- local debugtext = "Q*BERT Loc: " .. qbert.x .. "," .. qbert.y
	-- print(debugtext, 5, 120, 2)
	-- print(statetext, 5, 130, 2)

	-- not working
	-- if checkGameOver() then
	-- 	print("Game Over!", 100, 120, 2)
	-- end

	

	-- ignore this, saving the hardcoded numbers just in case
	--first
	-- spr(28, Q.x, Q.y, 11, 1, Q.flip, 0, 2, 2)
	--spr(28, 105, 17, 11, 1, 0, 0, 2, 2) -- start position
	-- -- second
	-- --spr(28, 89, 33, 11, 1, 0, 0, 2, 2) -- left second
	-- spr(28, 121, 33, 11, 1, 0, 0, 2, 2) -- right second
	-- -- third
	-- spr(28, 73, 49, 11, 1, 0, 0, 2, 2) -- left third
	-- spr(28, 105, 49, 11, 1, 0, 0, 2, 2) -- middle third
	-- spr(28, 137, 49, 11, 1, 0, 0, 2, 2) -- right third
	-- -- fourth
	-- spr(28, 57, 65, 11, 1, 0, 0, 2, 2) -- left fourth
	-- spr(28, 89, 65, 11, 1, 0, 0, 2, 2) -- middle left fourth
	-- spr(28, 121, 65, 11, 1, 0, 0, 2, 2) -- middle right fourth
	-- spr(28, 153, 65, 11, 1, 0, 0, 2, 2) -- right fourth
	-- -- fifth
	-- spr(28, 41, 81, 11, 1, 0, 0, 2, 2) -- left fifth
	-- spr(28, 73, 81, 11, 1, 0, 0, 2, 2) -- middle left fifth
	-- spr(28, 105, 81, 11, 1, 0, 0, 2, 2) -- middle fifth
	-- spr(28, 137, 81, 11, 1, 0, 0, 2, 2) -- middle right fifth
	-- spr(28, 169, 81, 11, 1, 0, 0, 2, 2) -- right fifth


end

--gravity = 0.2
-- jump animation code
--spr(QBERTID, qbert.x, qbert.y, 11, 1, 0, 0, 2, 2)
--*code for moveQ inspired by: https://www.youtube.com/watch?v=L8Q0bMHccko
function moveQ() -- want to use new cube's x and y
	--directional movement
	if btn(2) then
		qbert.vx = -1*0.5
		qbert.flip = 1
	elseif btn(3) then
		qbert.vx = 0.5
		qbert.flip = 0
	else
		qbert.vx = 0
	end

	--Jump if any button key is pressed
	--if btnp(0) then
		--sfx(1, 30)
	--	qbert.vy = -2.5
	--	qbert.y = y -- intended next y
	--	qbert.x = x -- intended next x
	--elseif qbert.y > y then -- new boundary is intended y of new cube to jump to
	--	qbert.vy = 0 
	--else
	--	qbert.vy = qbert.vy + 0.2 --gravity = 0.2
	--end

	--update position
	qbert.x = qbert.x + qbert.vx
	--qbert.y = qbert.y + qbert.vy
	--spr(QBERTID, qbert.x, qbert.y, 11, 1, qbert.flip, 0, 2, 2)

end


-- <TILES>
-- 017:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 018:eeeeeee0eeeeee09eeeee099eeee0999eee09999ee099999e099999909999999
-- 019:0777777790777777990777779990777799990777999990779999990799999990
-- 020:7777777777777777777777777777777777777777777777777777777777777777
-- 024:0000000000000009000000990000099900009999000999990099999909999999
-- 025:0000000090000000990000009990000099990000999990009999990099999990
-- 028:bbbbbbbbbbbbbbbbbbbbbbbbbbbbb333bbbb3333bbbb33c3bbb33303bbb33333
-- 029:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbc3bbbbbb0333bbbb3333bbbb
-- 030:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb2222bbb22c22bb22c222
-- 031:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb22bbbbbb222bbbbb2222bbbb
-- 033:eeeeeee0eeeeee09eeeee099eeee0999eee09999ee099999e099999900000000
-- 034:9999999999999999999999999999999999999999999999999999999900000000
-- 035:9999999999999999999999999999999999999999999999999999999900000000
-- 036:0777777790777777990777779990777799990777999990779999990700000000
-- 039:0000000000000009000000990000099900009999000999990099999900000000
-- 042:0000000090000000990000009990000099990000999990009999990000000000
-- 044:bbbb3333bbbbb3b3bbbbb3b3bbbb33b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 045:3bbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 046:bb222222bbb22222bbbb2222bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 047:2022bbbb022bbbbb22bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 049:0eeeeeee90eeeeee990eeeee9990eeee99990eee999990ee9999990e99999990
-- 050:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 051:7777777777777777777777777777777777777777777777777777777777777777
-- 052:7777777077777709777770997777099977709999770999997099999909999999
-- 065:9999999999999999999999999999999999999999999999999999999900000000
-- 066:0eeeeeee90eeeeee990eeeee9990eeee99990eee999990ee9999990e00000000
-- 067:7777777077777709777770997777099977709999770999997099999900000000
-- 068:9999999999999999999999999999999999999999999999999999999900000000
-- 071:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb333bbbb3333
-- 072:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbb
-- 076:bbbbb333bbbb3333bbbb33c3bbb33303bbb33333bbbb3333bbbbb3b3bbbbb3b3
-- 077:bbbbbbbb3bbbbbbbc3bbbbbb0333bbbb3333bbbb3bbbbbbbbbbbbbbbbbbbbbbb
-- 087:bbbb33c3bbb33303bbb33333bbbb3333bbbbb3b3bbbbb3b3bbbbb3b3bbbb33b3
-- 088:c3bbbbbb0333bbbb3333bbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbb
-- 092:bbbb33b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 093:3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 147:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 148:eeeeeee0eeeeee04eeeee044eeee0444eee04444ee044444e044444404444444
-- 149:0777777740777777440777774440777744440777444440774444440744444440
-- 150:7777777777777777777777777777777777777777777777777777777777777777
-- 151:eeeeeee0eeeeee04eeeee044eeee0444eee04444ee044444e0444444e0000000
-- 152:0777777740777777440777774440777744440777444440774444440700000007
-- 155:0000000000000004000000440000044400004444000444440044444404444444
-- 156:0000000040000000440000004440000044440000444440004444440044444440
-- 163:eeeeeee0eeeeee04eeeee044eeee0444eee04444ee044444e044444400000000
-- 164:4444444444444444444444444444444444444444444444444444444400000000
-- 165:4444444444444444444444444444444444444444444444444444444400000000
-- 166:0777777740777777440777774440777744440777444440774444440700000000
-- 167:0eeeeeee40eeeeee440eeeee4440eeee44440eee444440ee4444440e00000000
-- 168:7777777077777704777770447777044477704444770444447044444400000000
-- 170:0000000000000004000000440000044400004444000444440044444400000000
-- 173:0000000040000000440000004440000044440000444440004444440000000000
-- 179:0eeeeeee40eeeeee440eeeee4440eeee44440eee444440ee4444440e44444440
-- 180:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 181:7777777777777777777777777777777777777777777777777777777777777777
-- 182:7777777077777704777770447777044477704444770444447044444404444444
-- 195:4444444444444444444444444444444444444444444444444444444400000000
-- 196:0eeeeeee40eeeeee440eeeee4440eeee44440eee444440ee4444440e00000000
-- 197:7777777077777704777770447777044477704444770444447044444400000000
-- 198:4444444444444444444444444444444444444444444444444444444400000000
-- 202:0eeeeeee00eeeeee000eeeee0000eeee00000eee000000ee0000000e00000000
-- 205:7777777077777700777770007777000077700000770000007000000000000000
-- 219:0eeeeeee00eeeeee000eeeee0000eeee00000eee000000ee0000000e00000000
-- 220:7777777077777700777770007777000077700000770000007000000000000000
-- </TILES>

-- <MAP>
-- 001:000000000000000000000028384858680000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:00000000000000000000002950b9c9500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:00000000000000000000002aaa4a5ada0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:0000000000000000000050b959693949c950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:00000000000000000000aa4a5a6a3a4a5ada000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:000000000000000050b95969394959693949c95000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:0000000000000000aa4a5a6a3a4a5a6a3a4a5ada00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:00000000000050b9596939495969394959693949c9500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:000000000000aa4a5a6a3a4a5a6a3a4a5a6a3a4a5ada0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:0000000050b959693949596939495969394959693949c950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:00000000aa4a5a6a3a4a5a6a3a4a5a6a3a4a5a6a3a4a5ada000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:00000000ac4b5bdcac4b5bdcac4b5bdcac4b5bdcac4b5bdc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:0000000050acdc5050acdc5050acdc5050acdc5050acdc50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 003:22226666222266666aaaaa66666aaaaa
-- 006:2689abbcddeeffffffeeeddcba988764
-- </WAVES>

-- <SFX>
-- 000:23d323d323c333c333b333b343b343a343a35393539353836382638273728372836293619351b351b351c341c342d342d332d332d332d322e322e32226b000000000
-- 001:664e664e664e664e664e664e664e668e668e668e668e668e668e668e66ce66c366c466c566c666c666c666f666f666f766f766f766f766f766f766f7b15000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

