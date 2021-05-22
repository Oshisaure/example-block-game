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
	Width, Height = love.graphics.getDimensions()
	HUDFont = love.graphics.newFont("assets/font/exampleblockgame.ttf", math.floor(Height/50))
	MenuFont = love.graphics.newFont("assets/font/exampleblockgame.ttf", math.floor(Height/32))
	TitleFont = love.graphics.newFont("assets/font/exampleblockgame.ttf", math.floor(Height/16))

	require("util")
	require("config")
	require("piece")
	require("engine")
	require("speedcurve")
	-- require("characters")
	-- require("netserver")
	-- require("netclient")
	require("menu")
	require("title")
	require("splash")
    
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
               love.audio.newSource("assets/bgm/aryx.s3m"                          , "stream"),
    }
    for _, track in pairs(BGM) do
        track:setLooping(true)
        track:setVolume(tostring(Config.bgm_volume)/100)
    end
	BlockSize = Height/40
	BlockCanvas = love.graphics.newCanvas(BlockSize,BlockSize)
	love.graphics.setCanvas(BlockCanvas)
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle("fill",0,0,BlockSize,BlockSize)
	love.graphics.setCanvas()
	Games = {}
	for i = 1, #Levels do
		Games[i] = Board.new(Levels[i], os.time(), BlockSize, BlockCanvas, 0.5, 0.5)
	end
	-- Games.P1 = Board.new(Levels["vs"], os.time(), BlockSize, BlockCanvas, 0.5 - 0.23, 0.5)
	-- Games.P2 = Board.new(Levels["vs"], os.time(), BlockSize, BlockCanvas, 0.5 + 0.23, 0.5)
	-- Games.ss = Board.new(Levels["serv"], os.time(), BlockSize, BlockCanvas, 0.5 - 0.23, 0.5)
    
    TitleText = love.graphics.newText(TitleFont, "EXAMPLE BLOCK GAME")
    ScoreText = love.graphics.newText(TitleFont)
    
    -- ShaderXD = love.graphics.newShader("shaders/chroma-misalign.glsl")
    ShaderBG = {
        practice  = love.graphics.newShader("shaders/bgpractice.glsl"),
        practice2 = love.graphics.newShader("shaders/bgpractice2.glsl"),
        original  = love.graphics.newShader("shaders/bg1.glsl"),
        master    = love.graphics.newShader("shaders/bg10.glsl"),
        menu      = love.graphics.newShader("shaders/bgmenu.glsl"),
    }
    ShaderBlur    = love.graphics.newShader("shaders/blur.glsl")
    ShaderRainbow = love.graphics.newShader("shaders/rainbow.glsl")
    CanvasBG      = love.graphics.newCanvas()
    CanvasBGprev  = love.graphics.newCanvas()
    CanvasRainbow = love.graphics.newCanvas()
    
    local moontex = love.graphics.newImage("assets/texture/lroc_color_poles_2k.png")
    local moondis = love.graphics.newImage("assets/texture/ldem_4_uint.png")
    local moondw, moondh = moondis:getDimensions()
    local moonnor = love.graphics.newCanvas(moondw, moondh)
    local normalshader = love.graphics.newShader("shaders/displacementnormals.glsl")
    normalshader:send("off", {1/moondw, 1/moondh, 0})
    love.graphics.setCanvas(moonnor)
    love.graphics.setShader(normalshader)
    love.graphics.draw(moondis)
    love.graphics.setCanvas()
    love.graphics.setShader()
    ShaderBG.practice :send("moontex", moontex)
    ShaderBG.practice :send("moonnor", moonnor)
    ShaderBG.practice2:send("moontex", moontex)
    ShaderBG.practice2:send("moonnor", moonnor)
    
    --[[
    Width = 3840
    Height = 2160
    CanvasBG      = love.graphics.newCanvas(Width, Height)
    CanvasBGprev  = love.graphics.newCanvas(Width, Height)
    PrerenderShaders()
    Prerendered_frames["master"]:newImageData():encode("png", "master_bg_4k.png")
    Prerendered_frames["practice"]:newImageData():encode("png", "practice_bg_4k.png")
    Prerendered_frames["practice2"]:newImageData():encode("png", "practice2_bg_4k.png")
	Width, Height = love.graphics.getDimensions()
    CanvasBG      = love.graphics.newCanvas()
    CanvasBGprev  = love.graphics.newCanvas()
    --]]
    if Config.use_glsl_shaders == "X" then PrerenderShaders() end
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
	love.graphics.setFont(MenuFont)
	
	bottomtext = ""
	STATE = "splash"
    SetBGM()
	UpdateTime = 0
	UpdateRate = 30
