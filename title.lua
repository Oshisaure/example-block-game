--[==[
    Title screen for example block game
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

Title = {current = "main"}

local change = function(menu) return function(button) button.parent.highlight = 1; SaveConfig(); Title.current = menu end end
local open   = function(menu) return function(button)                              SaveConfig(); Title.current = menu end end

Title.main = Menu.new("Menu", {
	{x = 0, y = -0.2, label = "START GAME",      action_e = open("play")},
	{x = 0, y =  0.0, label = "SETTINGS",        action_e = open("settings")},
	{x = 0, y =  0.2, label = "HIGH SCORES",     action_e = open("highscores")}
	--[[
	{x = 0, y =  0.2, label = "Networking test",
		action_e = function(button)
			Game = Games.ss
			Game:reset(os.time())
			Game.time = 0
			-- ServerThreadUDP:start()
			ServerThreadTCP:start()
			STATE = "serverspec"
		end,
	},
	--]]
})

--[[
Title.play = Menu.new(MenuFont, {
	{x = 0, y = -0.2, label = "SINGLEPLAYER\n< DIFFICULTY : REGULAR >", param = 1,
		action_e = function(button)
			Game = Games[button.param]
            SetBGM(1)
			Game:reset(os.time())
			-- ConnectServer()
			STATE = "ingame"
            -- BGM:play()
		end,
		action_r = function(button)
			button.param = (button.param)   % #Levels + 1
			button.label = ("SINGLEPLAYER\n< DIFFICULTY : %s >"):format(Levels[button.param].name)
		end,
		action_l = function(button)
			button.param = (button.param-2) % #Levels + 1
			button.label = ("SINGLEPLAYER\n< DIFFICULTY : %s >"):format(Levels[button.param].name)
		end,
	},
	{x = 0, y =  0.1, label = "Local 1 vs 1",
		action_e = function()
			STATE = "battle2P"
			local seed = os.time()
			Games.P1:reset(seed, "Lilla")
			Games.P2:reset(seed, "Lilla")
		end
	},
	{x = 0, y =  0.3, label = "BACK", action_e = change("main")},
})
--]]
local gamemodes = {}
for i, mode in ipairs(Levels) do
    if mode.name ~= "Death" then -- keep that for carnival?
        table.insert(gamemodes, 
            {x = -0.5, y = -0.5+0.1*i, label = mode.name, id = i,
                action_e = function(button)
                    Game = Games[i]
                    Game:reset(os.time(), button.parent.startlv)
                    SetBGM(Game.BGM)
                    Game.display_score = 999999999 -- 999,999,999
                    if Config.dynamic_bg == "X" then PrerenderBG(Game.speedcurve.BG) end
					-- ApplyZoneMod(Game)
                    STATE = "ingame"
                end,
                action_l = function(button)
                    button.parent.startlv = math.max(button.parent.startlv - 1, 1)
                end,
                action_r = function(button)
                    button.parent.startlv = math.min(button.parent.startlv + 1, mode.maxstart or #mode)
                end,
            }
        )
    end
end
table.insert(gamemodes, {x = 0, y =  0.7, label = "BACK", action_e = change("main")})
Title.play = Menu.new("Menu", gamemodes)
Title.play.startlv = 1
Title.play.updateSelected = function(self, key)
	Menu.updateSelected(self, key)
	if key == "up" or key == "down" then self.startlv = 1 end
	local modeid = Title.play.items[Title.play.highlight].id

	if modeid then
		self.text:addf({{1,1,1}, Levels[modeid].description}, Width*0.4, "right", math.floor(Width*0.5), math.floor(Height*0.4))
		local leveldisp = Levels[modeid][Title.play.startlv].level_name
		if leveldisp == math.huge then leveldisp = "  " end
		self.text:addf({{1, 0.7, 0.5}, string.format("Start level: < %s >", leveldisp)}, Width, "center", 0, math.floor(Height*0.7))
	end
end
Title.play:updateSelected()

Title.settings = Menu.new("Menu", {
	{x = 0, y = -0.3, label = ("< BGM VOLUME : %d%% >"):format(Config.bgm_volume),
		action_e = function(button)
			local n = (tonumber(Config.bgm_volume) + 5) % 105
			Config.bgm_volume = tostring(n)
			button.label = ("< BGM VOLUME : %d%% >"):format(Config.bgm_volume)
            SetBGMVolume(n/100)
            SaveConfig()
		end,
		action_r = function(button)
			local n = math.min(tonumber(Config.bgm_volume) + 5, 100)
			Config.bgm_volume = tostring(n)
			button.label = ("< BGM VOLUME : %d%% >"):format(Config.bgm_volume)
            SetBGMVolume(n/100)
            SaveConfig()
		end,
		action_l = function(button)
			local n = math.max(tonumber(Config.bgm_volume) - 5, 0)
			Config.bgm_volume = tostring(n)
			button.label = ("< BGM VOLUME : %d%% >"):format(Config.bgm_volume)
            SetBGMVolume(n/100)
            SaveConfig()
		end,
    },
	{x = 0, y = -0.2, label = ("< SFX VOLUME : %d%% >"):format(Config.sfx_volume),
		action_e = function(button)
			local n = (tonumber(Config.sfx_volume) + 5) % 105
			Config.sfx_volume = tostring(n)
			button.label = ("< SFX VOLUME : %d%% >"):format(Config.sfx_volume)
            SetSFXVolume(n/100)
            SaveConfig()
		end,
		action_r = function(button)
			local n = math.min(tonumber(Config.sfx_volume) + 5, 100)
			Config.sfx_volume = tostring(n)
			button.label = ("< SFX VOLUME : %d%% >"):format(Config.sfx_volume)
            SetSFXVolume(n/100)
            SaveConfig()
		end,
		action_l = function(button)
			local n = math.max(tonumber(Config.sfx_volume) - 5, 0)
			Config.sfx_volume = tostring(n)
			button.label = ("< SFX VOLUME : %d%% >"):format(Config.sfx_volume)
            SetSFXVolume(n/100)
            SaveConfig()
		end,
    },
    
	{x = 0, y =  0.0, label = "KEYBOARD CONFIG",  action_e = open("keyconf")},
	{x = 0, y =  0.1, label = "GAMEPAD CONFIG",   action_e = open("padconf")},
	{x = 0, y =  0.3, label = "GRAPHICS OPTIONS", action_e = open("graphics")},
	{x = 0, y =  0.4, label = "WINDOW OPTIONS",   action_e = open("window")},
	{x = 0, y =  0.7, label = "BACK",             action_e = change("main")},
})

local keySettingsItems = {}
local padSettingsItems = {
	{x = 0, y = -0.4, label = ("< AXIS DEADZONE : %d%% >"):format(Config.pad_deadzone),
		action_e = function(button)
			local n = (tonumber(Config.pad_deadzone) + 5) % 105
			Config.pad_deadzone = tostring(n)
			button.label = ("< AXIS DEADZONE : %d%% >"):format(Config.pad_deadzone)
		end,
		action_r = function(button)
			local n = math.min(tonumber(Config.pad_deadzone) + 5, 100)
			Config.pad_deadzone = tostring(n)
			button.label = ("< AXIS DEADZONE : %d%% >"):format(Config.pad_deadzone)
		end,
		action_l = function(button)
			local n = math.max(tonumber(Config.pad_deadzone) - 5, 0)
			Config.pad_deadzone = tostring(n)
			button.label = ("< AXIS DEADZONE : %d%% >"):format(Config.pad_deadzone)
		end,
	},
}
for i = 1, #Bindlist do
    local kbt = {x = 0, y = -0.3+0.07*i, label = ("%s : %s"):format(Bindlist[i][2], (KeyBindings[Bindlist[i][1]] or "<NONE>"):upper()), id = i, action_e = function(button)
		button.label = ("%s : [AWAITING INPUT]"):format(Bindlist[i][2])
		STATE = "keyinput"
	end}
	table.insert(keySettingsItems, kbt)
    
    local cbt = {x = 0, y = -0.3+0.07*i, label = ("%s : %s"):format(Bindlist[i][2], (PadBindings[Bindlist[i][1]] or "<NONE>"):upper()), id = i, action_e = function(button)
		button.label = ("%s : [AWAITING INPUT]"):format(Bindlist[i][2])
		STATE = "padinput"
	end}
	table.insert(padSettingsItems, cbt)
end

table.insert(keySettingsItems, {x = 0, y = -0.07+0.07*#Bindlist, label = ("DONE"), id = i, action_e = change("settings")})
table.insert(padSettingsItems, {x = 0, y = -0.07+0.07*#Bindlist, label = ("DONE"), id = i, action_e = change("settings")})

Title.keyconf = Menu.new("Menu", keySettingsItems)
Title.padconf = Menu.new("Menu", padSettingsItems)

Title.graphics = Menu.new("Menu", {
	{x = 0, y = -0.4,
		label = ("MATRIX SWAY AMPLITUDE: <%s%s>"):format(("|"):rep(tonumber(Config.sway_amplitude)), ("."):rep(10 - tonumber(Config.sway_amplitude))),
		action_e = function(button)
			local n = (tonumber(Config.sway_amplitude) + 1) % 10
			button.label = ("MATRIX SWAY AMPLITUDE: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.sway_amplitude = tostring(n)
		end,
		action_r = function(button)
			local n = math.min(10, tonumber(Config.sway_amplitude) + 1)
			button.label = ("MATRIX SWAY AMPLITUDE: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.sway_amplitude = tostring(n)
		end,
		action_l = function(button)
			local n = math.max(0, tonumber(Config.sway_amplitude) - 1)
			button.label = ("MATRIX SWAY AMPLITUDE: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.sway_amplitude = tostring(n)
		end,
	},
	{x = 0, y = -0.3,
		label = ("MATRIX SWAY SPEED: <%s%s>"):format(("|"):rep(tonumber(Config.sway_speed)), ("."):rep(10 - tonumber(Config.sway_speed))),
		action_e = function(button)
			local n = (tonumber(Config.sway_speed) % 10) + 1
			button.label = ("MATRIX SWAY SPEED: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.sway_speed = tostring(n)
		end,
		action_r = function(button)
			local n = math.min(10, tonumber(Config.sway_speed) + 1)
			button.label = ("MATRIX SWAY SPEED: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.sway_speed = tostring(n)
		end,
		action_l = function(button)
			local n = math.max(1, tonumber(Config.sway_speed) - 1)
			button.label = ("MATRIX SWAY SPEED: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.sway_speed = tostring(n)
		end,
	},
	{x = 0, y = -0.2,
		label = ("MATRIX SWAY BOUNCINESS: <%s%s>"):format(("|"):rep(tonumber(Config.sway_bounciness)), ("."):rep(10 - tonumber(Config.sway_bounciness))),
		action_e = function(button)
			local n = (tonumber(Config.sway_bounciness) % 10) + 1
			button.label = ("MATRIX SWAY BOUNCINESS: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.sway_bounciness = tostring(n)
		end,
		action_r = function(button)
			local n = math.min(10, tonumber(Config.sway_bounciness) + 1)
			button.label = ("MATRIX SWAY BOUNCINESS: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.sway_bounciness = tostring(n)
		end,
		action_l = function(button)
			local n = math.max(1, tonumber(Config.sway_bounciness) - 1)
			button.label = ("MATRIX SWAY BOUNCINESS: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.sway_bounciness = tostring(n)
		end,
	},
	-- {x = 0, y =  0.0, label = ("< FULLSCREEN : %s >"):format(Config.vsync),
		-- action_e = function(button)
			-- Config.vsync = (Config.vsync == "O" and "X" or "O")
			-- button.label = ("< VSYNC : %s >"):format(Config.vsync)
            -- love.window.setVSync(Config.vsync == "O")
            -- SaveConfig()
		-- end,
		-- action_r = function(button)
			-- Config.vsync = (Config.vsync == "O" and "X" or "O")
			-- button.label = ("< VSYNC : %s >"):format(Config.vsync)
            -- love.window.setVSync(Config.vsync == "O")
            -- SaveConfig()
		-- end,
		-- action_l = function(button)
			-- Config.vsync = (Config.vsync == "O" and "X" or "O")
			-- button.label = ("< VSYNC : %s >"):format(Config.vsync)
            -- love.window.setVSync(Config.vsync == "O")
            -- SaveConfig()
		-- end,
    -- },
	{x = 0, y =  0.1, label = ("< DYNAMIC BACKGROUNDS : %s >"):format(Config.dynamic_bg),
		action_e = function(button)
			Config.dynamic_bg = (Config.dynamic_bg == "O" and "X" or "O")
			button.label = ("< DYNAMIC BACKGROUNDS : %s >"):format(Config.dynamic_bg)
            if Config.dynamic_bg == "X" then PrerenderBG() end
            SaveConfig()
		end,
		action_r = function(button)
			Config.dynamic_bg = (Config.dynamic_bg == "O" and "X" or "O")
			button.label = ("< DYNAMIC BACKGROUNDS : %s >"):format(Config.dynamic_bg)
            if Config.dynamic_bg == "X" then PrerenderBG() end
            SaveConfig()
		end,
		action_l = function(button)
			Config.dynamic_bg = (Config.dynamic_bg == "O" and "X" or "O")
			button.label = ("< DYNAMIC BACKGROUNDS : %s >"):format(Config.dynamic_bg)
            if Config.dynamic_bg == "X" then PrerenderBG() end
            SaveConfig()
		end,
    },
	{x = 0, y =  0.2, label = ("< BACKGROUND BRIGHTNESS : %d%% >"):format(Config.bg_brightness),
		action_e = function(button)
			local n = (tonumber(Config.bg_brightness) + 5) % 105
			Config.bg_brightness = tostring(n)
			button.label = ("< BACKGROUND BRIGHTNESS : %d%% >"):format(Config.bg_brightness)
            SaveConfig()
		end,
		action_r = function(button)
			local n = math.min(tonumber(Config.bg_brightness) + 5, 100)
			Config.bg_brightness = tostring(n)
			button.label = ("< BACKGROUND BRIGHTNESS : %d%% >"):format(Config.bg_brightness)
            SaveConfig()
		end,
		action_l = function(button)
			local n = math.max(tonumber(Config.bg_brightness) - 5, 0)
			Config.bg_brightness = tostring(n)
			button.label = ("< BACKGROUND BRIGHTNESS : %d%% >"):format(Config.bg_brightness)
            SaveConfig()
		end,
    },
	{x = 0, y =  0.3,
		label = ("BLUR SPREAD: <%s%s>"):format(("|"):rep(tonumber(Config.blur_spread)), ("."):rep(10 - tonumber(Config.blur_spread))),
		action_e = function(button)
			local n = (tonumber(Config.blur_spread) % 10)
			button.label = ("BLUR SPREAD: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.blur_spread = tostring(n)
		end,
		action_r = function(button)
			local n = math.min(10, tonumber(Config.blur_spread) + 1)
			button.label = ("BLUR SPREAD: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.blur_spread = tostring(n)
		end,
		action_l = function(button)
			local n = math.max(0, tonumber(Config.blur_spread) - 1)
			button.label = ("BLUR SPREAD: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.blur_spread = tostring(n)
		end,
	},
	{x = 0, y =  0.4,
		label = ("TRAIL FADEOUT DURATION: <%s%s>"):format(("|"):rep(tonumber(Config.trail_duration)), ("."):rep(10 - tonumber(Config.trail_duration))),
		action_e = function(button)
			local n = (tonumber(Config.trail_duration) % 10)
			button.label = ("TRAIL FADEOUT DURATION: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.trail_duration = tostring(n)
		end,
		action_r = function(button)
			local n = math.min(10, tonumber(Config.trail_duration) + 1)
			button.label = ("TRAIL FADEOUT DURATION: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.trail_duration = tostring(n)
		end,
		action_l = function(button)
			local n = math.max(0, tonumber(Config.trail_duration) - 1)
			button.label = ("TRAIL FADEOUT DURATION: <%s%s>"):format(("|"):rep(n), ("."):rep(10 - n))
			Config.trail_duration = tostring(n)
		end,
	},
	{x = 0, y =  0.7, label = "BACK", action_e = change("settings")},
})

Title.window = Menu.new("Menu", {
	{x = 0, y = -0.2,
	label = ("< RESOLUTION : %4dx%4d >\n(SCREEN #%d)"):format(FullScreenModes[1].width, FullScreenModes[1].height, FullScreenModes[1].display),
	param = 1,
		action_e = function(button)
			button.param = (button.param % #FullScreenModes) + 1
			local mode = FullScreenModes[button.param]
			button.label = ("< RESOLUTION : %4dx%4d >\n(SCREEN #%d)"):format(mode.width, mode.height, mode.display)
		end,
		action_r = function(button)
			button.param = (button.param % #FullScreenModes) + 1
			local mode = FullScreenModes[button.param]
			button.label = ("< RESOLUTION : %4dx%4d >\n(SCREEN #%d)"):format(mode.width, mode.height, mode.display)
		end,
		action_l = function(button)
			button.param = ((button.param - 2) % #FullScreenModes) + 1
			local mode = FullScreenModes[button.param]
			button.label = ("< RESOLUTION : %4dx%4d >\n(SCREEN #%d)"):format(mode.width, mode.height, mode.display)
		end,
    },
	{x = 0, y =  0.1, label = ("< FULLSCREEN : %s >"):format(Config.fullscreen), param = Config.fullscreen,
		action_e = function(button)
			button.param = (button.param == "O" and "X" or "O")
			button.label = ("< FULLSCREEN : %s >"):format(button.param)
		end,
		action_r = function(button)
			button.param = (button.param == "O" and "X" or "O")
			button.label = ("< FULLSCREEN : %s >"):format(button.param)
		end,
		action_l = function(button)
			button.param = (button.param == "O" and "X" or "O")
			button.label = ("< FULLSCREEN : %s >"):format(button.param)
		end,
    },
	{x = 0, y =  0.2, label = ("< VSYNC : %s >"):format(Config.vsync), param = Config.vsync,
		action_e = function(button)
			button.param = (button.param == "O" and "X" or "O")
			button.label = ("< VSYNC : %s >"):format(button.param)
		end,
		action_r = function(button)
			button.param = (button.param == "O" and "X" or "O")
			button.label = ("< VSYNC : %s >"):format(button.param)
		end,
		action_l = function(button)
			button.param = (button.param == "O" and "X" or "O")
			button.label = ("< VSYNC : %s >"):format(button.param)
		end,
    },
	
	{x = 0, y =  0.5, label = "APPLY",
		action_e = function(button)
			local width, height, display, vsync, fs
			local buttons = button.parent.items
			local mode = FullScreenModes[buttons[1].param]
			width, height, display = mode.width, mode.height, mode.display
			fs    = buttons[2].param
			vsync = buttons[3].param
			SetDisplayMode(width, height, display, fs == "O", vsync == "O")
			Config.window_width   = tostring(width  )
			Config.window_height  = tostring(height )
			Config.window_display = tostring(display)
			Config.fullscreen = fs
			Config.vsync      = vsync
		end
	},
	{x = 0, y =  0.7, label = "BACK",  action_e = change("settings")},
})



-- sets the default high score mode view to the first mode alphabetically
local hs_keys = {}
local mode_indices = {} -- to prevent unnecessary lookups
for k,v in pairs(HighScores) do
	if(k ~= "Death") then table.insert(hs_keys,k) end -- death is technically a secret mode
	for i=1,#Levels do
		if(Levels[i].name == k) then mode_indices[k] = i end
	end
end
table.sort(hs_keys) -- alphabetical order
if(#hs_keys == 0) then
	error("No high score keys. Are you sure there's at least one mode?")
end

Title.highscores = Menu.new("Menu", {
	{x = 0, y = -0.8, label = "< MODE: "..hs_keys[1].." >",
		action_l = function(button)
			Title.highscores.selection = (Title.highscores.selection+#Title.highscores.modeList-2)%(#Title.highscores.modeList)+1
			button.label = "< MODE: "..hs_keys[Title.highscores.selection].." >"
		end,
		action_r = function(button)
			Title.highscores.selection = (Title.highscores.selection)%(#Title.highscores.modeList)+1
			button.label = "< MODE: "..hs_keys[Title.highscores.selection].." >"
		end},
	{x = 0, y = -0.7, label = "< SHOW CLEAR STATISTICS: X >",
		action_l = function(button)
			Title.highscores.showclear = not Title.highscores.showclear
			button.label = "< SHOW CLEAR STATISTICS: " .. (Title.highscores.showclear and "O" or "X") .. " >"
		end,
		action_r = function(button)
			Title.highscores.showclear = not Title.highscores.showclear
			button.label = "< SHOW CLEAR STATISTICS: " .. (Title.highscores.showclear and "O" or "X") .. " >"
		end},
	{x = 0, y =  0.7, label = "BACK", action_e = function(button)
		Title.highscores.resetCounter = 0
		Title.highscores.items[4].label = "RESET HIGH SCORES"
		change("main")(button)
	end},
	{x = 0, y =  0.8, label = "RESET HIGH SCORES", action_e = function(button)
		Title.highscores.resetCounter = Title.highscores.resetCounter + 1
		if(Title.highscores.resetCounter == 1) then
			button.label = "ARE YOU SURE YOU WANT TO CLEAR RECORDS?"
		elseif(Title.highscores.resetCounter == 2) then
			button.label = "ARE YOU REALLY SURE?"
		elseif(Title.highscores.resetCounter == 3) then
			button.label = "LAST CHANCE! ARE YOU SURE YOU WANT TO?"
		else
			button.label = "RESET HIGH SCORES"
			Title.highscores.resetCounter = 0
			for _,mode in pairs(Levels) do
				local name = mode.name
				HighScores[name] = {}
			end
			SaveHighScores()
		end
	end}
})
Title.highscores.selection = 1
Title.highscores.modeList = hs_keys
Title.highscores.modeIndices = mode_indices
Title.highscores.showclear = false
Title.highscores.resetCounter = 0