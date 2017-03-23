
local multiplyingprompt = class("multiplyingprompt", function ()
	return display.newNode()
end)

function multiplyingprompt:ctor(value)
	
  
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(0)
    self:setContentSize(cc.size(self.bg:getContentSize().width, self.bg:getContentSize().height ))
    self:setAnchorPoint(cc.p(0,0))

    --创建精灵
    -- local fruitBasepath = "banker/onlineopenmoney.png"
    -- self.fruit = display.newSprite(fruitBasepath)
    -- 		:align(display.CENTER,self.bg:getContentSize().width/2, self.bg:getContentSize().height + 100 )
    --    		:addTo(self.bg)
    
    -- local sequence = transition.sequence({
	   --        --cc.ScaleTo:create(0.1,1.9,1.9),
	   --        cc.MoveTo:create(0.2,cc.p(self.bg:getContentSize().width/2, self.bg:getContentSize().height/2) ),
	   --        cc.ScaleTo:create(0.2,0.9,0.9),
	   --        cc.ScaleTo:create(0.2,1.0,1.0),

	   --    })        
	   --    	transition.execute(self.fruit,sequence,{
	   --                 delay = 0,
	   --                 onComplete = function ()
	   --                 		self.gerenyinhang = display.newTTFLabel(
				-- 			        { text = "+"..value,
				-- 			          font = "Arial",
				-- 			          size = 30,
				-- 			          align = cc.TEXT_ALIGNMENT_LEFT,
				-- 			          color = cc.c3b(234,199,135) })
				-- 			        :align(display.CENTER,self.bg:getContentSize().width/2, self.bg:getContentSize().height/2 +100 )
				-- 			       	:addTo(self.bg)
	   --                 		self:addTouchonoroff(true)
	   --                  end})
	-- self:addTouchonoroff(true)



	self.historyfruit = {}
	self.historyfruittext = {}
	self:addSpritefruit(0.4,display.cx - 205, display.bottom - 50 ,"萝卜" ,value[1])
	self:addSpritefruit(0.5,display.cx - 145, display.bottom - 50 ,"白菜" ,value[2])
	self:addSpritefruit(0.6,display.cx - 85,  display.bottom - 50 ,"豌豆" ,value[3])
	self:addSpritefruit(0.7,display.cx - 25,  display.bottom - 50 ,"南瓜" ,value[4])
	self:addSpritefruit(0.8,display.cx + 40,  display.bottom - 50 ,"甘蔗" ,value[5])
	self:addSpritefruit(0.9,display.cx + 100, display.bottom - 50 ,"蘑菇" ,value[6])
	self:addSpritefruit(1.0,display.cx + 160, display.bottom - 50 ,"关苍术" ,value[7])
	self:addSpritefruit(1.1,display.cx + 215, display.bottom - 50 ,"一点红" ,value[8])
	
	-- self:addSpritefruit(0.5,self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 205 + 20)
	-- self:addSpritefruit(0.6,self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 270 + 20)
	-- self:addSpritefruit(0.7,self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 335 + 20)
	-- self:addSpritefruit(0.8,self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 400 + 20)
	-- self:addSpritefruit(1.0,self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 465 + 20)
	-- self:addSpritefruit(1.1,self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 530 + 20)
	-- self:addSpritefruit(1.2,self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 595 + 20)
	

	--210, 130
	self.multiplyingtishi = display.newSprite("banker/multiplyingtishi.png")
	    		:align(display.TOP_CENTER, display.width * 0.24, -30 )
	       		:addTo(self.bg)
	local sequence = transition.sequence({
	          cc.MoveTo:create(0.2,cc.p(display.width * 0.24, 150)),
	          cc.MoveTo:create(0.1,cc.p(display.width * 0.24, 120)),
	          cc.MoveTo:create(0.1,cc.p(display.width * 0.24, 130)),
	      }) 
   	local temptrans = transition.execute(self.multiplyingtishi,sequence,{
	                   delay = 0.1,
	                   onComplete = function ()
	                   		self:addTouchonoroff(true)
	                    end})

	self.addmultiplyingziti = display.newSprite("banker/addmultiplyingziti.png")
    		:align(display.TOP_CENTER, display.width * 0.24, -75 )
       		:addTo(self.bg)
    local sequence1 = transition.sequence({
	          cc.MoveTo:create(0.3,cc.p(display.width * 0.24, 105)),
	          cc.MoveTo:create(0.1,cc.p(display.width * 0.24, 75)),
	          cc.MoveTo:create(0.1,cc.p(display.width * 0.24, 85)),
	      }) 
   	local temptrans1 = transition.execute(self.addmultiplyingziti,sequence1,{
	                   delay = 0.1,
	                   onComplete = function ()
	                   		-- self:addTouchonoroff(true)
	                    end})
	self.moveto = true
	self:performWithDelay(function ()
		self.moveto = false
	end, 1.2)
