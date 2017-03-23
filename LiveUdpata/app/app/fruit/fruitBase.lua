

--转盘水果基类
--@2017-1-10
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")


local fruitBase = class("fruitBase", function ()
	-- body
	--print("fruitBase")
	return display.newNode()
end)

function fruitBase:ctor(path)
	-- body
    --倍率，默认为0
    self.multiplying = 0
    --金额，根据当前选择设置金额
    self.Amount = 0
    --默认
    self.rescolor = nil
    --亮了
    self.openlight = false
    --时间
    self.times = 0.2

    --创建精灵
    local fruitBasepath = path..".png"
    --print(fruitBasepath)
    self.fruit = display.newSprite("fruitbase/color.png")
    		:align(display.CENTER,0,0)
    		:addTo(self)
    self.fruit:setScale(1)
    self:setContentSize(cc.size(self.fruit:getContentSize().width, self.fruit:getContentSize().height ))
    self:setAnchorPoint(cc.p(0.5,0.5))
    
    local addfruit = display.newSprite(fruitBasepath)
    			:align(display.CENTER,self.fruit:getContentSize().width/2, self.fruit:getContentSize().height/2)
    			:addTo(self.fruit)

    --设置self.rescolor
    self:getspritecolor()
end

--是否添加监听(开启，金额)
function fruitBase:addTouchonoroff(open,amount)
	-- body
  	if open then
		--todo
		--添加监听,吞噬事件
		self:setTouchEnabled(true)
		self:setTouchSwallowEnabled(true)
		self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
				-- body
				if event.name == "began" then
					--todo
					--print("chdii")
					self:setopenlight(true,true)

				end
			end)	

  	end
end

--由于不知道之前精灵建立的时候是什么颜色
function fruitBase:getspritecolor()
	-- body
	if self.fruit then
		--todo	
		self.rescolor = self.fruit:getColor()
		
	end
end

function fruitBase:rescoloropen()
	-- body
	self.fruit:setColor(self.rescolor)
	self.openlight = false
	self.fruit:setScale(1)
end

---设置是否亮灯,是否需要复原,time
function fruitBase:setopenlight(open,res,time)
	-- body
	--setSpriteFrame(filename) 改变精灵图片的方法
	if not self.openlight then
		--todo
		--点击了
		self.openlight = true
		self.fruit:setColor(cc.c3b(0,137,255))
		self.fruit:setScale(1.2)
		--是否需要复原
		if res then
			--todo
			if time then
				--todo
				self.times = time
			end
			scheduler.performWithDelayGlobal(function ( )
			-- body
	        self.fruit:setColor(self.rescolor)
	        --self.fruit:setScale(1)
	        transition.scaleTo(self.fruit, {scale = 1, time = 0.3})
	        self.openlight = false
			end , self.times )
		end		
	end
end




return fruitBase