--[==[
    Splash logo screen for example block game
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

local splashlogo = love.graphics.newImage("assets/splashscreen/splashlogo.png")
local splashbg   = love.graphics.newImage("assets/splashscreen/splashbg.png")
local splashtext = love.graphics.newImage("assets/splashscreen/splashtext.png")
local splashtime = 0
local splashcanvas = love.graphics.newCanvas(1600, 900)


function ResetSplashScreen(t) splashtime = t or 0 end -- idk maybe itll be useful

function UpdateSplashScreen(dt)
    if not love.keyboard.isDown("return") and splashtime < 4 then
        splashtime = splashtime + dt
    else
        love.graphics.setCanvas(CanvasBG)
        DrawSplashScreen()
        love.graphics.setCanvas()
        STATE = "menu"
        SetBGM("menu")
    end
end

function DrawSplashScreen()
    local _c = love.graphics.getCanvas()
    love.graphics.push()
    love.graphics.translate(splashcanvas:getWidth()/2, splashcanvas:getHeight()/2)
    local t = math.max(0,splashtime)
    love.graphics.setCanvas(splashcanvas)
    love.graphics.clear()
    love.graphics.setColor(1,1,1,1)
    local ease2 = (math.sin(math.pi * (math.max(0, math.min((t-0.7)/0.5, 1)) - 0.5)) + 1) * 0.5
    love.graphics.draw(splashbg, -(-splashlogo:getWidth()/2+splashbg:getWidth())/2, 0, (ease2-1)*math.pi, ease2, 1, 0, splashbg:getHeight()/2)
    local ease1 = ((math.min(t/1.2, 1) - 1)^3 + 1)
    love.graphics.draw(splashlogo, -(-splashlogo:getWidth()/2+splashbg:getWidth())/2, 0, (ease1-1)*math.pi*10, ease1, ease1, splashlogo:getWidth()/2, splashlogo:getHeight()/2)
    love.graphics.setColor(1,1,1,(t-1.2)*2)
    love.graphics.draw(splashtext, -(-splashlogo:getWidth()/2+splashbg:getWidth())/2, 0, 0, 1, 1, 0, splashtext:getHeight()/2)
    
    love.graphics.setCanvas(_c)
    love.graphics.pop()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(splashcanvas, Width/2, Height/2, 0, Height/900, Height/900, splashcanvas:getWidth()/2, splashcanvas:getHeight()/2)
end