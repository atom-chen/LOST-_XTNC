
--下注筹码基类
--@2017-1-10
--local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local bottomBase = class("bottomBase", function ()
	-- body
	--print("fruitBase")
	return display.newNode()
end)

function bottomBase:ctor(ddd,chiptext)

    --金额，根据当前选择设置金额
    self.chip = chiptext
    self.indexchip = nil
    --默认
    --self.rescolor = nil
    --亮了
    self.openlight = false
    --显示动画
    self.isMove = false
   
    if self.chip == 100 then
        self.indexchip = 1
    elseif self.chip == 1000 then
        self.indexchip = 2
    elseif self.chip == 10000 then
        self.indexchip = 3
    elseif self.chip == 100000 then
        self.indexchip = 4
    elseif self.chip == 500000 then
        self.indexchip = 5
    else
        self.indexchip = 6
    end

    --创建精灵
    local bottomname = {"black","purple","blue","green","red","golden"}
    local bottompath = "fruitbase/"..bottomname[self.indexchip]..".png"
    local bottomlightpath = "fruitbase/light"..bottomname[self.indexchip]..".png"

    local imageszhongbang = {
       off = bottompath,
       on = bottomlightpath,
       }
    self.bottomsprite = cc.ui.UICheckBoxButton.new(imageszhongbang)
        --:setButtonSelected(CheckBoxtempbool)
        :onButtonClicked(function () 
         end)
        --:align(display.CENTER, 0 ,0)self.bottomsprite:setButtonSelected()
        :pos(0,0)
        :addTo(self)
    self.bottomsprite:setButtonEnabled(false)
    --self.bottomsprite:setButtonSelected(true)

    self.chipsprite = display.newSprite("fruitbase/chip.png")
            --:align(display.LEFT_BOTTOM,0,0)
            :pos(self.bottomsprite:getContentSize().width *0.5, self.bottomsprite:getContentSize().height*0.5)
            :addTo(self.bottomsprite) 
    self.chipsprite:setOpacity(0)
    --self.chipsprite:setScale(1)

    self:setContentSize(cc.size(self.bottomsprite:getContentSize().width *0.5, self.bottomsprite:getContentSize().height*0.5 ))
    self:setAnchorPoint(cc.p(0.5,0.5))
    
    self:addTouchonoroff(true)

    if self.chip == 100 then
        self.bottomsprite:setButtonSelected(true)
    end
end

--是否添加监听(开启，金额)
function bottomBase:addTouchonoroff(open)
	-- body
  	if open then
		--todo
		--添加监听,吞噬事件
		self.chipsprite:setTouchEnabled(true)
		self.chipsprite:setTouchSwallowEnabled(true)
		self.chipsprite:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
				-- body
				if  self.isMove then
                 print(" kai da le ")
                 return 
               end
				if event.name == "began" then
					self.isMove = true                    
					local sequence = transition.sequence({
						    cc.ScaleTo:create(0.1,0.90,0.90),
						    cc.ScaleTo:create(0.1,1.05,1.05),					    
						})
	                transition.execute(self.bottomsprite,sequence,{
	                             delay = 0,
	                             onComplete = function ()
	                               self.isMove = false
	                               	if not self.openlight then
	                               	    self:getParent():getParent():oneopenlight(self.indexchip , self.chip)				                    	
				                    	self:setopenlight()
				                    	
				                    end
	                               end
	                            })
				end
			end)	

  	end
end

--关闭亮灯
function bottomBase:rescoloropen()
    self.openlight = false
    self.bottomsprite:setButtonSelected(false)	
end

--设置亮灯
function bottomBase:setopenlight()
	self.openlight = true
    self.bottomsprite:setButtonSelected(true)	
end


return bottomBase