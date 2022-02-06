--[==[
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

Menu = {
	updateSelected = function(self, key)
            if key == "up"     then self.highlight = (self.highlight - 2) % #self.items + 1
        elseif key == "down"   then self.highlight = (self.highlight - 0) % #self.items + 1
        elseif key == "return" then r = self.items[self.highlight]:action_e(); self.items[self.highlight]:update()
        elseif key == "right"  then r = self.items[self.highlight]:action_r(); self.items[self.highlight]:update()
        elseif key == "left"   then r = self.items[self.highlight]:action_l(); self.items[self.highlight]:update()
        end

        self.text:setFont(Font[self.font])
        self.text:set("")
		for k, item in ipairs(self.items) do
			self.text:addf({k == self.highlight and {1, 0.7, 0.5} or {1,1,1}, item.label},
                            Width, "center",
                            math.floor(item.x*Width/2),
                            math.floor(item.y*Height/2)+Height/2)
		end
	end,

    reload = function(self)
        -- local fontsize = self.font
        -- local font
            -- if fontsize == "big"   then font = HUDFontBig
        -- elseif fontsize == "small" then font = HUDFontSmall
        -- else font = HUDFont
        -- end
        -- self.text:setFont(font)
        self:updateSelected("kek")
    end,

    new = function(font, items)
        for k = 1, #items do
            if not items[k].action_e then items[k].action_e = NADA end
            if not items[k].action_l then items[k].action_l = NADA end
            if not items[k].action_r then items[k].action_r = NADA end
            if not items[k].update 	 then items[k].update   = NADA end
            items[k].index = k
		end
		--[[
        local font
            if fontsize == "big"   then font = HUDFontBig
        elseif fontsize == "small" then font = HUDFontSmall
        else font = HUDFont
        end]]
		local menu = {
			items          = items,
            font           = font,
			text           = love.graphics.newText(Font[font]),
			highlight      = 1,
			updateSelected = Menu.updateSelected,
            reload         = Menu.reload,
		}
		for k = 1, #menu.items do menu.items[k].parent = menu end
		menu:updateSelected("kek")
		return menu
	end,
}