end


function love.update(dt)
    UpdateShadersUniforms(dt)
	if STATE == "splash" then
        UpdateSplashScreen(dt)
	elseif STATE == "ingame" then
		if not Game.dead then
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
            Game.display_score = Game.score - (Game.score - (Game.display_score or 0)) * 0.001^dt
            ScoreText:set(CommaValue(math.floor(Game.display_score+0.5)))
            
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
		end
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
        DrawRainbow(CanvasRainbow)
        love.graphics.setCanvas()
        local b = tonumber(Config.bg_brightness)/100
		love.graphics.setColor(b, b, b)
        love.graphics.draw(CanvasBG)
		love.graphics.setColor(1,1,1)
		love.graphics.draw(Title[Title.current].text)
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
		love.graphics.setColor(1, 1, 1)
        
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
        
        --[[shader test
        love.graphics.setShader(ShaderXD)
        local shiftDamp = (Game.last_collision_down  or -math.huge) - Game.time
        local shiftLamp = (Game.last_collision_left  or -math.huge) - Game.time
        local shiftRamp = (Game.last_collision_right or -math.huge) - Game.time
        local decay  = 40
        local decay2 = 10
        local sh_scale = 0.0 -- 0.1
        local an_scale = 0.0 -- 0.1
        local distortscaleX = 0.03
        local distortscaleY = 0.04
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
        
        --ShaderXD:send("shift", shift)
        ShaderXD:send("shift", {0,0,0,0,0,0,0,0,0})
        ShaderXD:send("angle", angle)
        ShaderXD:send("distort", distort)
        ShaderXD:send("time", os.clock())
        --]]
        
        RenderBG(Game.speedcurve.BG)
        love.graphics.setCanvas(CanvasBG)
        love.graphics.draw(Game.canvas)
        love.graphics.setCanvas()
        local b = tonumber(Config.bg_brightness)/100
		love.graphics.setColor(b, b, b)
        love.graphics.draw(CanvasBG)
        love.graphics.setColor(1,1,1)
        -- [===[ activate this block comment to render none of the HUD and only the BG
        love.graphics.draw(Game.canvas)
        -- love.graphics.draw(Game.overlay_canvas)
        
		-- love.graphics.draw(Game.canvas, -Width*0.23, 0)
        -- love.graphics.setShader()
		-- love.graphics.printf(bottomtext, -Width*0.23, Height*0.86, Width, "center")
        local w7, w6 = Width*0.5-7*Game.size, Width*0.5-6*Game.size
        love.graphics.setFont(MenuFont)
        love.graphics.printf("HOLD", 0,        Height*0.2, w7, "right")
        love.graphics.printf("NEXT", Width-w7, Height*0.2, w7, "left")
        love.graphics.setFont(HUDFont)
        love.graphics.printf("LINE CLEAR STATISTICS", 0, Height*0.4, w6, "center")
        
		for k, id in ipairs(Piece.IDs) do
			love.graphics.setColor(unpack(Piece.colours[id]))
			love.graphics.print(id, w6*(0.20+0.1*k), Height*0.45)
		end
		for i, lc in ipairs(LineClearTypes) do
			local j = i + (i > 4 and 1 or 0) -- skip a line between regular and spin clears
			love.graphics.setColor(1, 1, 1)
			love.graphics.print(lc[3], w6*0.05, Height*(0.45+0.025*j))
			for k, id in ipairs(Piece.IDs) do
				love.graphics.setColor(unpack(Piece.colours[id]))
				love.graphics.print(Game.stat[lc[2]][id][lc[1]], w6*(0.20+0.1*k), Height*(0.45+0.025*j))
			end
		end
		-- if Game.stat[true]["I"][4] and Game.stat[true]["I"][4] > 0 then
			-- love.graphics.setColor(1, 1, 1)
			-- love.graphics.print("Spin-4", w6*0.05, Height*(0.45+0.025*10))
			-- love.graphics.setColor(unpack(Piece.colours["I"]))
			-- love.graphics.print(Game.stat[true]["I"][4], w6*(0.20+0.01), Height*(0.45+0.025*10))
		-- end
        
		love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(HUDFont)
        love.graphics.printf("LEVEL", Width*0.75, Height*0.40, Width*0.2, "left")
        love.graphics.printf("LINES", Width*0.75, Height*0.50, Width*0.2, "left")
        love.graphics.printf("TIME ", Width*0.75, Height*0.60, Width*0.2, "left")
        love.graphics.setFont(MenuFont)
        love.graphics.printf("SCORE", Width*0.75, Height*0.80, Width*0.2, "right")
        
        love.graphics.printf(Game.level_name,        Width*0.75, Height*0.425, Width*0.2, "right")
        love.graphics.printf(Game.lines,             Width*0.75, Height*0.525, Width*0.2, "right")
        love.graphics.printf(FormatTime(Game.time),  Width*0.75, Height*0.625, Width*0.2, "right")
        
        local stw, sth = ScoreText:getDimensions()
        love.graphics.draw(ScoreText, Width*0.95-stw/2, Height*0.85+sth/2, math.log(math.max(Game.score-Game.display_score, 0)+1)/math.log(Game.score+2)*0.1, 1, 1, stw/2, sth/2, -0.3)
        
        -- love.graphics.setColor(0.5, 0.5, 0.5)
		-- love.graphics.print("Bag:"..table.concat(Game.bag).."\nHistory:"..table.concat(Game.history), Width*0.62, Height*0.86)
        
        --]===]
	end
    
    love.graphics.setFont(MenuFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(love.timer.getFPS().."FPS")
end

function love.keypressed(key)
	if STATE == "ingame" and key == "return" and Game.dead then
		Game:reset(os.time())
		Game:setLV(1)
		-- DisconnectServer()
		bottomtext = ""
		STATE = "menu"
        SetBGM("menu")
    --[[
	elseif STATE == "ingame" then
        if key == "kp8" then Game.position_y = Game.position_y - 0.1 end
        if key == "kp2" then Game.position_y = Game.position_y + 0.1 end
        if key == "kp4" then Game.position_x = Game.position_x - 0.1 end
        if key == "kp6" then Game.position_x = Game.position_x + 0.1 end
    ]]
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
    else
        local boop = MenuPadControls[button]
        if boop then love.keypressed(boop) end
    end
end

function love.gamepadaxis(joystick, axis, value)
    CurrentController = joystick
    local dz = tonumber(Config.pad_deadzone)
	if STATE == "padinput" and (value*100 > dz or -value*100 > dz) then
		local id = Title.padconf.highlight - 1
		local field = Bindlist[id][1]
        local input = axis..(value > 0 and "+" or "-")
		Config["pad_"..field] = input
		PadBindings[field] = input
		Title.padconf.items[id+1].label = ("%s : %s"):format(Bindlist[id][2], input:upper())
		Title.padconf:updateSelected("kek")
		SaveConfig()
		STATE = "menu"
	end
end
