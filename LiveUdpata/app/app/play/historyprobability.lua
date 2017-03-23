

-- local createpicturelayer = require("app.layer.createpicture")
--历史概率
local historyprobability = class("historyprobability", function ()
	return display.newNode()
end)

function historyprobability:ctor(value)	
  
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(20)
    self:setContentSize(cc.size(self.bg:getContentSize().width, self.bg:getContentSize().height ))
    self:setAnchorPoint(cc.p(0,0))

    --创建精灵
    -- local fruitBasepath = "banker/onlineopenmoney.png"
    -- self.fruit = display.newSprite(fruitBasepath)
    -- 		:align(display.CENTER,self.bg:getContentSize().width/2, self.bg:getContentSize().height + 100 )
    --    		:addTo(self.bg)
	self.itmelv = cc.ui.UIListView.new {
        -- bg = "dengdai/bg4.png",
        bgScale9 = true,
        viewRect = cc.rect(40, 80, 320, 328),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = "banker/bar.png"
    	}
    self.itmelv:ignoreAnchorPointForPosition(false) 
    self.itmelv:setAnchorPoint(cc.p(1,0.5))
    self.itmelv:setPosition(self.bg:getContentSize().width - 360, self.bg:getContentSize().height/4 - 80)
    self.bg:addChild(self.itmelv)
 	
	self:addTouchonoroff(true)

	self.historyfruit = {}
	--self:addSpritefruit(0.4,self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 140 + 20)
	-- self:addSpritefruit(0.5,self.bg:getContentSize().width + 125 - 35, self.bg:getContentSize().height - 205 + 20)
	-- self:addSpritefruit(0.6,self.bg:getContentSize().width + 125 - 35, self.bg:getContentSize().height - 270 + 20)
	-- self:addSpritefruit(0.7,self.bg:getContentSize().width + 125 - 35, self.bg:getContentSize().height - 335 + 20)
	-- self:addSpritefruit(0.8,self.bg:getContentSize().width + 125 - 35, self.bg:getContentSize().height - 400 + 20)
	-- self:addSpritefruit(1.0,self.bg:getContentSize().width + 125 - 35, self.bg:getContentSize().height - 465 + 20)
	-- --self:addSpritefruit(1.1,self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 530 + 20)
	--self:addSpritefruit(1.2,self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 595 + 20)
	local tempvalue = {}
	if not value[1].name then
	  	for i,v in ipairs(value) do
	  	    if i > 1 then
	  	    	table.insert(tempvalue,v)
	  	    end
	  	end
	  	-- print("gggggg",#tempvalue)
	  	local tempvaluechilditme = {}
	  	for i,t in ipairs(tempvalue) do
		   if i <= 5 then
			   self:addsprtoItme(0.3 + i *0.1,self.bg:getContentSize().width + 170,self.bg:getContentSize().height - 185 - 65*(i-1),false,t)    	
		   	   -- table.remove(tempvalue,1)
		   else
		   	   table.insert(tempvaluechilditme,t)
		   end
		end

		self:performWithDelay(function ()
			self.moveto = false
			if next(tempvaluechilditme) ~= nil then
				self:addtochilditme(tempvaluechilditme)
			end
		end, 0.9)	
	else		
	  	self:addsprtoItme(0.4,self.bg:getContentSize().width + 170,self.bg:getContentSize().height - 185,true,value[1]) 	   
		for i,v in ipairs(value) do
	  	    if i > 1 then
	  	    	table.insert(tempvalue,v)
	  	    end
	  	end
	  	local tempvaluechilditme = {}
	  	for i,t in ipairs(tempvalue) do
		   if i <= 4 then
			   self:addsprtoItme(0.4 + i *0.1,self.bg:getContentSize().width + 170,self.bg:getContentSize().height - 185 - 65*(i),false,t)    	
		   	   -- table.remove(tempvalue,1)
		   else
		   	   table.insert(tempvaluechilditme,t)
		   end
		end
		self:performWithDelay(function ()
			self.moveto = false
			if next(tempvaluechilditme) ~= nil then
				self:addtochilditme(tempvaluechilditme)
			end
		end, 0.9)
	end
	
	-- self:addsprtoItme(0.4,self.bg:getContentSize().width + 170,self.bg:getContentSize().height - 185,true) 
	-- self:addsprtoItme(0.5,self.bg:getContentSize().width + 170,self.bg:getContentSize().height - 185 - 65)
	-- self:addsprtoItme(0.6,self.bg:getContentSize().width + 170,self.bg:getContentSize().height - 185 - 65*2)
	-- self:addsprtoItme(0.7,self.bg:getContentSize().width + 170,self.bg:getContentSize().height - 185 - 65*3)
	-- self:addsprtoItme(0.8,self.bg:getContentSize().width + 170,self.bg:getContentSize().height - 185 - 65*4)
	-- self.moveto = true
	-- self:performWithDelay(function ()
	-- 	self.moveto = false
	-- 	self:addtochilditme(6)
	-- end, 0.9)
	--print(self.historyfruit[1]:getPositionY())640 - 140 + 20 320 - 596 + 20
end

function historyprobability:addsprtoItme(time,x,y,banker,temptext)
		local content
        local sprite  
        local spritetext1
        local spritetext2
        local spritetext3
        
        if not temptext then
           temptext = {name = "-",icon = 1, money = "$$$$$$"}
        end
        content = cc.LayerColor:create()
            -- cc.c4b(math.random(250),
            --     math.random(250),
            --     math.random(250),
            --     250))
        content:setContentSize(320, 65)
        content:ignoreAnchorPointForPosition(false)
        content:setAnchorPoint(cc.p(0.5,0.5))

  		content:setPosition(x,y)
  		self.bg:addChild(content)  		
        local historyfruit = display.newSprite("banker/historyprobability.png")
		historyfruit:setPosition(content:getContentSize().width/2, content:getContentSize().height/2)
		content:addChild(historyfruit)

		local temp = "displaypicture/boy"..(temptext.icon)..".png"
		local fruit = display.newSprite(temp)
		       :pos(40, content:getContentSize().height/2)
		       :addTo(content)
		fruit:setScale(0.64)

		if banker then
		   local youisbankerspr = display.newSprite("bankerbg.png")
		        :pos(30 , content:getContentSize().height/4)
		        :addTo(content)
			youisbankerspr:setScale(0.4)
			historyfruit:setColor(cc.c3b(255,128,0))
		end

	    table.insert(self.historyfruit,content)

	    spritetext1 = display.newTTFLabel(
        { text = temptext.name,
          --font = "MarkerFelt",
          size = 18,
          align = cc.TEXT_ALIGNMENT_RIGHT,
          color = cc.c3b(0,0,0) })      
        --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
            :align(display.LEFT_CENTER,75, content:getContentSize().height/2)
        content:addChild(spritetext1)


        spritetext2 = display.newTTFLabel(
        { text = temptext.money,
          --font = "MarkerFelt",
          size = 18,
          align = cc.TEXT_ALIGNMENT_RIGHT,
          color = cc.c3b(0,0,0) })      
        --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
            :align(display.LEFT_CENTER,content:getContentSize().width/2 + 20, content:getContentSize().height/2)
        content:addChild(spritetext2)


	    local sequence = transition.sequence({
		          cc.MoveBy:create(time/2,cc.p(-341 , 0)),
		          cc.MoveBy:create(time/4,cc.p(30 , 0)),
		          cc.MoveBy:create(time/4,cc.p(-20 , 0)),
		      }) 
	   	local temptrans = transition.execute(content,sequence,{
		                   delay = 0,
		                   onComplete = function ()
		                   		local item = self.itmelv:newItem()
							    content:retain()
						        content:removeFromParent()
							    item:addContent(content)
							    content:release()
						        item:setItemSize(320,65)
						        self.itmelv:addItem(item)

						    	self.itmelv:reload()

		                    end})

