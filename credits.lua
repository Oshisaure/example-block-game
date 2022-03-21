--[==[
    Credits screen for example block game
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

local backbutton = {
	x = 0.0, y =  0.8, label = "BACK", action_e = function(button)
		button.parent.highlight = 1
		Credits.screen = 1
		STATE = "menu"
	end,
}

local splashcanvas = love.graphics.newCanvas()
Credits = {
	screen = 1,
	menus = {
		Menu.new("Menu", {
			{x = 0.0, y =  0.7, label = "ASSETS ATTRIBUTIONS", 
				action_e = function(button) Credits.screen = 2; button.parent.highlight = 1 end,
			},
			backbutton,
			{x = 0.0, y = -0.7, label = "A GAME BY OSHISAURE", 
				action_e = function(button) love.system.openURL("https://oshisaure.itch.io/") end,
			},
			{x = 0.4, y = -0.4, label = "LOVE2D v11.3", 
				action_e = function(button) love.system.openURL("http://love2d.org/") end,
			},
			{x = 0.0, y = -0.2, label = "GITHUB CONTRIBUTORS", 
				action_e = function(button) love.system.openURL("https://github.com/Oshisaure/example-block-game/graphs/contributors") end,
			},
			{x = 0.0, y =  0.3, label = "THE CAMBRIDGE GAME DISCORD SERVER", 
				action_e = function(button) love.system.openURL("https://t-sp.in/cambridge") end,
			},
		}),
		Menu.new("HUD", {
			{x = 0.0, y =  0.7, label = "GENERAL CREDITS", 
				action_e = function(button) Credits.screen = 1; button.parent.highlight = 1; ResetSplashScreen() end,
			},
			backbutton,
			{x = 0.00, y = -0.50, label = "CGI MOON KIT FROM NASA'S SCIENTIFIC VISUALIZATION STUDIO", 
				action_e = function(button) love.system.openURL("https://svs.gsfc.nasa.gov/4720") end,
			},
			{x = 0.00, y = -0.20, label = "MADE BY MARKGAMED7794", 
				action_e = function(button) love.system.openURL("https://github.com/MarkGamed7794") end,
			},
			{x = 0.00, y =  0.10, label = "emma \"msx\" essex - beside yourself", 
				action_e = function(button)
					love.system.openURL("https://halleylabs.com/track/beside-yourself")
				end,
			},
			{x = 0.00, y =  0.15, label = "substance - aftertouch", 
				action_e = function(button)
					love.system.openURL("https://modarchive.org/module.php?126990")
				end,
			},
			{x = 0.00, y =  0.20, label = "FearofDark - late night early morning jam", 
				action_e = function(button)
					love.system.openURL("https://modarchive.org/module.php?173929")
				end,
			},
			{x = 0.00, y =  0.25, label = "Tempest - Crema Lubricante", 
				action_e = function(button)
					love.system.openURL("https://modarchive.org/module.php?188911")
				end,
			},
			{x = 0.00, y =  0.30, label = "Jazzcat - Thinking of TIT", 
				action_e = function(button)
					love.system.openURL("https://modarchive.org/module.php?181530")
				end,
			},
			{x = 0.00, y =  0.35, label = "Elwood - Into the Shadow", 
				action_e = function(button)
					love.system.openURL("https://modarchive.org/module.php?54298")
				end,
			},
			{x = 0.00, y =  0.40, label = "Karsten Koch - Aryx", 
				action_e = function(button)
					love.system.openURL("https://modarchive.org/module.php?34036")
				end,
			},
		}),
	},
	labels = {
		{
			{x = -0.4, y = -0.40, font = "Menu", label = "POWERED BY"},
			{x = -0.0, y = -0.10, font = "HUD",  label = "ZLY_U - GENERAL CODE AND REFACTOR HELP"},
			{x = -0.0, y = -0.05, font = "HUD",  label = "MILLABASSET - ADDITIONAL SPEED CURVES"},
			{x = -0.0, y =  0.00, font = "HUD",  label = "MARKGAMED7794 - SCORING AND LEADERBOARD HELP"},
			{x = -0.0, y =  0.20, font = "Menu", label = "SPECIAL THANKS TO"},
			{x = -0.0, y =  0.40, font = "Menu", label = "LANTERNS AND SHELLELOCH"},
		},
		{
			{x = 0, y = -0.6, font = "Menu", label = "MOON TEXTURE/DISPLACEMENT MAP"},
			{x = 0, y = -0.3, font = "Menu", label = "TEXT FONT"},
			{x = 0, y = -0.0, font = "Menu", label = "MUSIC CREDITS"},
		}
	},
	resize = function(self)
		self.menus[1]:updateSelected()
		self.menus[2]:updateSelected()
		splashcanvas:release()
		splashcanvas = love.graphics.newCanvas(Width, Height)
	end,
	draw = function(self)
        RenderBG()
        love.graphics.setShader()
        love.graphics.setCanvas(CanvasBG)
		love.graphics.setColor(.5,.5,.5)
		love.graphics.draw(self.menus[self.screen].text)
		for _, item in pairs(self.labels[self.screen]) do
			love.graphics.setFont(Font[item.font])
			love.graphics.printf(
				item.label,
				math.floor(item.x*Width/2),
				math.floor(item.y*Height/2)+Height/2,
				Width, "center"
			)
		end
		
		if self.screen == 1 then
			local w, h = TitleText:getDimensions()
			love.graphics.draw(TitleText, Width*0.5, Height*0.1, 0, 1, 1, w/2, h/2, -math.cos(os.clock()*0.5)*0.4, 0)
		end
		
        love.graphics.setCanvas()
        local b = tonumber(Config.bg_brightness)/100
		love.graphics.setColor(b, b, b)
        love.graphics.draw(CanvasBG)
		
		love.graphics.setColor(1,1,1)
		if self.screen == 1 then
			local w, h = TitleText:getDimensions()
			love.graphics.draw(TitleText, Width*0.5, Height*0.1, 0, 1, 1, w/2, h/2, -math.cos(os.clock()*0.5)*0.4, 0)
			
			love.graphics.setCanvas(splashcanvas)
			love.graphics.clear()
			DrawSplashScreen()
			love.graphics.setCanvas()
			love.graphics.draw(splashcanvas, Width*0.8, Height*0.2, -0.2+math.sin(os.clock()*0.5)*0.1, 0.3, 0.3, splashcanvas:getWidth()/2, splashcanvas:getHeight()/2)
		else
			love.graphics.setShader(ShaderBG.credits)
			love.graphics.draw(CanvasBG) 
			love.graphics.setShader()
		end
		
		love.graphics.draw(self.menus[self.screen].text)
		for _, item in pairs(self.labels[self.screen]) do
			love.graphics.setFont(Font[item.font])
			love.graphics.printf(
				item.label,
				math.floor(item.x*Width/2),
				math.floor(item.y*Height/2)+Height/2,
				Width, "center"
			)
		end
	end,
}
