

--local gamescene = require("app.scenes.GameScene")
local SocketTCPMain = require("framework.cc.net.SocketTCP")
--local schedule = require(cc.PACKAGE_NAME .. ".scheduler")

local lodingwaitlayer = require("app.layer.lodingwait")
local Gamelayer = class("Gamelayer", function()
	return display.newNode()
end)

function Gamelayer:ctor(current_energy)

    --第一次连接失败
    self.createlodinginfun = 1

    --self.createusebool = true
    --保存玩家输入的账号密码
    self.createUsetable = {uuid = "" , password = ""}
    --吞噬事件
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)    
    self.registerSocket = nil
    --取消按钮
    --self.cancelinMove = false
    self.number = 0
	  --340 340
	  self.createUse = cc.LayerColor:create(cc.c4b(255,255,255,255),550,320)
                   :pos(display.width/2,display.height/2 * 3)
    self.createUse:ignoreAnchorPointForPosition(false)                 
    self.createUse:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.createUse,2)
    -- self:setTag(10)

    self.createUse:setOpacity(0)
    
    local loginmap = display.newSprite("mian/createusebg.png")
            :pos(self.createUse:getContentSize().width/2,self.createUse:getContentSize().height/2)
            :addTo(self.createUse)
    -- loginmap:setScaleX(fScaleX)         
    local username
    username = cc.ui.UIInput.new({
          image = "mian/PasswordBox2.png",
          linstener = nil,
          x = self.createUse:getContentSize().width/3*2,
          y = self.createUse:getContentSize().height/5 * 4,
          size = cc.size(300,55),
          listener = function(event, userPassword)
            if event == "began" then
                
            elseif event == "ended" then
             
            elseif event == "return" then
              self.createUsetable.uuid = username:getText()
            elseif event == "changed" then
                --是否含有中文
                local str = username:getText()
                local len , count = self:utfstrlan(str)
                --print(len , count)
                if count > 0 then
                  --todo
                  username:setText("")
                  self:createtishi(5)
                elseif len >= 13 then
                  --todo
                  username:setText("")
                  self:createtishi(1)
                elseif len < 6 then
                  --todo
                  username:setText("")
                  self:createtishi(2)
                end
            end
        end
       })
     username:setOpacity(240)
     username:setFontColor(cc.c4b(80,80,80,255))
     username:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
     username:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
     username:setMaxLength(13)
     username:setPlaceHolder("不超过12个")
     self.createUse:addChild(username)

    local userPassword 
    userPassword = cc.ui.UIInput.new({
        --UIInputType = 2,
        image = "mian/PasswordBox2.png",
        size = cc.size(300,55),
        x = self.createUse:getContentSize().width/3*2 ,
        y = self.createUse:getContentSize().height/5 * 3,
        listener = function(event, userPassword)
            if event == "began" then
                
            elseif event == "ended" then
             
            elseif event == "return" then
  
            elseif event == "changed" then
                --检验密码是否过短或过长
                local str = userPassword:getText()
                local len , count = self:utfstrlan(str)
                --print(len)
                if count > 0 then
                  --todo
                  userPassword:setText("")
                  self:createtishi(5)
                elseif len >= 13 then
                  --todo
                  userPassword:setText("")
                  self:createtishi(0)
                elseif len < 6 then
                  --todo
                  userPassword:setText("")
                  self:createtishi(3)
                end
            end
        end
    })
    userPassword:setPlaceHolder("不超过15个")
    userPassword:setFontColor(cc.c4b(80,80,80,255))
    userPassword:setInputFlag(0)
    userPassword:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    userPassword:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    userPassword:setMaxLength(16)
    self.createUse:addChild(userPassword)
    

    local againuserPassword 
    againuserPassword = cc.ui.UIInput.new({
        --UIInputType = 2,
        image = "mian/PasswordBox2.png",
        size = cc.size(300,55),
        x = self.createUse:getContentSize().width/3*2 ,
        y = self.createUse:getContentSize().height/5 * 2,
        listener = function(event, againuserPassword)
            if event == "began" then
                
                if userPassword:getText() == "" then
                    print("pass Nil")
                end
            elseif event == "ended" then
                
            elseif event == "return" then
                
            elseif event == "changed" then
                if userPassword:getText() ~= againuserPassword:getText() then
                    againuserPassword:setText("")
                    self:createtishi(4)
                     --[[
                     device.showAlert("提示", "密码不一致", {"YES","NO"}, function (event)
                                           if event.buttonIndex == 1 then                                                    
                                                   device.cancelAlert() 
                                            end  
                                         end)
                      ]]--
                else
                  --todo
                  --获取密码
                  self.createUsetable.password = againuserPassword:getText()
                end
            else

            end
        end
    })
    againuserPassword:setPlaceHolder("确认密码")
    againuserPassword:setFontColor(cc.c4b(80,80,80,255))
    againuserPassword:setInputFlag(0)
    againuserPassword:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    againuserPassword:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    againuserPassword:setMaxLength(16)
    self.createUse:addChild(againuserPassword)
    
    --[[
    --文字提示
    display.newTTFLabel(
        { text = "输入账号",
          font = "Arial",
          size = 24,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,self.createUse:getContentSize().width/3*2-160 ,self.createUse:getContentSize().height/5 * 4)
        :addTo(self.createUse)

    display.newTTFLabel(
        { text = "输入密码",
          font = "Arial",
          size = 24,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,self.createUse:getContentSize().width/3*2-160 ,self.createUse:getContentSize().height/5 * 3)
        :addTo(self.createUse)

     display.newTTFLabel(
        { text = "确认密码",
          font = "Arial",
          size = 24,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,self.createUse:getContentSize().width/3*2-160 ,self.createUse:getContentSize().height/5 * 2)
        :addTo(self.createUse)
    ]]--


    --确定按钮
    local login = {
     normal = "mian/oknormal.png",
     pressed = "mian/okpressed.png",
     disabled = "mian/oknormal.png",
    } 
   
    local okButton = cc.ui.UIPushButton.new(login, {scale9 = true})
         :setButtonSize(130,60)
         --[[
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
            ]]--
         :onButtonClicked(function ()           
              --发送账号，密码信息
              --self.useNameID = ediUsernameBox:getText()
              -- self.usePassword = ediUserPasswordBox:getText()
              --注册连接againuserPassword  username
              if againuserPassword:getText() ~= "" and username:getText() ~= "" then
                self:openloginSocket()
                self:getParent().dengdaijiazai = lodingwaitlayer.new()
                    :pos(0, 0)
                    :addTo(self:getParent())
              else
                 self:createtishi(6)
              end
              
              -- if( self.createUsetable.uuid ~= "" and self.createUsetable.password ~= "") then        
                  
              --     self:getParent().dengdaijiazai = lodingwaitlayer.new()
              --         :pos(0, 0)
              --         :addTo(self:getParent()) 

              --     local registerpack 
              --     registerpack = 
              --     {
              --     type = "register",
              --     uuid = self.createUsetable.uuid,
              --     pass = self.createUsetable.password,               
              --     }
              --     local age = PACK_AGE(registerpack)                 
              --     self.registerSocket:send(age)
              -- else
              --     --todo
              --   self:createtishi(6)           
              -- end            
            end)
         :align(display.LEFT_CENTER, self.createUse:getContentSize().width/4 - 45 , self.createUse:getContentSize().height/5 )
         :addTo(self.createUse)


    local cancel = {
     normal = "mian/cancelnormal.png",
     pressed = "mian/cancelpressed.png",
     disabled = "mian/cancelnormal.png",
    } 
    local cancelButton = cc.ui.UIPushButton.new(cancel, {scale9 = true})
         :setButtonSize(130,60)
         --[[
         :setButtonLabel("normal", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "取消",
              size = 30,
         	  }))
         :setButtonLabel("pressed", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "取消",
              size = 30,
              color = cc.c3b(255,64,64),
         	  }))
         :setButtonLabel("disabled", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "取消",
              size = 30,
              color = cc.c3b(0,0,0),
         	  }))]]--
         :onButtonClicked(function ()
          --if self.cancelinMove then
            --return
          --end
            -- transition.moveTo(self:getParent().login, {x = self:getParent().login:getPositionX(), y = display.cy, time = 0.2})
            local sequence = transition.sequence({
            cc.ScaleTo:create(0.05,0.9,0.9),
            cc.ScaleTo:create(0.05,1.1,1.1),
            cc.ScaleTo:create(0.05,0.3,0.3),
            })        
            transition.execute(self.createUse,sequence,{
                         delay = 0,
                         onComplete = function ()
                            local sequence1 = transition.sequence({
                                cc.MoveTo:create(0.2,cc.p(self:getParent().login:getPositionX(),display.cy) ),
                                cc.ScaleTo:create(0.05,0.9,0.9),
                                cc.ScaleTo:create(0.05,1.1,1.1),
                                cc.ScaleTo:create(0.05,1.0,1.0),
                              }) 
                            transition.execute(self:getParent().login,sequence1)
                            -- transition.moveTo(self:getParent().login, {x = self:getParent().login:getPositionX(), y = display.cy, time = 0.2})                                
                            self:getParent().createusebool = false
                            self:getParent():removeChild(self:getParent().dataLayer)
                            end})
            
         	  --local WinScene= gamescene.new()
            --display.replaceScene(WinScene,"fade",1)

            end)
         :align(display.LEFT_CENTER, self.createUse:getContentSize().width/4 * 3 - 45, self.createUse:getContentSize().height/5 )
         :addTo(self.createUse)

         local sequence = transition.sequence({
            --cc.ScaleTo:create(0.1,1.9,1.9),
            cc.MoveTo:create(0.2,cc.p(display.width/2,display.height/2) ),
            cc.ScaleTo:create(0.1,0.9,0.9),
            cc.ScaleTo:create(0.1,1.1,1.1),
            cc.ScaleTo:create(0.1,1.0,1.0),
        })        
        transition.execute(self.createUse,sequence,{
                     delay = 0,
                     onComplete = function ()
                      end})
          