end


function historyprobability:addtochilditme(number)
	-- for i=1,number do
	for i,v in ipairs(number) do
		local spritetext1
        local spritetext2
        local spritetext3
		content = cc.LayerColor:create()
	    -- cc.c4b(math.random(250),
	    --     math.random(250),
	    --     math.random(250),
	    --     250))
	    content:setContentSize(320, 65)
	    content:ignoreAnchorPointForPosition(false)
	    content:setAnchorPoint(cc.p(0.5,0.5))	
	    local historyfruit = display.newSprite("banker/historyprobability.png")
		historyfruit:setPosition(content:getContentSize().width/2, content:getContentSize().height/2)
		content:addChild(historyfruit)
	    table.insert(self.historyfruit,content)

	    ------------------------------
	    spritetext1 = display.newTTFLabel(
        { text = v.name,
          --font = "MarkerFelt",
          size = 18,
          align = cc.TEXT_ALIGNMENT_RIGHT,
          color = cc.c3b(0,0,0) })      
        --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
            :align(display.LEFT_CENTER,75, content:getContentSize().height/2)
        content:addChild(spritetext1)


        spritetext2 = display.newTTFLabel(
        { text = v.money,
          --font = "MarkerFelt",
          size = 18,
          align = cc.TEXT_ALIGNMENT_RIGHT,
          color = cc.c3b(0,0,0) })      
        --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
            :align(display.LEFT_CENTER,content:getContentSize().width/2 + 20, content:getContentSize().height/2)
        content:addChild(spritetext2)


        local temp = "displaypicture/boy"..(v.icon)..".png"
		local fruit = display.newSprite(temp)
		       :pos(40, content:getContentSize().height/2)
		       -- :addTo(content)
		fruit:setScale(0.64)
		content:addChild(fruit)
	    ------------------------------
	    local item = self.itmelv:newItem()
	    item:addContent(content)
	    item:setItemSize(320,65)
	    self.itmelv:addItem(item)
		self.itmelv:reload()
	end
