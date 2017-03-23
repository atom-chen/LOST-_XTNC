

--网络心跳，断线，
local connectfailure = class("connectfailure", function()
	return display.newNode()
end)

--调用
function connectfailure:ctor(value)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)  
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(150)	
	
	if value then
		local fafa = display.newTTFLabel(
        { text = value.."\n"..debug.traceback("", 2),
          font = "Arial",
          size = 15,
          align = cc.ui.TEXT_ALIGN_LEFT,
          color = cc.c3b(255, 255, 255) })
        :align(display.LEFT_CENTER,self.bg:getContentSize().width/12,self.bg:getContentSize().height/4 *3)
        :addTo(self.bg)
	end
    
end

function connectfailure:addfailure(xinxi)
	if xinxi then
		local fafa = display.newTTFLabel(
        { text = value.."\n"..debug.traceback("", 2),
          font = "Arial",
          size = 18,
          align = cc.ui.TEXT_ALIGN_LEFT,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,self.bg:getContentSize().width/2 + 30,self.bg:getContentSize().height/2)
        :addTo(self.bg)
	end
end

function connectfailure:removeformparentconnect()
	self:removeFromParent()
end

return connectfailure