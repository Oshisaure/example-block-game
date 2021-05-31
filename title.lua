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

Title.main = Menu.new(MenuFont, {
	{x = 0, y = -0.2, label = "START GAME",      action_e = open("play")},
	{x = 0, y =  0.0, label = "SETTINGS",        action_e = open("settings")},
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
            {x = 0, y = -0.5+0.1*i, label = mode.name,
                action_e = function()
                    Game = Games[i]
                    Game:reset(os.time())
                    SetBGM(Game.BGM)
                    Game.display_score = 999999999 -- 999,999,999
                    if Config.dynamic_bg == "X" then PrerenderBG(Game.speedcurve.BG) end
                    STATE = "ingame"
                end,
            }
        )
    end
end
table.insert(gamemodes, {x = 0, y =  0.7, label = "BACK", action_e = change("main")})
Title.play = Menu.new(MenuFont, gamemodes)

Title.settings = Menu.new(MenuFont, {
	{x = 0, y = -0.5, label = ("< BGM VOLUME : %d%% >"):format(Config.bgm_volume),
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
    
	{x = 0, y = -0.3, label = "KEYBOARD CONFIG", action_e = open("keyconf")},
	{x = 0, y = -0.1, label = "GAMEPAD CONFIG",  action_e = open("padconf")},
	{x = 0, y =  0.1, label = "GRAPHICS OPTIONS",  action_e = open("graphics")},
	{x = 0, y =  0.3, label = "BACK",  action_e = change("main")},
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

Title.keyconf = Menu.new(MenuFont, keySettingsItems)
Title.padconf = Menu.new(MenuFont, padSettingsItems)

Title.graphics = Menu.new(MenuFont, {
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
	{x = 0, y =  0.1, label = ("< VSYNC : %s >"):format(Config.vsync),
		action_e = function(button)
			Config.vsync = (Config.vsync == "O" and "X" or "O")
			button.label = ("< VSYNC : %s >"):format(Config.vsync)
            love.window.setVSync(Config.vsync == "O")
            SaveConfig()
		end,
		action_r = function(button)
			Config.vsync = (Config.vsync == "O" and "X" or "O")
			button.label = ("< VSYNC : %s >"):format(Config.vsync)
            love.window.setVSync(Config.vsync == "O")
            SaveConfig()
		end,
		action_l = function(button)
			Config.vsync = (Config.vsync == "O" and "X" or "O")
			button.label = ("< VSYNC : %s >"):format(Config.vsync)
            love.window.setVSync(Config.vsync == "O")
            SaveConfig()
		end,
    },
	{x = 0, y =  0.2, label = ("< DYNAMIC BACKGROUNDS : %s >"):format(Config.dynamic_bg),
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
	{x = 0, y =  0.3, label = ("< BACKGROUND BRIGHTNESS : %d%% >"):format(Config.bg_brightness),
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
	{x = 0, y =  0.4,
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
	{x = 0, y =  0.5,
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