end

function historyprobability:addSpritefruit(time,x,y)
	local historyfruit = display.newSprite("banker/historyprobability.png")
    		:align(display.CENTER,x, y )
       		:addTo(self.bg)
    table.insert(self.historyfruit,historyfruit)
    local sequence = transition.sequence({
	          cc.MoveTo:create(time/4,cc.p(x - 280 , y)),
	          cc.MoveTo:create(time/4,cc.p(x - 240 , y)),
	          cc.MoveTo:create(time/4,cc.p(x - 250 , y)),
	          -- cc.ScaleTo:create(0.2,0.9,0.9),
	          -- cc.ScaleTo:create(0.2,1.0,1.0),
	      }) 
   	local temptrans = transition.execute(historyfruit,sequence,{
	                   delay = time/4,
	                   onComplete = function ()
	                   		-- self:addTouchonoroff(true)
	                   		self:addsprtoItme(historyfruit)
	                    end})

end

function historyprobability:addtransition()
	local time = 0.4
	for i,v in ipairs(self.historyfruit) do
		-- content:retain()
  --       content:removeFromParent()
	 --    item:addContent(content)
	 --    content:release()
		local sequence = transition.sequence({
	          cc.MoveBy:create(time/2,cc.p(-30, 0)),
	          cc.MoveBy:create(time/4,cc.p(20 , 0)),
	          cc.MoveBy:create(time/4,cc.p(341 , 0)),
	          -- cc.ScaleTo:create(0.2,0.9,0.9),
	          -- cc.ScaleTo:create(0.2,1.0,1.0),
	      }) 
	   	local temptrans = transition.execute(v,sequence,{
		                   delay = 0,
		                   onComplete = function ()
		                   		-- self:addTouchonoroff(true)
		                    end})
	   	time = time + 0.1
	end
end
--是否添加监听(开启)
function historyprobability:addTouchonoroff(open)
	-- body
	--self.moveto = false
  	if open then
		--添加监听,吞噬事件
		self:setTouchEnabled(true)
		self:setTouchSwallowEnabled(true)
		self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
			if event.name == "began" then
				-- local sequence = transition.sequence({
			 --          --cc.ScaleTo:create(0.1,1.9,1.9),
			 --          cc.MoveTo:create(0.3,cc.p(160, self.bg:getContentSize().height - 50) ),
			 --      })
			 	if self.moveto then
			 		--print("ddddd")
			 		return true
			 	end
			 	self.moveto = true
			    local movetospr = cc.DelayTime:create(1.2)
	   			-- self:addtransition(self.bg:getContentSize().width + 125, self.bg:getContentSize().height - 140 + 20)      
		      	self:addtransition()
		      	transition.execute(self,movetospr,{
		                   delay = 0.1,
		                   onComplete = function ()
		                   		--self:addTouchonoroff(true)
		                   		self:removeFromParent()
		                    end})
				
			end
		end)	
  	end
end

return historyprobability