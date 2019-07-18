--
-- @name ui.lua
-- @author vincent <wang.yuanqiu007@gmail.com>
-- @description This is a ui framework for ssh_1106 128x64 oled display
--

local UI = { disp }
local ylist = { 23, 35, 48, 60 }

function UI:init()
    -- setup display
    local id, sda, scl, addr = 0, 1, 2, 0x3C
    i2c.setup(id, sda, scl, i2c.SLOW)
    self.disp = u8g2.sh1106_i2c_128x64_noname(id, addr)
    -- initialize variables
    self:initValiables(disp)
    -- draw base layout
    self:drawBaseLayout(disp)
end

function UI:initValiables()
    self.disp:clearBuffer()
    self.disp:setFlipMode(1)
    self.disp:setContrast(255)
    self.disp:setFontMode(0)
    self.disp:setBitmapMode(0)
    self.disp:setFont(u8g2.font_6x10_tf)
end

function UI:drawBaseLayout(disp)
    -- draw frame
    self.disp:setDrawColor(1)
    self.disp:drawFrame(0, 0, 128, 64)
    -- draw title
    self.disp:setDrawColor(1)
    self.disp:drawBox(0, 0, 128, 13)
    self.disp:setDrawColor(0)
    self.disp:drawStr(22, 10, "VINCENT STUDIO")
    -- draw lines
    self.disp:setDrawColor(1)
    self.disp:drawLine(0, 25, 128, 25)
    self.disp:drawLine(0, 37, 128, 37)
    self.disp:drawLine(0, 50, 128, 50) 
    self.disp:drawLine(35, 14, 35, 64)
end

function UI:flush()
    self.disp:sendBuffer()
end

function UI:drawLabel(index, text)
    local y = ylist[index+1]
    self.disp:setDrawColor(1)
    self.disp:drawStr(7, y, text)
end

function UI:drawValue(index, text)
    local y = ylist[index+1]
    self.disp:setDrawColor(0)
    self.disp:drawBox(38, y - 8, 87, 10)
    self.disp:setDrawColor(1)
    self.disp:drawStr(40, y, text)
end

return UI
