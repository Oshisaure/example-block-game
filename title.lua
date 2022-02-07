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
	{x = 0, y = -0.2, label = "START GAME",  action_e = open("play")},
	{x = 0, y =  0.0, label = "SETTINGS",    action_e = open("settings")},
	{x = 0, y =  0.2, label = "HIGH SCORES", action_e = open("highscores")}
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
			Config.bgm_volume = tostring((tonumber(Config.bgm_volume) + 5) % 105)
		end,
		action_r = function(button)
			Config.bgm_volume = tostring(math.min(tonumber(Config.bgm_volume) + 5, 100))
		end,
		action_l = function(button)
			Config.bgm_volume = tostring(math.max(tonumber(Config.bgm_volume) - 5, 0))
		end,
        update = function(button)
            button.label = ("< BGM VOLUME : %d%% >"):format(Config.bgm_volume)
            SetBGMVolume(tonumber(Config.bgm_volume)/100)
        end
    },
	{x = 0, y = -0.2, label = ("< SFX VOLUME : %d%% >"):format(Config.sfx_volume),
		action_e = function(button)
			Config.sfx_volume = tostring((tonumber(Config.sfx_volume) + 5) % 105)
		end,
		action_r = function(button)
			Config.sfx_volume = tostring(math.min(tonumber(Config.sfx_volume) + 5, 100))
		end,
		action_l = function(button)
			Config.sfx_volume = tostring(math.max(tonumber(Config.sfx_volume) - 5, 0))
		end,
        update = function(button)
			button.label = ("< SFX VOLUME : %d%% >"):format(Config.sfx_volume)
            SetSFXVolume(tonumber(Config.sfx_volume)/100)
        end
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
			Config.pad_deadzone = tostring((tonumber(Config.pad_deadzone) + 5) % 105)
		end,
		action_r = function(button)
			Config.pad_deadzone = tostring(math.min(tonumber(Config.pad_deadzone) + 5, 100))
		end,
		action_l = function(button)
			Config.pad_deadzone = tostring(math.max(tonumber(Config.pad_deadzone) - 5, 0))
		end,
        update = function(button)
            button.label = ("< AXIS DEADZONE : %d%% >"):format(Config.pad_deadzone)
        end
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
			Config.sway_amplitude = tostring((tonumber(Config.sway_amplitude) + 1) % 10)
		end,
		action_r = function(button)
			Config.sway_amplitude = tostring(math.min(10, tonumber(Config.sway_amplitude) + 1))
		end,
		action_l = function(button)
			Config.sway_amplitude = tostring(math.max(0, tonumber(Config.sway_amplitude) - 1))
		end,
        update = function(button)
            button.label = ("MATRIX SWAY AMPLITUDE: <%s%s>"):format(("|"):rep(Config.sway_amplitude), ("."):rep(10 - Config.sway_amplitude))
        end
	},
	{x = 0, y = -0.3,
		label = ("MATRIX SWAY SPEED: <%s%s>"):format(("|"):rep(tonumber(Config.sway_speed)), ("."):rep(10 - tonumber(Config.sway_speed))),
		action_e = function(button)
			Config.sway_speed = tostring((tonumber(Config.sway_speed) % 10) + 1)
		end,
		action_r = function(button)
			Config.sway_speed = tostring(math.min(10, tonumber(Config.sway_speed) + 1))
		end,
		action_l = function(button)
			Config.sway_speed = tostring(math.max(1, tonumber(Config.sway_speed) - 1))
		end,
        update = function(button)
            button.label = ("MATRIX SWAY SPEED: <%s%s>"):format(("|"):rep(Config.sway_speed), ("."):rep(10 - Config.sway_speed))
        end
	},
	{x = 0, y = -0.2,
		label = ("MATRIX SWAY BOUNCINESS: <%s%s>"):format(("|"):rep(tonumber(Config.sway_bounciness)), ("."):rep(10 - tonumber(Config.sway_bounciness))),
		action_e = function(button)
			Config.sway_bounciness = tostring((tonumber(Config.sway_bounciness) % 10) + 1)
		end,
		action_r = function(button)
			Config.sway_bounciness = tostring(math.min(10, tonumber(Config.sway_bounciness) + 1))
		end,
		action_l = function(button)
			Config.sway_bounciness = tostring(math.max(1, tonumber(Config.sway_bounciness) - 1))
		end,
        update = function(button)
            button.label = ("MATRIX SWAY BOUNCINESS: <%s%s>"):format(("|"):rep(Config.sway_bounciness), ("."):rep(10 - Config.sway_bounciness))
        end
	},
	{x = 0, y =  0.1, label = ("< DYNAMIC BACKGROUNDS : %s >"):format(Config.dynamic_bg),
        update = function(button)
            Config.dynamic_bg = (Config.dynamic_bg == "O" and "X" or "O")
            button.label = ("< DYNAMIC BACKGROUNDS : %s >"):format(Config.dynamic_bg)
            if Config.dynamic_bg == "X" then PrerenderBG() end
        end
    },
	{x = 0, y =  0.2, label = ("< BACKGROUND BRIGHTNESS : %d%% >"):format(Config.bg_brightness),
		action_e = function(button)
			Config.bg_brightness = tostring((tonumber(Config.bg_brightness) + 5) % 105)
		end,
		action_r = function(button)
			Config.bg_brightness = tostring(math.min(tonumber(Config.bg_brightness) + 5, 100))
		end,
		action_l = function(button)
			Config.bg_brightness = tostring(math.max(tonumber(Config.bg_brightness) - 5, 0))
		end,
        update = function(button)
            button.label = ("< BACKGROUND BRIGHTNESS : %d%% >"):format(Config.bg_brightness)
        end
    },
	{x = 0, y =  0.3, label = ("BLUR SPREAD: <%s%s>"):format(("|"):rep(tonumber(Config.blur_spread)), ("."):rep(10 - tonumber(Config.blur_spread))),
		action_e = function(button)
			Config.blur_spread = tostring((tonumber(Config.blur_spread) % 10))
		end,
		action_r = function(button)
			Config.blur_spread = tostring(math.min(10, tonumber(Config.blur_spread) + 1))
		end,
		action_l = function(button)
			Config.blur_spread = tostring(math.max(0, tonumber(Config.blur_spread) - 1))
		end,
        update = function(button)
            button.label = ("BLUR SPREAD: <%s%s>"):format(("|"):rep(Config.blur_spread), ("."):rep(10 - Config.blur_spread))
        end
	},
	{x = 0, y =  0.4, label = ("TRAIL FADEOUT DURATION: <%s%s>"):format(("|"):rep(tonumber(Config.trail_duration)), ("."):rep(10 - tonumber(Config.trail_duration))),
		action_e = function(button)
			Config.trail_duration = tostring((tonumber(Config.trail_duration) % 10))
		end,
		action_r = function(button)
			Config.trail_duration = tostring(math.min(10, tonumber(Config.trail_duration) + 1))
		end,
		action_l = function(button)
			Config.trail_duration = tostring(math.max(0, tonumber(Config.trail_duration) - 1))
		end,
        update = function(button)
            button.label = ("TRAIL FADEOUT DURATION: <%s%s>"):format(("|"):rep(Config.trail_duration), ("."):rep(10 - Config.trail_duration))
        end
	},
	{x = 0, y =  0.7, label = "BACK", action_e = change("settings")},
})

