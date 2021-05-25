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
     LV = "10L", prev = 7, hold = true, colour = {0.75,0.95,1.00,1}, BG = "beginner",
		{level_name = "01", gravity = 0.15, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "02", gravity = 0.25, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "03", gravity = 0.40, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "04", gravity = 0.65, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		{level_name = "05", gravity = 0.80, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 1},
		
		{level_name = "06", gravity = 0.90, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 2},
		{level_name = "07", gravity = 1.10, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 2},
		{level_name = "08", gravity = 1.45, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 2},
		{level_name = "09", gravity = 1.75, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 2},
		{level_name = "10", gravity = 2.00, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.5, line_delay = 0.5, AS_delay = 0.3, BGM = 2},
    },
    
    {name = "Standard", description = "A fairly balanced 20-level mode going from slow to fast gravity",
     LV = "10L", prev = 6, hold = true, colour = {0.85,0.85,0.85,1}, BG = "original",
		{level_name = "01", gravity = 1.0, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "02", gravity = 1.1, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "03", gravity = 1.2, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "04", gravity = 1.4, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "05", gravity = 1.7, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		
		{level_name = "06", gravity = 2, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "07", gravity = 3, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "08", gravity = 4, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "09", gravity = 6, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		{level_name = "10", gravity = 8, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 2},
		
		{level_name = "11", gravity = 10, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 3},
		{level_name = "12", gravity = 12, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 3},
		{level_name = "13", gravity = 15, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 3},
		{level_name = "14", gravity = 20, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 3},
		{level_name = "15", gravity = 30, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 3},
		
		{level_name = "16", gravity = 060, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 3},
		{level_name = "17", gravity = 090, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 3},
		{level_name = "18", gravity = 120, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 3},
		{level_name = "19", gravity = 180, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 3},
		{level_name = "20", gravity = 300, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 3},
    },
    
	-- Original build speed curve
	{name = "Original", description = "A 36-level mode covering a wide range of speeds",
     LV = "10L", prev = 5, hold = true, colour = {0.90,0.75,1.00,1}, BG = "original",
		{level_name = "01", gravity = 1.0, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "02", gravity = 1.1, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "03", gravity = 1.2, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "04", gravity = 1.4, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "05", gravity = 1.7, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		
		{level_name = "06", gravity = 2, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "07", gravity = 3, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "08", gravity = 4, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "09", gravity = 6, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		{level_name = "10", gravity = 8, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 2},
		
		{level_name = "11", gravity = 10, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 3},
		{level_name = "12", gravity = 12, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 3},
		{level_name = "13", gravity = 15, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 3},
		{level_name = "14", gravity = 20, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 3},
		{level_name = "15", gravity = 30, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 3},
		
		{level_name = "16", gravity = 060, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 3},
		{level_name = "17", gravity = 090, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 3},
		{level_name = "18", gravity = 120, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 3},
		{level_name = "19", gravity = 180, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 3},
		{level_name = "20", gravity = 300, lock_delay = 2, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.5, AS_delay = 0.25, BGM = 3},
		
		{level_name = "X1", gravity = math.huge, lock_delay = 2.00, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.4, AS_delay = 0.15, BGM = 4},  --0.5PPS
		{level_name = "X2", gravity = math.huge, lock_delay = 1.67, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.4, AS_delay = 0.15, BGM = 4},  --0.6PPS
		{level_name = "X3", gravity = math.huge, lock_delay = 1.43, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.4, AS_delay = 0.15, BGM = 4},  --0.7PPS
		{level_name = "X4", gravity = math.huge, lock_delay = 1.25, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.4, AS_delay = 0.15, BGM = 4},  --0.5PPS
		{level_name = "X5", gravity = math.huge, lock_delay = 1.11, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.4, AS_delay = 0.15, BGM = 4},  --0.9PPS
		
		{level_name = "X6", gravity = math.huge, lock_delay = 1.00, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.3, AS_delay = 0.15, BGM = 4},  --1.0PPS
		{level_name = "X7", gravity = math.huge, lock_delay = 0.80, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.3, AS_delay = 0.15, BGM = 4},  --1.2PPS
		{level_name = "X8", gravity = math.huge, lock_delay = 0.75, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.3, AS_delay = 0.15, BGM = 4},  --1.3PPS
		{level_name = "X9", gravity = math.huge, lock_delay = 0.67, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.3, AS_delay = 0.15, BGM = 4},  --1.5PPS
		{level_name = "XX", gravity = math.huge, lock_delay = 0.50, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.3, AS_delay = 0.15, BGM = 4},  --2.0PPS
        
		{level_name = "PB", gravity = math.huge, lock_delay = 0.45, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 5},  --2.2PPS
		{level_name = "SN", gravity = math.huge, lock_delay = 0.40, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 5},  --2.5PPS
		{level_name = "FE", gravity = math.huge, lock_delay = 0.35, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 5},  --2.9PPS
		{level_name = "CU", gravity = math.huge, lock_delay = 0.30, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 5},  --3.3PPS
		{level_name = "AG", gravity = math.huge, lock_delay = 0.25, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.2, AS_delay = 0.1, BGM = 5},  --4.0PPS
		
		{level_name = "AU", gravity = math.huge, lock_delay = 0.20, spawn_delay = 0.25, spawn_delay_after_line = 0.20, line_delay = 0.1, AS_delay = 0.1, BGM = 5},  --5.0PPS
	},
    
    {name = "Master", description = "A 30-level mode that starts on infinite gravity, yet keeps going faster",
     LV = "10L", prev = 5, hold = true, colour = {0.35,0.10,0.15,1}, BG = "master",
		{level_name = "M01", gravity = math.huge, lock_delay = 1.000, spawn_delay = 0.500, spawn_delay_after_line = 0.500, line_delay = 0.375, AS_delay = 0.150, BGM = 4},
		{level_name = "M02", gravity = math.huge, lock_delay = 0.946, spawn_delay = 0.473, spawn_delay_after_line = 0.473, line_delay = 0.355, AS_delay = 0.150, BGM = 4},
		{level_name = "M03", gravity = math.huge, lock_delay = 0.895, spawn_delay = 0.447, spawn_delay_after_line = 0.447, line_delay = 0.336, AS_delay = 0.150, BGM = 4},
		{level_name = "M04", gravity = math.huge, lock_delay = 0.847, spawn_delay = 0.423, spawn_delay_after_line = 0.423, line_delay = 0.317, AS_delay = 0.150, BGM = 4},
		{level_name = "M05", gravity = math.huge, lock_delay = 0.801, spawn_delay = 0.400, spawn_delay_after_line = 0.400, line_delay = 0.300, AS_delay = 0.150, BGM = 4},

		{level_name = "M06", gravity = math.huge, lock_delay = 0.758, spawn_delay = 0.379, spawn_delay_after_line = 0.379, line_delay = 0.284, AS_delay = 0.150, BGM = 4},
		{level_name = "M07", gravity = math.huge, lock_delay = 0.717, spawn_delay = 0.358, spawn_delay_after_line = 0.358, line_delay = 0.268, AS_delay = 0.150, BGM = 4},
		{level_name = "M08", gravity = math.huge, lock_delay = 0.678, spawn_delay = 0.339, spawn_delay_after_line = 0.339, line_delay = 0.254, AS_delay = 0.150, BGM = 4},
		{level_name = "M09", gravity = math.huge, lock_delay = 0.641, spawn_delay = 0.321, spawn_delay_after_line = 0.321, line_delay = 0.241, AS_delay = 0.150, BGM = 4},
		{level_name = "M10", gravity = math.huge, lock_delay = 0.607, spawn_delay = 0.303, spawn_delay_after_line = 0.303, line_delay = 0.228, AS_delay = 0.150, BGM = 4},

		{level_name = "M11", gravity = math.huge, lock_delay = 0.574, spawn_delay = 0.287, spawn_delay_after_line = 0.287, line_delay = 0.215, AS_delay = 0.150, BGM = 5},
		{level_name = "M12", gravity = math.huge, lock_delay = 0.543, spawn_delay = 0.272, spawn_delay_after_line = 0.272, line_delay = 0.204, AS_delay = 0.150, BGM = 5},
		{level_name = "M13", gravity = math.huge, lock_delay = 0.514, spawn_delay = 0.257, spawn_delay_after_line = 0.257, line_delay = 0.193, AS_delay = 0.150, BGM = 5},
		{level_name = "M14", gravity = math.huge, lock_delay = 0.486, spawn_delay = 0.243, spawn_delay_after_line = 0.243, line_delay = 0.182, AS_delay = 0.150, BGM = 5},
		{level_name = "M15", gravity = math.huge, lock_delay = 0.460, spawn_delay = 0.230, spawn_delay_after_line = 0.230, line_delay = 0.172, AS_delay = 0.150, BGM = 5},

		{level_name = "M16", gravity = math.huge, lock_delay = 0.435, spawn_delay = 0.217, spawn_delay_after_line = 0.217, line_delay = 0.163, AS_delay = 0.150, BGM = 5},
		{level_name = "M17", gravity = math.huge, lock_delay = 0.411, spawn_delay = 0.206, spawn_delay_after_line = 0.206, line_delay = 0.154, AS_delay = 0.150, BGM = 5},
		{level_name = "M18", gravity = math.huge, lock_delay = 0.389, spawn_delay = 0.195, spawn_delay_after_line = 0.195, line_delay = 0.146, AS_delay = 0.146, BGM = 5},
		{level_name = "M19", gravity = math.huge, lock_delay = 0.368, spawn_delay = 0.184, spawn_delay_after_line = 0.184, line_delay = 0.138, AS_delay = 0.138, BGM = 5},
		{level_name = "M20", gravity = math.huge, lock_delay = 0.348, spawn_delay = 0.174, spawn_delay_after_line = 0.174, line_delay = 0.131, AS_delay = 0.131, BGM = 5},

		{level_name = "M21", gravity = math.huge, lock_delay = 0.330, spawn_delay = 0.165, spawn_delay_after_line = 0.165, line_delay = 0.124, AS_delay = 0.124, BGM = 6},
		{level_name = "M22", gravity = math.huge, lock_delay = 0.312, spawn_delay = 0.156, spawn_delay_after_line = 0.156, line_delay = 0.117, AS_delay = 0.117, BGM = 6},
		{level_name = "M23", gravity = math.huge, lock_delay = 0.295, spawn_delay = 0.147, spawn_delay_after_line = 0.147, line_delay = 0.111, AS_delay = 0.111, BGM = 6},
		{level_name = "M24", gravity = math.huge, lock_delay = 0.279, spawn_delay = 0.140, spawn_delay_after_line = 0.140, line_delay = 0.105, AS_delay = 0.105, BGM = 6},
		{level_name = "M25", gravity = math.huge, lock_delay = 0.264, spawn_delay = 0.132, spawn_delay_after_line = 0.132, line_delay = 0.099, AS_delay = 0.099, BGM = 6},

		{level_name = "M26", gravity = math.huge, lock_delay = 0.250, spawn_delay = 0.125, spawn_delay_after_line = 0.125, line_delay = 0.094, AS_delay = 0.094, BGM = 6},
		{level_name = "M27", gravity = math.huge, lock_delay = 0.236, spawn_delay = 0.118, spawn_delay_after_line = 0.118, line_delay = 0.089, AS_delay = 0.089, BGM = 6},
		{level_name = "M28", gravity = math.huge, lock_delay = 0.223, spawn_delay = 0.112, spawn_delay_after_line = 0.112, line_delay = 0.084, AS_delay = 0.084, BGM = 6},
		{level_name = "M29", gravity = math.huge, lock_delay = 0.211, spawn_delay = 0.106, spawn_delay_after_line = 0.106, line_delay = 0.079, AS_delay = 0.079, BGM = 6},
		{level_name = "M30", gravity = math.huge, lock_delay = 0.200, spawn_delay = 0.100, spawn_delay_after_line = 0.100, line_delay = 0.075, AS_delay = 0.075, BGM = 6},
    },
    
    {name = "Classic", description = "\"Block game is easy with hold and lock delay\" -- clueless block game non-player",
     LV = "10L", prev = 1, hold = false, colour = {0.60,0.95,0.85,1}, BG = "original",
		{level_name = "00", gravity = 01.25, lock_delay = 1/01.25, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "01", gravity = 01.48, lock_delay = 1/01.48, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "02", gravity = 01.75, lock_delay = 1/01.75, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "03", gravity = 02.06, lock_delay = 1/02.06, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "04", gravity = 02.44, lock_delay = 1/02.44, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},

		{level_name = "05", gravity = 02.88, lock_delay = 1/02.88, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "06", gravity = 03.41, lock_delay = 1/03.41, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "07", gravity = 04.03, lock_delay = 1/04.03, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "08", gravity = 04.76, lock_delay = 1/04.76, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "09", gravity = 05.63, lock_delay = 1/05.63, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},

		{level_name = "10", gravity = 06.66, lock_delay = 1/06.66, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "11", gravity = 07.87, lock_delay = 1/07.87, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "12", gravity = 09.30, lock_delay = 1/09.30, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "13", gravity = 11.00, lock_delay = 1/11.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "14", gravity = 13.00, lock_delay = 1/13.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},

		{level_name = "15", gravity = 15.37, lock_delay = 1/15.37, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "16", gravity = 18.16, lock_delay = 1/18.16, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "17", gravity = 21.47, lock_delay = 1/21.47, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "18", gravity = 25.37, lock_delay = 1/25.37, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "19", gravity = 30.00, lock_delay = 1/30.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},

		{level_name = "20", gravity = 30.00, lock_delay = 1/30.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "21", gravity = 30.00, lock_delay = 1/30.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "22", gravity = 30.00, lock_delay = 1/30.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "23", gravity = 30.00, lock_delay = 1/30.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "24", gravity = 30.00, lock_delay = 1/30.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},

		{level_name = "25", gravity = 30.00, lock_delay = 1/30.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "26", gravity = 30.00, lock_delay = 1/30.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "27", gravity = 30.00, lock_delay = 1/30.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "28", gravity = 30.00, lock_delay = 1/30.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
		{level_name = "29", gravity = 60.00, lock_delay = 1/60.00, spawn_delay = 16/60, spawn_delay_after_line = 16/60, line_delay = 20/60, AS_delay = 16/60, BGM = 4},
    },
    
	-- Practice level (low-g)
	{name = "Zero-G Practice", description = "A practice mode with no gravity and infinite time to place your piece",
     LV = "10L", prev = 5, hold = true, colour = {0.65,0.75,0.80,1}, BG = "practice",
		{level_name = "Practice", gravity = 0, lock_delay = math.huge, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 1},
	},
	
	-- Practice level (inf-g)
	{name = "Max-G Practice", description = "A practice mode with infinite gravity but infinite time to place your piece",
     LV = "10L", prev = 5, hold = true, colour = {0.85,0.55,0.55,1}, BG = "practice2",
		{level_name = "Practice", gravity = math.huge, lock_delay = math.huge, spawn_delay = 0.5, spawn_delay_after_line = 0.25, line_delay = 0.25, AS_delay = 0.25, BGM = 4},
	},
    
	--TGM2 Death
	{name = "Death", description = "",
     LV = "SEC", prev = 1, hold = false, colour = {0.55,0.25,0.25,1}, BG = "original",
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