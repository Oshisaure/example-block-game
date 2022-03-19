--[==[
    Main file for example block game
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

function love.load()
	-- Width, Height = love.graphics.getDimensions()
	require("util")
	require("config")
	
	SetDisplayMode(
		tonumber(Config.window_width),
		tonumber(Config.window_height),
		tonumber(Config.window_display),
		Config.fullscreen == "O",
		Config.vsync == "O"
	)
    
	require("piece")
	require("engine")
	require("speedcurve")

	require("highscores")
	-- require("characters")
	-- require("netserver")
	-- require("netclient")
	require("menu")
	require("title")
	require("pause")
	require("splash")
    
    -- love.window.setVSync(BoolNumber(Config.vsync == "O"))
    
    --[[
    BGMSD = love.sound.newSoundData("assets/bounce.mp3")
    BGM = love.audio.newSource(BGMSD)
    BGM:setVolume(0.3)
    print(BGM:getChannelCount())
    print(BGMSD:getSampleRate())
	--]]
    

    
    BGM = {
    ["menu"] = love.audio.newSource("assets/bgm/D_DM2INT.it"                       , "stream"),
               love.audio.newSource("assets/bgm/aftertouch(loop).mod"              , "stream"),
               love.audio.newSource("assets/bgm/fod_ohclatenightearlymorningjam.it", "stream"),
               love.audio.newSource("assets/bgm/crema_lubricante_v3.mod"           , "stream"),
               love.audio.newSource("assets/bgm/thinking_of_tit.xm"                , "stream"),
               love.audio.newSource("assets/bgm/SHADOW(LOOP).XM"                   , "stream"),
               love.audio.newSource("assets/bgm/aryx(T67).s3m"                     , "stream"),
    }
    for _, track in pairs(BGM) do
        track:setLooping(true)
        track:setVolume(tostring(Config.bgm_volume)/100)
    end
	SFX = {
		classic_move    = love.audio.newSource("assets/sfx/classic_move.ogg"   , "stream"),
		classic_rotate  = love.audio.newSource("assets/sfx/classic_rotate.ogg" , "stream"),
		classic_clear   = love.audio.newSource("assets/sfx/classic_clear.ogg"  , "stream"),
		classic_bonus   = love.audio.newSource("assets/sfx/classic_bonus.ogg"  , "stream"),
		classic_lock    = love.audio.newSource("assets/sfx/classic_lock.ogg"   , "stream"),
		classic_levelup = love.audio.newSource("assets/sfx/classic_levelup.ogg", "stream"),
		perfectclear    = love.audio.newSource("assets/sfx/perfectclear3.ogg"  , "stream"),
	}
	BlockSize = Height/40
	-- BlockCanvas = love.graphics.newCanvas(BlockSize,BlockSize)
	-- love.graphics.setCanvas(BlockCanvas)
	-- love.graphics.setColor(1,1,1,1)
	-- love.graphics.rectangle("fill",0,0,BlockSize,BlockSize)
	-- love.graphics.setCanvas()
	Games = {}
	for i = 1, #Levels do
		Games[i] = Board.new(Levels[i], os.time(), BlockSize, 0.5, 0.5)
	end
	-- Games.P1 = Board.new(Levels["vs"], os.time(), BlockSize, BlockCanvas, 0.5 - 0.23, 0.5)
	-- Games.P2 = Board.new(Levels["vs"], os.time(), BlockSize, BlockCanvas, 0.5 + 0.23, 0.5)
	-- Games.ss = Board.new(Levels["serv"], os.time(), BlockSize, BlockCanvas, 0.5 - 0.23, 0.5)
    
    TitleText  = love.graphics.newText(Font.Title, "EXAMPLE BLOCK GAME")
    ScoreText  = love.graphics.newText(Font.Title)
    ScorePopup = love.graphics.newText(Font.HUD)
    
    LoadShaders()
    
    --[[
    Width = 3840
    Height = 2160
    CanvasBG    :release()
    CanvasBGprev:release()
    CanvasBG      = love.graphics.newCanvas(Width, Height)
    CanvasBGprev  = love.graphics.newCanvas(Width, Height)
    PrerenderBG("classic")
    print("prerendered")
    local dat = PrerenderedFrame:newImageData()
    print("imagedata")
    dat:encode("png", "classic_bg_4k.png")
    print("encode")
    dat:release()
    print("release")
	Width, Height = love.graphics.getDimensions()
    CanvasBG    :release()
    CanvasBGprev:release()
    CanvasBG      = love.graphics.newCanvas(Width, Height)
    CanvasBGprev  = love.graphics.newCanvas(Width, Height)
    --]]
	
	if Config.dynamic_bg == "X" then PrerenderBG("menu") end
	--[==[
	ServerThreadUDP = love.thread.newThread([[
		require("netserver")
		RunServerUDP()
	]])
	ServerThreadTCP = love.thread.newThread([[
		require("netserver")
		RunServerTCP()
	]])
	--]==]
	
	LineClearTypes = {
		{1, false, "Single"},
		{2, false, "Double"},
		{3, false, "Triple"},
		{4, false, "Quad"},
		
		{0, true, "Spin-0"},
		{1, true, "Spin-1"},
		{2, true, "Spin-2"},
		{3, true, "Spin-3"},
	}
	love.graphics.setFont(Font.Menu)
	
	--ApplyZoneMod = require("zone_mod")
	
	bottomtext = ""
	STATE = "splash"
    SetBGM()
	-- UpdateTime = 0
	-- UpdateRate = 30
	ResultsScreenTimer = 0
end


function love.update(dt)
    UpdateShadersUniforms(dt)
	if STATE == "splash" then
        UpdateSplashScreen(dt)
	elseif STATE == "menu" then
		key = ProcessMenuAutorepeat(dt)
		if key then love.keypressed(key) end
	elseif STATE == "ingame" then
		if not Game.dead then
			Game.dead_time = 0
			Game:update({
				left     = CheckKeyInput(KeyBindings.left     ) or CheckPadInput(CurrentController, PadBindings.left     ),
				right    = CheckKeyInput(KeyBindings.right    ) or CheckPadInput(CurrentController, PadBindings.right    ),
				ccw1     = CheckKeyInput(KeyBindings.ccw1     ) or CheckPadInput(CurrentController, PadBindings.ccw1     ),
				ccw2     = CheckKeyInput(KeyBindings.ccw2     ) or CheckPadInput(CurrentController, PadBindings.ccw2     ),
				ccw3     = CheckKeyInput(KeyBindings.ccw3     ) or CheckPadInput(CurrentController, PadBindings.ccw3     ),
				ccw4     = CheckKeyInput(KeyBindings.ccw4     ) or CheckPadInput(CurrentController, PadBindings.ccw4     ),
				cw1      = CheckKeyInput(KeyBindings.cw1      ) or CheckPadInput(CurrentController, PadBindings.cw1      ),
				cw2      = CheckKeyInput(KeyBindings.cw2      ) or CheckPadInput(CurrentController, PadBindings.cw2      ),
				cw3      = CheckKeyInput(KeyBindings.cw3      ) or CheckPadInput(CurrentController, PadBindings.cw3      ),
				cw4      = CheckKeyInput(KeyBindings.cw4      ) or CheckPadInput(CurrentController, PadBindings.cw4      ),
				harddrop = CheckKeyInput(KeyBindings.sonicdrop) or CheckPadInput(CurrentController, PadBindings.sonicdrop),
				softdrop = CheckKeyInput(KeyBindings.softdrop ) or CheckPadInput(CurrentController, PadBindings.softdrop ),
				hold     = CheckKeyInput(KeyBindings.hold     ) or CheckPadInput(CurrentController, PadBindings.hold     ),
			}, dt)
            SetBGM(Game.BGM)
            Game.display_score = Game.score - (Game.score - Game.display_score) * 0.001^dt
            ScoreText:set(CommaValue(math.floor(Game.display_score+0.5)))
            SendShaderUniform("level", Game.level)
            SendShaderUniform("levelprev", Game.last_level)
            SendShaderUniform("leveltime", Game.level_times[Game.level])
			-- bottomtext = "LV. "..(Game.level_type == "10L" and Game.level_name or Game.level*100+Game.percentile-100).."\nLines: "..Game.lines.."\n"..FormatTime(Game.time)
			--[[
			UpdateTime = UpdateTime + dt
			if UpdateTime > 1/UpdateRate then
				SendServer(Game:encodeBoard())
				UpdateTime = UpdateTime % (1/UpdateRate)
			end
			local eventstr = Game.last_clear .. (Game.last_spin and "S" or "")
			if eventstr ~= "0" then SendEventServer(Game.last_id..eventstr) end
			--]]
            
            --[[
            local playbacktime = BGM:tell("samples")*2
            local soundL = {}
            local soundR = {}
            local avgL = 0
            local avgR = 0
            for i = 1, 200*2+2, 2 do
                local sampleL = BGMSD:getSample(playbacktime + i    )
                local sampleR = BGMSD:getSample(playbacktime + i + 1)
                table.insert(soundL, sampleL)
                table.insert(soundR, sampleR)
                -- avgL = avgL + sampleL/100
                -- avgR = avgR + sampleR/100
            end
            ShaderBG:send("soundL", unpack(soundL))
            ShaderBG:send("soundR", unpack(soundR))
            ShaderBG:send("samplerate", BGMSD:getSampleRate())
            -- ShaderBG:send("avgL", avgL)
            -- ShaderBG:send("avgR", avgR)
            -- ShaderBG:send("time", os.clock())
            ShaderBG:send("dt", dt)
            --]]
        else
            SetBGM()
            -- BGM:stop()
			Game.dead_time = Game.dead_time + dt
			ResultsScreenTimer = ResultsScreenTimer - dt
		end
	elseif STATE == "results" then
		Game.dead_time = Game.dead_time + dt
		ResultsScreenTimer = ResultsScreenTimer + dt
	elseif STATE == "battle2P" then
		if not Games.P1.dead and not Games.P2.dead then
			Games.P1:update({
				left     = CheckKeyInput(KeyBindings.left     ),
				right    = CheckKeyInput(KeyBindings.right    ),
				ccw1     = CheckKeyInput(KeyBindings.ccw1     ),
				ccw2     = CheckKeyInput(KeyBindings.ccw2     ),
				ccw3     = CheckKeyInput(KeyBindings.ccw3     ),
				ccw4     = CheckKeyInput(KeyBindings.ccw4     ),
				cw1      = CheckKeyInput(KeyBindings.cw1      ),
				cw2      = CheckKeyInput(KeyBindings.cw2      ),
				cw3      = CheckKeyInput(KeyBindings.cw3      ),
				cw4      = CheckKeyInput(KeyBindings.cw4      ),
				harddrop = CheckKeyInput(KeyBindings.sonicdrop),
				softdrop = CheckKeyInput(KeyBindings.softdrop ),
				hold     = CheckKeyInput(KeyBindings.hold     ),
			}, dt)
			Games.P2:update({
				left     = CheckPadInput(CurrentController, PadBindings.left     ),
				right    = CheckPadInput(CurrentController, PadBindings.right    ),
				ccw1     = CheckPadInput(CurrentController, PadBindings.ccw1     ),
				ccw2     = CheckPadInput(CurrentController, PadBindings.ccw2     ),
				ccw3     = CheckPadInput(CurrentController, PadBindings.ccw3     ),
				ccw4     = CheckPadInput(CurrentController, PadBindings.ccw4     ),
				cw1      = CheckPadInput(CurrentController, PadBindings.cw1      ),
				cw2      = CheckPadInput(CurrentController, PadBindings.cw2      ),
				cw3      = CheckPadInput(CurrentController, PadBindings.cw3      ),
				cw4      = CheckPadInput(CurrentController, PadBindings.cw4      ),
				harddrop = CheckPadInput(CurrentController, PadBindings.sonicdrop),
				softdrop = CheckPadInput(CurrentController, PadBindings.softdrop ),
				hold     = CheckPadInput(CurrentController, PadBindings.hold     ),
			}, dt)
		end
		local eventP1str = Games.P1.last_clear .. (Games.P1.last_spin and "S" or "")
		local eventP2str = Games.P2.last_clear .. (Games.P2.last_spin and "S" or "")
		
		local eventP1fun = Characters[Games.P1.character][eventP1str]
		local eventP2fun = Characters[Games.P2.character][eventP2str]
		
		if eventP1fun then eventP1fun(Games.P1, Games.P2) end
		if eventP2fun then eventP2fun(Games.P2, Games.P1) end
		
    elseif STATE == "serverspec" then
		local msg = love.thread.getChannel('spec'):pop()
		if msg then
			local e = msg:sub(1, 2)
			local d = msg:sub(3,-1)
			if     e == "c/" then bottomtext = "Connected to\n"..d
			elseif e == "d/" then bottomtext = "Disconnected"
			elseif e == "b/" then
				Game:decodeBoard(d)
				if Game.piece ~= nil then Game:create_ghost() end
			elseif e == "q/" then
				love.thread.getChannel('stopspec'):clear()
				STATE = "menu"
			end
		end
		local ev = love.thread.getChannel('event'):pop()
		if ev then
			local id, ln, sp = ev:sub(1,1), ev:sub(2,2), ev:sub(3,3) == "S"
			Game.stat[sp][id][ln] = Game.stat[sp][lc][id] + 1
		end
		
		if love.keyboard.isDown("k") then love.thread.getChannel('stopspec'):push(true) end
        
		
	-- elseif STATE == "levelselect" then
		-- bottomtext = "Pick level:\n< "..Game.level_name.." >"
	end
end

function love.draw()
    love.graphics.setCanvas()
    if STATE == "splash" then
        DrawSplashScreen()
	elseif STATE == "menu" or STATE == "keyinput" or STATE == "padinput" then
        RenderBG()
		love.graphics.setColor(1,1,1)
        
        love.graphics.setCanvas(CanvasRainbow)
        love.graphics.clear(0,0,0,0)
        if Title.current == "main" then
            local w, h = TitleText:getDimensions()
            love.graphics.draw(TitleText, Width*0.5, Height*0.2, math.sin(os.clock()*0.5)*0.2, 1, 1, w/2, h/2, -math.cos(os.clock()*0.5)*0.4, 0)
        end
        
        love.graphics.setShader()
        love.graphics.setCanvas(CanvasBG)
		love.graphics.setColor(.5,.5,.5)
		love.graphics.draw(Title[Title.current].text)
		if Title.current == "play" then
			local modeid = Title.play.items[Title.play.highlight].id
			if modeid and Levels[modeid][Title.play.startlv].level_name == math.huge then
				local scx, scy = Font.Menu:getWidth("AA"), Font.Menu:getHeight()
				local posx = 0.5*Font.Menu:getWidth("Start level: <    >") - Font.Menu:getWidth(" >")
				DrawInfinitySymbol(Width*0.5 + posx - scx/10, math.floor(Height*0.7), 0, -scx/10, scy/6)
			end
		end
        DrawRainbow(CanvasRainbow)
        love.graphics.setCanvas()
        local b = tonumber(Config.bg_brightness)/100
		love.graphics.setColor(b, b, b)
        love.graphics.draw(CanvasBG)
		love.graphics.setColor(1,1,1)
		love.graphics.draw(Title[Title.current].text)

        if Title.current == "play" then
			local modeid = Title.play.items[Title.play.highlight].id
			if modeid and Levels[modeid][Title.play.startlv].level_name == math.huge then
				local scx, scy = Font.Menu:getWidth("AA"), Font.Menu:getHeight()
				local posx = 0.5*Font.Menu:getWidth("Start level: <    >") - Font.Menu:getWidth(" >")
				DrawInfinitySymbol(Width*0.5 + posx - scx/10, math.floor(Height*0.7), 0, -scx/10, scy/6)
			end
		end

		if Title.current == "highscores" then
			local mode = Title.highscores.mode_list[Title.highscores.selection]
			local current_scores = HighScores[mode]
			if(#current_scores == 0) then
				love.graphics.printf("[ NO HIGH SCORES TO DISPLAY ]",0,Height*0.3,Width,"center")
			else
				-- title bar
				love.graphics.setFont(Font.HUD)
				local char_width = Font.Menu:getWidth("A")
				local left_x -- for use later
				if(Title.highscores.show_clear) then
					local text_width = char_width *40
					left_x  = Width*0.5- text_width /2
					love.graphics.printf("CLEAR SCORE", math.floor(left_x + char_width *6),  Height*0.3-Font.HUD:getHeight()*1.1, Width*0.5, "left")
					love.graphics.printf("START LV",    math.floor(left_x + char_width *19), Height*0.3-Font.HUD:getHeight()*1.1, Width*0.5, "left")
					love.graphics.printf("LEVEL",       math.floor(left_x + char_width *26), Height*0.3-Font.HUD:getHeight()*1.1, Width*0.5, "left")
					love.graphics.printf("CLEAR TIME",  math.floor(left_x + char_width *32), Height*0.3-Font.HUD:getHeight()*1.1, Width*0.5, "left")
				else
					local textw = char_width *41
					left_x = Width*0.5-textw/2
					love.graphics.printf("SCORE", math.floor(left_x + char_width *6),  Height*0.3-Font.HUD:getHeight()*1.1, Width*0.5, "left")
					love.graphics.printf("LINES", math.floor(left_x + char_width *20), Height*0.3-Font.HUD:getHeight()*1.1, Width*0.5, "left")
					love.graphics.printf("LEVEL", math.floor(left_x + char_width *27), Height*0.3-Font.HUD:getHeight()*1.1, Width*0.5, "left")
					love.graphics.printf("TIME",  math.floor(left_x + char_width *33), Height*0.3-Font.HUD:getHeight()*1.1, Width*0.5, "left")
				end
				love.graphics.setFont(Font.Menu)
				local curve = Levels[Title.highscores.mode_indices[mode]]
				local function levelStr(l)
					-- Removes the level text if it's Lv. Inf so it can draw the infinity symbol instead
					return l ~= math.huge and l or ""
				end
				for i = 1, math.min(#current_scores, 10) do
					local score = current_scores[i]
					local st = ""
					if(Title.highscores.show_clear) then
						st = string.format(
							"#%2s -%12s - %3s - %3s -%9s",
							i,
							CommaValue(score.clear_score),
							levelStr(curve[score.start_level].level_name),
							levelStr(curve[score.final_level].level_name),
							FormatTime(score.clear_time)
						)
						if(curve[score.start_level].level_name == math.huge) then
							DrawInfinitySymbol(left_x + char_width *(22+5/6), Height*0.3+(i-1)*Font.Menu:getHeight(), 0, -(char_width *2)/10, Font.Menu:getHeight()/6)
						end
						if(curve[score.final_level].level_name == math.huge) then
							DrawInfinitySymbol(left_x + char_width *(28+5/6), Height*0.3+(i-1)*Font.Menu:getHeight(), 0, -(char_width *2)/10, Font.Menu:getHeight()/6)
						end
					else
						st = string.format(
							"#%2s -%12s -%5d - %3s -%9s",
                            i,
                            tonumber(score.score) >= 1000000000 and score.score or CommaValue(score.score),
                            score.lines,
                            levelStr(curve[score.final_level].level_name),
                            FormatTime(score.time)
						)
						if(curve[score.final_level].level_name == math.huge) then
							DrawInfinitySymbol(left_x + char_width *(29+5/6), Height*0.3+(i-1)*Font.Menu:getHeight(), 0, -(char_width *2)/10, Font.Menu:getHeight()/6)
						end
					end
							
					love.graphics.printf(st, 0, Height*0.3+(i-1)*Font.Menu:getHeight(), Width, "center")
				end
			end
		end
        DrawRainbow(CanvasRainbow)
	elseif STATE == "battle2P" then
		Games.P1:draw()
		Games.P2:draw()
		--[[
        love.graphics.setColor(1, 1, 1, Games.P1.dead and 0.5 or 1)
		love.graphics.draw(Games.P1.canvas, -Width*0.23, 0)
		love.graphics.setColor(1, 1, 1, Games.P2.dead and 0.5 or 1)
		love.graphics.draw(Games.P2.canvas,  Width*0.23, 0)
        ]]
		love.graphics.setColor(1, 1, 1, Games.P1.dead and 0.5 or 1)
		love.graphics.draw(Games.P1.canvas)
		love.graphics.setColor(1, 1, 1, Games.P2.dead and 0.5 or 1)
		love.graphics.draw(Games.P2.canvas)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(Games.P1.overlay_canvas)
		love.graphics.draw(Games.P2.overlay_canvas)
		
	else
		Game:draw()
		love.graphics.setColor(1,1,1)
        
        --[[
        love.graphics.setCanvas(CanvasBG)
        love.graphics.setShader(ShaderBG)
        love.graphics.draw(CanvasBGprev)
        love.graphics.setShader()
        -- love.graphics.setCanvas(CanvasBGprev)
        -- love.graphics.draw(CanvasBG)
        love.graphics.setCanvas()
        love.graphics.draw(CanvasBG)
        --]]
        
        -- [[shader test
        -- love.graphics.setShader(ShaderShaking)
        local shiftDamp = (Game.last_collision_down  or -math.huge) - Game.time
        local shiftLamp = (Game.last_collision_left  or -math.huge) - Game.time
        local shiftRamp = (Game.last_collision_right or -math.huge) - Game.time
        local decay  = 40
        local decay2 = 10
        local sh_scale = 0.0 -- 0.1
        local an_scale = 0.0 -- 0.1
        local distortscaleX = -0.03
        local distortscaleY = -0.04
        -- [==[
        local distort = {
            distortscaleX * (math.exp(shiftRamp*decay) - math.exp(shiftLamp*decay)),
            distortscaleY *  math.exp(shiftDamp*decay2) * (Game.last_collision_down_impact_force or 0)
        }
        -- ]==]
        local shift = {}
        local angle = {}
        for i = 1, 3 do 
            shift[i] = {}
            for j = 1, 3 do
                shift[i][j] = (math.random() - 0.5) * sh_scale * math.exp(shiftDamp*decay)
            end
            angle[i] = (math.random() - 0.5) * an_scale * math.exp(shiftDamp*decay)
        end
        
        --ShaderShaking:send("shift", shift)
        ShaderShaking:send("shift", {0,0,0,0,0,0,0,0,0})
        ShaderShaking:send("angle", angle)
        ShaderShaking:send("distort", distort)
        ShaderShaking:send("time", os.clock())
        --]]
        
        RenderBG(Game.speedcurve.BG)
        love.graphics.setCanvas(CanvasBG)
		-- love.graphics.setShader(ShaderShaking)
        love.graphics.draw(Game.canvas)
		love.graphics.setShader()
        love.graphics.setCanvas()
        local b = tonumber(Config.bg_brightness)/100
		love.graphics.setColor(b, b, b)
        love.graphics.draw(CanvasBG)
        -- [===[ activate this block comment to render none of the HUD and only the BG
		-- love.graphics.setShader(ShaderShaking)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Game.canvas)
		love.graphics.setShader()
        love.graphics.draw(Game.overlay_canvas)
        
		-- love.graphics.draw(Game.canvas, -Width*0.23, 0)
        -- love.graphics.setShader()
		-- love.graphics.printf(bottomtext, -Width*0.23, Height*0.86, Width, "center")
        local w7, w6 = Width*0.5-7*Game.size, Width*0.5-6*Game.size
        love.graphics.setFont(Font.Menu)
        if Game.allow_hold then
            love.graphics.printf("HOLD",    0, Height*0.15, w7, "right")
        end
        love.graphics.printf("NEXT", Width-w7, Height*0.15, w7, "left")
		
		love.graphics.setFont(Font.HUD)
        love.graphics.printf("LINE CLEAR STATISTICS", 0, Height*0.4, w6, "center")
        
		for k, id in ipairs(Piece.IDs) do
			love.graphics.setColor(unpack(Piece.colours[id]))
			love.graphics.print(id, w6*(0.20+0.1*k), Height*0.45)
		end
		for i, lc in ipairs(LineClearTypes) do
			local j = i + BoolNumber(i > 4) -- skip a line between regular and spin clears
			love.graphics.setColor(1, 1, 1)
			love.graphics.print(lc[3], w6*0.05, Height*(0.45+0.025*j))
			for k, id in ipairs(Piece.IDs) do
				love.graphics.setColor(unpack(Piece.colours[id]))
				love.graphics.print(Game.stat[lc[2]][id][lc[1]], w6*(0.20+0.1*k), Height*(0.45+0.025*j))
			end
		end
        love.graphics.setColor(1, 1, 1)
		-- if Game.stat[true]["I"][4] and Game.stat[true]["I"][4] > 0 then
			-- love.graphics.setColor(1, 1, 1)
			-- love.graphics.print("Spin-4", w6*0.05, Height*(0.45+0.025*10))
			-- love.graphics.setColor(unpack(Piece.colours["I"]))
			-- love.graphics.print(Game.stat[true]["I"][4], w6*(0.20+0.01), Height*(0.45+0.025*10))
		-- end
        if Game.all_clears > 0 then
            love.graphics.printf("PERFECT CLEARS:", w6*0.05, Height*(0.55+0.025*#LineClearTypes), w6*0.90, "left")
            love.graphics.printf(Game.all_clears  , w6*0.05, Height*(0.55+0.025*#LineClearTypes), w6*0.90, "right")
        end
		
        if #Game.speedcurve > 1 then 
            local lvdisp = 5
            for d = 0, math.min(lvdisp-1, Game.level-1) do
                local lv = Game.level - d
                local currentlevel = (d == 0)
                if Game.level_name == math.huge or Game.level_name == -math.huge then
                    currentlevel = false
                    lv = lv - 1
                end
                local xoff = 0
                love.graphics.setColor(1,1,1,1-d/lvdisp)
                if currentlevel then
                    local t = math.min(Game.level_times[lv]*3, 1)
                    love.graphics.setColor(1,1,1,t)
                    xoff = (1-t)*Height*(-0.05)
                end
                love.graphics.printf(string.format(
                    "%s%3s -%6sK - %s",
                    currentlevel and ">" or " ",
                    Game.speedcurve[lv].level_name,
                    CommaValue(math.floor((Game.level_scores[lv] or 0)/1000)),
                    FormatTime(Game.level_times[lv]):sub(1, -3)
                ), w6*0.05 + xoff, Height*(0.9-0.025*d), w6*0.90, "left", 0, 1, 1, 0, 0, -0.3)
            end
		end
        
        local lastentry
        repeat
            lastentry = table.remove(Game.recent_actions)
        until (not lastentry) or lastentry.time + 3 > Game.time
        table.insert(Game.recent_actions, lastentry)
        local yscoff = 0
        for _, entry in ipairs(Game.recent_actions) do
            local t = (Game.time - entry.time)/3
            local ysc, xsc = 1-(1-t)^15, 1-t^10
            yscoff = yscoff + ysc
            ScorePopup:setf(entry.label.."\n+"..CommaValue(entry.score), w6*0.9, "right")
            if entry.colour then
                love.graphics.setColor(entry.colour)
                love.graphics.draw(ScorePopup, Width-w6*xsc, Height*(0.80-yscoff*0.05), 0, 1, ysc, 0, 0, -0.3)
            else
                DrawRainbow(ScorePopup, Width-w6*xsc, Height*(0.80-yscoff*0.05), 0, 1, ysc, 0, 0, -0.3)
            end
        end
        
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(Font.HUD)
        love.graphics.printf("LEVEL", Width*0.75, Height*0.40, Width*0.2, "left")
        love.graphics.printf("LINES", Width*0.75, Height*0.50, Width*0.2, "left")
        love.graphics.printf("TIME ", Width*0.75, Height*0.60, Width*0.2, "left")
        love.graphics.setFont(Font.Menu)
        love.graphics.printf("SCORE", Width*0.75, Height*0.80, Width*0.2, "right")
        
		local leveldisplay = Game.level_name
		if Game.level_type == "SEC" then
            if leveldisplay == math.huge then
                leveldisplay = string.format("%03d/", Game.speedcurve[Game.level-1].level_name+Game.percentile+100)
                local scx, scy = Font.Menu:getWidth("AA"), Font.Menu:getHeight()
				love.graphics.printf(leveldisplay, Width*0.75-scx, Height*0.425, Width*0.2, "right")
                DrawInfinitySymbol(Width*0.95-scx/10, Height*0.425, 0, -scx/10, scy/6)
                leveldisplay = ""
            else 
                leveldisplay = string.format("%03d/%03d", leveldisplay+Game.percentile, leveldisplay+100)
            end
		elseif leveldisplay == math.huge or leveldisplay == -math.huge then
			local scx, scy = Font.Menu:getWidth("AA"), Font.Menu:getHeight()
			if leveldisplay < 0 then
				love.graphics.setShader(ShaderRainbow)
				love.graphics.printf("M", Width*0.75-scx, Height*0.425, Width*0.2, "right")
				love.graphics.setShader()
			end
			leveldisplay = ""
			DrawInfinitySymbol(Width*0.95-scx/10, Height*0.425, 0, -scx/10, scy/6)
			
			love.graphics.setFont(Font.HUD)
			love.graphics.printf("("..FormatTime(Game.level_final_time )..")",  Width*0.75, Height*0.625 + Font.Menu:getHeight(), Width*0.2, "right")
			love.graphics.printf("("..CommaValue(Game.level_final_score)..")",  Width*0.75, Height*0.850 + ScoreText:getHeight(), Width*0.2, "right")
			love.graphics.setFont(Font.Menu)
		end
		
		if Game.startlevel ~= 1 then
			love.graphics.setFont(Font.HUD)
			love.graphics.printf("("..Game.speedcurve[Game.startlevel].level_name..")",  Width*0.75, Height*0.425 + Font.Menu:getHeight(), Width*0.2, "right")
			love.graphics.setFont(Font.Menu)
		end
		
		love.graphics.printf(leveldisplay,           Width*0.75, Height*0.425, Width*0.2, "right")
        love.graphics.printf(Game.lines,             Width*0.75, Height*0.525, Width*0.2, "right")
        love.graphics.printf(FormatTime(Game.time),  Width*0.75, Height*0.625, Width*0.2, "right")
		
        local stw, sth = ScoreText:getDimensions()
        love.graphics.draw(ScoreText, Width*0.95-stw/2, Height*0.85+sth/2, math.log(math.max(Game.score-Game.display_score, 0)+1)/math.log(Game.score+2)*0.1, 1, 1, stw/2, sth/2, -0.3)
        
        -- love.graphics.setColor(0.5, 0.5, 0.5)
		-- love.graphics.print("Bag:"..table.concat(Game.bag).."\nHistory:"..table.concat(Game.history), Width*0.62, Height*0.86)
        
        --]===]
		
		if STATE == "pause" then DrawPause() end

		if Game.dead then
			local deadtime = Game.dead_time
			love.graphics.setColor(1,1,1,math.min(deadtime*0.5, 1))
			love.graphics.setFont(Font.Title)
			local gameoveroff = math.max((1-deadtime)*0.05, 0)
			love.graphics.printf("GAME", Width*(0.00-gameoveroff), Height*0.05, Width*0.45, "right", 0, 1, 1, 0, 0, -0.3)
			love.graphics.printf("OVER", Width*(0.55+gameoveroff), Height*0.05, Width*0.45, "left" , 0, 1, 1, 0, 0, -0.3)
			love.graphics.setFont(Font.Menu)
			love.graphics.setColor(1,1,1,math.min(deadtime-0.5, 1))
			love.graphics.printf("PRESS [TAB] TO SHOW PER LEVEL RESULTS", Width*0.1, Height*0.95, Width*0.8, "center")
			
			love.graphics.setColor(0,0,0,Clamp(ResultsScreenTimer*0.5, 0, 0.75))
			love.graphics.rectangle("fill", 0, 0, Width, Height)
			love.graphics.setFont(Font.HUD)
			love.graphics.setColor(1,1,1,Clamp(ResultsScreenTimer, 0, 1))
			love.graphics.printf("LEVEL -  ISOLATED SCORE-TIME -  CUMULATIVE SCORE-TIME", 0, Height*0.06, Width, "center", 0, 1, 1, 0, 0, -0.3)
			local maxlv = Game.speedcurve.maxlevel
			if maxlv == math.huge then maxlv = Game.level end
			for lv = 1, maxlv do
				local lvname = Game.speedcurve[lv].level_name
				if lvname ~= math.huge and lvname ~= -math.huge then
					local offt = (STATE == "results" and lv*0.05 or 0.75)
					local t = Clamp((ResultsScreenTimer - offt)*4, 0, 1)
					local xoff = (-1)^lv*(1-t)*Width*0.1
					love.graphics.setColor(1,1,1,t)
					love.graphics.printf(string.format(
						"%3s -%10s - %s -%10s - %s",
						Game.speedcurve[lv].level_name,
						CommaValue(Game.level_scores[lv]),
						FormatTime(Game.level_times [lv]),
						CommaValue(Game.cumul_scores[lv]),
						FormatTime(Game.cumul_times [lv])
					), xoff, Height*(0.06+0.025*lv), Width, "center", 0, 1, 1, 0, 0, -0.3)
				end
			end
		end
		
	end
    
    love.graphics.setFont(Font.Menu)
    love.graphics.setColor(1,1,1)
    love.graphics.print(love.timer.getFPS().."FPS")
end

function love.keypressed(key)
    if key == "f5" then
        for _, v in pairs(ShaderBG) do v:release() end
        ShaderBlur    :release()
        ShaderRainbow :release()
        ShaderShaking :release()
        ShaderInfinity:release()
        LoadShaders()
    end
	if (STATE == "ingame" or STATE == "results") and (key == "return" or key == KeyBindings.pause) and Game.dead then
		Game:reset(os.time())
		Game:setLV(1)
		-- DisconnectServer()
		bottomtext = ""
        if Config.dynamic_bg == "X" then PrerenderBG() end
		STATE = "menu"
        SetBGM("menu")
        ResultsScreenTimer = 0
	elseif STATE == "ingame" and key == KeyBindings.pause then
        STATE = "pause"
    --[[
	elseif STATE == "ingame" then
        if key == "kp8" then Game.position_y = Game.position_y - 0.1 end
        if key == "kp2" then Game.position_y = Game.position_y + 0.1 end
        if key == "kp4" then Game.position_x = Game.position_x - 0.1 end
        if key == "kp6" then Game.position_x = Game.position_x + 0.1 end
    ]]
	elseif STATE == "ingame" and key == "tab" and Game.dead then
		STATE = "results"
		ResultsScreenTimer = 0
	elseif STATE == "results" and key == "tab" then
		STATE = "ingame"
		ResultsScreenTimer = 1
	elseif STATE == "battle2P" and key == "return" and (Games.P1.dead or Games.P2.dead) then
		Games.P1:reset(os.time())
		Games.P2:reset(os.time())
		STATE = "menu"
	elseif STATE == "keyinput" then
		local id = Title.keyconf.highlight
		local field = Bindlist[id][1]
		Config["key_"..field] = key
		KeyBindings[field] = key
		Title.keyconf.items[id].label = ("%s : %s"):format(Bindlist[id][2], key:upper())
		Title.keyconf:updateSelected("kek")
		SaveConfig()
		STATE = "menu"
	
	elseif STATE == "padinput" and key == "escape" then
		local id = Title.padconf.highlight - 1
		local field = Bindlist[id][1]
		Config["pad_"..field] = "<none>"
		PadBindings[field] = "<none>"
		Title.padconf.items[id+1].label = ("%s : %s"):format(Bindlist[id][2], "<NONE>")
		Title.padconf:updateSelected("kek")
		SaveConfig()
		STATE = "menu"
	elseif STATE == "menu" then
		Title[Title.current]:updateSelected(key)
	elseif STATE == "pause" then
		Pause:updateSelected(key)
	end
end


function love.gamepadpressed(joystick, button)
    CurrentController = joystick
	if STATE == "padinput" then
		local id = Title.padconf.highlight - 1
		local field = Bindlist[id][1]
		Config["pad_"..field] = button
		PadBindings[field] = button
		Title.padconf.items[id+1].label = ("%s : %s"):format(Bindlist[id][2], button:upper())
		Title.padconf:updateSelected("kek")
		SaveConfig()
		STATE = "menu"
    elseif STATE == "ingame" then
        if button == PadBindings.pause then
            if Game.dead then
                Game:setLV(1)
                Game:reset(os.time())
                bottomtext = ""
                if Config.dynamic_bg == "X" then PrerenderBG() end
                STATE = "menu"
                SetBGM("menu")
            else
                STATE = "pause"
            end
        end
    else
        local boop = MenuPadControls[button]
        if boop then love.keypressed(boop) end
    end
end

function love.gamepadaxis(joystick, axis, value)
    CurrentController = joystick
    local dz = tonumber(Config.pad_deadzone)
    if not (value*100 > dz or -value*100 > dz) then return end
    local input = axis..(value > 0 and "+" or "-")
    
	if STATE == "padinput" then
		local id = Title.padconf.highlight - 1
		local field = Bindlist[id][1]
		Config["pad_"..field] = input
		PadBindings[field] = input
		Title.padconf.items[id+1].label = ("%s : %s"):format(Bindlist[id][2], input:upper())
		Title.padconf:updateSelected("kek")
		SaveConfig()
		STATE = "menu"
    elseif STATE == "ingame" then
        if input == PadBindings.pause then
            if Game.dead then
                Game:setLV(1)
                Game:reset(os.time())
                bottomtext = ""
                if Config.dynamic_bg == "X" then PrerenderBG() end
                STATE = "menu"
                SetBGM("menu")
            else
                STATE = "pause"
            end
        end
	end
end

function love.resize(w, h)
    ProcessResize(w, h)
end
