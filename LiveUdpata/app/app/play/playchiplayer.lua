
--测试
local chip = require("app.fruit.bottomBase")

local playchiplayer = class("playchiplayer", function()
	return display.newNode()
end)

function playchiplayer:ctor(roomset)
    
    --测试
    --self.ddddddddd = 5
    --筹码类
    self.allchip = {}
    --当前选择了多少数额的筹码,默认为1,100RMB
    self.chipmoney = {index = 1 , money = 100}

	  self.chiplayer = cc.LayerColor:create(cc.c4b(55,55,55,255),display.width * 0.50,display.height * 0.297)
              --:pos(0, 0)             
              :addTo(self)
    self.chiplayer:ignoreAnchorPointForPosition(false)
    self.chiplayer:setAnchorPoint(cc.p(0.5,0))
    self.chiplayer:setPosition(cc.p(display.cx ,display.bottom ))
    
    self.chiplayer:setOpacity(0)

    ---100筹码
    local chipposy = self.chiplayer:getContentSize().height/3 - 10
    local chipposx = self.chiplayer:getContentSize().width/7

    local chip100 = chip.new("chip",100)
               :pos(chipposx,chipposy)
               :addTo(self.chiplayer)
        table.insert(self.allchip, chip100)

    local chip1000 = chip.new("chip",1000)
               :pos(2*chipposx,chipposy)
               :addTo(self.chiplayer)
        table.insert(self.allchip, chip1000)

    local chip1w = chip.new("chip",10000)
               :pos(3*chipposx,chipposy)
               :addTo(self.chiplayer)
        table.insert(self.allchip, chip1w)

    local chip10w = chip.new("chip",100000)
               :pos(4*chipposx,chipposy)
               :addTo(self.chiplayer)
        table.insert(self.allchip, chip10w)

    local chip50w = chip.new("chip",500000)
               :pos(5*chipposx,chipposy)
               :addTo(self.chiplayer)
        table.insert(self.allchip, chip50w)

    local chip100w = chip.new("chip",1000000)
               :pos(6*chipposx,chipposy)
               :addTo(self.chiplayer)
        table.insert(self.allchip, chip100w)
end

--设置亮,关灯
function playchiplayer:oneopenlight(index , money)
	-- body
	local x = self.chipmoney.index
	--print(x)
  --关闭前一个亮灯
	self.allchip[x]:rescoloropen()
  --更新筹码
  self.chipmoney.index = index
  self.chipmoney.money = money

  --更新下注金额
  self:getParent().gameview:setinitialvalue(self.chipmoney.money)
end

return playchiplayer