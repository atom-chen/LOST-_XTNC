


--银行界面
local bankeruser = class("bankeruser", function()
	return display.newNode()
end)

--调用
function bankeruser:ctor(nowmoney,savemoney)
    --现在的金币
    self.presentmoney = nowmoney
    --已存金币
    self.alreadymoney = savemoney

    self.getmoney = nil
    self.presentmoneybool = false
    self.alreadymoneybool = false

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(150)

	  self.lv = display.newSprite("banker/bankeropenbg.png")
    self.lv:setPosition(self.bg:getContentSize().width/2 ,self.bg:getContentSize().height/2)   
	  self.bg:addChild(self.lv)

    --[[
    local gerenyinhang = display.newTTFLabel(
        { text = "个人银行",
          font = "Arial",
          size = 25,
          align = cc.TEXT_ALIGNMENT_LEFT,
          color = cc.c3b(0, 0, 0) })
        :align(display.CENTER,self.lv:getContentSize().width/2 ,self.lv:getContentSize().height-20)
        :addTo(self.lv)
    ]]--
	    local close = display.newSprite("gamescene/close_btn.png")
        :align(display.CENTER_BOTTOM,self.bg:getContentSize().width/1.35,self.bg:getContentSize().height/1.4)
        :addTo(self.bg)
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

    --取钱
    local qumoney
    local qumoneycolor
    local qumoneyisMove 
    --滑动条
    self.huadongtiao = nil
    --存钱
    local cunmoney
    cunmoney = display.newSprite("gamescene/bankerBut.png")
        :align(display.CENTER_BOTTOM,self.lv:getContentSize().width/2.2 ,self.lv:getContentSize().height/1.7)
        :addTo(self.lv)

    local cunmoneybg = display.newSprite("banker/cunmoneybg.png")
          cunmoneybg:setPosition(cunmoney:getContentSize().width/2 ,cunmoney:getContentSize().height/2)   
          cunmoney:addChild(cunmoneybg)

    local cunmoneyisMove = true
    local cunmoneycolor = cunmoney:getColor()
    --点击了存钱
    self.cunmoneyopenlight = true
    cunmoney:setColor(cc.c3b(255,128,0))

    cunmoney:setTouchEnabled(true)
    cunmoney:setTouchSwallowEnabled(true)
    cunmoney:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  cunmoneyisMove then
            return 
        end
        if event.name == "began" then
          --吞噬，并且设置取钱可点击，不亮,存钱灯亮
          cunmoneyisMove = true          
          qumoneyisMove = false
          qumoney:setColor(qumoneycolor)
          self.cunmoneyopenlight = true
          self.qumoneyopenlight = false
          cunmoney:setColor(cc.c3b(255,128,0))
          --设置取钱上限
          print("取钱",self.presentmoney)
          self.money:setString("0")
          self.alreadymoneybool = false
          if self.presentmoney == 0 then
             self.presentmoneybool = true
             self.huadongtiao.max_ = 10
          else
             self.huadongtiao.max_ = tonumber(self.presentmoney)
          end
          self.huadongtiao:setSliderValue(0)
          local sequence = transition.sequence({
              cc.ScaleTo:create(0.1,0.9,0.9),
              cc.ScaleTo:create(0.2,1.0,1.0),             
          })        
          transition.execute(cunmoney,sequence,{
                       delay = 0,
                       onComplete = function ()
                        --cunmoneyisMove = false
                        --cunmoney:setColor(cunmoneycolor)
                        end})           
        end
    end)

    --取钱 
    -- local qumoney 
    qumoney = display.newSprite("gamescene/bankerBut.png")
        :align(display.CENTER_BOTTOM,self.lv:getContentSize().width/3 * 2 ,self.lv:getContentSize().height/1.7)
        :addTo(self.lv)

    local qumoneybg = display.newSprite("banker/qumoney.png")
          qumoneybg:setPosition(qumoney:getContentSize().width/2 ,qumoney:getContentSize().height/2)   
          qumoney:addChild(qumoneybg)

    qumoneyisMove = false
    qumoneycolor = qumoney:getColor()
    qumoney:setTouchEnabled(true)
    qumoney:setTouchSwallowEnabled(true)
    qumoney:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  qumoneyisMove then
            return 
        end
        if event.name == "began" then
          --吞噬，并且设置取钱可点击，不亮,取钱灯亮
          qumoneyisMove = true 
          self.qumoneyopenlight = true
          self.cunmoneyopenlight = false
          cunmoneyisMove = false
          cunmoney:setColor(cunmoneycolor)

          qumoney:setColor(cc.c3b(255,128,0))

          --设置存钱上限
          print("存钱",self.alreadymoney)
          self.money:setString("0")
          self.presentmoneybool = false
          if self.alreadymoney == 0 then
             self.alreadymoneybool = true
             self.huadongtiao.max_ = 10
          else
             self.huadongtiao.max_ = tonumber(self.alreadymoney)
          end
          -- self.huadongtiao.max_ = tonumber(self.alreadymoney)
          self.huadongtiao:setSliderValue(0)
          
          local sequence = transition.sequence({
              cc.ScaleTo:create(0.1,0.9,0.9),
              cc.ScaleTo:create(0.2,1.0,1.0),             
          })        
          transition.execute(qumoney,sequence,{
                       delay = 0,
                       onComplete = function ()
                        --qumoneyisMove = false
                        --qumoney:setColor(qumoneycolor)
                        end})           
        end
    end)


    local yinghao = display.newSprite("banker/input.png")
    yinghao:setPosition(self.lv:getContentSize().width/1.8 ,self.lv:getContentSize().height/1.9)   
    self.lv:addChild(yinghao)

    self.money = display.newTTFLabel(
        { text = "0",
          font = "Arial",
          size = 32,
          align = cc.TEXT_ALIGNMENT_LEFT,
          color = cc.c3b(0, 0, 0) })
        :align(display.CENTER,yinghao:getContentSize().width/2 ,yinghao:getContentSize().height/2)
        :addTo(yinghao)

    local SLIDERIMAGES = {
    bar = "banker/loadbg.png",
    button = "gamescene/LoadingBar.png",
    }
    local loadBar = cc.ui.UILoadingBar.new({
          scale9 = true,
          capInsets = cc.rect(0,0,10,10),
          image = "banker/loadjiazai.png",
          viewRect = cc.rect(0,0,380,28),
          percent = 0,
          })
          :align(display.CENTER_TOP ,self.lv:getContentSize().width/1.8 - 181 ,self.lv:getContentSize().height/2.4 )
          :addTo(self.lv)

    self.huadongtiao = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, SLIDERIMAGES, {scale9 = true})
        :onSliderValueChanged(function(event)         
            if self.presentmoneybool or self.alreadymoneybool then            
              loadBar:setPercent(tonumber(string.format("%0.0f",self.huadongtiao:getSliderValue()/self.huadongtiao.max_ * 100) ))
              self.money:setString(string.format("%0.0f",0))
            else
              loadBar:setPercent(tonumber(string.format("%0.0f",self.huadongtiao:getSliderValue()/self.huadongtiao.max_ * 100) ))
              self.money:setString(string.format("%0.0f",event.value))
            end
        end)
        :setSliderSize(380, 30)
        :setSliderValue(0)
        :align(display.CENTER_TOP ,self.lv:getContentSize().width/1.8 ,self.lv:getContentSize().height/2.4 +30)
        :addTo(self.lv)
    --设置最大值
    --huadongtiao.max_ = 8849561254

    local xianmoney = display.newTTFLabel(
        { text = "现金",
          font = "Arial",
          size = 30,
          align = cc.TEXT_ALIGNMENT_LEFT,
          color = cc.c3b(0, 0, 0) })
        :align(display.CENTER,self.lv:getContentSize().width/2.7 ,self.lv:getContentSize().height/2.8)
        :addTo(self.lv)

    local xiancunmoney = display.newTTFLabel(
        { text = "存金",
          font = "Arial",
          size = 30,
          align = cc.TEXT_ALIGNMENT_LEFT,
          color = cc.c3b(0, 0, 0) })
        :align(display.CENTER,self.lv:getContentSize().width/1.7 ,self.lv:getContentSize().height/2.8)
        :addTo(self.lv)

    local presentmoneybg = display.newSprite("banker/moneybg.png")
          presentmoneybg:setPosition(self.lv:getContentSize().width/2.1 ,self.lv:getContentSize().height/2.8)   
          self.lv:addChild(presentmoneybg)

    local alreadymoneybg = display.newSprite("banker/moneybg.png")
          alreadymoneybg:setPosition(self.lv:getContentSize().width/1.45 ,self.lv:getContentSize().height/2.8)   
          self.lv:addChild(alreadymoneybg)

    local bankerqcbg = display.newSprite("banker/bankerqc.png")
            :pos(self.lv:getContentSize().width/3.6 ,self.lv:getContentSize().height/1.8)
            :addTo(self.lv)

    self.xianmoney = display.newTTFLabel(
        { text = self.presentmoney,
          font = "Arial",
          size = 18,
          align = cc.ui.TEXT_ALIGN_LEFT,
          color = cc.c3b(0, 0, 0) })
        :align(display.CENTER,presentmoneybg:getContentSize().width/2 ,presentmoneybg:getContentSize().height/2)
        :addTo(presentmoneybg)

    self.xiancunmoney = display.newTTFLabel(
        { text = self.alreadymoney,
          font = "Arial",
          size = 18,
          align = cc.ui.TEXT_ALIGN_LEFT,
          color = cc.c3b(0, 0, 0) })
        :align(display.CENTER,alreadymoneybg:getContentSize().width/2,alreadymoneybg:getContentSize().height/2)
        :addTo(alreadymoneybg)

    --设置最大值
    --现在金币
    --self.presentmoney = 88888888
    --已存金币
    --self.alreadymoney = 10000000000
    if self.presentmoney == 0 then
       self.presentmoneybool = true

       self.huadongtiao.max_ = 10
    else
       self.huadongtiao.max_ = tonumber(self.presentmoney)
    end
    --确定
    local Determine
    self.qumoneyvalue = nil
    Determine = display.newSprite("gamescene/buyconfirm.png")
        :align(display.CENTER_BOTTOM,self.lv:getContentSize().width/3 * 2 ,self.lv:getContentSize().height/5)
        :addTo(self.lv)
    self.DetermineisMove = false
    -- local Determinecolor = Determine:getColor()
    Determine:setTouchEnabled(true)
    Determine:setTouchSwallowEnabled(true)
    Determine:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  self.DetermineisMove then
            return 
        end
        if event.name == "began" then
          self.DetermineisMove = true 
          self.Determineopenlight = true
          -- Determine:setColor(cc.c3b(255,128,0))
          -------------------------金币存取逻辑
          --self.qumoneyopenlight = true self.cunmoneyopenlight = true
          if self.qumoneyopenlight then
              print("取钱")
              -- local value = self.huadongtiao:getSliderValue()
              local value = self.money:getString()
              value = math.floor(value)
              self.qumoneyvalue = value
              if value == 0 then
                self.DetermineisMove = false
              else
                self:reslogin()
              end            

          end
          if self.cunmoneyopenlight then
              print("存钱")
              -- local value = self.huadongtiao:getSliderValue()
              local value = self.money:getString()
              value = math.floor(value)
              self:bnakermoneyTouser(value)
          end          
          -------------------------        
          local sequence = transition.sequence({
              cc.ScaleTo:create(0.1,0.9,0.9),
              cc.ScaleTo:create(0.2,1.0,1.0),             
          })        
          transition.execute(Determine,sequence,{
                       delay = 0,
                       onComplete = function ()
                        -- self.DetermineisMove = false
                        -- Determine:setColor(Determinecolor)
                        -- self:removeFromParent()
                        end})           
        end
    end)

    local Changepassword
    --移除函数
    self.removenodefun = nil
    Changepassword = display.newSprite("gamescene/Changepassword.png")
        :align(display.CENTER_BOTTOM,self.lv:getContentSize().width/2.2 ,self.lv:getContentSize().height/4.6)
        :addTo(self.lv)
    local ChangepasswordisMove = false
    -- local Changepasswordcolor = Changepassword:getColor()
    -- Changepassword:setColor(cc.c3b(255,128,0))
    Changepassword:setTouchEnabled(true)
    Changepassword:setTouchSwallowEnabled(true)
    Changepassword:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  ChangepasswordisMove then
            return 
        end
        if event.name == "began" then
          ChangepasswordisMove = true
           -------------------------
          -- Changepassword:setColor(cc.c3b(255,128,0)) 
          self.removenodefun = self:changepasswordfun()       
          local sequence = transition.sequence({
              cc.ScaleTo:create(0.1,0.9,0.9),
              cc.ScaleTo:create(0.2,1.0,1.0),             
          })        
          transition.execute(Changepassword,sequence,{
                       delay = 0,
                       onComplete = function ()
                        -- self.DetermineisMove = false
                        ChangepasswordisMove = false
                        -- Changepassword:setColor(Changepasswordcolor)
                        end}) 
        end
    end)
