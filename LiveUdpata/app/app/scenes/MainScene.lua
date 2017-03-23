
local createuselayer = require("app.layer.createuse")
local SocketTCPMain = require("framework.cc.net.SocketTCP")
local lodingwaitlayer = require("app.layer.lodingwait")
--local schedule = require(cc.PACKAGE_NAME .. ".scheduler")
local connectfailurelayer = require("app.layer.connectfailure")

gamescene = require("app.scenes.GameScene")
playscene = require("app.scenes.Playscene")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()

    --注册页面
    self.createusebool = false
    --暂时无用
    self.isfun = false
    --保存有账号密码
    self.gamestateisfun = false
    --用户名,密码
    self.useNameID = ""
    self.usePassword = ""
    --登录冷却
    self.loginbool = true 

    --登录失败
    self.loginfaiure = 1

    self.map = display.newSprite("mian/background.png")
            :pos(display.cx,display.cy)
            :addTo(self)
    
    
    --self.login = nil
    self.dataLayer = nil
    --登录层
    self:createlogin()
    --登陆加载 
    self.dengdaijiazai = nil
    ---------------------------2017/1/13
    --[[
    self.cecece = display.newTTFLabel(
        { text = cc.Network:getInternetConnectionStatus(),
          font = "Arial",
          size = 50,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(10, 10, 10) })
        :align(display.CENTER,display.cx ,display.cy - 200)
        :addTo(self)

    self:schedule(function ()
      if cc.Network:getInternetConnectionStatus() == 0 then   
        self.cecece:setString("断网了")
      end
    end, 1)
    --]]--

    -- audio.preloadMusic("Sound/Datingbgm.mp3")
    -- audio.preloadMusic("Sound/Gamebgm.wav")
    -------------音乐
    if not Socketegame._Music then
      audio.playMusic("Sound/Datingbgm.mp3",true)
      audio.setMusicVolume(0.5)
    end  
    --添加错误信息
    self:getfailure()   
    
end 

---错误信息
---[[
function MainScene:getfailure()
  function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    local failure = connectfailurelayer.new(tostring(errorMessage))
                  :pos(0, 0)
                  :addTo(self) 
  end
end
--]]--
----登录连接
function MainScene:openloginSocket()
  ---------------------------2017/1/16
          --登录服务器
          -- self.loginSocket = SocketTCPMain.new("192.168.80.20",8191,false)
          -- self.loginSocket = SocketTCPMain.new("192.168.80.246",8191,false)
          -- self.loginSocket = SocketTCPMain.new("192.168.83.185",8191,false)        
          self.loginSocket = SocketTCPMain.new("139.199.220.181",8191,false)
          self.loginSocket:addEventListener(SocketTCPMain.EVENT_CONNECTED , handler(self,self.onStatus))
          self.loginSocket:addEventListener(SocketTCPMain.EVENT_CLOSE , handler(self,self.onStatus))
          --网络连接关闭
          self.loginSocket:addEventListener(SocketTCPMain.EVENT_CLOSED, handler(self,self.onStatus))
          --网络连接失败
          self.loginSocket:addEventListener(SocketTCPMain.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))         
          --网络连接，收到消息
          self.loginSocket:addEventListener(SocketTCPMain.EVENT_DATA, handler(self,self.onStatus))         
          self.loginSocket:connect()

          if not Socketegame._Touristbool then
            self.dengdaijiazai = lodingwaitlayer.new()
                  :pos(0, 0)
                  :addTo(self)
          end 
          --self.loginSocket:dumpAllEventListeners()
    --------------------2017/1/16 
end