end
function multiplyingprompt:addSpritefruit(time,x,y,text,multiplying)

	local historyfruit = display.newSprite("fruitbase/chip.png")
    		:align(display.CENTER,x, y )
       		:addTo(self.bg)
    historyfruit:setScale(0.75)   		
    local historyfruittext = display.newTTFLabel(
        { text = multiplying.."%",
          font = "Arial",
          size = 18,
          align = cc.TEXT_ALIGNMENT_LEFT,
          color = cc.c3b(255, 0, 0) })
        :align(display.CENTER,historyfruit:getContentSize().width/2,historyfruit:getContentSize().height/2 +12)
        :addTo(historyfruit)
    table.insert(self.historyfruittext,historyfruittext)

    local historyfruittext = display.newTTFLabel(
        { text = text,
          font = "Arial",
          size = 22,
          align = cc.TEXT_ALIGNMENT_LEFT,
          color = cc.c3b(0, 0, 0) })
        :align(display.CENTER,historyfruit:getContentSize().width/2,historyfruit:getContentSize().height/2 -10)
        :addTo(historyfruit)

    table.insert(self.historyfruit,historyfruit)

    local sequence = transition.sequence({
	          cc.MoveTo:create(time/4,cc.p(x  , y + 180)),
	          cc.MoveTo:create(time/4,cc.p(x  , y + 155)),
	          cc.MoveTo:create(time/4,cc.p(x  , y + 165)),
	      }) 
   	local temptrans = transition.execute(historyfruit,sequence,{
	                   delay = time/4,
	                   onComplete = function ()
	                   		-- self:addTouchonoroff(true)
	                    end})
end

function multiplyingprompt:uddatertext(value)
	for k,v in pairs(self.historyfruittext) do
		v:setString(value[k].."%")
	end
end

function multiplyingprompt:addtransition()
	local time = 0.4
	--local y = self.historyfruit[1]:getPositionY()
	for i,v in ipairs(self.historyfruit) do
		local sequence = transition.sequence({
	          -- cc.MoveTo:create(time/2,cc.p(x  , y - 35)),
	          -- cc.MoveTo:create(time/4,cc.p(x  , y + 25)),
	          -- cc.MoveTo:create(time/4,cc.p(x  , y - 155)),

	          cc.MoveBy:create(time/2,cc.p(0 , -35)),
	          cc.MoveBy:create(time/4,cc.p(0 , 25)),
	          cc.MoveBy:create(time/4,cc.p(0 , -155)),
	          -- cc.ScaleTo:create(0.2,0.9,0.9),
	          -- cc.ScaleTo:create(0.2,1.0,1.0),
	      }) 
	   	local temptrans = transition.execute(v,sequence,{
		                   delay = 0,
		                   onComplete = function ()
		                   		-- self:addTouchonoroff(true)
		                    end})
	   	time = time + 0.1
	   	-- x = x + 65 
	end
end

function multiplyingprompt:addtransitionres(value,value1)
	local sequence = transition.sequence({
			  cc.ScaleTo:create(0.05,0.9,0.9),
	          cc.ScaleTo:create(0.05,1.0,1.0),
	          cc.MoveTo:create(0.1,cc.p(display.width * 0.24, 150)),
	          cc.MoveTo:create(0.1,cc.p(display.width * 0.24, 120)),
	          cc.MoveTo:create(0.1,cc.p(display.width * 0.24, -30)),
	      }) 
   	local temptrans = transition.execute(value,sequence,{
	                   delay = 0,
	                   onComplete = function ()
	                   		-- self:addTouchonoroff(true)
	                    end})

   	local sequence1 = transition.sequence({
			  cc.DelayTime:create(0.1),
	          cc.MoveTo:create(0.3,cc.p(display.width * 0.24, 105)),
	          cc.MoveTo:create(0.1,cc.p(display.width * 0.24, 75)),
	          cc.MoveTo:create(0.1,cc.p(display.width * 0.24, -75)),
	      }) 
   	local temptrans1 = transition.execute(value1,sequence1,{
	                   delay = 0,
	                   onComplete = function ()
	                   		-- self:addTouchonoroff(true)
	                    end})
end
--是否添加监听(开启)
function multiplyingprompt:addTouchonoroff(open)
	-- body
	--self.moveto = false
  	if open then
		--添加监听,吞噬事件
		self.multiplyingtishi:setTouchEnabled(true)
		self.multiplyingtishi:setTouchSwallowEnabled(true)
		self.multiplyingtishi:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
			if event.name == "began" then
			 	if self.moveto then
			 		return true
			 	end
			 	self.moveto = true
			    local movetospr = cc.DelayTime:create(1.2)
	   			self:addtransition()      
		      	self:addtransitionres(self.multiplyingtishi,self.addmultiplyingziti)
		      	
		      	--local Parentaddaction = cc.MoveBy:create(0.1 , cc.p(0, 50)) 
		      	self:performWithDelay(function ()
					self:getParent().addmultiplying:runAction(cc.MoveBy:create(0.1 , cc.p(0, 50)))
					self:getParent().openmultiplying = false
				end, 0.6)

		      	transition.execute(self.multiplyingtishi,movetospr,{
		                   delay = 0.1,
		                   onComplete = function ()
		                   		self:removeFromParent()
		                    end})
				
			end
		end)	
  	end
end

return multiplyingprompt