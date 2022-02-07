--[==[
    Main block game engine for example block game
    Copyright (C) 2021 Lilla Oshisaure

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]==]

Board = {
	lock_delay = 2,
	maxrots = 99,--15,
    gravity = 1,
    AS_delay = 0.25, --15f@60fps
	AS_repeat = 1/60, --1f@60fps
	spawn_delay = 0.5,
	--startbag = {"I", "T", "L", "J", "O"}, -- 7-bag with no SZ
	-- startbag = {"I", "T", "L", "J", "O", "S", "Z"}, -- re-introduction of SZ in starting bag after 2-history addition
	mainbag = {'I', 'I', 'L', 'L', 'J', 'J', 'S', 'S', 'Z', 'Z', 'T', 'T', 'O', 'O'}, -- changed again to 14-bag strict 3-history
    starthistory = {'S', 'Z', 'O'},                                                   -- with no starting bag since history starts at SZO
	-- mainbag = {'test'},
	-- mainbag = {'I'},
	-- mainbag = {'I', 'L', 'J', 'S', 'Z', 'T', 'O', 'F5l', 'F5r', 'I5', 'L5l', 'L5r', 'N5l', 'N5r', 'P5l', 'P5r', 'T5', 'U5', 'V5', 'W5', 'X5', 'Y5l', 'Y5r', 'Z5l', 'Z5r' },
	-- mainbag = {'I', 'L', 'J', 'S', 'Z', 'T', 'O', 'F5l', 'F5r', 'I5', 'L5l', 'L5r', 'N5l', 'N5r', 'P5l', 'P5r', 'T5', 'U5', 'V5', 'W5', 'X5', 'Y5l', 'Y5r', 'Z5l', 'Z5r', 'w6' },
	events = {"update", "shift", "drop", "place", "hold", "drawpiece", "drawfield", "drawnext", "drawghost"},
    
    getScore = function(board, linecount)
        local base = linecount * (linecount + 1)       -- 0,  2,  6, 12, 20
        if board.spin then base = 2^(linecount+2) end  -- 4,  8, 16, 32, 64
        return base * board.level * 1000
    end,
	
	check_cell = function(board, x, y)
		-- returns true if cell is blocked/oob
		if x > 10 or x < 1 or y <= 0 or board.grid[x][y] then return true end
		return false
	end,
	
	check_collision_with = function(board, piece)
		-- return true on collision
		local o = piece.orientation
		for b = 1, #piece.blocks[o] do
			local x, y = piece.blocks[o][b][1], piece.blocks[o][b][2]
			if board:check_cell(x + piece.x, y + piece.y) then return true end
		end
		return false
	end,
	
	check_spin = function(board)
		-- immobile check on current piece
		local piece = board.piece
		local x, y = piece.x, piece.y
		piece.y = y + 1
		local up = board:check_collision_with(piece)
		piece.y = y
		piece.x = x - 1
		local left = board:check_collision_with(piece)
		piece.x = x + 1
		local right = board:check_collision_with(piece)
		piece.x = x
		return up and left and right
	end,
	
	update_ghost = function(board)
		-- update ghost piece position by simulating a harddrop of the current piece
		local ghost, piece = board.ghost, board.piece
		ghost.orientation = piece.orientation
		ghost.x = piece.x
		ghost.y = piece.y
		repeat ghost.y = ghost.y - 1 until board:check_collision_with(ghost)
		ghost.y = ghost.y + 1
	end,
	
	create_ghost = function(board)
		-- create a copy of the active piece to be stored in as ghost piece
		board.ghost = Deepcopy(board.piece)
		board:update_ghost()
	end,
	
	rotate_cw = function(board)
        local kik = board.piece:rotateCW(board)
		if kik then
            board.cur_rots = board.cur_rots + 1
            board.spin = board:check_spin()
            if board.spin then board.last_collision_cw = board.time end
            board.last_rotate_point = board.piece:get_rotate_point("cw", kik)
            board.last_rotate_time  = board.time
            board.last_rotate_dir   = -1
            board:update_ghost() -- update ghost on rotate
			
			PlaySFX("classic_rotate")
        end
	end,
	
	rotate_ccw = function(board)
        local kik = board.piece:rotateCCW(board)
        if kik then
            board.cur_rots = board.cur_rots + 1
            board.spin = board:check_spin()
            if board.spin then board.last_collision_ccw = board.time end
            board.last_rotate_point = board.piece:get_rotate_point("ccw", kik)
            board.last_rotate_time  = board.time
            board.last_rotate_dir   = 1
            board:update_ghost() -- update ghost on rotate
			
			PlaySFX("classic_rotate")
        end
	end,

	initial_rotate = function(board, input)
		local s = false
		if input.cw1  and not (input.ccw1 or input.ccw2 or input.ccw3 or input.ccw4) then s = board.piece:rotateCW (board) end
		if input.cw2  and not (input.ccw1 or input.ccw2 or input.ccw3 or input.ccw4) then s = board.piece:rotateCW (board) end
		if input.cw3  and not (input.ccw1 or input.ccw2 or input.ccw3 or input.ccw4) then s = board.piece:rotateCW (board) end
		if input.cw4  and not (input.ccw1 or input.ccw2 or input.ccw3 or input.ccw4) then s = board.piece:rotateCW (board) end
		if input.ccw1 and not (input.cw1  or input.cw2  or input.cw3  or input.cw4 ) then s = board.piece:rotateCCW(board) end
		if input.ccw2 and not (input.cw1  or input.cw2  or input.cw3  or input.cw4 ) then s = board.piece:rotateCCW(board) end
		if input.ccw3 and not (input.cw1  or input.cw2  or input.cw3  or input.cw4 ) then s = board.piece:rotateCCW(board) end
		if input.ccw4 and not (input.cw1  or input.cw2  or input.cw3  or input.cw4 ) then s = board.piece:rotateCCW(board) end
		if s then PlaySFX("classic_rotate") end
	end,
	
	place_raw = function(board)	
		-- place each block in the grid
		local o = board.piece.orientation
		for b = 1, #board.piece.blocks[o] do
			local x, y = board.piece.blocks[o][b][1], board.piece.blocks[o][b][2]
			x, y = x + board.piece.x, y + board.piece.y
			if y > board.max_y then board.max_y = y end
			board.grid[x][y] = true
		end

		-- then check lines 
		local ln = board:clear_lines()
		if board.piece.parent then
			local counts = board.stat[board.spin][board.piece.parent]
			if counts then
				if not counts[ln] then counts[ln] = 0 end
				counts[ln] = counts[ln] + 1
			end
			board.last_clear = ln
			board.last_spin = board.spin
			board.last_id = board.piece.parent
		end
		
		-- update score and line clear animation if necessary
		board.last_score = board:getScore(ln)
		board.score = board.score + board.last_score
		board.drop_points = 0
		if ln >= 1 then
			table.insert(board.recent_actions, 1, {
				time   = board.time,
				label  = (board.last_spin and (board.piece.parent.."-SPIN ") or "") .. LineClearName(ln),
				score  = board.last_score,
				colour = AvgArrays(board.piece.colour, {1,1,1,1}),
			})
			if board:is_grid_empty() then
				PlaySFX("perfectclear")
				table.insert(board.recent_actions, 1, {
					time   = board.time,
					label  = "PERFECT CLEAR!!!",
					score  = 1000000,
					colour = nil,
				})
				board.all_clears = board.all_clears + 1
				board.score = board.score + 1000000
			end
			board.animation_time = board.line_delay
			--[[
			local s = board.size
			local w, h = board.canvas:getDimensions()
			local x, y = board.piece.x, board.piece.y
			local px, py = board.position_x*w, board.position_y*h
			local start_x, start_y = (x-5.5)*s+px, (11.5-y)*s+py
			local text = love.graphics.newText(MenuFont, "+"..CommaValue(board.last_score))
			local starttime = board.time
			board:add_draw_item("overlay", function(board)
				local t = board.time - starttime
				if t >= 1 then
					text:release()
					return true
				end
				
				local xoff, yoff = start_x, start_y
				-- if t < 0.5 then
					-- xoff = px + math.cos(math.pi*t) * (start_x-px)
					-- yoff = start_y + s*20 * (2*t) * (2*t-2)
				-- elseif t < 0.75 then
					-- local t2 = 2*t-1
					-- xoff = px + (x>5 and -10 or 10) * s * math.sin(math.pi*t2)
					-- yoff = h*0.85 + (h*0.85 - start_y + s*20) * (2*t) * (2*t-2)
				-- else
					-- local t2 = 2*t-1
					-- xoff = px + 10*s - (x>5 and 20 or 0) * s * math.sin(math.pi*t2)
					-- yoff = h*0.85 + (h*0.85 - start_y + s*20) * (2*t) * (2*t-2)
				-- end
				
				love.graphics.setColor(HSVA(360*t, 0.5, 1))
				love.graphics.draw(text, xoff, yoff, 0, 1, 1, text:getWidth()/2, text:getHeight()/2)
			end)
			--]]
			board:add_event("update", "before", function(board)
				if board.animation_time <= 0 then
					board:drop_lines()
					board.spawn_timer = board.spawn_delay - board.spawn_delay_after_line
					PlaySFX("classic_lock")
					return true
				end
				return false
			end)
			
			if board.spin or ln >= 4 then PlaySFX("classic_bonus") end
			PlaySFX("classic_clear")
		else
			if board.last_spin then
				table.insert(board.recent_actions, 1, {
					time   = board.time,
					label  = board.piece.parent.."-SPIN",
					score  = board.last_score,
					colour = AvgArrays(board.piece.colour, {1,1,1,1}),
				})
			end
			
			PlaySFX("classic_lock")
		end

		-- check level up
		board.percentile = board.percentile + ln
		board.lines = board.lines + ln
		if (board.level_type == "10L" and board.level * 10 <= board.lines) 
		or (board.level_type == "SEC" and board.percentile >= 100)
		then 
			local oldlv = board.level
			board:setLV(board.level + 1)
			if oldlv == board.level then	
				board.percentile = 99
			else
				board.percentile = board.percentile % 100
				board.level_time = board.time
				board.level_final_score = board.score
				board.last_level = oldlv
				PlaySFX("classic_levelup")
			end
		end
		
		-- nil the current piece to signify spawn delay started
		board.piece = nil
	end,
	
	place = function(board)
		board:call_events("place", "before")
		-- print("called pre-place event")
		local override = board:call_events("place", "override")
		-- print("called place override event")
		if not override then
			board:place_raw()
		end
		board:call_events("place", "after")
		-- print("called post-place event")
	end,
	
	
	hold = function(board, input)
		-- reset & hold piece
		board.cur_rots = 0
		board.cur_lock = 0
		local held = board.hold_piece
		board.hold_piece = Deepcopy(board.piece)
		board.hold_piece.x = 5
		board.hold_piece.y = 21
		board.hold_piece.orientation = 1
		if held then
			board.piece = held
		else
			board.piece = board:pull_next()
		end
		board.ghost = nil
		
		-- initial rotate
		board:initial_rotate(input)
		
		-- check death and make new ghost
		if board:check_collision_with(board.piece) then
			board.dead = true
			board:saveScore()
		end
		board:create_ghost()
		
		-- set hold flag
		board.held = true
	end,
	
	clear_lines = function(board)
        board.last_lines = {}
		local ln = 0
		for y = board.max_y, 1, -1 do
			local should_clear = true
			for x = 1, 10 do
				if not board.grid[x][y] then
					should_clear = false
					break
				end
			end
			if should_clear then
                table.insert(board.last_lines, y)
				ln = ln + 1
				for x = 1, 10 do
					local G = math.min(30, board.gravity)
					local gv = math.max(1, G)
					local vx, vy, vr = board.random:random()*150-75, (board.random:random()*5+5)*gv^0.5, (board.random:random()*150-75) * (board.spin and 50 or 1)
                    local sc = board.size
					table.insert(board.animate, {
						object = board.block_mesh,
						startt = board.time,
						endt = board.time + 15,
						func = function(t)
							local t2 = 30*t
							return sc*(x-5.5+vx*t), sc*(3*t2*t2*G - vy*t2 - y + 10.5), vr*t, sc 
						end
					})
                    board.grid[x][y] = nil
				end
			end
		end
		return ln
	end,
    
    drop_lines = function(board)
		for _, y in ipairs(board.last_lines) do
            for x = 1, 10 do
                for y2 = y, board.max_y do
                    board.grid[x][y2] = board.grid[x][y2+1]
                end
            end
        end
    end,
    
	is_grid_empty = function(board)
		for y = board.max_y, 1, -1 do
			for x = 1, 10 do
				if board.grid[x][y] then
                    return false
				end
			end
		end
		return true
	end,
	
	shuffle_bag = function(board)
		-- for every place in the list pick an element at random and put it in that place
		local n = #board.bag
		for i = 1, n do
			local k = board.random:random(i, n)
			board.bag[i], board.bag[k] = board.bag[k], board.bag[i]
		end
	end,

	--[[
	get_piece = function(board) -- 14-bag randomiser. Longest snake sequence 8, longest drought 25, but if that happens you get double the piece before and after.
		-- refill bag if empty, then draw piece from bag
		if #board.bag == 0 then
			board.bag = Deepcopy(Board.mainbag)
			board:shuffle_bag()
		end
		local newid = table.remove(board.bag,board.random:random(#board.bag))
		for n, rep in ipairs(board.rep_queue) do
			if newid == rep.old then
				newid = rep.new
				table.remove(board.rep_queue, n)
				break
			end
		end
		return Piece.new(newid)
	end,
	--]]
	
	get_piece = function(board) -- 14-bag randomiser, with strict 3-history prevention. Longest snake sequence 4, longest drought 21... but far less likely.
		-- refill bag if empty, then draw piece from bag
		if #board.bag == 0 then
			board.bag = Deepcopy(Board.mainbag)
			-- board:shuffle_bag() -- don't need to shuffle bag since in this method the randomness comes from which index we pick
		end
        -- see what pieces you can take out of the bag
        local valid_indexes = {}
        local empty = true
        for index, idbag in ipairs(board.bag) do
            local isin = false
            for _, idhst in ipairs(board.history) do
                if idbag == idhst then
                    isin = true
                end
            end
            if not isin then
                empty = false
                table.insert(valid_indexes, index)
            end
        end
        -- print(string.format("bag: %s\thistory: %s\tvalid indexes:%s", table.concat(board.bag), table.concat(board.history), table.concat(valid_indexes, ",")))
        local finalindex
        if empty then
            -- history covers the whole remainder of the bag, deal the least recent piece in history that is still in bag
            for _, idhst in ipairs(board.history) do
                for index, idbag in ipairs(board.bag) do
                    if idbag == idhst then
                        finalindex = index
                        break
                    end
                end
            end
        else
            -- there's something to deal, so deal something
            finalindex = valid_indexes[board.random:random(#valid_indexes)]
        end
        
		local newid = table.remove(board.bag,finalindex)
        table.remove(board.history, 1)
        table.insert(board.history, newid)
		for n, rep in ipairs(board.rep_queue) do
			if newid == rep.old then
				newid = rep.new
				table.remove(board.rep_queue, n)
				break
			end
		end
		return Piece.new(newid)
	end,
	
	pull_next = function(board)
        local p, good
        while not good do
            p = table.remove(board.nexts, 1)
            while #board.nexts < board.next_count do
                table.insert(board.nexts, board:get_piece())
            end
            
            local frick
            good, frick = pcall(function()
                -- THIS SHOULD NOT HAPPEN, but in case it does, discard empty pieces
                for o, b in ipairs(p.blocks) do
                    assert(#b > 0, "Piece orientation "..o.." is empty!")
                end
            end)
            if not good then
                print("\nWARNING - PIECE DISCARDED: "..frick.."\n\n")
            end
        end
		return p
	end,
	
	add_trails = function(board, dist)
        local _c = love.graphics.getCanvas()
        local sc = board.size
		local piece = board.piece
		local o = piece.orientation
        local g_acc = board.current_grounded and 0 or board.gravity_acc
        love.graphics.setColor(piece.colour)
        love.graphics.setCanvas(board.glow_canvas)
        love.graphics.push()
        local w, h = board.glow_canvas:getDimensions()
        love.graphics.translate(w*0.5, h*0.5)
		for b = 1, #piece.blocks[o] do
			local x, y = piece.blocks[o][b][1] + piece.x, piece.blocks[o][b][2] + piece.y - g_acc
            love.graphics.rectangle("fill", (x-6)*sc, (10-y-dist)*sc, sc, (dist+1)*sc)
		end
        love.graphics.pop()
        love.graphics.setCanvas(_c)
	end,
    
    darken_glow = function(board, s)
        local _c = love.graphics.getCanvas()
        
        love.graphics.setBlendMode("subtract")
        love.graphics.setCanvas(board.glow_canvas)
        love.graphics.setColor(s, s, s, 1)
        local w, h = board.glow_canvas:getDimensions()
        love.graphics.rectangle("fill", -w, -h, 2*w, 2*h)
        
        love.graphics.setBlendMode("alpha")
        love.graphics.setCanvas(_c)
    end,
	
    setLV = function(board, newlevel)
		newlevel = math.min(newlevel, #board.speedcurve)
        board.level = newlevel
        for k, v in pairs(board.speedcurve[newlevel]) do
			board[k] = (type(v) == "function" and v(newlevel) or v)
		end
    end,
    
    putTheBlock = function(board, ...)
        local x, y, r, sx, sy, ox, oy, kx, ky = ...
        x  = x  or 0
        y  = y  or 0
        r  = r  or 0
        sx = sx or 1
        sy = sy or sx
        ox = ox or 0
        oy = oy or 0
        kx = kx or 0
        ky = ky or 0
        
        local sc = board.size
        x = (x-5.5)*sc
        y = (10.5-y)*sc
        sx = sx * sc
        sy = sy * sc
		love.graphics.draw(board.block_mesh, x, y, r, sx, sy, ox, oy, kx, ky)
    end,
	
	add_event = function(board, where, when, action)
		-- where: on what function call should the event be called
		-- when: before or after actually executing the function, or override execution
        -- action: event code, return true to resolve the event and remove it from the list
		table.insert(board.events[where][when], action)
	end,
	
	call_events = function(board, where, when)
		local t = board.events[where][when]
		local not_empty = false
		for k, a in pairs(t) do
			not_empty = true
			local delet = a(board)
			if delet then
				t[k] = nil
			end
		end
		return not_empty
	end,
    
    add_draw_item = function(board, layer, action)
        -- layer: back is behind frame and falling blocks, front is in front of everything
        -- action: draw code, return true to resolve the draw item and remove it from the list
        table.insert(board.draw_items[layer], action)
    end,
    
    do_draw_items = function(board, layer)
		local i = board.draw_items[layer]
		local not_empty = false
		for k, a in pairs(i) do
			not_empty = true
			local delet = a(board)
			if delet then
				i[k] = nil
			end
		end
		return not_empty
    end,
    
    encodeBoard = function(board)
        local enc
        if board.piece then
            enc = board.piece.id .. string.char(0x80 + board.piece.x, 0x80 + board.piece.y, 0x80 + board.piece.orientation)
        else
            enc = "    "
        end
        
		-- [[
        for y = 1, board.max_y do
            local byte1 = 0
            for x = 1, 5 do
                byte1 = byte1 * 2
                byte1 = byte1 + BoolNumber(board.grid[x][y])
            end
            byte1 = byte1 + 0x80
            enc = enc..string.char(byte1)
            local byte2 = 0
            for x = 6,10 do
                byte2 = byte2 * 2
                byte2 = byte2 + BoolNumber(board.grid[x][y])
            end
            byte2 = byte2 + 0x80
            enc = enc..string.char(byte2)
        end
		--]]

        return enc
    end,
    
    decodeBoard = function(board, s)
        if s then
            board.grid = {{},{},{},{},{},{},{},{},{},{}}
            if s:sub(1,4) == "    " then
				if board.piece ~= nil then board:place() end
            else
                board.piece = Piece.new(s:sub(1,1))
                board.piece.x = s:byte(2) - 0x80
                board.piece.y = s:byte(3) - 0x80
                board.piece.orientation = s:byte(4) - 0x80
            end
			
			-- [[
            local fieldbytes = {s:byte(5,-1)}
            local x, y = 1, 1
            for n, b in ipairs(fieldbytes) do
                b = b - 0x80
                for i = 0,4 do
                    if b%2 == 1 then board.grid[x+4-i][y] = true; b = b-1 end
                    b = b/2
                end
                if x == 6 then x, y = 1, y + 1 else x = 6 end
            end
            board.max_y = y
			--]]
        end
    end,
    
	update = function(board, input, dt)
		board.last_clear = 0
		board.last_spin = false
		board.last_id = nil
        board:darken_glow(dt*15/tonumber(Config.trail_duration))
        
		board:call_events("update", "before")
        
		if board.time >= 0 and board.animation_time <= 0 then
            board.last_score = board.score
			if board.piece then
			-- not in spawn delay
				-- rotation
				if (input.cw1  and not board.prev.cw1 ) and board.cur_rots <= Board.maxrots then board:rotate_cw () end
				if (input.ccw1 and not board.prev.ccw1) and board.cur_rots <= Board.maxrots then board:rotate_ccw() end
				if (input.cw2  and not board.prev.cw2 ) and board.cur_rots <= Board.maxrots then board:rotate_cw () end
				if (input.ccw2 and not board.prev.ccw2) and board.cur_rots <= Board.maxrots then board:rotate_ccw() end
				if (input.cw3  and not board.prev.cw3 ) and board.cur_rots <= Board.maxrots then board:rotate_cw () end
				if (input.ccw3 and not board.prev.ccw3) and board.cur_rots <= Board.maxrots then board:rotate_ccw() end
				if (input.cw4  and not board.prev.cw4 ) and board.cur_rots <= Board.maxrots then board:rotate_cw () end
				if (input.ccw4 and not board.prev.ccw4) and board.cur_rots <= Board.maxrots then board:rotate_ccw() end
				
				-- hold
				if input.hold and not board.held and board.allow_hold then board:hold(input) end
				
				-- shifting
					if input.left  and not input.right then board.AS_timer = board.AS_dir == -1 and board.AS_timer + dt or 0; board.AS_dir = -1 -- left
				elseif input.right and not input.left  then board.AS_timer = board.AS_dir ==  1 and board.AS_timer + dt or 0; board.AS_dir =  1 -- right
				else                                        board.AS_timer =                                               0; board.AS_dir =  0 -- no move
				end -- should reset DAS on L+R to avoid the piece flying across the screen in a L-(L+R)-R sequence of inputs
				if board.AS_timer == 0 or board.AS_timer >= board.AS_delay then
					board.piece.x = board.piece.x + board.AS_dir
					if board:check_collision_with(board.piece) then
						if board.AS_dir == 1 then board.last_collision_right = board.time else board.last_collision_left = board.time end
						board.piece.x = board.piece.x - board.AS_dir
                        board.AS_timer = board.AS_delay
                    else
						if board.AS_dir ~= 0 then PlaySFX("classic_move") end
                        if board.AS_timer >= board.AS_delay then board.AS_timer = board.AS_timer - board.AS_repeat end
					end
					board:update_ghost() -- update ghost when the piece moves
				end
				
				-- gravity
				board.piece.y = board.piece.y - 1 -- check for grounded
				if board:check_collision_with(board.piece) then
					-- grounded: undo gravity and update lock conditions
                    board.current_grounded = true
					board.piece.y = board.piece.y + 1
					board:add_trails(0)
					board.cur_lock = board.cur_lock + dt
					if board.cur_lock > board.lock_delay or board.cur_rots > Board.maxrots or input.softdrop then
						board:place()
						board.pieces = board.pieces + 1
						board.cur_lock = 0
						board.cur_rots = 0
                        board.gravity_acc = 0
					end
				else
					-- not grounded: apply gravity
                    board.current_grounded = false
					local old_height = board.piece.y + 1 - board.gravity_acc
					board.gravity_acc = board.gravity_acc + dt * board.gravity + (input.softdrop and 60*dt or 0)
                    local fall_force = board.gravity + (input.softdrop and 60 or 0)
					if input.harddrop then
                        board.gravity_acc = math.huge
                        fall_force = math.huge
                    end
					while not board:check_collision_with(board.piece) and board.gravity_acc >= 1 do
						board.piece.y = board.piece.y - 1
						board.gravity_acc = board.gravity_acc - 1
						board.cur_lock = 0
						board.spin = false
						if(input.softdrop and not input.harddrop) then
							board.drop_points = board.drop_points + 1
							board.score = board.score + 1
						end
						-- fall_dist = fall_dist + 1
					end
                    
					if board:check_collision_with(board.piece) then
                        board.last_collision_down = board.time
                        board.last_collision_down_impact_force = ImpactFormula(math.min(fall_force, 1200))
                        -- print(fall_force, board.last_collision_down_impact_force)
                        board.current_grounded = true
                    end
					board.gravity_acc = math.min(1, board.gravity_acc)
					board.piece.y = board.piece.y + 1
                    
                    local fall_height = old_height - (board.piece.y - board.gravity_acc)
					if input.harddrop then
						board.score = board.score + math.floor(fall_height*fall_height)
					end
					board:add_trails(fall_height)
				end
			else
			-- in spawn delay
				-- continue to update DAS
					if input.left  and not input.right then board.AS_timer = board.AS_dir == -1 and board.AS_timer + dt or 0; board.AS_dir = -1 -- left
				elseif input.right and not input.left  then board.AS_timer = board.AS_dir ==  1 and board.AS_timer + dt or 0; board.AS_dir =  1 -- right
				else                                        board.AS_timer =                                               0; board.AS_dir =  0 -- no move
				end
				board.AS_timer = math.min(board.AS_timer, board.AS_delay)
				
				--check if the piece should spawn
				board.spawn_timer = board.spawn_timer + dt
				if board.spawn_timer >= board.spawn_delay then
					-- reset hold flag, update percentile
					board.held = false
					board.percentile = math.min(board.percentile + 1, 99)
                    
					-- reset timer, spawn, prerotate/prehold
					board.spawn_timer = 0
					board.piece = board:pull_next()
					board:initial_rotate(input)
                    if input.hold and board.allow_hold then board:hold(input) end
                    
					-- check death, if not dead make new ghost
					if board:check_collision_with(board.piece) then
						board.dead = true
						board:saveScore()
					else
						board:create_ghost()
					end
				end
			end
		else
			-- continue to update DAS
				if input.left  and not input.right then board.AS_timer = board.AS_dir == -1 and board.AS_timer + dt or 0; board.AS_dir = -1 -- left
			elseif input.right and not input.left  then board.AS_timer = board.AS_dir ==  1 and board.AS_timer + dt or 0; board.AS_dir =  1 -- right
			else                                        board.AS_timer =                                               0; board.AS_dir =  0 -- no move
			end
			board.AS_timer = math.min(board.AS_timer, board.AS_delay)
            
            -- hide ghost so that it doesn't play in the animation
            if board.ghost then board.ghost.colour[4] = 0 end
		end
		
		board:call_events("update", "after")
		
		local n = 1
		local i = board.trails[n]
		while i do
			local h = i.h
			if h < 1 then 
				table.remove(board.trails, n)
			else
				i.h = h - 120 * dt
				n = n+1
			end
			i = board.trails[n]
		end
		
		if board.first_frame then
			board.first_frame = false
		else
			board.prev = input
			board.time = board.time + dt
			board.animation_time = board.animation_time - dt
		end
	end,
	
	draw = function(board)
		local sc = board.size
        local board_x0, board_y0 = board.field_canvas:getWidth()*0.5,              board.field_canvas:getHeight()*0.5
        local board_x,  board_y  = board.field_canvas:getWidth()*board.position_x, board.field_canvas:getHeight()*board.position_y
		love.graphics.setCanvas(board.field_canvas)
		love.graphics.translate(board_x0, board_y0)
		love.graphics.clear()
		love.graphics.setLineWidth(sc)
		love.graphics.setColor(board.edge_colour)
		love.graphics.rectangle("line", -5.5*sc, -10.5*sc, 11*sc, 21*sc)
		
		for x = 1, 10 do
			love.graphics.setColor(x/10, x/10, x/10, 0.5)
			love.graphics.rectangle("fill", (x-6)*sc, -10*sc, sc, 20*sc)
		end
		
		
		for n, trail in ipairs(board.trails) do
			love.graphics.setColor(unpack(trail.c))
			local x, y, h = trail.x, trail.y, trail.h
			board.trail_mesh:setVertex(3, 0, (0.5-h)*sc, 0,0, 1,1,1,0)
			love.graphics.draw(board.trail_mesh, (x-5.5)*sc, (10.5-y)*sc)
		end
        
        local r, g, b = unpack(board.edge_colour)
		love.graphics.setColor(0.5+0.4*r, 0.5+0.4*g, 0.5+0.4*b, 1)
		for y = 1, board.max_y do
			for x = 1, 10 do
				if board.grid[x][y] then
					-- love.graphics.rectangle("fill", (x-6)*sc, (10-y)*sc, sc, sc)
					board:putTheBlock(x, y)
				end
			end
		end
		
		local pc = board.piece
		if pc then
			love.graphics.setColor(pc.colour)
			for _, b in ipairs(pc.blocks[pc.orientation]) do
                if not board.last_rotate_point then
                    local x, y = b[1] + pc.x, b[2] + pc.y
                    if not board.current_grounded then y = y - board.gravity_acc end
                    -- love.graphics.rectangle("fill", (x-6)*sc, (10-y)*sc, sc, sc)
                    board:putTheBlock(x, y)
                else
                    local x1, y1 = unpack(b)
                    local rotate_anim_time = 0.1
                    local t = math.min((board.time - board.last_rotate_time)/rotate_anim_time, 1)-1
                    local a = t*board.last_rotate_dir*math.pi/2
                    local c, s = math.cos(a), math.sin(a)
                    local xr, yr = unpack(board.last_rotate_point)
                    local x2, y2 = c*(x1-xr)-s*(y1-yr)+xr, s*(x1-xr)+c*(y1-yr)+yr
                    local x, y = x2 + pc.x, y2 + pc.y
                    if not board.current_grounded then y = y - board.gravity_acc end
                    board:putTheBlock(x, y, -a)
                end
			end
		end
		
		local gh = board.ghost
		if gh and board.animation_time <= 0 and not board.dead then
			local r, g, b, a = unpack(gh.colour)
			local t = board.spawn_timer/board.spawn_delay
			love.graphics.setLineWidth(sc/8)
			for _, bl in ipairs(gh.blocks[gh.orientation]) do
				local x, y = bl[1] + gh.x, bl[2] + gh.y
				if t == 0 then
					love.graphics.setColor(r,g,b,a)
					love.graphics.rectangle("line", (x-5.9375)*sc, (10.0625-y)*sc, sc*0.875, sc*0.875)
					love.graphics.line((x-5.9375)*sc, (10.0625-y)*sc, (x-5.0625)*sc, (10.9375-y)*sc)
				else
					love.graphics.setColor(1,1,1,t <= 0.1 and a or 0)
					love.graphics.rectangle("fill", (x-6)*sc, (10-y )*sc, sc, sc)
				end
			end
		end
        
        love.graphics.setColor(1,1,1,1)
        DrawBlurred(board.glow_canvas, -board_x0, -board_y0)
        
		
		local xoff, yoff, roff = 0, 0, 0
		if board.last_collision_down  then yoff = yoff + SwayFormula(board.time - board.last_collision_down ) * board.last_collision_down_impact_force end
		if board.last_collision_left  then xoff = xoff - SwayFormula(board.time - board.last_collision_left ) end
		if board.last_collision_right then xoff = xoff + SwayFormula(board.time - board.last_collision_right) end
		if board.last_collision_cw    then roff = roff + SwayFormula(board.time - board.last_collision_cw   ) end
		if board.last_collision_ccw   then roff = roff - SwayFormula(board.time - board.last_collision_ccw  ) end
        love.graphics.origin()
		love.graphics.translate(board_x, board_y)
		love.graphics.setCanvas(board.canvas)
		love.graphics.clear()
        
        board:do_draw_items("back")
		
		love.graphics.setColor(0.5,0.5,0.5)
		local n = 1
		local i = board.animate[n]
		while i do
			local startt, endt = i.startt, i.endt
			if board.time > endt then
				table.remove(board.animate, n)
			else
				love.graphics.draw(i.object, Interpolate(i.func, board.time, startt, endt))
				n = n+1
			end
			i = board.animate[n]
		end
		
		love.graphics.setColor(1,1,1,1)
        local xsc, ysc = board.scale_x, board.scale_y
		love.graphics.draw(board.field_canvas, xoff*sc, yoff*sc, roff*0.25, xsc, ysc, board.field_canvas:getWidth()/2, board.field_canvas:getHeight()/2)


		for n = 1, #board.nexts do
			local piece = board.nexts[n]
			love.graphics.setColor(unpack(piece.colour))
			for _, b in ipairs(piece.blocks[piece.orientation]) do
				local x, y = b[1], b[2]
				-- love.graphics.rectangle("fill", (x+8)*sc, (4*n-y-12)*sc, sc, sc)
				board:putTheBlock(x+14, y+21-3.5*(n-1))
			end
		end
		
		local hold = board.hold_piece
		if hold then
			local r, g, b, a = unpack(hold.colour)
			if board.held then r, g, b, a = r/4+0.25, g/4+0.25, b/4+0.25, a end
			love.graphics.setColor(r, g, b, a)
			for _, b in ipairs(hold.blocks[hold.orientation]) do
				local x, y = b[1], b[2]
				-- love.graphics.rectangle("fill", (x-10)*sc, (-y-9)*sc, sc, sc)
				board:putTheBlock(x-4, y+21)
			end
		end
        
        board:do_draw_items("front")
        
		
		love.graphics.setColor(1, 1, 1, 1)
		if     board.time < -1 then love.graphics.printf("Ready?", -sc*10, 0, sc*20, "center")
		elseif board.time <  0 then love.graphics.printf("Go!",    -sc*10, 0, sc*20, "center")
		end
        
		love.graphics.origin()
        love.graphics.setCanvas(board.overlay_canvas)
        love.graphics.clear()
        board:do_draw_items("overlay")
        
        love.graphics.setCanvas()
		love.graphics.origin()
	end,
	
	reset = function(board, seed, level, character)
		board.first_frame = true
		board.cur_lock = 0
		board.lock_delay = Board.lock_delay
		board.cur_rots = 0
		board.max_y = 0
		board.pieces = 0
		board.lines = 0
        board.all_clears = 0
		board.score = 0
		board.last_score = 0
		board.drop_points = 0
		board.recent_actions = {}
        board.percentile = 0
        board.level = level or board.startlevel
        board.startlevel = level or board.startlevel
		board.last_level = 0
		board.level_time = -2
        board.time = -2
		board.gravity = Board.gravity
        board.gravity_acc = 0
        board.AS_acc = 0
        board.AS_dir = 0
        board.AS_timer = 0
		board.AS_repeat = Board.AS_repeat
		board.AS_delay = Board.AS_delay
		board.spawn_timer = 0
		board.spawn_delay = Board.spawn_delay
		board.held = false
		board.spin = false
		board.dead = false
		board.hold_piece = nil
		board.character = character
        board.edge_colour = character and Characters[character].colour or board.speedcurve.colour
        board.animation_time = 0
        board.scale_x = 1
        board.scale_y = 1
		-- board.ignore_next_event = false
		board.trails = {}
		board.last_clear = 0
		board.last_spin = false
		board.last_id = nil
        board.last_lines = {}
		board.prev = {}
		board.stat = {[false] = {}, [true] = {}}
		board.grid = {{},{},{},{},{},{},{},{},{},{}}
		-- board.bag = Deepcopy(Board.startbag)
		board.bag = Deepcopy(Board.mainbag)
		board.history = Deepcopy(Board.starthistory)
		board.rep_queue = {}
		board.animate = {}
		board.events = {}
        board.draw_items = {back = {}, front = {}, overlay = {}}
        -- board.anim_sprites = {}
        board.current_grounded = false
		board.last_collision_down  = nil
		board.last_collision_left  = nil
		board.last_collision_right = nil
		board.last_collision_cw    = nil
		board.last_collision_ccw   = nil
        board.last_rotate_point = nil
        board.last_rotate_time  = nil
        board.last_rotate_dir   = 0
		
		board.random:setSeed(seed)
		-- board:shuffle_bag()
		board.piece = nil
		for i = 1, #board.nexts do
			board.nexts[i] = board:get_piece()
		end
		for _, id in pairs(Piece.IDs) do
			board.stat[true ][id] = {}
		    board.stat[false][id] = {}
			for n = 0, 4 do
				board.stat[true ][id][n] = 0
				board.stat[false][id][n] = 0
			end
		end
		for k, v in pairs(Board.events) do
			board.events[v] = {}
			board.events[v].before   = {}
			board.events[v].after    = {}
			board.events[v].override = {}
		end
		board.ghost = nil
        board:setLV(board.level)
        
        love.graphics.setCanvas(board.glow_canvas)
        love.graphics.clear(0,0,0,1)
        love.graphics.setCanvas()
	end,

	saveScore = function(board)
		local isClear = (board.speedcurve[board.level].level_name == math.huge and board.level ~= board.startlevel)
		print("score = " .. board.score .. ", clearscore = " .. (board.level_final_score or "nil"))
		table.insert(HighScores[board.speedcurve.name],
			{
				score 		= board.score,
				clearScore	= isClear and (board.level_final_score or 0),
				lines		= board.lines,
				startLevel	= board.startlevel,
				finalLevel	= board.level or board.startlevel,
				time		= board.time,
				clearTime   = isClear and board.level_time
			}
		)
		SaveHighScores()
	end,
	
	new = function(curve, seed, blocksize, posx, posy)
		local newboard = {
			nexts = {},
			next_count = curve.prev,
            allow_hold = curve.hold,
            level_type = curve.LV,
            speedcurve = curve,
			size = blocksize,
            position_x = posx,
            position_y = posy,
            edge_colour = curve.colour,
			block_mesh = love.graphics.newMesh({
				{-0.5, -0.5, 0, 0, 1.0,1.0,1.0, 1},
				{ 0.5, -0.5, 1, 0, 0.9,0.9,0.9, 1},
				{ 0.5,  0.5, 1, 1, 0.7,0.7,0.7, 1},
				{-0.5,  0.5, 0, 1, 0.8,0.8,0.8, 1},
			}, "fan", "static"),
			trail_mesh = love.graphics.newMesh({
				{-0.5,  0.5, 0, 0, 1,1,1,1},
				{ 0.5,  0.5, 0, 0, 1,1,1,1},
				{ 0,    0,   0, 0, 1,1,1,0},
			}, "fan", "dynamic"),
			random = love.math.newRandomGenerator(seed),
			canvas = love.graphics.newCanvas(),
			field_canvas = love.graphics.newCanvas(),
			glow_canvas = love.graphics.newCanvas(),
			overlay_canvas = love.graphics.newCanvas(),
			getScore = Board.getScore,
			check_cell = Board.check_cell,
			check_collision_with = Board.check_collision_with,
			rotate_cw = Board.rotate_cw,
			rotate_ccw = Board.rotate_ccw,
			initial_rotate = Board.initial_rotate,
			check_spin = Board.check_spin,
			update_ghost = Board.update_ghost,
			create_ghost = Board.create_ghost,
			add_trails = Board.add_trails,
			place_raw = Board.place_raw,
			place = Board.place,
			clear_lines = Board.clear_lines,
            drop_lines = Board.drop_lines,
            is_grid_empty = Board.is_grid_empty,
			shuffle_bag = Board.shuffle_bag,
			pull_next = Board.pull_next,
			get_piece = Board.get_piece,
			update = Board.update,
			draw = Board.draw,
			reset = Board.reset,
			hold = Board.hold,
            setLV = Board.setLV,
            encodeBoard = Board.encodeBoard,
            decodeBoard = Board.decodeBoard,
			add_event = Board.add_event,
			call_events = Board.call_events,
			add_draw_item = Board.add_draw_item,
			do_draw_items = Board.do_draw_items,
            darken_glow = Board.darken_glow,
            putTheBlock = Board.putTheBlock,
			saveScore = Board.saveScore
		}
		newboard.block_mesh:setTexture(blocktexture)
		for i = 1, curve.prev do newboard.nexts[i] = 0 end
		newboard:reset(seed, 1)
		
		return newboard
	end
}