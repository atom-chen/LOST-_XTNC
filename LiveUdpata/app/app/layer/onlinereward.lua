
local schedule = require(cc.PACKAGE_NAME .. ".scheduler")

-- local onlineopenmoneylayer = require("app.layer.onlineopenmoney")
local relieffundlayer = require("app.layer.relieffund")
--在线奖励界面
local onlinereward = class("onlinereward", function()
	return display.newNode()
end)

--调用
function onlinereward:ctor(value)
    

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(150)

	  self.lv = display.newSprite("gamescene/callcenterbg.png")
    self.lv:setPosition(self.bg:getContentSize().width/2 ,self.bg:getContentSize().height/2)   
	  self.bg:addChild(self.lv)


    -- local gerenyinhang = display.newTTFLabel(
    --     { text = "在线奖励",
    --       font = "Arial",
    --       size = 25,
    --       align = cc.TEXT_ALIGNMENT_LEFT,
    --       color = cc.c3b(255, 255, 255) })
    --     :align(display.CENTER,self.lv:getContentSize().width/2 ,self.lv:getContentSize().height-20 - 190)
    --     :addTo(self.lv)

	local loadBarminutebg =  display.newSprite("banker/onlineload.png")
					:align(display.CENTER_TOP ,self.lv:getContentSize().width/2 ,self.lv:getContentSize().height-60  - 190)
	    			:addTo(self.lv)

 	local loadBarminute = cc.ui.UILoadingBar.new({
 		scale9 = true,
 		capInsets = cc.rect(0,0,10,10),
 		image = "banker/onlineloadtiao.png",
 		viewRect = cc.rect(0,0,430,10),
 		percent = 0,
 		})
 		:align(display.CENTER_TOP ,self.lv:getContentSize().width/2 - 215 ,self.lv:getContentSize().height-92 - 190)
 	    :addTo(self.lv)
 	    
 	local time = math.floor(value.time/60)
  if time<30 then
     loadBarminute:setPercent(25 *(time/30))
  elseif time >=30 and time < 60 then
    local temp = 25 + 25 *((time - 30)/30)
    loadBarminute:setPercent(temp)
    self:addSpritenmuber(2)
  elseif time >= 60 and time < 180 then
    --todo
    print("档次二")
    self:addSpritenmuber(2)
    self:addSpritenmuber(3)
    loadBarminute:setPercent(50 + 25 *((time - 60)/120))
  elseif time >= 180 and time < 300 then
    --todo
    print("档次s3")
    self:addSpritenmuber(2)
    self:addSpritenmuber(3)
    self:addSpritenmuber(4)
    loadBarminute:setPercent(75 + 25 *((time - 180)/120))
  else 
    print("档次4")
    loadBarminute:setPercent(100)
    self:addSpritenmuber(2)
    self:addSpritenmuber(3)
    self:addSpritenmuber(4)
    self:addSpritenmuber(5)
  end


  self:addTextmin(time.."分", self.lv:getContentSize().width/2 - 218 ,self.lv:getContentSize().height-137 - 190)
  
	self:addSpritenmuber(1)
	self:addTextmin("在线时间", self.lv:getContentSize().width/2 - 218 ,self.lv:getContentSize().height-117 - 190)
	self:addTextmin("30分钟", self.lv:getContentSize().width/2 - 110 ,self.lv:getContentSize().height-117 - 190)
	self:addTextmin("1小时", self.lv:getContentSize().width/2 - 1 ,self.lv:getContentSize().height-117 - 190)
	self:addTextmin("3小时", self.lv:getContentSize().width/2 + 110 ,self.lv:getContentSize().height-117 - 190)
	self:addTextmin("5小时", self.lv:getContentSize().width/2 + 218 ,self.lv:getContentSize().height-117 - 190)
	
 	--self.Spritemoney = {}
  --value
  -- self:getPos(value.level,1)
  -- self:getPosok(value.curLevel,1)
 	self:addSpritmoney(self:getPos(value.level,1),self:getPosok(value.curLevel,1),self.lv:getContentSize().width/2 - 160 ,self.lv:getContentSize().height-182 - 190,5000,1)
 	self:addSpritmoney(self:getPos(value.level,2),self:getPosok(value.curLevel,2),self.lv:getContentSize().width/2 - 50 ,self.lv:getContentSize().height-182 - 190,15000,2)
 	self:addSpritmoney(self:getPos(value.level,3),self:getPosok(value.curLevel,3),self.lv:getContentSize().width/2 + 60 ,self.lv:getContentSize().height-182 - 190,50000,3)
 	self:addSpritmoney(self:getPos(value.level,4),self:getPosok(value.curLevel,4),self.lv:getContentSize().width/2 + 170 ,self.lv:getContentSize().height-182 - 190,100000,4)
  
  local close = display.newSprite("gamescene/close_btn.png")
        :align(display.CENTER_BOTTOM,self.lv:getContentSize().width/1.3,self.lv:getContentSize().height/1.35)
        :addTo(self.lv)
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


  local closesequence = display.newSprite("gamescene/logobg.png")
    :align(display.CENTER_BOTTOM,self.lv:getContentSize().width/3.35,self.lv:getContentSize().height/3.8)
    :addTo(self.lv)

  local sequence = transition.sequence({
        cc.ScaleTo:create(4,0.96,0.96),
        cc.ScaleTo:create(4,1.0,1.0),             
  })        
  local action = cc.RepeatForever:create(sequence)
  closesequence:runAction(action)          
  local sequence1 = transition.sequence({
        cc.MoveBy:create(4,cc.p( 0, -10)),
        -- cc.MoveBy:create(2,cc.p( 0, 20)),
        cc.MoveBy:create(4,cc.p( 0, 10)),            
  })
  local action1 = cc.RepeatForever:create(sequence1)
  closesequence:runAction(action1)