function MainScene:onStatus(event)
  -- body
  --print("fun")
    -- body
    if event.name == "SOCKET_TCP_CONNECTED" then

      if Socketegame._Touristbool then
        local token = {
          type = "login",
          server = "Hall",
          user = Socketegame._TouristID,
          pass = Socketegame._TouristPassword,
        }
        local package = PACK_AGE(token)
        self.loginSocket:send(package)
        self.loginfaiure = 2
        return 
      end
      --连接成功
      local token = {
          type = "login",
          server = "Hall",
          user = self.useNameID ,
          pass = crypto.md5(self.usePassword, false) ,
        }
      local package = PACK_AGE(token)
      self.loginSocket:send(package)
      self.loginfaiure = 2       
   end

    if event.name == "SOCKET_TCP_DATA" then
      --登录一次
        local TTTTT = READ(event.data)
        Socketegame._SUBID = TTTTT[1].subid
        Socketegame._UID = TTTTT[1].subid
        if TTTTT[1].status == 200 then
          print("登录成功")
          self.loginfaiure = 2
          ----保存密码
          if self.rememberpassword:isButtonSelected() and (not Socketegame._Touristbool) then
              local databaocun = {}
              databaocun.useNameID = self.useNameID
              databaocun.usePassword = self.usePassword
              databaocun.base = 2
              -----------------------------
              databaocun.TouristID = Socketegame._TouristID 
              databaocun.TouristPassword = Socketegame._TouristPassword
              -----------------------------
              gamestate.save(databaocun)          
          end
          self:setSocketTransmission(self:onwangguanStatus())
        elseif TTTTT[1].status == 14 then
          print("账号或密码错误")
          self:lodingremoveformmain()
          self:createtishi(1) 
          self.loginbool = true  
          self.loginfaiure = 1       
        elseif TTTTT[1].status == 406 then
          print("用户已经登录 ")
          self:lodingremoveformmain()
          self:createtishi(2) 
          self.loginbool = true  
          self.loginfaiure = 1
        elseif TTTTT[1].status == 16 then
          self:lodingremoveformmain()
          self:createtishi(6) 
          self.loginbool = true  
          self.loginfaiure = 1   
        elseif TTTTT[1].status == 52 then
          self:lodingremoveformmain()
          self:createtishi(7) 
          self.loginbool = true  
          self.loginfaiure = 1       
        else
          self:lodingremoveformmain()
          -- self:createtishi(4,json.encode(TTTTT[1]))
          self:createtishi(4) 
          self.loginbool = true
          self.loginfaiure = 1
        end
    end
    if event.name == "SOCKET_TCP_CLOSE" then
      --disconnect()
      --断开连接
      --self.loginSocket:disconnect()
    end
    if event.name == "SOCKET_TCP_CONNECT_FAILURE" then
      --
      print("登录连接失败")
      if self.loginfaiure == 1 then
        self:lodingremoveformmain()
        self:createtishi(3)
        self.loginbool = true
      end
      --self:createtishi(3)
      --self.loginSocket:disconnect() 
      print("登录SOCKET_TCP_CONNECT_FAILURE")
    end 
end

function MainScene:lodingremoveformmain()
  if self.dengdaijiazai then
    self.dengdaijiazai:removeselfformparent()
    self.dengdaijiazai = nil
  end
end