end

----注册连接
function Gamelayer:openloginSocket()
  ---------------------------2017/1/16
          --注册服务器
          -- self.registerSocket = SocketTCPMain.new("192.168.80.246",8190,false)
          -- self.registerSocket = SocketTCPMain.new("192.168.83.185",8190,false)
          -- self.registerSocket = SocketTCPMain.new("192.168.80.20",8190,false)
          self.registerSocket = SocketTCPMain.new("139.199.220.181",8190,false)          
          self.registerSocket:addEventListener(SocketTCPMain.EVENT_CONNECTED , handler(self,self.onStatus))
          self.registerSocket:addEventListener(SocketTCPMain.EVENT_CLOSE , handler(self,self.onStatus))
          --网络连接关闭
          self.registerSocket:addEventListener(SocketTCPMain.EVENT_CLOSED, handler(self,self.onStatus))
          --网络连接失败
          self.registerSocket:addEventListener(SocketTCPMain.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))          
          --网络连接，收到消息
          self.registerSocket:addEventListener(SocketTCPMain.EVENT_DATA, handler(self,self.onStatus))          
          self.registerSocket:connect()
    --------------------2017/1/16 
end

function Gamelayer:onStatus(event)
  -- body
  --print("fun")
    -- body
    if event.name == "SOCKET_TCP_CONNECTED" then
      self:getParent():lodingremoveformmain()
      self.createlodinginfun = 2
      if( self.createUsetable.uuid ~= "" and self.createUsetable.password ~= "") then        
                  
          self:getParent().dengdaijiazai = lodingwaitlayer.new()
              :pos(0, 0)
              :addTo(self:getParent()) 

          local registerpack 
          registerpack = 
          {
          type = "register",
          uuid = self.createUsetable.uuid,
          pass = crypto.md5(self.createUsetable.password,false),               
          }
          local age = PACK_AGE(registerpack)                 
          self.registerSocket:send(age)
      else
          --todo
        self:createtishi(6)           
      end
    end

    if event.name == "SOCKET_TCP_DATA" then
      --todo
      ---[[
      --print("<==<pack>:"..event.data)
      --local jsonText = string.sub(event.data,3,-1)
      --print("<==",jsonText)
      local fuwuhuifu = READ(event.data)
      for k,v in pairs(fuwuhuifu[1]) do
        print(k,v)
      end
      if fuwuhuifu[1].status == 20  then
        
        --移除加载
        self:getParent():lodingremoveformmain()
        --关闭连接
        self.registerSocket:removeAllEventListeners()
        self.registerSocket:disconnect()

        transition.moveTo(self:getParent().login, {x = self:getParent().login:getPositionX(), y = display.cy, time = 0.5})
        self:getParent().createusebool = false

        ------------------注册成功
        self:getParent().useNameID = self.createUsetable.uuid
        self:getParent().usePassword = self.createUsetable.password
        self:getParent():openloginSocket()  
        --第一次注册用户
        Socketegame._isoneLogin = true
        
        self:getParent():removeChild(self:getParent().dataLayer)
      elseif fuwuhuifu[1].status == 21 then
        --移除加载
        self:getParent():lodingremoveformmain()
        self:createtishi(7)
        self.registerSocket:disconnect()
        -- self.createlodinginfun = 1
        self:performWithDelay(function ()
          self.createlodinginfun = 1
        end, 0.5)
      else
        self:getParent():lodingremoveformmain()
      end
      --self.registerSocket:disconnect()
      --]]--
    end
    if event.name == "SOCKET_TCP_CONNECT_FAILURE" then
      if self.createlodinginfun == 1 then
        self:getParent():lodingremoveformmain()
        self:createtishi(8)
      end     
      print("SOCKET_TCP_CONNECT_FAILURE")
    end 
  --return fun