end

function onlinereward:getPos(level, pos)
  
  if math.modf((level%10^pos)/10^(pos-1)) == 0 then
    print("pos true = ",pos)
    return true
  elseif math.modf((level%10^pos)/10^(pos-1)) == 1 then
    print("pos false = ",pos)
    return false
  end
end

--4
function onlinereward:getPosok(level,pos)
  if level >= pos then
    -- print("getPosokpos true = ",pos)
    return true
  elseif level < pos then
    -- print("getPosokpos false = ",pos)
    return false
  end
end


function onlinereward:addSpritmoney(CheckBoxtempbool,qutButtonbool,x,y,money,temp)
	local imageszhongbang = {
	   on = "banker/onlinemoney.png",
	   off = "banker/onlinemoneyclose.png",
	   }
   	local moneydaybang = cc.ui.UICheckBoxButton.new(imageszhongbang)
        :setButtonSelected(CheckBoxtempbool)
        :onButtonClicked(function () 	
        end)
        :align(display.LEFT_CENTER, x ,y)
        :addTo(self.lv)
    moneydaybang:setButtonEnabled(false)
    --table.insert(self.Spritemoney,moneydaybang)

    local gerenyinhang = display.newTTFLabel(
        { text = "X"..money,
          font = "Arial",
          size = 18,
          align = cc.TEXT_ALIGNMENT_LEFT,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,x + 45,y - 50)
        :addTo(self.lv)

    local login = {
     normal = "gamescene/receiveon.png",
     pressed = "gamescene/receive.png",
     --disabled = "banker/onlinenormal.png",
    }
    --退出按钮    
    local qutButton 
    qutButton = cc.ui.UIPushButton.new(login, {scale9 = true})
         :setButtonSize(120,60)
         :setButtonLabel("normal", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "",
              size = 18,
              color = cc.c3b(255,255,255),
         	  }))
         :setButtonLabel("pressed", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "",
              size = 18,
              color = cc.c3b(255,64,64),
         	  }))
         :setButtonLabel("disabled", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "",
              size = 18,
              color = cc.c3b(255,255,255),
         	  }))
         :onButtonClicked(function ()
               	moneydaybang:setButtonSelected(false)
               	qutButton:setButtonEnabled(false)
               	qutButton:setColor(cc.c3b(155,155,155))
                -- relieffundlayer
                -- local openmoneylayer = onlineopenmoneylayer.new(money)
                --                     :pos(0, 0)
                --                     :addTo(self)
                local openmoneylayer = relieffundlayer.new(money,"领取在线奖励",2)
                                    :pos(0, 0)
                                    :addTo(self)   
                --发送数据
                local taken = {}
                taken.type = "lua"
                --print("Session = ",Session)
                taken.session = Session
                taken.command = "getReward"
                taken.data = {level = temp}
                Session = Session + 1
                Socketegame:send(PACK_AGE(taken))   

              end)
         :align(display.LEFT_CENTER, x - 15, y - 90)
         :addTo(self.lv)

    if not CheckBoxtempbool then
    	qutButton:setButtonEnabled(false)
    	qutButton:setColor(cc.c3b(120,120,120))
    end
    if not qutButtonbool then
      qutButton:setButtonEnabled(false)
      qutButton:setColor(cc.c3b(120,120,120))
    end
end

function onlinereward:addTextmin(temptext,x,y)
	local gerenyinhang = display.newTTFLabel(
        { text = temptext,
          font = "Arial",
          size = 18,
          align = cc.TEXT_ALIGNMENT_LEFT,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,x,y)
        :addTo(self.lv)
end

function onlinereward:addSpritenmuber(temp)
	
	--for i,v in ipairs(temp) do
		if temp == 1 then		
			local loadBarminutebg1 =  display.newSprite("banker/onlinedian.png")
	  					:align(display.CENTER_TOP ,self.lv:getContentSize().width/2 - 218 ,self.lv:getContentSize().height-67 - 190)
	 	    			:addTo(self.lv)
		 	loadBarminutebg1 :setScale(1.5)
		elseif temp == 2 then
		 	local loadBarminutebg2 =  display.newSprite("banker/onlinedian.png")
		  					:align(display.CENTER_TOP ,self.lv:getContentSize().width/2 - 110 ,self.lv:getContentSize().height-67 - 190)
		 	    			:addTo(self.lv)
		 	loadBarminutebg2:setScale(1.5)
		elseif temp == 3 then
		 	local loadBarminutebg3 =  display.newSprite("banker/onlinedian.png")
		  					:align(display.CENTER_TOP ,self.lv:getContentSize().width/2 - 3 ,self.lv:getContentSize().height-67 - 190)
		 	    			:addTo(self.lv)
		 	loadBarminutebg3:setScale(1.5)
		elseif temp == 4 then	
		 	local loadBarminutebg4 =  display.newSprite("banker/onlinedian.png")
		  					:align(display.CENTER_TOP ,self.lv:getContentSize().width/2 + 110 ,self.lv:getContentSize().height-67 - 190)
		 	    			:addTo(self.lv)
		 	loadBarminutebg4:setScale(1.5)
		elseif temp == 5 then	
		 	local loadBarminutebg5 =  display.newSprite("banker/onlinedian.png")
		  					:align(display.CENTER_TOP ,self.lv:getContentSize().width/2 + 218 ,self.lv:getContentSize().height-67 - 190)
		 	    			:addTo(self.lv)
		 	loadBarminutebg5:setScale(1.5)
	 	end
	--end	
end


return onlinereward