----断开连接网关
function MainScene:onwangguanStatus()
  local fun
  fun = function (event)
    if event.name == "SOCKET_TCP_CONNECTED" then
      if Socketegame._Touristbool then
        Socketegame._ID = Socketegame._TouristID
      else
        Socketegame._ID = self.useNameID
      end     
      local tablevales = {}
      tablevales.user = Socketegame._ID
      --print("tablevales.subid",Socketegame._UID)
      tablevales.subid = Socketegame._UID
      tablevales.server = "Hall"
      tablevales.type = "login"
      --print("Session = ",Session)
      tablevales.index = Session
      Session = Session + 1
      Socketegame:send(PACK_AGE(tablevales))
      print("网关连接成功")
    end
    if event.name == "SOCKET_TCP_DATA" then
      --local x = READ(event.data)
      if not self.isfun then 
        local x = READ(event.data)
        print("网关接收")
        self.isfun = true       
        if x[1].status == 200  then
          -- local  token = {         
          --   cmd = "selectUser",
          --  }
          --  SEND(token)
           local  token = {         
            cmd = "goToWhere",
           }
           SEND(token)
        else
          print("网关连接失败")
          self:lodingremoveformmain()
          self:createtishi(4)
          self.loginbool = true
          self.isfun = false
          -- Socketegame:disconnect()
        end
      else
        local panduan = SESSRESULT(READ(event.data))
        print("登录大厅")
        if panduan.cmd == "createUser" then
          --验证是否登录成功，并且进入大厅
          Socketegame._NICHENG = panduan.name
          Socketegame._MONEY = panduan.money
          Socketegame._diaplaypictrue = panduan.photo
          --Socketegame._UID = panduan.uid
          if panduan.alms then
            Socketegame._alms = panduan.alms
          end

          -- Socketegame._alms = panduan.alms
          self:lodingremoveformmain()
          local WinScene= gamescene.new()
          display.replaceScene(WinScene,"fade",0.2)
        elseif panduan.cmd == "gotoHall" then
          local  token = {         
            cmd = "selectUser",
           }
           SEND(token)
           --如果上一把存在输赢的钱
          if panduan.OffMoney then
            Socketegame._OffMoney = panduan.OffMoney
          end 
        elseif panduan.cmd == "gotoRoom" then
          Socketegame._orandbreaklineRunning = true
          --重新回到房间
          Socketegame._NICHENG = panduan.name
          Socketegame._MONEY = panduan.money
          Socketegame._diaplaypictrue = panduan.photo
  
          Socketegame._roomtable.status = panduan.status 
          Socketegame._roomtable.timer = panduan.timer
          Socketegame._roomtable.banker = panduan.banker
          if not Socketegame._roomtable.banker then
            Socketegame._roomtable.banker = {name = "无人上庄",money = 0,bankerLine = 0}
          end
          -------------玩家列表
          Socketegame._roomtable.Icons = panduan.usersname
          if panduan.bankerqueuepos then
            Socketegame._roomtable.bankerqueuepos = panduan.bankerqueuepos
          end
          if panduan.fruit then
            Socketegame._roomtable.fruit = panduan.fruit
          end

          if panduan.betstb then
            Socketegame._betstb = panduan.betstb
          end
          ------下注上限
          if panduan.betupmoney then
            Socketegame._betupmoney = panduan.betupmoney
          end          
          --如果保存上一把的成绩
          if panduan.score then
              Socketegame._score = panduan.score
          end
          --如果上一把存在所有人的下注信息
          if panduan.allusersbettb then
            Socketegame._Allbetstb = panduan.allusersbettb
          end
          local plaScene= playscene.new()
          display.replaceScene(plaScene,"fade",0)
        end   
      end
    end
    if event.name == "SOCKET_TCP_CLOSE" then

    end
    if event.name == "SOCKET_TCP_CONNECT_FAILURE" then
      if self.loginfaiure == 2 then
        self.loginbool = true
        self.loginfaiure = 1
        self:createtishi(4)
        self:lodingremoveformmain()  
      end
      print("CONNECT_FAILURE wangguan")
    end
  end
  return fun
end

--网络通信
function MainScene:setSocketTransmission(fun)
  -- body
  print("网关SocketTransmission")
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_DATA",fun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CONNECT_FAILURE",fun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CONNECTED",fun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CLOSED",fun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CLOSE",fun)

  Socketegame:connect()
  --断开登陆
  self.loginSocket:disconnect() 
end