end

function Gamelayer:createtishi(upormoney)
  -- body
  --print(self.mybankerlayer:getPositionX()/2 + 200 , self.mybankerlayer:getPositionY()/2 + 200)
  local fruittishi = display.newSprite("fruitpic/tishi.png")
        :pos(display.cx  , display.cy )
        :addTo(self,10)
  --禁用取消按钮
  self.cancelinMove = true
  self.number = self.number + 1
  --print("self.number加1",self.number)
  if upormoney == 0 then
    --todo
    display.newTTFLabel(
        { text = "密码长度超过15",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 1 then
    --todo
    display.newTTFLabel(
        { text = "账号长度超过12",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 2 then
    --todo
    display.newTTFLabel(
        { text = "账号过短",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 3 then
    --todo
    display.newTTFLabel(
        { text = "密码过短",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 4 then
    --todo
    display.newTTFLabel(
        { text = "密码不一致",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 5 then
    --todo
    display.newTTFLabel(
        { text = "账号不能含有中文",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 6 then
    --todo
    display.newTTFLabel(
        { text = "账号或密码为空",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 7 then
    --todo
    display.newTTFLabel(
        { text = "抱歉,该账号已存在",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 8 then
    --todo
    display.newTTFLabel(
        { text = "服务器连接失败",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  end

  transition.moveBy(fruittishi, { y = 80, time = 2})
  transition.fadeTo(fruittishi, {opacity = 50, time = 2})
  -- local jiediaodiaodu = schedule.performWithDelayGlobal(function ()
  --               self:removeChild(fruittishi)
  --               --启用取消按钮
  --               self.number = self.number - 1
  --               if self.number == 0 then
  --                 --
  --                 self.cancelinMove = false 
  --               end
                
  --               --print("减1",self.number)               
  --               end , 1)
  self:performWithDelay(function ()
                self:removeChild(fruittishi)             
                end , 1)
end


--字符串检查，和中文检查
function Gamelayer:utfstrlan( input )
  -- body 
  local len  = #input  
  local left = len  
  local cnt  = 0
  local china = 0  
  local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}   
  while left ~= 0 do  
      local tmp = string.byte(input, -left)  
      local i   = #arr  
      while arr[i] do
          if tmp >= 224 and tmp < 239 then
              --todo
              china = china + 1
          end  
          if tmp >= arr[i] then  
              left = left - i  
              break  
          end  
          i = i - 1  
      end  
      cnt = cnt + 1  
  end  
  return cnt,china
end 


return Gamelayer
