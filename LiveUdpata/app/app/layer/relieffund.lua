

--领取金币
local relieffund = class("relieffund", function ()
	return display.newNode()
end)

function relieffund:ctor(value,tishitext,number)

    self.moneyvalue = value
    self.numbervalue = number
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(20)
    self:setContentSize(cc.size(self.bg:getContentSize().width, self.bg:getContentSize().height ))
    self:setAnchorPoint(cc.p(0,0))
    
    self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
    --创建精灵
    local fruitBasepath = "banker/relieffund.png"
    --print(fruitBasepath)
    self.fruit = display.newSprite(fruitBasepath)
    		:align(display.CENTER,self.bg:getContentSize().width/2, self.bg:getContentSize().height  )
       		:addTo(self.bg)

    -- local textmoney = display.newTTFLabel(
    --     { text = "领取救济金: +"..value,
    --       font = "Arial",
    --       size = 30,
    --       align = cc.TEXT_ALIGNMENT_LEFT,
    --       color = cc.c3b(234,199,135) })
    --     :align(display.CENTER,self.bg:getContentSize().width/2, self.bg:getContentSize().height/2  )
    --    	:addTo(self.bg)

    local sequence = transition.sequence({
	          --cc.ScaleTo:create(0.1,1.9,1.9),
	          cc.MoveTo:create(0.2,cc.p(self.bg:getContentSize().width/2, self.bg:getContentSize().height/2) ),
	          cc.ScaleTo:create(0.2,0.9,0.9),
	          cc.ScaleTo:create(0.2,1.0,1.0),

	      })        
	      	transition.execute(self.fruit,sequence,{
	                   delay = 0,
	                   onComplete = function ()
	                   		local textmoney = display.newTTFLabel(
						        { text = tishitext..": "..value,
						          font = "Arial",
						          size = 30,
						          align = cc.TEXT_ALIGNMENT_LEFT,
						          color = cc.c3b(234,199,135) })
						        :align(display.CENTER,self.bg:getContentSize().width/2, self.bg:getContentSize().height/2  )
						       	:addTo(self.bg)
	                   		self:addTouchonoroff(true)
	                    end})

    
end


--是否添加监听(开启)
function relieffund:addTouchonoroff(open)
	-- body
  	if open then
		--添加监听,吞噬事件
		local moveto = false
		-- self:setTouchEnabled(true)
		-- self:setTouchSwallowEnabled(true)
		self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
			if event.name == "began" then
				if moveto then
					print("ddddddd")
					return true
				end
				moveto = true
				local sequence = transition.sequence({
			          --cc.ScaleTo:create(0.1,1.9,1.9),
			          cc.MoveTo:create(0.4,cc.p(160, self.bg:getContentSize().height - 50) ),
			      	  cc.DelayTime:create(0.3)
			      })
				-- local movetospr = cc.MoveTo:create(0.3,cc.p(160, self.bg:getContentSize().height - 50) )
				-- local scale = cc.ScaleTo:create(0.4,0.1)
	            -- self.fruit:removeFromParent()
	            -- self.gerenyinhang:runAction(scale)
	            -- self.gerenyinhang:runAction(movetospr)      
		      	-- local temp = transition.execute(self.gerenyinhang,sequence,{
		       --             delay = 0,
		       --             onComplete = function ()
		       --             		--self:addTouchonoroff(true)
		       --             		Socketegame._MONEY = Socketegame._MONEY + self.moneyvalue
		       --             		self:getParent():getParent().money:setString("金币:"..(Socketegame._MONEY))
		       --             		self:removeFromParent()
		       --              end})
		      	local sequence1 = transition.sequence({
			          cc.ScaleTo:create(0.1,1.0,1.0),
			          cc.ScaleTo:create(0.1,0.9,0.9),
			          cc.ScaleTo:create(0.1,1.0,1.0),
			          cc.ScaleTo:create(0.1,0.2,0.2),
			          --cc.MoveTo:create(0.3,cc.p(160, self.bg:getContentSize().height - 50) ),
			      })
		      	local scale = cc.FadeOut:create(0.4)
		      	self.fruit:runAction(scale)
		      	local temp1 = transition.execute(self.fruit,sequence1,{
		                   delay = 0,
		                   onComplete = function ()
		                   		--self:addTouchonoroff(true)
		                   		-- Socketegame._MONEY = Socketegame._MONEY + self.moneyvalue
		                   		if self.numbervalue == 2 then
		                   			Socketegame._MONEY = Socketegame._MONEY + self.moneyvalue
		                   			self:getParent():getParent().money:setString((Socketegame._MONEY))
		                   		elseif self.numbervalue == 1 then
		                   			Socketegame._MONEY = Socketegame._MONEY + self.moneyvalue
		                   			self:getParent().money:setString((Socketegame._MONEY))
		                   		end
		                   		self:removeFromParent()
		                   		-- self.fruit:removeFromParent()
		                   		-- self:removeFromParent()
		                    end})
				
			end
		end)	
  	end
end

return relieffund