---------------------------------上：网络
function MainScene:createlogin()
	-- body
	--登录层
	--self.login = nil
    local loginlayer = cc.LayerColor:create(cc.c4b(255,255,255,255),400,300)
                  :pos(display.cx,display.cy)
    loginlayer:ignoreAnchorPointForPosition(false)
    loginlayer:setAnchorPoint(cc.p(0.5,0.5))  
    loginlayer:setOpacity(0)
    --self:addChild(loginlayer,1)

    local usename = display.newScale9Sprite("mian/PasswordBox1.png")
    local ediUsernameBox 
    ediUsernameBox = cc.ui.UIInput.new({
        -- UIInputType = 2,
        image = usename,
        size = cc.size(400, 70),
        -- maxLength = 12,
        x = loginlayer:getContentSize().width/2,
        y = loginlayer:getContentSize().height/4 *3.5,
        ---[[
        listener = function (event)
            if event == "began" then
                
            elseif event == "ended" then
             
            elseif event == "return" then
              --self.useNameID = ediUsernameBox
            elseif event == "changed" then
              if #ediUsernameBox:getText() >=12 then
                ediUsernameBox:setText(string.sub(ediUsernameBox:getText(),1,12))
              end
            end
          end
          --]]--
       })
    -- ediUsernameBox:setPlaceHolder("账号")
    ediUsernameBox:setFontColor(cc.c4b(80,80,80,255))
    ediUsernameBox:setFontName("MarkerFelt.ttf")
    ediUsernameBox:setFontSize(36)
    ediUsernameBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    ediUsernameBox:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    -- ediUsernameBox:setMaxLengthEnabled(true)
    ediUsernameBox:setMaxLength(12)  
    loginlayer:addChild(ediUsernameBox)

    

    local loginmapuser = display.newSprite("mian/circle-login-user.png")
            :pos(ediUsernameBox:getPositionX() - ediUsernameBox:getContentSize().width/2 - 55,ediUsernameBox:getPositionY())
            :addTo(loginlayer)
    


    local usePassword = display.newScale9Sprite("mian/PasswordBox1.png")
    local ediUserPasswordBox 
    ediUserPasswordBox = cc.ui.UIInput.new({
        --UIInputType = 2,
        image = usePassword,
        size = cc.size(400,70),
        --maxLength = 14,
        x = loginlayer:getContentSize().width/2,
        y = loginlayer:getContentSize().height/4 *2.4,
        listener = function (event)
        	-- body
          if event == "began" then
                
          elseif event == "ended" then
             
          elseif event == "return" then
            --self.usePassword =  ediUserPasswordBox
          elseif event == "changed" then

          end
        end,
       })
    -- ediUserPasswordBox:setPlaceHolder("密码")
    ediUserPasswordBox:setFontColor(cc.c4b(80,80,80,255))
    ediUserPasswordBox:setInputFlag(0)
    ediUserPasswordBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    ediUserPasswordBox:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    ediUserPasswordBox:setMaxLength(25) 
    -- ediUserPasswordBox:setPosition(loginlayer:getContentSize().width/2, loginlayer:getContentSize().height/4 *2.4)  
    loginlayer:addChild(ediUserPasswordBox)
    
    local loginmapform = display.newSprite("mian/circle-login-form.png")
            :pos(ediUserPasswordBox:getPositionX() - ediUserPasswordBox:getContentSize().width/2 - 55,ediUserPasswordBox:getPositionY())
            :addTo(loginlayer)

    --记住密码
    local BUTTON2_IMAGES = {
        off = "mian/CheckBoxButton2Off.png",
        on = "mian/CheckBoxButton2On.png",
    }
    self.rememberpassword = cc.ui.UICheckBoxButton.new(BUTTON2_IMAGES)
        :setButtonLabel(cc.ui.UILabel.new({text = "记住密码", size = 28,  color = display.COLOR_WHITE}))
        :setButtonLabelOffset(25, 0)
        :setButtonLabelAlignment(display.LEFT_CENTER)
        :onButtonStateChanged(function (event)
            if event.state == "on" and not self.gamestateisfun then
                local databaocun = {}
                databaocun.useNameID = ediUsernameBox:getText()
                databaocun.usePassword = ediUserPasswordBox:getText()
                -- databaocun.usePassword = crypto.md5(ediUserPasswordBox:getText(), false)
                databaocun.base = 2
                if( databaocun.useNameID ~= "" and databaocun.usePassword ~= "") then
                  databaocun.TouristID = Socketegame._TouristID 
                  databaocun.TouristPassword = Socketegame._TouristPassword        
                  gamestate.save(databaocun)          
                end
            elseif event.state == "off" then
                --ediUsernameBox:setText("")
                --ediUserPasswordBox:setText("")
            end           
        end)
        :align(display.LEFT_CENTER, loginlayer:getContentSize().width/5, loginlayer:getContentSize().height/4 + 25)
        :addTo(loginlayer)

    local loginbgt = display.newSprite("mian/loginbgt.png")
            --:pos(ediUserPasswordBox:getPositionX() - ediUserPasswordBox:getContentSize().width/2 - 45,ediUserPasswordBox:getPositionY())
            :align(display.CENTER, 200 , 10)
            :addTo(loginlayer)

    --登录按钮
    local login = {
     normal = "mian/loginnormal.png",
     pressed = "mian/loginpressed.png",
     disabled = "mian/loginnormal.png",
    }
    local loginButton = cc.ui.UIPushButton.new(login, {scale9 = true})
             :setButtonSize(160,60)
             :setButtonLabel("normal", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 28,
             	  }))
             :setButtonLabel("pressed", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 28,
                  color = cc.c3b(255,64,64),
             	  }))
             :setButtonLabel("disabled", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 28,
                  color = cc.c3b(0,0,0),
             	  }))
             :onButtonClicked(function ()
             	    --
                  if self.loginbool then
                      --print("登陆按钮")
                      self.useNameID = ediUsernameBox:getText()
                      self.usePassword = ediUserPasswordBox:getText()
                      -- self.usePassword = crypto.md5(ediUserPasswordBox:getText(), false)
                      self.loginbool = false
                      if( self.useNameID ~= "" and self.usePassword ~= "") then        
                        --打开连接
                        print("打开登录连接")
                        self:openloginSocket()           
                      else
                        --todo
                        self:createtishi(0)
                        self.loginbool = true           
                      end
                  end  
                end)
             -- :align(display.LEFT_CENTER, loginlayer:getContentSize().width/5 -50, loginlayer:getContentSize().height/6 )
             :align(display.CENTER, 200 , 10)
             :addTo(loginlayer)


    local sign = {
     normal = "mian/regnormal.png",
     pressed = "mian/regpressed.png",
     disabled = "mian/regnormal.png",
    }
    --注册按钮    
    local signButton = cc.ui.UIPushButton.new(sign, {scale9 = true})
         :setButtonSize(160,60)
         :setButtonLabel("normal", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "",
              size = 28,
         	  }))
         :setButtonLabel("pressed", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "",
              size = 28,
              color = cc.c3b(255,64,64),
         	  }))
         :setButtonLabel("disabled", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "",
              size = 28,
              color = cc.c3b(0,0,0),
         	  }))
         :onButtonClicked(function ()
           	  if self.createusebool == false then
           	  	--todo        	  	
           	  	self.dataLayer=createuselayer.new(5000)
                              :addTo(self)
                self.createusebool = true
                --transition.fadeTo(self.login, {opacity = 0, time = 1.5})
                transition.moveTo(self.login, {x = self.login:getPositionX(), y = display.height+300, time = 0.2})
           	  end         	  
            end)
         -- :align(display.LEFT_CENTER, loginlayer:getContentSize().width/2 - 45, loginlayer:getContentSize().height/6 )
         :align(display.CENTER, 450 , 10)
         :addTo(loginlayer)
    
    local qut = {
     normal = "mian/qutnormal.png",
     pressed = "mian/qutpressed.png",
     disabled = "mian/qutnormal.png",
    }
    --退出按钮    
    local qutButton = cc.ui.UIPushButton.new(qut, {scale9 = true})
         :setButtonSize(160,60)
         :setButtonLabel("normal", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "",
              size = 28,
         	  }))
         :setButtonLabel("pressed", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "",
              size = 28,
              color = cc.c3b(255,64,64),
         	  }))
         :setButtonLabel("disabled", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "",
              size = 28,
              color = cc.c3b(0,0,0),
         	  }))
         :onButtonClicked(function ()
              self:performWithDelay(function ()
                cc.Director:getInstance():endToLua()
                end , 0.2) 
               	--Socketegame._diaoyongSchedule("open")
                -- local  token = {         
                --   cmd = "selectUser",
                --  }
                --  self.loginSocket:send(PACK_AGE(token))
                --[[
                local data_c2s = {
                  session = self.cesss,
                  command = "start",
                }               
                print(json.encode(data_c2s))
                Socketegame:send(string.pack(">P",json.encode(data_c2s)))
                self.cesss = self.cesss +1
                ]]--
              end)
         --:align(display.LEFT_CENTER, loginlayer:getContentSize().width/5 *4 -45, loginlayer:getContentSize().height/6 )
         :align(display.CENTER, loginlayer:getContentSize().width*1.4 , loginlayer:getContentSize().height * 1.2)
         :addTo(loginlayer)
    --return loginlayer

    -----获取保存的密码
    local temp = gamestate.load() or {}
    if temp.base == 2 then
      self.gamestateisfun = true
      self.rememberpassword:setButtonSelected(true)
      ediUsernameBox:setText(temp.useNameID)
      ediUserPasswordBox:setText(temp.usePassword)
    end
    if temp.TouristID and temp.TouristPassword then
      Socketegame._TouristID = temp.TouristID
      Socketegame._TouristPassword = temp.TouristPassword
    end

    --[[
    local Touristtemp = Touristtate.load() or {}
    if Touristtemp.TouristID and Touristtemp.TouristPassword then
      Socketegame._TouristID = Touristtemp.TouristID
      Socketegame._TouristPassword = Touristtemp.TouristPassword
    end
    ]]--
    ------------------------------------------------游客
    local Tourist = {
     normal = "mian/normal.png",
     pressed = "mian/pressed.png",
     disabled = "mian/normal.png",
    }
    local fnum = 0
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local TouristButton = cc.ui.UIPushButton.new(Tourist, {scale9 = true})
             :setButtonSize(160,60)
             :onButtonClicked(function ()
                if Socketegame._TouristID ~= "" and Socketegame._TouristPassword ~= "" then
                  Socketegame._Touristbool = true
                  -- Socketegame._isoneLogin = true
                  self.dengdaijiazai = lodingwaitlayer.new()
                                    :pos(0, 0)
                                    :addTo(self)
                  self:openloginSocket()
                else
                  for i=0,math.random(4, 6) do
                     fnum = fnum + (math.random(0, 5))*(10^i)
                  end
                  Socketegame._TouristID = "YK"..fnum
                  Socketegame._TouristPassword = crypto.md5("123456",false)
                  fnum = 0
                  --[[--
                  local databaocun = {}
                  databaocun.TouristID = Socketegame._TouristID 
                  databaocun.TouristPassword = Socketegame._TouristPassword
                  databaocun.useNameID = self.useNameID
                  databaocun.usePassword = self.usePassword
                  if self.useNameID == "" and self.usePassword == "" then
                    databaocun.base = 1
                  else
                    databaocun.base = 2
                  end                  
                  ------------------
                  gamestate.save(databaocun)
                  --------------------------------------
                  Socketegame._Touristbool = true
                  ]]--
                  self.dengdaijiazai = lodingwaitlayer.new()
                                    :pos(0, 0)
                                    :addTo(self)
                  self:createTourist()                     
                end
              end)
             :align(display.CENTER, -50 , 10)
             :addTo(loginlayer)
    ------------------------------------------------------------------------
    self.login = loginlayer
               :addTo(self)
