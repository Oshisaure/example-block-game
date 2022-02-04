--[==[
    Configurations file saving and loading for example block game
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

Bindlist = {
	{"left", "Move left"},
	{"right", "Move right"},
	{"softdrop", "Soft Drop"},
	{"sonicdrop", "Sonic Drop"},
	{"cw1", "Rotate Right #1"},
	{"cw2", "Rotate Right #2"},
	{"cw3", "Rotate Right #3"},
	{"cw4", "Rotate Right #4"},
	{"ccw1", "Rotate Left #1"},
	{"ccw2", "Rotate Left #2"},
	{"ccw3", "Rotate Left #3"},
	{"ccw4", "Rotate Left #4"},
	{"hold", "Hold"},
	{"pause", "Pause"},
}


MenuPadControls = {
	["dpleft"] = "left",
	["dpright"] = "right",
	["dpup"] = "up",
	["dpdown"] = "down",
	["a"] = "return",
	["b"] = "escape",
}

KeyDefaults = {
	left      = "left",
	right     = "right",
	cw1       = "c",
	cw2       = "b",
	cw3       = "d",
	cw4       = "g",
	ccw1      = "x",
	ccw2      = "v",
	ccw3      = "s",
	ccw4      = "f",
	sonicdrop = "up",
	softdrop  = "down",
	hold      = "space",
}

PadDefaults = {
	left      = "leftx-",
	right     = "leftx+",
	cw1       = "b",
	cw2       = "y",
	cw3       = "triggerright+",
	cw4       = "<none>",
	ccw1      = "a",
	ccw2      = "x",
	ccw3      = "triggerleft+",
	ccw4      = "leftshoulder",
	sonicdrop = "lefty-",
	softdrop  = "lefty+",
	hold      = "rightshoulder",
}

ConfigDefaults = {
	key_left      = "left",
	key_right     = "right",
	key_cw1       = "c",
	key_cw2       = "b",
	key_cw3       = "d",
	key_cw4       = "g",
	key_ccw1      = "x",
	key_ccw2      = "v",
	key_ccw3      = "s",
	key_ccw4      = "f",
	key_sonicdrop = "up",
	key_softdrop  = "down",
	key_hold      = "space",
	
	pad_left      = "leftx-",
	pad_right     = "leftx+",
	pad_cw1       = "b",
	pad_cw2       = "y",
	pad_cw3       = "triggerright+",
	pad_cw4       = "<none>",
	pad_ccw1      = "a",
	pad_ccw2      = "x",
	pad_ccw3      = "triggerleft+",
	pad_ccw4      = "leftshoulder",
	pad_sonicdrop = "lefty-",
	pad_softdrop  = "lefty+",
	pad_hold      = "rightshoulder",
	
	pad_deadzone  = "70",
	bgm_volume    = "50",
	sfx_volume    = "50",
    
	sway_bounciness = "5",
	sway_amplitude  = "5",
	sway_speed      = "5",
    
    bg_brightness  = "40",
    dynamic_bg     = "O",
    blur_spread    = "5",
    trail_duration = "5",
	
	window_width   = "960",
	window_height  = "720",
	window_display = "1",
	fullscreen     = "X",
    vsync          = "O",
}

KeyBindings = {}
PadBindings = {}
Config = {}

function LoadConfig()
	Config = {}
	KeyBindings = {}
	PadBindings = {}
	local confmachinebroke

	if love.filesystem.getInfo("keys.conf") then
		for line in love.filesystem.lines("keys.conf") do
			key, param = line:match("(.*)=(.+)")
			--print(key, param)
			if key then
				Config[key] = param
				if key:sub(1, 4) == "key_" then KeyBindings[key:sub(5,-1)] = param end
				if key:sub(1, 4) == "pad_" then PadBindings[key:sub(5,-1)] = param end
			elseif #line > 0 then
				confmachinebroke = true
			end
		end
	else
		confmachinebroke = true
	end
	
	if confmachinebroke then
		Config = Deepcopy(ConfigDefaults)
		KeyBindings = Deepcopy(KeyDefaults)
		PadBindings = Deepcopy(PadDefaults)
	else
		for k, v in pairs(ConfigDefaults) do Config[k] = Config[k] or v end
	end
end

function SaveConfig()
	local str = ""
	for key, param in pairs(Config) do
		str = str..key.."="..param.."\n"
	end
	success, message = love.filesystem.write("keys.conf", str:sub(1,-2))
	ConfigBroke = false
end

LoadConfig()