

local Roomlayer = require("app.layer.roomlayer")
local gameguizelayer = require("app.layer.gameguize")
local paihangbanglayer = require("app.layer.paihangbang")
local bankeruserlayer = require("app.layer.bankeruser")
local lodingwaitlayer = require("app.layer.lodingwait")
local schedule = require(cc.PACKAGE_NAME .. ".scheduler")
local connectfailurelayer = require("app.layer.connectfailure")
local onlinerewardlayer = require("app.layer.onlinereward")
local relieffundlayer = require("app.layer.relieffund")

local soundsetuplayer = require("app.layer.soundsetup")

local shopinglayer = require("app.layer.shoping")
local turntablelayer = require("app.layer.turntable")

local isoneLoginlayer = require("app.layer.isoneLogin")

local displaypicturelayer = require("app.fruit.displaypicture")
local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)

function GameScene:ctor()
  self.numberconn = 0
  self.dengdaijiazai = nil
   --添加背景
  local addbg = display.newSprite("But/gamebg.png")
      :align(display.LEFT_BOTTOM,0,0)
      :addTo(self)      
   --房间层
   self.createroom = nil
   self.roomtable = false 
   self.roomlayer = false
   --银行
   self.yinhang = nil
   --头像层
   self.createpicture = nil
   local images = {
   normal = "gamescene/playgame.png",
   pressed = "gamescene/playgame1.png",
   disabled = "gamescene/playgame.png"
   }
   self.playgameisMove = false
   local playgame = cc.ui.UIPushButton.new(images,{scale9 = true})
   :setButtonSize(450,150)
   :setButtonLabel("normal",cc.ui.UILabel.new({
      UILabelType = 2,
      text = "",
      size = 18,
      color = cc.c3b(0,0,0)
   }))
   :setButtonLabel("pressed",cc.ui.UILabel.new({
      UILabelType = 2,
      text = "",
      size = 18,
      color = cc.c3b(255,64,64)
   }))
   :setButtonLabel("disabled",cc.ui.UILabel.new({
      UILabelType = 2,
      text = "",
      size = 18 ,
      color = cc.c3b(0,0,0)  
   }))
   :onButtonClicked(function (event)
        if self.playgameisMove then
          return
        end
        self.dengdaijiazai = lodingwaitlayer.new()
                :pos(0, 0)
                :addTo(self)
        self.playgameisMove = true
        --查看房间
        local age = {cmd = "seeRoom"}
        SEND(age)
   end)
   :align(display.LEFT_CENTER,display.cx,display.cy)
   :addTo(self) 


   local cutButton
   self.cutButtonisMove = false
    cutButton = display.newSprite("gamescene/cutButton.png")
        :align(display.CENTER_BOTTOM,self:getContentSize().width - 400, self:getContentSize().height -150 )
        :addTo(self)
    cutButton:setTouchEnabled(true)
    cutButton:setTouchSwallowEnabled(true)
    cutButton:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  self.cutButtonisMove then
            return 
        end
        if event.name == "began" then
          self.cutButtonisMove = true
          self:isornoSwitch()
          local sequence = transition.sequence({
              cc.ScaleTo:create(0.1,0.9,0.9),
              cc.ScaleTo:create(0.2,1.0,1.0),             
          })        
          transition.execute(cutButton,sequence,{
             delay = 0,
             onComplete = function ()            
                  --[[
                  --切换账号流程,客户端请求：
                  local taken = {}
                  taken.type = "lua"
                  taken.session = Session
                  taken.command = "switch"
                  taken.data = ""
                  Session = Session + 1
                  Socketegame:send(PACK_AGE(taken))
                  --无奈之举
                  --重新计时心跳
                  Socketegame._diaoyongSchedule("open")
                  --撤销心跳计时
                  Socketegame._sethendDetectionfunc(function ()

                  end)
                  Socketegame.setonTransmissionAfterEvent(function ()

                  end)
                  if Socketegame._Allschedulehend then
                    schedule.unscheduleGlobal(Socketegame._Allschedulehend)
                    Socketegame._Allschedulehend = nil
                  end
                  if Socketegame._Schedulehend then
                    schedule.unscheduleGlobal(Socketegame._Schedulehend)
                    Socketegame._Schedulehend = nil
                  end
                  --开启心跳发送调用函数
                  NUMBERSendMove = 1
                  --断开服务器连接
                  self:performWithDelay(function ()
                    Socketegame:disconnect()
                    end , 0.2)
                  --Socketegame:disconnect()
                  --排行榜重置
                  Socketegame._daybanglvitem = {}
                  Socketegame._zhongbanglvitem = {}
                  --清空last and Socketdata
                  updatalastandSocketdata()
                  Socketegame._isoneLogin = false

                  --游客false
                  Socketegame._Touristbool = false
                  --停止音乐
                  audio.stopMusic()
                  --回到登录界面
                  local cutmainscene= mainscene.new()
                  display.replaceScene(cutmainscene,"fade",1)
                  ]]--
              end})           
        end
    end)

    local exitButton
    self.exitButtonisMove = false
    exitButton = display.newSprite("gamescene/exitButton.png")
        :align(display.CENTER_BOTTOM,self:getContentSize().width - 100, self:getContentSize().height -150 )
        :addTo(self)
    exitButton:setTouchEnabled(true)
    exitButton:setTouchSwallowEnabled(true)
    exitButton:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  self.exitButtonisMove then
            return 
        end
        if event.name == "began" then
          self.exitButtonisMove = true
          --登出流程,客户端请求：                            
          self:closeprogram()  
          local sequence = transition.sequence({
              cc.ScaleTo:create(0.1,0.9,0.9),
              cc.ScaleTo:create(0.2,1.0,1.0),             
          })        
          transition.execute(exitButton,sequence,{
             delay = 0,
             onComplete = function ()                             
              end})          
        end
    end)

    local setButton
    setButton = display.newSprite("gamescene/setButton.png")
        :align(display.CENTER_BOTTOM,self:getContentSize().width - 250, self:getContentSize().height -150 )
        :addTo(self)
    setButton:setTouchEnabled(true)
    setButton:setTouchSwallowEnabled(true)
    setButton:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if event.name == "began" then
          local soundsetup = soundsetuplayer.new()
                  :pos(0, 0)
                  :addTo(self)
        end
    end)
  

    --[[
    self.qqqqq = display.newTTFLabel(
        { text = "输入账号",
          font = "Arial",
          size = 24,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,display.cx ,display.cy - 100)
        :addTo(self)
    ]]--

    self:setSocketTransmission(self:onStatus())
    --------过年回家
    self.paihang = nil
    self:addmentclassui("gamerule.png",display.width/1.105 - 760,display.height/400 - 20,function ()
      --
      self.guized = gameguizelayer.new()
                  :pos(0, 0)
                  :addTo(self)
    end)
    self:addmentclassui("rankinglist.png",display.width/1.105 - 570,display.height/400 - 20,function ()
      --
      self.paihang = paihangbanglayer.new()
                  :pos(0, 0)
                  :addTo(self)
    end)
    self:addmentclassui("BankofChina.png",display.width/1.105 - 380,display.height/400 - 20,function ()
        --发送银行数据
        local taken = {}
        taken.type = "lua"
        taken.session = Session
        taken.command = "enterBank"
        taken.data = ""
        Session = Session + 1
        Socketegame:send(PACK_AGE(taken))
    end)
    self:addmentclassui("shopping.png",display.width/1.105 - 190,display.height/400 - 20,function ()
      local shoping = shopinglayer.new()
              :pos(0, 0)
              :addTo(self)
      -- local turntable = turntablelayer.new()
      --         :pos(0, 0)
      --         :addTo(self)
    end)
    
    self.dengdaijiazaischedule = nil
    self:addmentclassui("online.png",display.width/1.105,display.height/400 - 20,function () 
        
        self.dengdaijiazai = lodingwaitlayer.new()
                      :pos(0, 0)
                      :addTo(self)
        --发送打开在线奖励数据
        local taken = {}
        taken.type = "lua"
        --print("Session = ",Session)
        taken.session = Session
        taken.command = "showReward"
        taken.data = ""
        Session = Session + 1
        Socketegame:send(PACK_AGE(taken))
        self.dengdaijiazai_time = 1
        self.dengdaijiazaischedule = self:performWithDelay(function ()
              if self.dengdaijiazai_time == 1 then
                  self:lodingremoveformmain()
                  --发送打开在线奖励数据
                  local taken = {}
                  taken.type = "lua"
                  --print("Session = ",Session)
                  taken.session = Session
                  taken.command = "showReward"
                  taken.data = ""
                  Session = Session + 1
                  Socketegame:send(PACK_AGE(taken))
                  self.dengdaijiazai_time = 1
              end
        end, 5)

        -- schedule.unscheduleGlobal(self.dengdaijiazai)
      end)
    
    self.userbg = display.newSprite("But/userng.png")
      :align(display.LEFT_BOTTOM,0,display.height/1.4)
      :addTo(self)
    -- self.userbg:setScale(0.8)
    --添加头像
    -- self.hendpicture = displaypicturelayer.new(Socketegame._diaplaypictrue)
    --           :pos(30, display.top - 60)
    --           :addTo(self)
    self.hendpicture = displaypicturelayer.new(Socketegame._diaplaypictrue)
              :pos(self.userbg:getContentSize().width/7.5, self.userbg:getContentSize().height/4.2)
              :addTo(self.userbg)
    if Socketegame._alms then
      Socketegame._MONEY = Socketegame._MONEY - 20000
    end         
    --------用户信息
    self:createplaycar()

    --上一把存在输赢
    if Socketegame._OffMoney then
      local relieffund = relieffundlayer.new(Socketegame._OffMoney,"上一把游戏异常退出\n该局结果为",3)
              :pos(0, 0)
              :addTo(self)
      Socketegame._OffMoney = nil
    end

    -- 救济金
    if Socketegame._alms then
       Socketegame._alms = false
       local relieffund = relieffundlayer.new(20000,"领取救济金",1)
              :pos(0, 0)
              :addTo(self)
    end
    if Socketegame._almsreturnroom then
      Socketegame._almsreturnroom = false
      local relieffund = relieffundlayer.new(20000,"领取救济金",1)
            :pos(0, 0)
            :addTo(self)
    end

    if Socketegame._isoneLogin then
      self.isoneLogin = isoneLoginlayer.new()
          :pos(0, 0)
          :addTo(self)
    end
    -----添加错误提示
    self:getfailure()
    
    --添加心跳
    Socketegame._sethendDetectionfunc(handler(self,self.henddatec))
    Socketegame.setonTransmissionAfterEvent(handler(self,self.resconnect))
    --发送start
    SendMove()
    if audio.isMusicPlaying() then
      audio.playMusic("Sound/Datingbgm.mp3", true)
    end
    --[[
    local Networkschedule
    Networkschedule = self:schedule(function ()
      if cc.Network:getInternetConnectionStatus() == 0 then
        if self.dengdaijiazai then
         self:lodingremoveformmain()
        end
        if not self.dengdaijiazai then
           self.dengdaijiazai = lodingwaitlayer.new(false,false,true)
                      :pos(0, 0)
                      :addTo(self)
        end
        self:chaoshifun()
        Socketegame._sethendDetectionfunc(function ()
        end)
        transition.removeAction(Networkschedule)
        -- Socketegame._Touristbool = false
      end
      -- transition.removeAction(Networkschedule)
    end,1)
    ]]--
end
---错误信息
---[[
function GameScene:getfailure()
  function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    if Socketegame._Allschedulehend then
      schedule.unscheduleGlobal(Socketegame._Allschedulehend)
      Socketegame._Allschedulehend = nil
    end
    if Socketegame._Schedulehend then
      schedule.unscheduleGlobal(Socketegame._Schedulehend)
      Socketegame._Schedulehend = nil
    end  
    local failure = connectfailurelayer.new(tostring(errorMessage))
                  :pos(0, 0)
                  :addTo(self) 
  end
end
--]]--

--------心跳调用
function GameScene:henddatec(zhiling)
    -- 写入函数
    Socketegame.setonTransmissionAfterEvent(handler(self,self.resconnect))   
    if zhiling == "chaoshi" then
        self:chaoshifun()
        --回到登录界面
        NUMBERSendMove = 1       
        local cutmainscene= mainscene.new()
        display.replaceScene(cutmainscene,"fade",1)
    else
        Socketegame:disconnect()
        
        if self.dengdaijiazai then
           self:lodingremoveformmain()
        end
        if not self.dengdaijiazai then
           self.dengdaijiazai = lodingwaitlayer.new("kk")
                       :pos(0, 0)
                       :addTo(self)
        end
        if self.dengdaijiazaischedule then
          transition.removeAction(self.dengdaijiazaischedule)
          self.dengdaijiazaischedule = nil
        end       
        if self.roomtable then
           self.createroom:removeroomlayer()
        end
        -- print("网络是否可用", cc.Network:getInternetConnectionStatus() )
    end
end


---断线重连
function GameScene:resconnect(event)
    
    if event.name == "SOCKET_TCP_CONNECTED" then
      --连接成功
      self:lodingremoveformmain()
      Socketegame.setonTransmission(Socketegame._onTransmission)
      print("重新连接成功")
      --撤销超时计时
      schedule.unscheduleGlobal(Socketegame._Allschedulehend)
      Socketegame._Allschedulehend = nil

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
      print("发送重新连接握手包") 
    end

    if event.name == "SOCKET_TCP_CONNECT_FAILURE" then
      if not self.dengdaijiazai then
         self.dengdaijiazai = lodingwaitlayer.new()
                       :pos(0, 0)
                       :addTo(self)
      end
      self.numberconn = self.numberconn + 1
      print("第"..self.numberconn.."次,尝试连接")
      Socketegame:connect()
    end
end

----预加载
function GameScene:lodingremoveformmain()
  if self.dengdaijiazai then
    self.dengdaijiazai:removeselfformparent()
    self.dengdaijiazai = nil
  end
end

function GameScene:chaoshifun()
  -- body
  local chaofun
  chaofun = function (event)
    -- body
    if event.name == "SOCKET_TCP_CONNECTED" then

    end
    if event.name == "SOCKET_TCP_DATA" then
              
    end
    if event.name == "SOCKET_TCP_CLOSE" then

    end
    if event.name == "SOCKET_TCP_CLOSED" then

    end
    if event.name == "SOCKET_TCP_CONNECT_FAILURE" then
    end
  end
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_DATA",chaofun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CONNECT_FAILURE",chaofun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CONNECTED",chaofun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CLOSED",chaofun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CLOSE",chaofun)
end

---------------------------------------网络通讯
function GameScene:onStatus()
  -- body
  local fun
  fun = function (event)
    -- body
    if event.name == "SOCKET_TCP_CONNECTED" then
      --todo
      --连接成功
      print("SOCKET_TCP_CONNECTED")
    end
    if event.name == "SOCKET_TCP_DATA" then
      --todo
      print("在大厅层接收消息")
      -- local panduan = SESSRESULT(READ(event.data))
      --如果房间层没有打开
      -- if not self.roomtable then
      local tablenianbaonumber = READ(event.data)
      for i=1,#tablenianbaonumber do
        local panduan = SESSRETABLENO1(tablenianbaonumber[i]) 
        --浏览房间层
        print("在大厅层")
        if panduan.cmd == "openRoom" then
            --打开了房间层
            print("打开了房间层")
            ----开始冷却重置            
            self.playgameisMove = false
            if not self.roomtable then
              self:lodingremoveformmain()
              ----开始冷却重置
              self.roomtable = true
              local temptb = panduan.ss
              self.createroom = Roomlayer.new(temptb)
                              :addTo(self)
              --加载房间层处理函数,包括房间时时更新
              self.createroom.itembool = true
              local fundata = self:setSocketTransmissionroom()
              Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_DATA",fundata)
            end         
        elseif panduan.type == 1 then
            -- print("收到服务器心跳")
            Socketegame._diaoyongSchedule("open")
            --反馈信息 
            SENDHENDBEAT()

        elseif panduan.cmd == "reconnect" then
            local age = {cmd = "heartbeat"}
            SEND(age)
        elseif panduan.cmd == "getDailyRank" then
          if self.paihang then
            self.paihang:removeChildformself()
            -- Socketegame._daybanglvitem = panduan.data
            self.paihang:adddaybanglvitem(panduan.data)
          end
        elseif panduan.cmd == "getTotalyRank" then
          if self.paihang and panduan.data then
            self.paihang:removeChildformself()
            -- Socketegame._zhongbanglvitem = panduan.data
            self.paihang:addzhongbanglvitem(panduan.data)
          end
        elseif panduan.cmd == "createpicture" then 
            self:lodingremoveformmain()
            if panduan.ok == true then
              self.createpicture:removeslef()
              self.hendpicture:uddatapicture(Socketegame._diaplaypictrue)
              self:createtishi(0)
            else
              self:createtishi(1)
            end
        elseif panduan.cmd == "onlinereward" then
          --todo
          if panduan.data == true then
            
            return 
          end
          -- schedule.unscheduleGlobal(self.dengdaijiazaischedule)
          if self.dengdaijiazaischedule then
            transition.removeAction(self.dengdaijiazaischedule)
            self.dengdaijiazaischedule = nil
          end
          self:lodingremoveformmain()
          self.onlinejiangli = onlinerewardlayer.new(panduan.data)
                :pos(0, 0)
                :addTo(self)

        elseif panduan.cmd == "enterBnak" then
          if not panduan.data then
            return
          end
          self.yinhang = bankeruserlayer.new(Socketegame._MONEY,panduan.data)
                    :pos(0, 0)
                    :addTo(self)
        elseif panduan.cmd == "forcedleave" then
          if self.dengdaijiazai then
           self:lodingremoveformmain()
          end
          if not self.dengdaijiazai then
             self.dengdaijiazai = lodingwaitlayer.new(false,true)
                        :pos(0, 0)
                        :addTo(self)
          end                
        elseif panduan.cmd == "setNickname" then
          if Socketegame._isoneLogin then     
            if panduan.data.ok then
              self.isoneLogin:Closenode()
              Socketegame._isoneLogin = false
            else
              self.isoneLogin:Closeshibai()
            end
            return
          end
          if panduan.data.ok then
            self.createpicture:Closenode()
          else
            self.createpicture:Closeshibai()
          end
        elseif panduan.cmd == "setPassword" then
          if panduan.data.status == 50 then
            self.createpicture:removePasswordnode()
          elseif panduan.data.status == 53 then
            self.createpicture:Passwordnodeshibai(11)
          else
            self.createpicture:Passwordnodeshibai(10)
          end 
        elseif panduan.cmd == "saveGold" then
          if panduan.data then
            self.yinhang:bnakermoneyTouserok()
          else
            self.yinhang:createtishi(0)
          end
        elseif panduan.cmd == "withdrawGold" then
          if panduan.data then
            self.yinhang:usergetmoneyformbankerok()
          else
            self.yinhang:createtishi(0)
          end
        elseif panduan.cmd == "changeKey" then
          --银行更改密码
          if panduan.data then
            self.yinhang:callremovenodefun(true)
          else
            self.yinhang:callremovenodefun(false)
          end           
        else

        end 
      end           
    end
    if event.name == "SOCKET_TCP_CLOSE" then
      --断开连接
      -- print("游戏连接即将关闭")
    end
    if event.name == "SOCKET_TCP_CLOSED" then
      print("网络断了？你为什么？？SOCKET_TCP_CLOSED")
    end
    if event.name == "SOCKET_TCP_CONNECT_FAILURE" then
      --todo
      --服务器断开连接,关闭Socket
      --Socketegame:close()
      --Socketegame = nil
      print("游戏连接断开")
    end
  end
  return fun
end


function GameScene:setSocketTransmissionroom()
  local fun
  fun = function (event)
    if event.name == "SOCKET_TCP_DATA" then
      ----------------------------------
      local tablenianbaonumber = READ(event.data)
      --收到消息，
      Socketegame._diaoyongSchedule("open")
      for i=1,#tablenianbaonumber do
        local roomtable = SESSRETABLENO1(tablenianbaonumber[i]) 
        ---------------------------
        -- local roomtable = SESSRESULT(READ(event.data))
        -- print("在房间列表")
        --存储接收数据
        if roomtable.cmd == "closeRoom" then
          --todo
          --如果该房间游戏开始,不给于进入
          -- print("adadadadad")
          self.createroom.itembool = true
          self.createroom:createtishi(0)
          self:lodingremoveformmain() 
        elseif roomtable.cmd == "updateRoom" then
          --更新房间人数个数
          -- if self.createroom.roomnumtext[Socketegame._roomtable.roomnum] then
          --   self.createroom.roomnumtext[Socketegame._roomtable.roomnum]:setString((Socketegame._roomtable.nums).."/20") 
          -- end
          for i,v in ipairs(self.createroom.roomnumtext) do
            if v.roomID == roomtable.roomnum then
              v.roomlab:setString((roomtable.nums).."/20") 
            end
          end
        -- elseif roomtable.status == "readytime" then
        elseif roomtable.status then
          --进入房间
          --设置房间倒计时，-1秒为动画效果
          Socketegame._roomtable.timer = roomtable.timer - 0
          Socketegame._roomtable.banker = roomtable.banker
          --房间存在玩家
          Socketegame._roomtable.Icons = roomtable.usersname
          -- Socketegame._multiplying = roomtable.getProbability
          Socketegame._roomtable.status = roomtable.status 

          if roomtable.fruit then
            Socketegame._roomtable.fruit = roomtable.fruit
          end
          --重新计时心跳
          Socketegame._diaoyongSchedule("open")

          self:lodingremoveformmain() 
          local plaScene= playscene.new()
          display.replaceScene(plaScene,"fade",0)

        elseif roomtable.cmd == "forcedleave" then
          if self.dengdaijiazai then
           self:lodingremoveformmain()
          end
          if not self.dengdaijiazai then
             self.dengdaijiazai = lodingwaitlayer.new(false,true)
                        :pos(0, 0)
                        :addTo(self)
          end       
          if self.roomtable then
             self.createroom:removeroomlayer()
          end 
        elseif roomtable.type == 1 then
            print("收到服务器心跳")
            Socketegame._diaoyongSchedule("open")
            --反馈信息 
            SENDHENDBEAT()
        end
        -- self:lodingremoveformmain()
      end      
    end
  end
  return fun
end

--网络通信
function GameScene:setSocketTransmission(fun)
  print("加载心跳")
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_DATA",fun)
  --Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CONNECT_FAILURE",fun)
  --Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CONNECTED",fun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CLOSED",fun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CLOSE",fun)
end
-----------------------------------------------------------
--头像
function GameScene:createtishi(upormoney)
  -- body
  --print(self.mybankerlayer:getPositionX()/2 + 200 , self.mybankerlayer:getPositionY()/2 + 200)
  local fruittishi = display.newSprite("fruitpic/tishi.png")
        :pos(display.cx  , display.cy )
        :addTo(self,10)

  if upormoney == 0 then
    --todo
    display.newTTFLabel(
        { text = "更换头像成功",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi) 
  elseif upormoney == 1 then
    --todo
    display.newTTFLabel(
        { text = "更换头像失败",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 2 then
    --todo
    display.newTTFLabel(
        { text = "更换名字成功",
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

-------------------------
function GameScene:addmentclassui(cdkey,posx,posy,fun) 
  local fruitaddbase = display.newSprite("But/"..cdkey)
        :align(display.CENTER_BOTTOM,posx,posy)
        :addTo(self)
      --fruitaddbase:setScale(0.5)
  -- local fruitadd = display.newSprite(cdkey)
  --       :align(display.CENTER_BOTTOM,fruitaddbase:getContentSize().width/2,fruitaddbase:getContentSize().height/3)
  --       :addTo(fruitaddbase)
  --       fruitadd:setScale(0.6)
  local isMove = false
  fruitaddbase:setTouchEnabled(true)
  fruitaddbase:setTouchSwallowEnabled(true)
  fruitaddbase:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
    if  isMove then
        return 
    end
    if event.name == "began" then
      isMove = true 
      if fun then
        fun()
      end        
      local sequence = transition.sequence({
          cc.ScaleTo:create(0.05,0.95,0.95),
          cc.ScaleTo:create(0.05,1.01,1.01),             
      })        
      transition.execute(fruitaddbase,sequence,{
                   delay = 0,
                   onComplete = function ()               
                     isMove = false
                     end
                })           
    end
  end)  
end
--------------------------------------
function GameScene:createplaycar()
  --
  print("游戏开始金币",Socketegame._MONEY)
  -- body
  -- self.money = display.newTTFLabel(
  --       { text = "金币:"..(Socketegame._MONEY),
  --         font = "Arial",
  --         size = 24,
  --         align = cc.ui.TEXT_ALIGN_LEFT,
  --         color = cc.c3b(255, 255, 255) })
  --       :align(display.LEFT_CENTER,display.left + 90 ,display.top - 60)
  --       :addTo(self)
  -- self.usenameID = display.newTTFLabel(
  --       { text = "昵称:"..(Socketegame._NICHENG),
  --         font = "Arial",
  --         size = 24,
  --         align = cc.ui.TEXT_ALIGN_LEFT,
  --         color = cc.c3b(255, 255, 255) })
  --       :align(display.LEFT_CENTER,display.left + 90 ,display.top - 30)
  --       :addTo(self)self.userbg
  self.money = display.newTTFLabel(
        { text = (Socketegame._MONEY),
          font = "Arial",
          size = 22,
          align = cc.ui.TEXT_ALIGN_LEFT,
          color = cc.c3b(0, 0, 0) })
        :align(display.LEFT_CENTER,self.userbg:getContentSize().width/2.3 ,self.userbg:getContentSize().height/4.8)
        :addTo(self.userbg)
  self.usenameID = display.newTTFLabel(
        { text = (Socketegame._NICHENG),
          font = "Arial",
          size = 22,
          align = cc.ui.TEXT_ALIGN_LEFT,
          color = cc.c3b(0, 0, 0) })
        :align(display.LEFT_CENTER,self.userbg:getContentSize().width/2.5 ,self.userbg:getContentSize().height/2.3)
        :addTo(self.userbg)
end

function GameScene:updateusenameID(name)
    self.usenameID:setString(name)
end

function GameScene:closeprogram()
  -- self.againuserPassword

    node = display.newNode()
    -----------------------------------------------------------------------  
    local loginmap = display.newSprite("mian/loginbg.png")

    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)
    node:setContentSize(display.width,display.height)
    node:ignoreAnchorPointForPosition(false)                 
    node:setAnchorPoint(cc.p(0.5,0.5))
    node:setPosition(display.cx , display.cy)
    self:addChild(node)
    
    loginmap:setPosition(node:getContentSize().width/2,node:getContentSize().height)
    node:addChild(loginmap)
 
    local tishi = display.newTTFLabel(
        { text = "真的不想玩了？",
          font = "Arial",
          size = 34,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,loginmap:getContentSize().width/2 ,loginmap:getContentSize().height/5 * 4)
        :addTo(loginmap)


    --确定按钮
    local login = {
     normal = "mian/PasswordBox.png",
     pressed = "mian/PasswordBox.png",
    } 
   
    local okButton = cc.ui.UIPushButton.new(login, {scale9 = true})
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
              local taken = {}
              taken.type = "lua"
              --print("Session = ",Session)
              taken.session = Session
              taken.command = "logout"
              taken.data = ""
              Session = Session + 1
              Socketegame:send(PACK_AGE(taken))
              --撤销心跳计时
              -- schedule.unscheduleGlobal(Socketegame._Schedulehend)
              --开启心跳发送调用函数
              -- NUMBERSendMove = 1
              --排行榜重置
              Socketegame._daybanglvitem = {}
              Socketegame._zhongbanglvitem = {}
              --断开服务器连接
              self:performWithDelay(function ()
                Socketegame:disconnect()
                cc.Director:getInstance():endToLua()
                end , 0.2) 
            end)
         :align(display.LEFT_CENTER, loginmap:getContentSize().width/4 - 45 , loginmap:getContentSize().height/5 )
         :addTo(loginmap)


    local cancelButton = cc.ui.UIPushButton.new(login, {scale9 = true})
         :setButtonSize(90,50)
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
            }))
         :onButtonClicked(function ()
           local sequence = transition.sequence({
              cc.ScaleTo:create(0.05,0.9,0.9),
              cc.ScaleTo:create(0.05,1.1,1.1),
              cc.ScaleTo:create(0.05,0.3,0.3),
              })        
              transition.execute(node,sequence,{
                           delay = 0,
                           onComplete = function ()
                              self.exitButtonisMove = false                              
                              node:removeFromParent()
                            end})

              end)
         :align(display.LEFT_CENTER, loginmap:getContentSize().width/4 * 3 - 45, loginmap:getContentSize().height/5 )
         :addTo(loginmap)

         local sequence = transition.sequence({
            cc.MoveTo:create(0.2,cc.p(node:getContentSize().width/2,node:getContentSize().height/2)),
            cc.ScaleTo:create(0.1,0.9,0.9),
            cc.ScaleTo:create(0.1,1.1,1.1),
            cc.ScaleTo:create(0.1,1.0,1.0),
        })        
        transition.execute(loginmap,sequence,{
                     delay = 0,
                     onComplete = function ()

                      end})
end

function GameScene:isornoSwitch()
  -- self.againuserPassword
    node = display.newNode()
    -----------------------------------------------------------------------  
    local loginmap = display.newSprite("mian/loginbg.png")

    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)
    node:setContentSize(display.width,display.height)
    node:ignoreAnchorPointForPosition(false)                 
    node:setAnchorPoint(cc.p(0.5,0.5))
    node:setPosition(display.cx , display.cy)
    self:addChild(node)

    -- local bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
    --                :pos(node:getContentSize().width/2,node:getContentSize().height/2)
    -- bg:ignoreAnchorPointForPosition(false)                 
    -- bg:setAnchorPoint(cc.p(0.5,0.5))
    -- node:addChild(bg)

    loginmap:setPosition(node:getContentSize().width/2,node:getContentSize().height)
    node:addChild(loginmap)
 
    local tishi = display.newTTFLabel(
        { text = "是否切换账号",
          font = "Arial",
          size = 34,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,loginmap:getContentSize().width/2 ,loginmap:getContentSize().height/5 * 4)
        :addTo(loginmap)


    --确定按钮
    local login = {
     normal = "mian/PasswordBox.png",
     pressed = "mian/PasswordBox.png",
    } 
   
    local okButton = cc.ui.UIPushButton.new(login, {scale9 = true})
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
                local taken = {}
                taken.type = "lua"
                taken.session = Session
                taken.command = "switch"
                taken.data = ""
                Session = Session + 1
                Socketegame:send(PACK_AGE(taken))
                --无奈之举
                --重新计时心跳
                Socketegame._diaoyongSchedule("open")
                --撤销心跳计时
                Socketegame._sethendDetectionfunc(function ()

                end)
                Socketegame.setonTransmissionAfterEvent(function ()

                end)
                if Socketegame._Allschedulehend then
                  schedule.unscheduleGlobal(Socketegame._Allschedulehend)
                  Socketegame._Allschedulehend = nil
                end
                if Socketegame._Schedulehend then
                  schedule.unscheduleGlobal(Socketegame._Schedulehend)
                  Socketegame._Schedulehend = nil
                end
                --开启心跳发送调用函数
                NUMBERSendMove = 1
                --断开服务器连接
                self:performWithDelay(function ()
                  Socketegame:disconnect()
                  end , 0.2)
                --Socketegame:disconnect()
                --排行榜重置
                Socketegame._daybanglvitem = {}
                Socketegame._zhongbanglvitem = {}
                --清空last and Socketdata
                updatalastandSocketdata()
                Socketegame._isoneLogin = false

                --游客false
                Socketegame._Touristbool = false
                --停止音乐
                audio.stopMusic()
                --回到登录界面
                local cutmainscene= mainscene.new()
                display.replaceScene(cutmainscene,"fade",1)
            end)
         :align(display.LEFT_CENTER, loginmap:getContentSize().width/4 - 45 , loginmap:getContentSize().height/5 )
         :addTo(loginmap)


    local cancelButton = cc.ui.UIPushButton.new(login, {scale9 = true})
         :setButtonSize(90,50)
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
            }))
         :onButtonClicked(function ()
           local sequence = transition.sequence({
              cc.ScaleTo:create(0.05,0.9,0.9),
              cc.ScaleTo:create(0.05,1.1,1.1),
              cc.ScaleTo:create(0.05,0.3,0.3),
              })        
              transition.execute(node,sequence,{
                           delay = 0,
                           onComplete = function () 
                              self.cutButtonisMove = false                        
                              node:removeFromParent()
                            end})

              end)
         :align(display.LEFT_CENTER, loginmap:getContentSize().width/4 * 3 - 45, loginmap:getContentSize().height/5 )
         :addTo(loginmap)

         local sequence = transition.sequence({
            cc.MoveTo:create(0.2,cc.p(node:getContentSize().width/2,node:getContentSize().height/2) ),
            cc.ScaleTo:create(0.1,0.9,0.9),
            cc.ScaleTo:create(0.1,1.1,1.1),
            cc.ScaleTo:create(0.1,1.0,1.0),
        })        
        transition.execute(loginmap,sequence,{
                     delay = 0,
                     onComplete = function ()

                      end})
end

return GameScene