end

-----游客注册
function MainScene:TouristonStatus(event)
  if event.name == "SOCKET_TCP_CONNECTED" then
    local registerpack 
    registerpack = 
    {
    type = "register",
    uuid = Socketegame._TouristID,
    pass = Socketegame._TouristPassword,               
    }
    local age = PACK_AGE(registerpack)                 
    self.registerSocket:send(age)
  end
  if event.name == "SOCKET_TCP_DATA" then
    local fuwuhuifu = READ(event.data)
      if fuwuhuifu[1].status == 20  then        
      --关闭连接
      self.registerSocket:removeAllEventListeners()
      self.registerSocket:disconnect()
      self.registerSocket = nil
      --第一次注册用户
      Socketegame._isoneLogin = true

      local databaocun = {}
      databaocun.TouristID = Socketegame._TouristID 
      databaocun.TouristPassword = Socketegame._TouristPassword
      databaocun.useNameID = self.useNameID
      databaocun.usePassword = self.usePassword
      if self.useNameID == "" and self.usePassword == "" then
        databaocun.base = 1
      else
        databaocun.base = 2
      end                  
      ------------------
      gamestate.save(databaocun)
      --------------------------------------
      Socketegame._Touristbool = true

      self:openloginSocket()

    elseif fuwuhuifu[1].status == 21 then
      --移除加载
      self:lodingremoveformmain()
      self.registerSocket:disconnect()
    else
      self:lodingremoveformmain()
    end
  end
  if event.name == "SOCKET_TCP_CONNECT_FAILURE" then
      self:lodingremoveformmain()
      Socketegame._TouristID = ""
      Socketegame._TouristPassword = ""
      print("游客注册失败")
  end