end

function bankeruser:reslogin()

    local node
    node = display.newNode()
    -----------------------------------------------------------------------  
    local loginmap = display.newSprite("banker/bankerbg.png")
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
    
    local userPassword = ""
    local userbankerpoassword
    userbankerpoassword = cc.ui.UIInput.new({
          image = "banker/input.png",
          linstener = nil,
          x = loginmap:getContentSize().width/2 ,
          y = loginmap:getContentSize().height/1.7,
          size = cc.size(310,65),
          listener = function(event)
            if event == "began" then
                
            elseif event == "ended" then
             
            elseif event == "return" then
              userPassword = userbankerpoassword:getText()
            elseif event == "changed" then

            end
        end
       })
     userbankerpoassword:setOpacity(250)
     userbankerpoassword:setFontColor(cc.c4b(0,0,0,255))
     userbankerpoassword:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
     userbankerpoassword:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
     userbankerpoassword:setPlaceHolder("输入密码")
     loginmap:addChild(userbankerpoassword)

    local buyreturn = display.newSprite("gamescene/buyreturn.png")
        :align(display.CENTER,loginmap:getContentSize().width/1.5 ,loginmap:getContentSize().height/3.8)
        :addTo(loginmap)
    local buyreturnisMove = false
    buyreturn:setTouchEnabled(true)
    buyreturn:setTouchSwallowEnabled(true)
    buyreturn:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  buyreturnisMove then
            return 
        end
        if event.name == "began" then
            buyreturnisMove = true
            self.DetermineisMove = false
            local buyreturnsequence = transition.sequence({
                cc.ScaleTo:create(0.1,0.9,0.9),
                cc.ScaleTo:create(0.1,1.1,1.1),
                cc.ScaleTo:create(0.1,0.3,0.3),
                })        
            transition.execute(node,buyreturnsequence,{
                delay = 0,
                onComplete = function ()                             
                    node:removeFromParent()
                end})        
              
        end
    end)

    local buyconfirm = display.newSprite("gamescene/buyconfirm.png")
        :align(display.CENTER,loginmap:getContentSize().width/3 ,loginmap:getContentSize().height/3.8)
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
            if userPassword == "" then
              self:createtishi(1)
              return
            end
            self:usergetmoneyformbanker(self.qumoneyvalue,userPassword)
            local buyconfirmsequence = transition.sequence({
                cc.ScaleTo:create(0.1,0.9,0.9),
                cc.ScaleTo:create(0.1,1.1,1.1),
                cc.ScaleTo:create(0.1,0.3,0.3),
                })        
            transition.execute(node,buyconfirmsequence,{
                delay = 0,
                onComplete = function ()                                                          
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

function bankeruser:changepasswordfun()
    local node
    node = display.newNode()
    -----------------------------------------------------------------------  
    local loginmap = display.newSprite("banker/Changepasswordbg.png")
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
    
    local userPassword = ""
    local userbankerpoassword
    userbankerpoassword = cc.ui.UIInput.new({
          image = "banker/input.png",
          linstener = nil,
          x = loginmap:getContentSize().width/2 ,
          y = loginmap:getContentSize().height/1.55,
          size = cc.size(310,65),
          listener = function(event)
            if event == "began" then
                
            elseif event == "ended" then
             
            elseif event == "return" then
              userPassword = userbankerpoassword:getText()
            elseif event == "changed" then

            end
        end
       })
     userbankerpoassword:setOpacity(250)
     userbankerpoassword:setFontColor(cc.c4b(0,0,0,255))
     userbankerpoassword:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
     userbankerpoassword:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
     userbankerpoassword:setPlaceHolder("原密码")
     loginmap:addChild(userbankerpoassword)

    local userchangepassword = ""
    local changepassword
    changepassword = cc.ui.UIInput.new({
          image = "banker/input.png",
          linstener = nil,
          x = loginmap:getContentSize().width/2 ,
          y = loginmap:getContentSize().height/2.15,
          size = cc.size(310,65),
          listener = function(event)
            if event == "began" then
                
            elseif event == "ended" then
             
            elseif event == "return" then
              userchangepassword = changepassword:getText()
            elseif event == "changed" then

            end
        end
       })
     changepassword:setOpacity(250)
     changepassword:setFontColor(cc.c4b(0,0,0,255))
     changepassword:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
     changepassword:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
     changepassword:setPlaceHolder("新密码")
     loginmap:addChild(changepassword)     

    local buyreturn = display.newSprite("gamescene/buyreturn.png")
        :align(display.CENTER,loginmap:getContentSize().width/1.5 ,loginmap:getContentSize().height/4.4)
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
                    node:removeFromParent()
                end})        
              
        end
    end)

    local buyconfirm = display.newSprite("gamescene/buyconfirm.png")
        :align(display.CENTER,loginmap:getContentSize().width/3 ,loginmap:getContentSize().height/4.4)
        :addTo(loginmap)
    local buyconfirmisMove = false
    buyconfirm:setTouchEnabled(true)
    buyconfirm:setTouchSwallowEnabled(true)
    buyconfirm:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  buyconfirmisMove then
            return 
        end
        if event.name == "began" then
            buyconfirmisMove = true
            if userPassword == "" then
              self:createtishi(1)
              buyconfirmisMove = false
              return
            end
            if userchangepassword == "" then
              self:createtishi(1)
              buyconfirmisMove = false
              return
            end          
            -- self:usergetmoneyformbanker(self.qumoneyvalue,userPassword)
            buyreturn:setTouchEnabled(false)
            --改密码数据
            local taken = {}
            taken.type = "lua"
            taken.session = Session
            taken.command = "changeKey"
            taken.data = {oldKey = userPassword , newKey = userchangepassword}
            Session = Session + 1
            Socketegame:send(PACK_AGE(taken))                
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

    local removenodefun
    removenodefun = function (tmep)
      if tmep then
        local buyconfirmsequence = transition.sequence({
          cc.ScaleTo:create(0.1,0.9,0.9),
          cc.ScaleTo:create(0.1,1.1,1.1),
          cc.ScaleTo:create(0.1,0.3,0.3),
          })        
        transition.execute(node,buyconfirmsequence,{
            delay = 0,
            onComplete = function ()                                                          
                node:removeFromParent()
            end}) 
      else
        --更改失败
        self:createtishi(2)
        buyconfirmisMove = false
        buyreturn:setTouchEnabled(true)
      end
    end
    return removenodefun
