--[==[
    List of gamemode speedcurves for example block game
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

Levels = {
    {name = "Beginner", description = "An easier 10-level mode for people who are new to block games",
     LV = "10L", prev = 7, hold = true, colour = {0.75,0.95,1.00,1},
		{level_name = "01", gravity = 0.15, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "02", gravity = 0.25, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "03", gravity = 0.40, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "04", gravity = 0.65, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "05", gravity = 0.80, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		
		{level_name = "06", gravity = 0.90, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "07", gravity = 1.10, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "08", gravity = 1.45, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "09", gravity = 1.75, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "10", gravity = 2.00, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
    },
    
    {name = "Standard", description = "A fairly balanced 20-level mode going from slow to fast gravity",
     LV = "10L", prev = 6, hold = true, colour = {0.85,0.85,0.85,1},
		{level_name = "01", gravity = 1.0, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
		{level_name = "02", gravity = 1.1, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
		{level_name = "03", gravity = 1.2, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
		{level_name = "04", gravity = 1.4, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
		{level_name = "05", gravity = 1.7, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
		
		{level_name = "06", gravity = 2, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
		{level_name = "07", gravity = 3, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
		{level_name = "08", gravity = 4, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
		{level_name = "09", gravity = 6, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
		{level_name = "10", gravity = 8, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
		
		{level_name = "11", gravity = 10, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "12", gravity = 12, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "13", gravity = 15, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "14", gravity = 20, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "15", gravity = 30, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		
		{level_name = "16", gravity = 060, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "17", gravity = 090, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "18", gravity = 120, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "19", gravity = 180, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "20", gravity = 300, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
    },
    
	-- Original build speed curve
	{name = "Original", description = "A 36-level mode covering a wide range of speeds",
     LV = "10L", prev = 5, hold = true, colour = {0.90,0.75,1.00,1},
		{level_name = "01", gravity = 1.0, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 1},
		{level_name = "02", gravity = 1.1, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 1},
		{level_name = "03", gravity = 1.2, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 1},
		{level_name = "04", gravity = 1.4, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 1},
		{level_name = "05", gravity = 1.7, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 1},
		
		{level_name = "06", gravity = 2, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 1},
		{level_name = "07", gravity = 3, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 1},
		{level_name = "08", gravity = 4, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 1},
		{level_name = "09", gravity = 6, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 1},
		{level_name = "10", gravity = 8, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 1},
		
		{level_name = "11", gravity = 10, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "12", gravity = 12, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "13", gravity = 15, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "14", gravity = 20, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "15", gravity = 30, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		
		{level_name = "16", gravity = 060, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "17", gravity = 090, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "18", gravity = 120, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "19", gravity = 180, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "20", gravity = 300, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		
		{level_name = "X0", gravity = math.huge, lock_delay = 2.00, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.4, AS_delay = 0.15, BGM = 3},  --0.5PPS
		{level_name = "X1", gravity = math.huge, lock_delay = 1.67, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.4, AS_delay = 0.15, BGM = 3},  --0.6PPS
		{level_name = "X2", gravity = math.huge, lock_delay = 1.43, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.4, AS_delay = 0.15, BGM = 3},  --0.7PPS
		{level_name = "X3", gravity = math.huge, lock_delay = 1.25, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.4, AS_delay = 0.15, BGM = 3},  --0.5PPS
		{level_name = "X4", gravity = math.huge, lock_delay = 1.11, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.4, AS_delay = 0.15, BGM = 3},  --0.9PPS
		
		{level_name = "X5", gravity = math.huge, lock_delay = 1.00, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.3, AS_delay = 0.15, BGM = 3},  --1.0PPS
		{level_name = "X6", gravity = math.huge, lock_delay = 0.80, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.3, AS_delay = 0.15, BGM = 3},  --1.2PPS
		{level_name = "X7", gravity = math.huge, lock_delay = 0.75, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.3, AS_delay = 0.15, BGM = 3},  --1.3PPS
		{level_name = "X8", gravity = math.huge, lock_delay = 0.67, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.3, AS_delay = 0.15, BGM = 3},  --1.5PPS
		{level_name = "X9", gravity = math.huge, lock_delay = 0.50, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.3, AS_delay = 0.15, BGM = 3},  --2.0PPS
		--[[
		{level_name = "Pb", gravity = math.huge, lock_delay = 0.45, spawn_delay = 0.25, AS_delay = 0.1},  --2.2PPS
		{level_name = "Sn", gravity = math.huge, lock_delay = 0.40, spawn_delay = 0.25, AS_delay = 0.1},  --2.5PPS
		{level_name = "Fe", gravity = math.huge, lock_delay = 0.35, spawn_delay = 0.25, AS_delay = 0.1},  --2.9PPS
		{level_name = "Cu", gravity = math.huge, lock_delay = 0.30, spawn_delay = 0.25, AS_delay = 0.1},  --3.3PPS
		{level_name = "Ag", gravity = math.huge, lock_delay = 0.25, spawn_delay = 0.25, AS_delay = 0.1},  --4.0PPS
															  
		{level_name = "Au", gravity = math.huge, lock_delay = 0.20, spawn_delay = 0.25, AS_delay = 0.1},  --5.0PPS
		]]
		{level_name = "M1", gravity = math.huge, lock_delay = 0.45, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 4},  --2.2PPS
		{level_name = "M2", gravity = math.huge, lock_delay = 0.40, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 4},  --2.5PPS
		{level_name = "M3", gravity = math.huge, lock_delay = 0.35, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 4},  --2.9PPS
		{level_name = "M4", gravity = math.huge, lock_delay = 0.30, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 4},  --3.3PPS
		{level_name = "M5", gravity = math.huge, lock_delay = 0.25, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 4},  --4.0PPS
		
		{level_name = "MX", gravity = math.huge, lock_delay = 0.20, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.1, AS_delay = 0.1, BGM = 4},  --5.0PPS
	},
    
    {name = "Master", description = "A 30-level mode that starts on infinite gravity, yet keeps going faster",
     LV = "10L", prev = 3, hold = true, colour = {0.35,0.10,0.15,1},
		{level_name = "M01", gravity = math.huge, lock_delay = 1, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 4},
    },
    
    {name = "Classic", description = "\"Block game is easy with hold and lock delay\" -- clueless block game non-player",
     LV = "10L", prev = 1, hold = false, colour = {0.60,0.95,0.85,1},
		{level_name = "00", gravity = 1, lock_delay = 1, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 4},
    },
    
	-- Practice level (low-g)
	{name = "Zero-G Practice", description = "A practice mode with no gravity and infinite time to place your piece",
     LV = "10L", prev = 5, hold = true, colour = {0.65,0.75,0.80,1},
		{level_name = "Practice", gravity = 0, lock_delay = math.huge, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25},
	},
	
	-- Practice level (inf-g)
	{name = "Max-G Practice", description = "A practice mode with infinite gravity but infinite time to place your piece",
     LV = "10L", prev = 5, hold = true, colour = {0.85,0.55,0.55,1},
		{level_name = "Practice", gravity = math.huge, lock_delay = math.huge, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25},
	},
    
	--TGM2 Death
	{name = "Death", description = "",
     LV = "SEC", prev = 1, hold = false, colour = {0.55,0.25,0.25,1},
		{level_name =   0, gravity = math.huge, lock_delay = 30/60, spawn_delay = 18/60, spawn_delay_after_line = 14/60, line_delay = 12/60, AS_delay = 12/60},
		{level_name = 100, gravity = math.huge, lock_delay = 26/60, spawn_delay = 14/60, spawn_delay_after_line = 08/60, line_delay = 06/60, AS_delay = 12/60},
		{level_name = 200, gravity = math.huge, lock_delay = 22/60, spawn_delay = 14/60, spawn_delay_after_line = 08/60, line_delay = 06/60, AS_delay = 11/60},
		{level_name = 300, gravity = math.huge, lock_delay = 18/60, spawn_delay = 08/60, spawn_delay_after_line = 08/60, line_delay = 06/60, AS_delay = 10/60},
		{level_name = 400, gravity = math.huge, lock_delay = 15/60, spawn_delay = 07/60, spawn_delay_after_line = 07/60, line_delay = 05/60, AS_delay = 08/60},
		{level_name = 500, gravity = math.huge, lock_delay = 15/60, spawn_delay = 06/60, spawn_delay_after_line = 06/60, line_delay = 04/60, AS_delay = 08/60},
		{level_name = 600, gravity = math.huge, lock_delay = 15/60, spawn_delay = 06/60, spawn_delay_after_line = 06/60, line_delay = 04/60, AS_delay = 08/60},
		{level_name = 700, gravity = math.huge, lock_delay = 15/60, spawn_delay = 06/60, spawn_delay_after_line = 06/60, line_delay = 04/60, AS_delay = 08/60},
		{level_name = 800, gravity = math.huge, lock_delay = 15/60, spawn_delay = 06/60, spawn_delay_after_line = 06/60, line_delay = 04/60, AS_delay = 08/60},
		{level_name = 900, gravity = math.huge, lock_delay = 15/60, spawn_delay = 06/60, spawn_delay_after_line = 06/60, line_delay = 04/60, AS_delay = 08/60},
	},
	--[[
	-- Server spec, won't show in the list
	["serv"] = {name = "server spec", LV = "10L", prev = 0, hold = false,
		{level_name = "Practice", gravity = 0, lock_delay = math.huge, spawn_delay = 0.5, AS_delay = 0.25},
	},
	
	["vs"] = {name = "versus", LV = "10L", prev = 5, hold = true, colour = {1,1,1,1},
		{level_name = "06", gravity = 2, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "07", gravity = 3, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "08", gravity = 4, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "09", gravity = 6, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "10", gravity = 8, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		
		{level_name = "11", gravity = 10, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "12", gravity = 12, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "13", gravity = 15, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "14", gravity = 20, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "15", gravity = 30, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		
		{level_name = "16", gravity = 060, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "17", gravity = 090, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "18", gravity = 120, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "19", gravity = 180, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		{level_name = "20", gravity = 300, lock_delay = 2, spawn_delay = 0.5, AS_delay = 0.25},
		
		{level_name = "X0", gravity = math.huge, lock_delay = 2.00, spawn_delay = 0.5, AS_delay = 0.15},  --0.5PPS
	},
    ]]
}