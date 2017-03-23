
local Help = class("Help", function ()
	return display.newNode()
end)

function Help:ctor(value)	
  
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(0)
    self:setContentSize(cc.size(self.bg:getContentSize().width, self.bg:getContentSize().height ))
    self:setAnchorPoint(cc.p(0,0))

    --创建精灵
    local fruitBasepath = "But/panelbg.png"
    self.fruit = display.newSprite(fruitBasepath)
    		:align(display.CENTER,self.bg:getContentSize().width/5 - 450, self.bg:getContentSize().height/1.8)
       		:addTo(self.bg)
    -- self.fruit:setOpacity(80)
    self.fruit:setTouchEnabled(true)
	self.fruit:setTouchSwallowEnabled(true)

	local sequence = transition.sequence({
      cc.MoveBy:create(0.2,cc.p(470, 0)),
      cc.MoveBy:create(0.1,cc.p(-30 , 0)),
      cc.MoveBy:create(0.1,cc.p(20 , 0)),
      -- cc.ScaleTo:create(0.2,0.9,0.9),
      -- cc.ScaleTo:create(0.2,1.0,1.0),
  	}) 
	transition.execute(self.fruit,sequence,{
                   delay = 0,
                   onComplete = function ()
                   		-- self:addTouchonoroff(true)
                    end})
    self:addTouchonoroff(true)
end


--是否添加监听(开启)
function Help:addTouchonoroff(open)
  	if open then
		--添加监听,吞噬事件
		self:setTouchEnabled(true)
		self:setTouchSwallowEnabled(true)
		self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
			if event.name == "began" then
			   local sequence = transition.sequence({
			      cc.MoveBy:create(0.1,cc.p(30, 0)),
			      -- cc.MoveBy:create(0.1,cc.p(50 , 0)),
			      cc.MoveBy:create(0.2,cc.p(-460 , 0)),
			      -- cc.ScaleTo:create(0.2,0.9,0.9),
			      -- cc.ScaleTo:create(0.2,1.0,1.0),
			  	}) 
				transition.execute(self.fruit,sequence,{
			                   delay = 0,
			                   onComplete = function ()
			                   		self:removeFromParent()
			                    end})
		       -- self:removeFromParent()
			end
		end)	
  	end
end

return Help