end

function bankeruser:callremovenodefun(temp)
  if temp then
    self.removenodefun(true)
  else
    self.removenodefun(false)
  end
end

function bankeruser:createtishi(upormoney)
  local fruittishi = display.newSprite("fruitpic/tishi.png")
        :pos(display.cx  , display.cy )
        :addTo(self,10)
  if upormoney == 0 then
    self.DetermineisMove = false
    display.newTTFLabel(
        { text = "密码错误",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 1 then
    -- self.DetermineisMove = false
    display.newTTFLabel(
        { text = "密码为空",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 2 then
    -- self.DetermineisMove = false
    display.newTTFLabel(
        { text = "更改失败",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  end
  transition.moveBy(fruittishi, { y = 80, time = 2})
  transition.fadeTo(fruittishi, {opacity = 50, time = 2})
  self:performWithDelay(function ()
                self:removeChild(fruittishi)             
                end , 1)
end
--现在金币self.xianmoney
--self.presentmoney = 88888888
--已存金币self.xiancunmoney
--self.alreadymoney = 10000000000
---发送取金币
function bankeruser:usergetmoneyformbanker(money,userPassword)
   if money <= 0 then
     self.DetermineisMove = false
     return
   end
   --取金币数据
   local taken = {}
   taken.type = "lua"
   taken.session = Session
   taken.command = "withdrawGold"
   taken.data = {password = userPassword , gold = money}
   Session = Session + 1
   Socketegame:send(PACK_AGE(taken))
   self.getmoney = money
end

--取金币
function bankeruser:usergetmoneyformbankerok()
   -- local money = self.getmoney
   self.presentmoney = self.presentmoney + self.getmoney
   self.alreadymoney = self.alreadymoney - self.getmoney
   self.xianmoney:setString(self.presentmoney)
   self.xiancunmoney:setString(self.alreadymoney)
   Socketegame._MONEY = Socketegame._MONEY + self.getmoney  

   self:okbankeruser(Socketegame._MONEY,self.alreadymoney)
   -- self:getParent().money:setString((Socketegame._MONEY))
   -- self.getmoney = nil
   -- self:removeFromParent()  
end

--发送存金币进金库
function bankeruser:bnakermoneyTouser(money)
   if money <= 0 then
     self.DetermineisMove = false
     return
   end
   -----发送存钱
   local taken = {}
   taken.type = "lua"
   taken.session = Session
   taken.command = "saveGold"
   taken.data = money
   Session = Session + 1
   Socketegame:send(PACK_AGE(taken))
   self.getmoney = money
end

--存金币
function bankeruser:bnakermoneyTouserok()
   -- local money = self.getmoney
   self.presentmoney = self.presentmoney - self.getmoney
   self.alreadymoney = self.alreadymoney + self.getmoney

   self.xianmoney:setString(self.presentmoney)
   self.xiancunmoney:setString(self.alreadymoney)

   Socketegame._MONEY = Socketegame._MONEY - self.getmoney

   self:okbankeruser(Socketegame._MONEY,self.alreadymoney)
   -- self:getParent().money:setString((Socketegame._MONEY))
   -- self.getmoney = nil
   -- self:removeFromParent()

end

--temp = 现金 --value = 存金
function bankeruser:okbankeruser(temp,value)
    local node = display.newNode()
    -----------------------------------------------------------------------  
    local loginmap = display.newSprite("But/loginbg.png")
            -- :pos(node:getContentSize().width/2,node:getContentSize().height/2)
            -- :addTo(node)
    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)
    node:setContentSize(display.width,display.height)
    node:ignoreAnchorPointForPosition(false)                 
    node:setAnchorPoint(cc.p(0.5,0.5))
    node:setPosition(display.cx , display.cy)
    self:addChild(node)
    
    loginmap:setPosition(node:getContentSize().width/2,node:getContentSize().height/2)
    node:addChild(loginmap)
    loginmap:setScale(0.2)
    local tishi = display.newTTFLabel(
        { text = "操作成功",
          font = "Arial",
          size = 34,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,loginmap:getContentSize().width/2 ,loginmap:getContentSize().height/5 * 4)
        :addTo(loginmap)


    local NICHENG = display.newTTFLabel(
        { text = "现金："..temp,
          font = "Arial",
          size = 30,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER, loginmap:getContentSize().width/2 ,loginmap:getContentSize().height/5 * 3)
        :addTo(loginmap)

    local NICHENG = display.newTTFLabel(
        { text = "存金："..value,
          font = "Arial",
          size = 30,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER, loginmap:getContentSize().width/2 ,loginmap:getContentSize().height/5 * 2)
        :addTo(loginmap)

    local login = {
     normal = "mian/PasswordBox.png",
     pressed = "mian/PasswordBox.png",
    } 
    local cancelButton = cc.ui.UIPushButton.new(login, {scale9 = true})
         :setButtonSize(90,50)
         :setButtonLabel("normal", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "确定",
              size = 30,
            }))
         :setButtonLabel("pressed", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "确定",
              size = 30,
              color = cc.c3b(255,64,64),
            }))
         :setButtonLabel("disabled", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "确定",
              size = 30,
              color = cc.c3b(0,0,0),
            }))
         :onButtonClicked(function ()
           local sequence2 = transition.sequence({
              cc.ScaleTo:create(0.05,0.9,0.9),
              cc.ScaleTo:create(0.05,1.1,1.1),
              cc.ScaleTo:create(0.05,0.3,0.3),
              })        
              transition.execute(loginmap,sequence2,{
                           delay = 0,
                           onComplete = function ()                              
                              -- loginmap:removeFromParent()
                              self:getParent().money:setString((Socketegame._MONEY))
                              self.getmoney = nil
                              node:removeFromParent()
                              self:removeFromParent()
                            end})

              end)
         :align(display.CENTER, loginmap:getContentSize().width/2, loginmap:getContentSize().height/5)
         :addTo(loginmap)

    local sequence1 = transition.sequence({
          cc.ScaleTo:create(0.1,1.0,1.0),
          cc.ScaleTo:create(0.1,0.9,0.9),
          cc.ScaleTo:create(0.1,1.1,1.1),
          cc.ScaleTo:create(0.1,1.0,1.0),               
      })        
      transition.execute(loginmap,sequence1,{
                   delay = 0,
                   onComplete = function ()
                    end})
end

return bankeruser