end
function MainScene:createTourist()
    -- self.registerSocket = SocketTCPMain.new("192.168.80.246",8190,false)
    -- self.registerSocket = SocketTCPMain.new("192.168.83.185",8190,false)
    -- self.registerSocket = SocketTCPMain.new("192.168.80.20",8190,false)
    self.registerSocket = SocketTCPMain.new("139.199.220.181",8190,false)          
    self.registerSocket:addEventListener(SocketTCPMain.EVENT_CONNECTED,handler(self,self.TouristonStatus))
    --网络连接失败
    self.registerSocket:addEventListener(SocketTCPMain.EVENT_CONNECT_FAILURE, handler(self,self.TouristonStatus))          
    --网络连接，收到消息
    self.registerSocket:addEventListener(SocketTCPMain.EVENT_DATA, handler(self,self.TouristonStatus))
    self.registerSocket:connect()   
end
-------------------------

function MainScene:createtishi(upormoney , temp)
  -- body
  --print(self.mybankerlayer:getPositionX()/2 + 200 , self.mybankerlayer:getPositionY()/2 + 200)
  local fruittishi = display.newSprite("fruitpic/tishi.png")
        :pos(display.cx  , display.cy )
        :addTo(self,10)
  -- if not temp then
  --   temp = ""
  -- end
  if upormoney == 0 then
    --todo
    display.newTTFLabel(
        { text = "账号密码为空",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 1 then
    display.newTTFLabel(
        { text = "账号或密码错误",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 2 then
    display.newTTFLabel(
        { text = "该账号已登陆",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 4 then
    display.newTTFLabel(
        { text = "登录失败:",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 3 then
    display.newTTFLabel(
        { text = "服务器连接失败",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 5 then
    display.newTTFLabel(
        { text = "用户已经登录",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 6 then
    display.newTTFLabel(
        { text = "服务器维护",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 7 then
    display.newTTFLabel(
        { text = "服务器发生错误",
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
                end , 2)

end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