Title.window = Menu.new("Menu", {
	{x = 0, y =  -0.3, param = 1, prev_screen = 1, label = ("< SCREEN : %s >"):format(1),
		action_e = function(button)
            button.prev_screen = button.param
			button.param = (button.param % #FullScreenModes) + 1
		end,
		action_r = function(button)
			button.prev_screen = button.param
            button.param = (button.param % #FullScreenModes) + 1
		end,
		action_l = function(button)
			button.prev_screen = button.param
            button.param = ((button.param - 2) % #FullScreenModes) + 1
		end,
        update = function(button)
            button.label = ("< SCREEN : %s >"):format(button.param)

			local prev_resolution_id = button.parent.items[2].param
            local prev_resolutions   = FullScreenModes[button.prev_screen]
            local cur_resolutions    = FullScreenModes[button.param]
            local prev_mode          = prev_resolutions[prev_resolution_id]

            local res_id_found
            for i, mode in pairs(cur_resolutions) do
                if mode.width == prev_mode.width and mode.height == prev_mode.height then
                    res_id_found = i
                    break
                elseif (mode.width > prev_mode.width and mode.height == prev_mode.height) or
                        mode.height > prev_mode.height then
                    res_id_found = i-1
                    break
                end
            end
            if not res_id_found then res_id_found = #cur_resolutions end

            -- Updates `RESOLUTION` item to match a selected screen's resolutions.
            button.parent.items[2].param = res_id_found
            button.parent.items[2]:update(2)
        end
    },

	{x = 0, y = -0.2, param = 1, label = ("< RESOLUTION : %4dx%4d >"):format("640", "480"),
		action_e = function(button)
			local cur_screen = button.parent.items[1].param
			button.param = (button.param % #FullScreenModes[cur_screen]) + 1
		end,
		action_r = function(button)
			local cur_screen = button.parent.items[1].param
			button.param = (button.param % #FullScreenModes[cur_screen]) + 1
		end,
		action_l = function(button)
			local cur_screen = button.parent.items[1].param
			button.param = ((button.param - 2) % #FullScreenModes[cur_screen]) + 1
		end,
		update = function(button)
			local cur_screen = button.parent.items[1].param
			local mode = FullScreenModes[cur_screen][button.param]
			--button.label = ("< RESOLUTION : %4dx%4d >\n(SCREEN #%d)"):format(mode.width, mode.height, cur_screen) -- Debuge
			button.label = ("< RESOLUTION : %4dx%4d >"):format(mode.width, mode.height)
		end
    },

	{x = 0, y = 0.1, param = Config.fullscreen, label = ("< FULLSCREEN : %s >"):format(Config.fullscreen),
        update = function(button)
            button.param = (button.param == "O" and "X" or "O")
            button.label = ("< FULLSCREEN : %s >"):format(button.param)
        end
    },

	{x = 0, y = 0.2, param = Config.vsync, label = ("< VSYNC : %s >"):format(Config.vsync),
        update = function(button)
            button.param = (button.param == "O" and "X" or "O")
            button.label = ("< VSYNC : %s >"):format(button.param)
        end
    },
	
	{x = 0, y = 0.5, label = "APPLY",
		action_e = function(button)
			local buttons = button.parent.items
			local display = buttons[1].param
			local mode    = FullScreenModes[display][buttons[2].param]

			local width, height = mode.width, mode.height
			local fs, vsync     = buttons[3].param, buttons[4].param

            SetDisplayMode(width, height, display, fs == "O", vsync == "O")
			Config.window_width   = tostring(width  )
			Config.window_height  = tostring(height )
			Config.window_display = tostring(display)
			Config.fullscreen     = fs
			Config.vsync          = vsync
		end
	},

	{x = 0, y =  0.7, label = "BACK",  action_e = change("settings")},
})



-- sets the default high score mode view to the first mode alphabetically
local hs_keys = {}
local mode_indices = {} -- to prevent unnecessary lookups
for k, _ in pairs(HighScores) do
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