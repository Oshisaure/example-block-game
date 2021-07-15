--[==[
    Pause screen for example block game
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

Pause = Menu.new("Menu", {
	{x = 0, y = -0.2, label = "RESUME",  action_e = function(button)
        STATE = "ingame"
        button.parent.highlight = 1
    end},
	{x = 0, y =  0.0, label = "RESTART", action_e = function(button)
        Game:reset(os.time())
        SetBGM(Game.BGM)
        STATE = "ingame"
        button.parent.highlight = 1
    end},
	{x = 0, y =  0.2, label = "QUIT",    action_e = function(button)
        if Config.dynamic_bg == "X" then PrerenderBG() end
		STATE = "menu"
        SetBGM("menu")
        button.parent.highlight = 1
    end},
})

local pausetext = love.graphics.newText(Font.Title, "GAME PAUSED")
function DrawPause()
    local _c = love.graphics.getCanvas()
    love.graphics.setCanvas(CanvasRainbow)
    love.graphics.clear(0,0,0,0)
    local w, h = pausetext:getDimensions()
    love.graphics.draw(pausetext, Width*0.5, Height*0.2, 0, 1, 1, w/2, h/2, math.cos(os.clock()*math.pi/2)*0.4, 0)
    
    love.graphics.setCanvas(_c)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", -Width, -Height, 2*Width, 2*Height)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(Pause.text)
    DrawRainbow(CanvasRainbow)
end

function UpdatePauseMenuFonts()
	pausetext:setFont(Font.Title)
	Pause:updateSelected()
end