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
local today = os.date("*t")
local carnivalhours = (today.month == 2 and today.day >= 28)
                   or (today.month == 3)
                   or (today.month == 4 and today.day == 1)
local gamemodes = {}
for i, mode in ipairs(Levels) do
    if mode.name ~= "Death" or #HighScores["Death"] > 0 or carnivalhours then
        table.insert(gamemodes, 
            {x = -0.5, y = -0.5+0.1*i, label = mode.name, id = i,
                action_e = function(button)
                    Game = Games[i]
                    Game:reset(os.time(), button.parent.startlv)
                    SetBGM(Game.BGM)
                    Game.display_score = 999999999 -- 999,999,999
                    if Config.dynamic_bg == "X" then
                        SendShaderUniform("level",     Game.level)
                        SendShaderUniform("levelprev", Game.level)
                        PrerenderBG(Game.speedcurve.BG)
                    end
					-- ApplyZoneMod(Game)
                    STATE = "ingame"
                end,
                action_l = function(button)
                    button.parent.startlv = math.max(button.parent.startlv - 1, 1)
                end,
                action_r = function(button)
                    button.parent.startlv = math.min(button.parent.startlv + 1, mode.maxstart or mode.maxlevel)
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
		self.text:addf({{1,1,1}, Levels[modeid].description}, Width*0.4, "right", math.floor(Width*0.5), math.floor(Height*0.35))
		local leveldisp = Levels[modeid][Title.play.startlv].level_name
		if leveldisp == math.huge then leveldisp = "  " end
		self.text:addf({{1, 0.7, 0.5}, string.format("Start level: < %s >", leveldisp)}, Width, "center", 0, math.floor(Height*0.7))
	end
end
Title.play:updateSelected()

Title.settings = Menu.new("Menu", {
    {x = 0, y = -0.3, label = ("BGM VOLUME : < %d%% >"):format(Config.bgm_volume),
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
            button.label = ("BGM VOLUME : < %d%% >"):format(Config.bgm_volume)
            SetBGMVolume(tonumber(Config.bgm_volume)/100)
        end
    },
	{x = 0, y = -0.2, label = ("SFX VOLUME : < %d%% >"):format(Config.sfx_volume),
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
			button.label = ("SFX VOLUME : < %d%% >"):format(Config.sfx_volume)
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
	{x = 0, y = -0.4, label = ("AXIS DEADZONE : < %d%% >"):format(Config.pad_deadzone),
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
            button.label = ("AXIS DEADZONE : < %d%% >"):format(Config.pad_deadzone)
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
	{x = 0, y = -0.4, param = 0,
		label = ("MATRIX SWAY AMPLITUDE: <%s>"):format(DrawBar(Config.sway_amplitude, 10)),
		action_e = function(button)
			Config.sway_amplitude = tostring((tonumber(Config.sway_amplitude) + 1) % 11)
		end,
		action_r = function(button)
			button.param = 1
		end,
		action_l = function(button)
			button.param = -1
		end,
        update = function(button)
			Config.sway_amplitude = tostring(Clamp(tonumber(Config.sway_amplitude) + button.param, 0, 10))
			button.param = 0
            button.label = ("MATRIX SWAY AMPLITUDE: <%s>"):format(DrawBar(Config.sway_amplitude, 10))
        end
	},

	{x = 0, y = -0.3,
		label = ("MATRIX SWAY SPEED: <%s>"):format(DrawBar(Config.sway_speed, 10)),
		action_e = function(button)
			Config.sway_speed = tostring(Mod1(tonumber(Config.sway_speed) + 1, 10))
		end,
		action_r = function(button)
			button.param = 1
		end,
		action_l = function(button)
			button.param = -1
		end,
        update = function(button)
			Config.sway_speed = tostring(Clamp(tonumber(Config.sway_speed) + button.param, 1, 10))
			button.param = 0
            button.label = ("MATRIX SWAY SPEED: <%s>"):format(DrawBar(Config.sway_speed, 10))
        end
	},

	{x = 0, y = -0.2, param = 0, label = ("MATRIX SWAY BOUNCINESS: <%s>"):format(DrawBar(Config.sway_bounciness, 10)),
		action_e = function(button)
			Config.sway_bounciness = tostring(Mod1(tonumber(Config.sway_bounciness) + 1, 10))
		end,
		action_r = function(button)
			button.param = 1
		end,
		action_l = function(button)
			button.param = -1
		end,
        update = function(button)
			Config.sway_bounciness = tostring(Clamp(tonumber(Config.sway_bounciness) + button.param, 1, 10))
			button.param = 0
            button.label = ("MATRIX SWAY BOUNCINESS: <%s>"):format(DrawBar(Config.sway_bounciness, 10))
        end
	},

	{x = 0, y =  0.0, label = ("DYNAMIC BACKGROUNDS : < %s >"):format(Config.dynamic_bg),
        update = function(button)
            Config.dynamic_bg = (Config.dynamic_bg == "O" and "X" or "O")
            button.label = ("DYNAMIC BACKGROUNDS : < %s >"):format(Config.dynamic_bg)
            if Config.dynamic_bg == "X" then PrerenderBG() end
        end
    },
	
	{x = 0, y =  0.1, label = ("BG REFRESH RATE CAP : < %sHz >"):format(Config.bg_framerate),
		action_e = function(button)
			Config.bg_framerate = tostring(Mod1(tonumber(Config.bg_framerate) + 5, 500))
		end,
		action_r = function(button)
			button.param = 5
		end,
		action_l = function(button)
			button.param = -5
		end,
        update = function(button)
			Config.bg_framerate = tostring(Clamp(tonumber(Config.bg_framerate) + button.param, 5, 500))
			button.param = 0
            button.label = ("BG REFRESH RATE CAP : < %sHz >"):format(Config.bg_framerate)
        end
    },

	{x = 0, y =  0.2, param = 0, label = ("BACKGROUND BRIGHTNESS : < %d%% >"):format(Config.bg_brightness),
		action_e = function(button)
			Config.bg_brightness = tostring((tonumber(Config.bg_brightness) + 5) % 105)
		end,
		action_r = function(button)
			button.param = 1
		end,
		action_l = function(button)
			button.param = -1
		end,
        update = function(button)
			Config.bg_brightness = tostring(Clamp(tonumber(Config.bg_brightness) + 5 * button.param, 0, 100))
			button.param = 0
            button.label = ("BACKGROUND BRIGHTNESS : < %d%% >"):format(Config.bg_brightness)
        end
    },

	{x = 0, y =  0.3, param = 0, label = ("BLUR SPREAD: <%s>"):format(DrawBar(Config.blur_spread, 10)),
		action_e = function(button)
			Config.blur_spread = tostring((tonumber(Config.blur_spread) + 1) % 11)
		end,
		action_r = function(button)
			button.param = 1
		end,
		action_l = function(button)
			button.param = -1
		end,
        update = function(button)
            Config.blur_spread = tostring(Clamp(tonumber(Config.blur_spread) + button.param, 0, 10))
			button.param = 0
			button.label = ("BLUR SPREAD: <%s>"):format(DrawBar(Config.blur_spread, 10))
        end
	},

	{x = 0, y =  0.4, label = ("TRAIL FADEOUT DURATION: <%s>"):format(DrawBar(Config.trail_duration, 10)),
		action_e = function(button)
			Config.trail_duration = tostring((tonumber(Config.trail_duration) + 1) % 11)
		end,
		action_r = function(button)
			button.param = 1
		end,
		action_l = function(button)
			button.param = -1
		end,
        update = function(button)
			Config.trail_duration = tostring(Clamp(tonumber(Config.trail_duration) + button.param, 0, 10))
			button.param = 0
            button.label = ("TRAIL FADEOUT DURATION: <%s>"):format(DrawBar(Config.trail_duration, 10))
        end
	},

	{x = 0, y =  0.7, label = "BACK", action_e = change("settings")},
})

Title.window = Menu.new("Menu", {
	{x = 0, y =  -0.3, param = 1, prev_screen = 1, label = ("SCREEN : < %s >"):format(1),
		action_e = function(button)
            button.prev_screen = button.param
			button.param = Mod1(button.param + 1, #FullScreenModes)
		end,
		action_r = function(button)
			button.prev_screen = button.param
            button.param = Mod1(button.param + 1, #FullScreenModes)
		end,
		action_l = function(button)
			button.prev_screen = button.param
            button.param = Mod1(button.param - 1, #FullScreenModes)
		end,
        update = function(button)
            button.label = ("SCREEN : < %s >"):format(button.param)

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

	{x = 0, y = -0.2, param = 1, label = ("RESOLUTION : < %4dx%4d >"):format("640", "480"),
		action_e = function(button)
			local cur_screen = button.parent.items[1].param
			button.param = Mod1(button.param + 1, #FullScreenModes[cur_screen])
		end,
		action_r = function(button)
			local cur_screen = button.parent.items[1].param
			button.param = Mod1(button.param + 1, #FullScreenModes[cur_screen])
		end,
		action_l = function(button)
			local cur_screen = button.parent.items[1].param
			button.param = Mod1(button.param - 1, #FullScreenModes[cur_screen])
		end,
		update = function(button)
			local cur_screen = button.parent.items[1].param
			local mode = FullScreenModes[cur_screen][button.param]
			button.label = ("RESOLUTION : < %4dx%4d >"):format(mode.width, mode.height)
		end
    },

	{x = 0, y = 0.1, param = Config.fullscreen, label = ("FULLSCREEN : < %s >"):format(Config.fullscreen),
        update = function(button)
            button.param = (button.param == "O" and "X" or "O")
            button.label = ("FULLSCREEN : < %s >"):format(button.param)
        end
    },

	{x = 0, y = 0.2, param = Config.vsync, label = ("VSYNC : < %s >"):format(Config.vsync),
        update = function(button)
            button.param = (button.param == "O" and "X" or "O")
            button.label = ("VSYNC : < %s >"):format(button.param)
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


-- [[ === === === [ HIGHSCORES ] === === === ]] --
-- sets the default high score mode view to the first mode alphabetically
--TODO: Proper Sorting
--TODO: Unlocking Secret Modes
local mode_list = {}
local mode_indices = {} -- to prevent unnecessary lookups
for k, _ in pairs(HighScores) do
	if k ~= "Death" or #HighScores["Death"] > 0 or carnivalhours then -- death is technically a secret mode, only show it if you have a score in it
        table.insert(mode_list, k)
    end
    for i = 1, #Levels do
		if Levels[i].name == k then mode_indices[k] = i end
	end
end

Title.highscores = Menu.new("Menu", {
	{x = 0, y = -0.8, param = 0, label = ("MODE: < %s >"):format(mode_list[1]),
		action_r = function(button)
			button.param = 1
		end,
		action_l = function(button)
			button.param = -1
		end,
        update = function(button)
            Title.highscores.selection = Mod1(Title.highscores.selection + button.param, #button.parent.mode_list)
            button.param = 0
            button.label = ("MODE: < %s >"):format(Title.highscores.mode_list[Title.highscores.selection])
        end
	},

	{x = 0, y = -0.7, label = "SHOW CLEAR STATISTICS: < X >",
		update = function(button)
			button.parent.show_clear = not button.parent.show_clear
			button.label = ("SHOW CLEAR STATISTICS: < %s >"):format(button.parent.show_clear and "O" or "X")
		end
	},

	{x = 0, y =  0.7, label = "BACK",
	 	action_e = function(button)
			button.parent.reset_counter = 1
			button.parent.items[4]:update()
			change("main")(button)
		end
	},

	{x = 0, y =  0.8, label = "RESET HIGH SCORES",
        labels = {"RESET HIGH SCORES",
                  "ARE YOU SURE YOU WANT TO CLEAR RECORDS?",
                  "ARE YOU REALLY SURE?",
                  "LAST CHANCE! ARE YOU SURE YOU WANT TO?"},
	 	action_e = function(button)
            button.parent.reset_counter = button.parent.reset_counter + 1
        end,
	 	update = function(button)
			if button.parent.reset_counter > #button.labels then
				button.parent.reset_counter = 1
				for _, mode in pairs(Levels) do HighScores[mode.name] = {} end
				SaveHighScores()
			end
            button.label = button.labels[button.parent.reset_counter]
		end
	}
})
--TODO: Apply general styling to this
Title.highscores.selection     = 1
Title.highscores.mode_list     = mode_list
Title.highscores.mode_indices  = mode_indices
Title.highscores.show_clear    = false
Title.highscores.reset_counter = 1