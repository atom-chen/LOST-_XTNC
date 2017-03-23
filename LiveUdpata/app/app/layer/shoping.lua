--商城规则界面
local shoping = class("shoping", function()
	return display.newNode()
end)


function shoping:ctor()

	--self:setContentSize(cc.size(520, 400 ))
    --self:setAnchorPoint(cc.p(0.5,0.5))
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    
    self.bg1 = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg1:ignoreAnchorPointForPosition(false)                 
    self.bg1:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg1)
    self.bg1:setOpacity(150)

    self.addmentclassuitable = {}

    self.bg = display.newSprite("gamescene/ShoppingMallbg.png")
        :align(display.CENTER,self.bg1:getContentSize().width/2,self.bg1:getContentSize().height/2)
        :addTo(self.bg1)
	
    self:addmentclassui("money5000.png",self.bg:getContentSize().width/3.6 + 100,self.bg:getContentSize().height/2.8,function ()
        self:reslogin("money5000.png")
    end)
    ---[[
    self:addmentclassui("money1w.png",self.bg:getContentSize().width/3.6 + 120 + 100,self.bg:getContentSize().height/2.8,function ()
        self:reslogin("money1w.png")
    end)

    self:addmentclassui("money10w.png",self.bg:getContentSize().width/3.6 + 240 + 100,self.bg:getContentSize().height/2.8,function ()
        self:reslogin("money10w.png")
    end)

    self:addmentclassui("money100w.png",self.bg:getContentSize().width/3.6 + 360 + 100,self.bg:getContentSize().height/2.8,function ()
        self:reslogin("money100w.png")
    end)
    --]]--

	local close = display.newSprite("gamescene/close_btn.png")
        :align(display.CENTER_BOTTOM,self.bg:getContentSize().width/2 + 290,self.bg:getContentSize().height/2 + 140)
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


function shoping:addmentclassui(cdkey,posx,posy,fun) 

    local fruitaddbase = display.newSprite("gamescene/"..cdkey)
        :align(display.CENTER_BOTTOM,posx,posy)
        :addTo(self.bg)
    local isMove = false
    fruitaddbase:setTouchEnabled(true)
    fruitaddbase:setTouchSwallowEnabled(true)
    fruitaddbase:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  isMove then
            return 
        end
        if event.name == "began" then
          isMove = true
          for k,v in pairs(self.addmentclassuitable) do
            v:setTouchEnabled(false)
          end        
          local sequence = transition.sequence({
              cc.ScaleTo:create(0.1,0.95,0.95),
              cc.ScaleTo:create(0.1,1.01,1.01),             
          })        
          transition.execute(fruitaddbase,sequence,{
                       delay = 0,
                       onComplete = function ()
                             if fun then
                               fun()
                             end
                             self:performWithDelay(function ()
                                 isMove = false
                             end, 0.5)                 
                         end
                      })           
        end
    end)

    table.insert(self.addmentclassuitable,fruitaddbase)

end

function shoping:reslogin(cdkey)

    local node
    node = display.newNode()
    -----------------------------------------------------------------------  
    local loginmap = display.newSprite("gamescene/bugbg.png")
            -- :pos(node:getContentSize().width/2,node:getContentSize().height/2)
            -- :addTo(node)
    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)
    node:setContentSize(loginmap:getContentSize().width + 600,loginmap:getContentSize().height + 400)
    node:ignoreAnchorPointForPosition(false)                 
    node:setAnchorPoint(cc.p(0.5,0.5))
    node:setPosition(display.cx , display.height + 400 )
    self:addChild(node)
    
    loginmap:setPosition(node:getContentSize().width/2,node:getContentSize().height/2)
    node:addChild(loginmap)
    
    local fruitaddbase = display.newSprite("gamescene/"..cdkey)
        :align(display.CENTER,loginmap:getContentSize().width/4.5 ,loginmap:getContentSize().height/1.7)
        :addTo(loginmap)

    local buyreturn = display.newSprite("gamescene/buyreturn.png")
        :align(display.CENTER,loginmap:getContentSize().width/1.5 ,loginmap:getContentSize().height/3.5)
        :addTo(loginmap)
    -- local buyreturnisMove = false
    buyreturn:setTouchEnabled(true)
    buyreturn:setTouchSwallowEnabled(true)
    buyreturn:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  isMove then
            return 
        end
        if event.name == "began" then
            -- buyreturnisMove = true
            local buyreturnsequence = transition.sequence({
                cc.ScaleTo:create(0.1,0.9,0.9),
                cc.ScaleTo:create(0.1,1.1,1.1),
                cc.ScaleTo:create(0.1,0.3,0.3),
                })        
            transition.execute(node,buyreturnsequence,{
                delay = 0,
                onComplete = function ()
                    for k,v in pairs(self.addmentclassuitable) do
                        v:setTouchEnabled(true)
                    end                              
                    node:removeFromParent()
                end})        
              
        end
    end)

    local buyconfirm = display.newSprite("gamescene/buyconfirm.png")
        :align(display.CENTER,loginmap:getContentSize().width/3 ,loginmap:getContentSize().height/3.5)
        :addTo(loginmap)
    -- local buyreturnisMove = false
    buyconfirm:setTouchEnabled(true)
    buyconfirm:setTouchSwallowEnabled(true)
    buyconfirm:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  isMove then
            return 
        end
        if event.name == "began" then
            -- buyreturnisMove = true
            local buyconfirmsequence = transition.sequence({
                cc.ScaleTo:create(0.1,0.9,0.9),
                cc.ScaleTo:create(0.1,1.1,1.1),
                cc.ScaleTo:create(0.1,0.3,0.3),
                })        
            transition.execute(node,buyconfirmsequence,{
                delay = 0,
                onComplete = function ()                              
                    for k,v in pairs(self.addmentclassuitable) do
                        v:setTouchEnabled(true)
                    end                              
                    node:removeFromParent()
                end})        
              
        end
    end)

    local sequence = transition.sequence({
        cc.MoveTo:create(0.2,cc.p(display.width/2,display.height/2) ),
        cc.ScaleTo:create(0.1,0.9,0.9),
        cc.ScaleTo:create(0.1,1.1,1.1),
        cc.ScaleTo:create(0.1,1.0,1.0),
    })        
    transition.execute(node,sequence,{
                 delay = 0,
                 onComplete = function ()

                  end})
end

return shoping