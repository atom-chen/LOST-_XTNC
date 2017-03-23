
--游戏规则界面
local gameguize = class("gameguize", function()
	return display.newNode()
end)

--调用
--self.record = luckylayer.new({1,5,8,6,5,8,4,5,6,1,2,4})
--:pos(display.left + 80, display.top + 66)
function gameguize:ctor()

	--self:setContentSize(cc.size(520, 400 ))
    --self:setAnchorPoint(cc.p(0.5,0.5))
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(150)

    local bg = display.newSprite("gamescene/gamebankerok.png")
        :align(display.CENTER,self.bg:getContentSize().width/2,self.bg:getContentSize().height/2)
        :addTo(self.bg)

	self.lv = cc.ui.UIListView.new {
        -- bg = "bankerok.png",
        bgScale9 = true,
        viewRect = cc.rect(0.5, 0.5, 520, 230),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        --scrollbarImgV = "bar.png"
    	}
    --self.lv:ignoreAnchorPointForPosition(false) 
    --self.lv:setAnchorPoint(cc.p(0.5,0.5))
    self.lv:setPosition(self.bg:getContentSize().width/2 - 260,self.bg:getContentSize().height/2 - 170)
    self.bg:addChild(self.lv)
    --for i,fruit in ipairs(self.luckyrecord) do
        local item = self.lv:newItem()
        local content      
        content = display.newSprite("gamescene/ziti.png")
        item:addContent(content)
        item:setItemSize(450, 1100)
        self.lv:addItem(item)
    --end
    self.lv:reload()
	
	local close = display.newSprite("gamescene/close_btn.png")
        :align(display.CENTER_BOTTOM,self.bg:getContentSize().width/2 + 270,self.bg:getContentSize().height/2 + 140)
        :addTo(self.bg)
    -- close:setScale(1.2)
  	local isMove = false
  	close:setTouchEnabled(true)
  	close:setTouchSwallowEnabled(true)
  	close:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
	    if  isMove then
	        return 
	    end
	    if event.name == "began" then
	      isMove = true        
	      local sequence = transition.sequence({
	          cc.ScaleTo:create(0.1,0.9,0.9),
	          cc.ScaleTo:create(0.2,1.0,1.0),             
	      })        
	      transition.execute(close,sequence,{
	                   delay = 0,
	                   onComplete = function ()
		                self:removeFromParent()
	                    end})           
	    end
 	end)  

end

return gameguize