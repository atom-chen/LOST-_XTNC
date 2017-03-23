
--Playscene 游戏场景

local bankerlayer = require("app.play.mybankerlayer")
local gameviewlayer = require("app.play.gameviewlayer")
local chiplayer = require("app.play.playchiplayer")
local usercard = require("app.play.userbettishi")
local schedule = require(cc.PACKAGE_NAME .. ".scheduler")
local connectfailurelayer = require("app.layer.connectfailure")

local soundsetuplayer = require("app.layer.soundsetup")
local historyprobabilitylayer = require("app.play.historyprobability")
local multiplyingpromptlayer = require("app.play.multiplyingprompt")

local helplayer = require("app.play.Help")

local userIconslayer = require("app.play.userIcons")

local lodingwaitlayer = require("app.layer.lodingwait")
--测试
local luckylayer = require("app.play.openrecord")

local Playscene = class("Playscene", function()
    return display.newScene("Playscene")
end)

function Playscene:ctor()
    
    ---消息存放历史记录
    self.myuserCardbool = false
    self.openrecord = nil
    --下注消息存放
    self.myuserCard = {}
    --结算表
    self.fruitclear  = nil
    
    --鬼知道你是干什么的了
    self.openMove = false
    --服务器发送的水果
    self.fruitfuwuqi = nil 

    --庄家
    self.scenebanker = {name = "", money = 0 ,term = 0}

    --倒计时计时器
    self.runingtimeSchedule = nil

    --添加背景
    local addbg = display.newSprite("bg4.png")
          :align(display.LEFT_BOTTOM,0,0)
          :addTo(self,-2)
          
    --初始化，无人上庄 或者当前有庄家
    if Socketegame._roomtable.banker then
      --
      self.mybanker = bankerlayer.new(Socketegame._roomtable)
                :addTo(self) 
      --场景局部变量
      self.scenebanker.name = Socketegame._roomtable.banker.name
      self.scenebanker.money = Socketegame._roomtable.banker.money
      self.scenebanker.bankerLine = Socketegame._roomtable.banker.bankerLine
    else
      self.mybanker = bankerlayer.new({banker = {name = "无人上庄",money = 0,bankerLine = 0}})
                :addTo(self) 
    end
    
    self.mychip = chiplayer.new()
                :addTo(self)

    self.gameview = gameviewlayer.new()
                :addTo(self)

    --for k,v in pairs(Socketegame._roomtable) do
    --  print(k,v)
    --end

    --网络段,预加载准备时间
    if Socketegame._orandbreaklineRunning then
      --重新进入
      self:PrepareCountdown(Socketegame._roomtable.timer,Socketegame._roomtable.status)
      ---保存的成绩
      if Socketegame._score then
        self.gameview.playshow:setscore(Socketegame._score)
      end
      ---重新开启心跳
      SendMove()
      if Socketegame._roomtable.status == "readytime" then
        self:RunningCountdown(Socketegame._roomtable.timer)             
      elseif Socketegame._roomtable.status == "bettime" then
        --如果是下注时间
        self:breaklineRunning(Socketegame._roomtable.timer)
        if Socketegame._betstb then
          for i,v in ipairs(self.gameview.xiazhu) do
            v:BnakeraddEnergy(Socketegame._betstb[i])
          end
          Socketegame._betstb = nil
          -- Socketegame._Allbetstbself.gameview.xiazhu[fuwukaijiang.fruit]:BnakeraddEnergy(fuwukaijiang.money)
        end
        if Socketegame._Allbetstb then
          for i,v in ipairs(self.gameview.xiazhu) do
            v:setAllmoney(Socketegame._Allbetstb[i])
          end
          Socketegame._Allbetstb = nil
        end
        if Socketegame._roomtable.fruit then
          self.fruitfuwuqi = Socketegame._roomtable.fruit
        end
        
        if Socketegame._betupmoney then
          --庄家承受能力
          --设置下注上限
          self.gameview:setbetupmoney(Socketegame._betupmoney)
          for _,v in ipairs(self.gameview.xiazhu) do
            v:offToucho(true)
          end
        end

      elseif Socketegame._roomtable.status == "playgame" then
          ---上下庄按钮的限制-----------------------------
          ---[[
          self.openMove = true
          --下注时间 不能上下庄
          self.mybanker.gameplay = true
          --不能下庄了
          self.mybanker.offTouth = false
          --]]--
          -- self.openMove = true
          ------------------------------------------------
          if Socketegame._betstb then
            for i,v in ipairs(self.gameview.xiazhu) do
              v:BnakeraddEnergy(Socketegame._betstb[i])
            end
            Socketegame._betstb = nil
          end
          if Socketegame._Allbetstb then
          for i,v in ipairs(self.gameview.xiazhu) do
              v:setAllmoney(Socketegame._Allbetstb[i])
            end
            Socketegame._Allbetstb = nil
          end
          if Socketegame._roomtable.fruit then
            self.fruitfuwuqi = Socketegame._roomtable.fruit
          end
          self.Preparetime:setString(0)
          -- 剩余转盘时间
          local time
          if Socketegame._roomtable.timer < 0 and Socketegame._roomtable.timer > -10 then
            time = 10 + Socketegame._roomtable.timer
            --根据从服务器接收到的水果，开始转盘
            self.gameview:setopenkaijiang(self.fruitfuwuqi ,time, (3 + math.round(time/2)) )
            --当前开奖水果设置为空
            self.fruitfuwuqi = nil
          elseif Socketegame._roomtable.timer >= 0 then
            time = 10
            --根据从服务器接收到的水果，开始转盘
            self.gameview:setopenkaijiang(self.fruitfuwuqi ,time, (3 + math.round(time/2)) )
            --当前开奖水果设置为空
            self.fruitfuwuqi = nil
          else
            time = 20 + Socketegame._roomtable.timer
            --直接结算
            self.gameview:aginaplaygame(self.fruitfuwuqi , (4 + math.round(time/2) ) )
          end                   
      end

      if Socketegame._roomtable.bankerqueuepos then
        --如果在队列
        self.gameview.playshow:addline()
        self.gameview.playshow:setplaybankerLine(Socketegame._roomtable.bankerqueuepos)
        self.mybanker:bankerQueue()
        --处在队列中
        self.mybanker.boolKamishoqueue = true
      end
      if Socketegame._roomtable.banker.name == Socketegame._NICHENG then
        --如果自己是庄家   
        self.mybanker:bankerQueue()
        --处在队列中
        self.mybanker.boolKamishoqueue = true
        self.gameview.playshow:addline()
        self.mybanker:updatemychildbanker(true)
      end
      Socketegame._orandbreaklineRunning = false
    else      
      --正常进入
      if Socketegame._roomtable.status == "bettime" then
        --重新进入
        self:PrepareCountdown(Socketegame._roomtable.timer,Socketegame._roomtable.status)
        --下注时间
        self:breaklineRunning(Socketegame._roomtable.timer,true)
      else
        --显示倒计时
        self:PrepareCountdown(Socketegame._roomtable.timer)
        --准备，开启倒计时
        self:RunningCountdown(Socketegame._roomtable.timer)
      end  
    end


   
    self:setSocketTransmission(self:onStatus())
    --退出 切换账号 设置按钮
    local login = {
         normal = "But/playgamecutnor.png",
         pressed = "But/playgamecutpress.png",
         disabled = "But/playgamecutnor.png",
        }
    self.cutisMOveBut = false
    local cutButton = cc.ui.UIPushButton.new(login, {scale9 = true})
             :setButtonSize(110,80)
             :setButtonLabel("normal", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "返回",
                  size = 38,
                  color = cc.c3b(0,0,0),
                  }))
             :setButtonLabel("pressed", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "返回",
                  size = 38,
                  color = cc.c3b(0,0,0),
                  }))
             :setButtonLabel("disabled", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "返回",
                  size = 38,
                  color = cc.c3b(0,0,0),
                  }))
             :onButtonClicked(function (event)
                    if self.openMove then
                      self:Confirmexit()
                      return 
                    end
                    if self.cutisMOveBut then
                      return
                    end
                    if event.name == "CLICKED_EVENT" then
                      self.cutisMOveBut = true
                      --发送退出请求
                      local  token = {cmd = "exitRoom"}
                      SEND(token)
                      ----------------------------------------------
                      --[[
                      Socketegame._multiplying = nil
                      Socketegame._orandbreaklineRunning = false
                      --关闭倒计时计时器
                      if self.runingtimeSchedule then
                        transition.removeAction(self.runingtimeSchedule)
                        self.runingtimeSchedule = nil
                      end
                      --重新计时心跳
                      Socketegame._diaoyongSchedule("open")         
                      local cutgamescene= gamescene.new()
                      display.replaceScene(cutgamescene,"fade",0)
                      ]]--
                    end
                  end)            
             :align(display.CENTER, display.left+55, display.top - 55 )
             :addTo(self)    
    ----------------------------------------------------
    self.addprobability = display.newSprite("But/playgamecutnor.png")
          :align(display.CENTER,display.right - 70,display.cy/1.4)
          :addTo(self)

    local spritetext1 = display.newTTFLabel(
        { text = "展开玩家们",
          --font = "MarkerFelt",
          size = 24,
          align = cc.TEXT_ALIGNMENT_RIGHT,
          color = cc.c3b(0,0,0) })      
        --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
        :align(display.CENTER,self.addprobability:getContentSize().width/2, self.addprobability:getContentSize().height/20)
    self.addprobability:addChild(spritetext1)

    self.probabilitynumber = display.newTTFLabel(
        { text = "1",
          --font = "MarkerFelt",
          size = 24,
          align = cc.TEXT_ALIGNMENT_RIGHT,
          color = cc.c3b(0,0,0) })      
        --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
        :align(display.CENTER,self.addprobability:getContentSize().width/2, self.addprobability:getContentSize().height/1.6)
    self.addprobability:addChild(self.probabilitynumber)

    self.probabilitymove = false
    self.addprobability:setTouchEnabled(true)
    self.addprobability:setTouchSwallowEnabled(true)
    self.addprobability:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)       
        if  self.probabilitymove then
                 print(" kai da le ")
                 return 
               end
        if event.name == "began" then
          self.probabilitymove = true 

          local  token = {         
                  cmd = "getAllUsers",
                }
              SEND(token)
          -- local addprobabilitysequence = transition.sequence({
          --       cc.ScaleTo:create(0.1,0.90,0.90),
          --       cc.ScaleTo:create(0.1,1.05,1.05),             
          --   })
          -- transition.execute(addprobability,addprobabilitysequence,{
          --              delay = 0.1,
          --              onComplete = function ()                    
          --                 local openmoneylayer = historyprobabilitylayer.new(455)
          --                               :pos(0, 0)
          --                               :addTo(self) 
          --                 self.probabilitymove = false
          --                end
          --             })
        end
      end)

    self.openmultiplying = false
    self.addmultiplying = display.newSprite("banker/addmultiplying.png")
          :align(display.TOP_CENTER,display.width * 0.24,display.bottom + 45)
          :addTo(self) 
    --仅仅发送一次请求
    local onenNo = 1
    self.multiplyingmove = false
    --收到数据了吗？
    self.succeedmultiplying = false
    self.addmultiplying :setTouchEnabled(true)
    self.addmultiplying:setTouchSwallowEnabled(true)
    self.addmultiplying:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)       
        if  self.multiplyingmove then
          print(" kai da le ")
          return 
        end
        if event.name == "began" then
          self.multiplyingmove = true
          -- -- 打开了概率
          -- self.openmultiplying = true
          if onenNo == 1 then
            local  token = {         
                  cmd = "getProbability",
                }
              SEND(token)
            onenNo = 2
            self:performWithDelay(function ()
              if not self.succeedmultiplying then
                onenNo = 1 
                self.multiplyingmove = false
              end
            end, 5)
          else
          -- elseif Socketegame._multiplying then
            self.openmultiplying = true
            local addmultiplyingsequence = transition.sequence({
                  cc.MoveBy:create(0.1, cc.p(0, -50))             
              })
              transition.execute(self.addmultiplying,addmultiplyingsequence,{
                           delay = 0.1,
                           onComplete = function ()                    
                              self.multiplyinglayer = multiplyingpromptlayer.new(Socketegame._multiplying)
                                          :pos(0, 0)
                                          :addTo(self) 
                              self.multiplyingmove = false
                             end
                          })
          end                                                     
        end
      end)
    
    --设置
    local setupButton = cc.ui.UIPushButton.new(login, {scale9 = true})
       :setButtonSize(110,60)
       :setButtonLabel("normal", cc.ui.UILabel.new({
            UILabelType = 2 ,
            text = "设置",
            size = 28,
            color = cc.c3b(0,0,0),
            }))
       :setButtonLabel("pressed", cc.ui.UILabel.new({
            UILabelType = 2 ,
            text = "设置",
            size = 28,
            color = cc.c3b(0,0,0),
            }))
       :setButtonLabel("disabled", cc.ui.UILabel.new({
            UILabelType = 2 ,
            text = "设置",
            size = 28,
            color = cc.c3b(0,0,0),
            }))
       :onButtonClicked(function (event)
              if event.name == "CLICKED_EVENT" then
                local soundsetup = soundsetuplayer.new(true)
                    :pos(0, 0)
                    :addTo(self)
              end
            end)            
       :align(display.CENTER, display.left+55, display.top - 255 )
       :addTo(self) 

    --帮助
    local helpbut
    helpbut = display.newSprite("But/pklord_game_help_n.png")
          :align(display.TOP_CENTER,display.left + 50, display.height/2.6)
    helpbut:setTouchEnabled(true)
    helpbut:setTouchSwallowEnabled(true)
    helpbut:ignoreAnchorPointForPosition(false)                 
    helpbut:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(helpbut)
    helpbut:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)       
        if event.name == "began" then              
          local help = helplayer.new()
                      :pos(0, 0)
                      :addTo(self) 
        end
      end)
    
    local helpbutanimation = transition.sequence({
      cc.ScaleTo:create(2,0.9,0.9),
      cc.ScaleTo:create(0.7,1.0,1.0),
    }) 
    local action = cc.RepeatForever:create(helpbutanimation)
    helpbut:runAction(action)

    -----------------------------玩家动态
    self.userIcons = userIconslayer.new(Socketegame._roomtable.Icons)
                  :pos(0, 0)
                  :addTo(self)
    self.probabilitynumber:setString(#Socketegame._roomtable.Icons)
    -----------------------------
    self:addLuckyfruit()

    --添加错误信息
    self:getfailure()
    
    --添加心跳
    Socketegame._sethendDetectionfunc(handler(self,self.henddatec))

    ------------------------音乐
    if audio.isMusicPlaying() then
      audio.playMusic("Sound/Gamebgm.wav")
    end 
    --异常断网
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
      end
      -- transition.removeAction(Networkschedule)
    end,1)
    --]]--
end

---错误信息
---[[
function Playscene:getfailure()
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

------心跳和断线重新连接
--------心跳调用
function Playscene:henddatec(zhiling)
    print("游戏层中断线了")
    ----------------------------------------------
    --关闭倒计时计时器
    if self.runingtimeSchedule then
      transition.removeAction(self.runingtimeSchedule)
      self.runingtimeSchedule = nil
    end
    -- if zhiling == "chaoshi" then
        -- self:chaoshifun()
        --回到登录界面
        -- NUMBERSendMove = 1       
        -- local cutmainscene= mainscene.new()
        -- display.replaceScene(cutmainscene,"fade",1)     
    -- else
        print("网络断了")
        if self.dengdaijiazai then
         self:lodingremoveformmain()
        end
        self:chaoshifun()
        if not self.dengdaijiazai then
           self.dengdaijiazai = lodingwaitlayer.new(false,false,true)
                      :pos(0, 0)
                      :addTo(self)
        end
        -- 写入函数
        -- Socketegame.setonTransmissionAfterEvent(handler(self,self.resconnect))
    -- end
    -- 写入函数
    -- Socketegame.setonTransmissionAfterEvent(handler(self,self.resconnect))
end


---断线重连
--[[
function Playscene:resconnect(event)
    local numberconn = 1 
    if event.name == "SOCKET_TCP_CONNECTED" then
      --连接成功
      self:lodingremoveformmain()

      Socketegame.setonTransmission(Socketegame._onTransmission)
      print("重新连接成功")
      --撤销超时计时
      if Socketegame._Allschedulehend then
        schedule.unscheduleGlobal(Socketegame._Allschedulehend)
        Socketegame._Allschedulehend = nil
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
      print("发送重新连接握手包") 
    end
    if event.name == "SOCKET_TCP_CONNECT_FAILURE" then
      numberconn = numberconn + 1
      print("第"..numberconn.."次,尝试连接")
      Socketegame:connect()
    end
end
]]--

--强退后进入房间
function Playscene:strongback()
  
end


function Playscene:lodingremoveformmain()
  if self.dengdaijiazai then
    self.dengdaijiazai:removeselfformparent()
    self.dengdaijiazai = nil
  end
end

function Playscene:chaoshifun()
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
---------------------------------------------------

---------------------------------------网络通讯
function Playscene:onStatus()
  -- body
  print("fun3scnene")
  local fun
  fun = function (event)
    -- body
    if event.name == "SOCKET_TCP_CONNECTED" then
      print("3scnene_CONNECTED")

    end
    if event.name == "SOCKET_TCP_DATA" then
      --
      local tablenianbaonumber = READ(event.data)
      Socketegame._diaoyongSchedule("open")
      for i=1,#tablenianbaonumber do
        local fuwukaijiang = SESSRETABLENO1(tablenianbaonumber[i])      
        if fuwukaijiang then
          if  fuwukaijiang.cmd == "runturntable" then
            --游戏开始,从服务器获取结果
            self.fruitfuwuqi = fuwukaijiang.fruit
            self:performWithDelay(function ()
              --下注面板关闭监听，不在接收下注信息
              for _,v in ipairs(self.gameview.xiazhu) do
                 v:closeToucho(true)
              end
            end, 1)
          elseif  fuwukaijiang.cmd == "again" then
             --游戏再次开始
             local bank = fuwukaijiang.banker
             --更新庄家信息
             self.mybanker:updatebanker(bank.name,bank.money,bank.bankerLine)
             --庄家按钮冷却
             self.mybanker.offTouth = false
             --可以上下庄
             self.mybanker.gameplay = false
             --开启历史记录查询
             self.myuserCardbool = false
             
             self.reminder:setString("准备期间")

             self.scenebanker.name = bank.name
             self.scenebanker.money = bank.money
             self.scenebanker.bankerLine = fuwukaijiang.bankerLine
             --如果庄家为自己
             --self.mybanker:updatemychildbanker(bank.name)
             --可退出
             self.openMove = false
             --传入时间，再次开启游戏
             self:RunningCountdown(fuwukaijiang.timer) 
          elseif fuwukaijiang.cmd == "betupmoney" then
            --从服务器接收庄家对于每个种类的下注上限
            --庄家承受能力
            --设置下注上限
            self.gameview:setbetupmoney(fuwukaijiang.ss)
            --下注面板开启监听
            for _,v in ipairs(self.gameview.xiazhu) do
              v:offToucho(true)
            end
          elseif fuwukaijiang.cmd == "bankerInfo" then
            --一局结束
            --更新庄家数据
            self.scenebanker.name = fuwukaijiang.name
            self.scenebanker.money = fuwukaijiang.money
            self.scenebanker.bankerLine = fuwukaijiang.bankerLine
            --在游戏层中的计时器里更新显示数据,18秒
            --self.mybanker:updatebanker(scenebanker.name,scenebanker.money)
          elseif fuwukaijiang.cmd == "presentBanker" then
            --如果更换庄家
            --更新庄家显示
            self.mybanker:updatebanker(fuwukaijiang.name,fuwukaijiang.money,fuwukaijiang.bankerLine)
            self.scenebanker.name = fuwukaijiang.name
            self.scenebanker.money = fuwukaijiang.money
            self.scenebanker.bankerLine = fuwukaijiang.bankerLine
            --self.mybanker:updatebanker(self.scenebanker.name,self.scenebanker.money)         
            --如果庄家为自己
            --self.mybanker:updatemychildbanker(fuwukaijiang.name)
          elseif fuwukaijiang.cmd == "becomebanker" then
            --庄家为自己
            self.mybanker:updatemychildbanker(true)
          elseif fuwukaijiang.cmd == "formerbanker" then
            --庄家变为闲家
            -- self.mybanker:updatemychildbanker(false)
          elseif fuwukaijiang.cmd == "bankerDown" then
            --下庄成功 改变按钮
            if fuwukaijiang.isSuccess then
              self.mybanker:getexitbanker()
              if fuwukaijiang.banker then
                self.mybanker:updatemychildbanker(false)
              end
            else
              print("下庄失败")
            end
          elseif fuwukaijiang.cmd == "bankerFlag" then
            ---------------------------------------------
            if fuwukaijiang.isSuccess then
              --如果isSuccess == true 成为庄家
              self.mybanker:getbecomebanker()
              self.mybanker:updatemychildbanker(true)
              --更新庄家面板
              self.mybanker:updatebanker(fuwukaijiang.banker.name,fuwukaijiang.banker.money,fuwukaijiang.banker.bankerLine)
              self.scenebanker.name = fuwukaijiang.banker.name
              self.scenebanker.money = fuwukaijiang.banker.money
              self.scenebanker.bankerLine = fuwukaijiang.banker.bankerLine
            else
              if fuwukaijiang.pos then
                self.mybanker:getbecomebanker()
                self.gameview.playshow:setplaybankerLine(fuwukaijiang.pos)
              else
                print("上庄失败")
              end
            end
            ---------------------------------------------
          --[[
          elseif fuwukaijiang.cmd == "bankerFlag" then
            --上庄成功 改变按钮
            if fuwukaijiang.isSuccess then
              self.mybanker:getbecomebanker()

            else
              if fuwukaijiang.pos then
                self.mybanker:getbecomebanker()
                self.gameview.playshow:setplaybankerLine(fuwukaijiang.pos)
              else
                print("上庄失败")
              end
            end
            ]]--
          --elseif fuwukaijiang.cmd == "kicking" then
            --庄家电脑,庄家被T下庄
          elseif fuwukaijiang.cmd == "oldBanker" then
            --如果更换庄家(庄家局数到达任期 and 金币不足最低限度)
            --更新庄家显示          
            --如果庄家为自己
            self.mybanker:updateokButton()

          elseif fuwukaijiang.cmd == "userbet" then
            --庄家状态,下注提示
            local tempfruit = math.floor(fuwukaijiang.fruit)
            if self.mybanker.mychildbanker then
               self.gameview.xiazhu[tempfruit]:BnakeraddEnergy(fuwukaijiang.money)      
            end
            local temp = {name = fuwukaijiang.name ,fruit = tempfruit , money = fuwukaijiang.money }
            self:addCanChoosePlant(temp)
            self.gameview.xiazhu[tempfruit]:setAllmoney(fuwukaijiang.money)
            
          elseif fuwukaijiang.cmd == "bankerqueuepos" then
            self.gameview.playshow:setplaybankerLine(fuwukaijiang.pos)
          elseif fuwukaijiang.cmd == "updateMoney" then
            self.gameview.playshow:updateplaymoney(fuwukaijiang.money)
            self.gameview.playshow:setscore(fuwukaijiang.score)
          elseif fuwukaijiang.cmd == "luckyfruits" then
            ---[[
            -- fuwukaijiang.fruits = {1,5,7,8,9,6,4,8,7,5,1,2,6,7}
            local daxiaosize = 200/5
            if  not fuwukaijiang.fruits   then
              self.record = luckylayer.new({9},daxiaosize)
                      :pos(display.left + 105, display.top + 30)
            else
              if #fuwukaijiang.fruits < 5 then
                  daxiaosize = (#fuwukaijiang.fruits) * (200/5)
              else
                  daxiaosize = 200
              end            
              self.record = luckylayer.new(fuwukaijiang.fruits,daxiaosize)
                      :pos(display.left + 105, display.top + 30)
            end
            -------------------保存记录
            self.openrecord = fuwukaijiang.fruits
            --self.luckyopen = true
            local emptyNode = cc.Node:create()
            emptyNode:addChild(self.record)
            local bound = self.record:getboundingbox()
            bound.width = 105
            bound.height = 210
            transition.moveTo(self.record, {x = display.left + 105, y =  display.top -15 - 234 + 300 - daxiaosize -300-30, time = 0.5})
            self:performWithDelay(function ()
                  self.onmove = false
                end , 0.6 )         
            self.Scrollview = cc.ui.UIScrollView.new({viewRect = bound})
                :addScrollNode(emptyNode)
                :setDirection(cc.ui.UIScrollView.DIRECTION_HORIZONTAL)
                :pos(0, 270)
                :addTo(self)         
            --]]--
          elseif fuwukaijiang.type == 1 then
            Socketegame._diaoyongSchedule("open")
            --反馈信息 
            SENDHENDBEAT()
          elseif fuwukaijiang.cmd == "getProbability" then
              -- 打开了概率
              self.openmultiplying = true
              self.succeedmultiplying = true
              local addmultiplyingsequence = transition.sequence({
                  cc.MoveBy:create(0.1, cc.p(0, -50))             
              })
              transition.execute(self.addmultiplying,addmultiplyingsequence,{
                           delay = 0.1,
                           onComplete = function ()                    
                              self.multiplyinglayer = multiplyingpromptlayer.new(fuwukaijiang.deta)
                                          :pos(0, 0)
                                          :addTo(self) 
                              self.multiplyingmove = false
                             end
                          })
              ----------------------------------打开了概率
              Socketegame._multiplying = fuwukaijiang.deta
              -- if self.openmultiplying then
              --     self.multiplyinglayer:uddatertext(Socketegame._multiplying)
              -- end
              ----------------------------------
          elseif fuwukaijiang.cmd == "updateProb" then

              if self.openmultiplying and Socketegame._multiplying then
                  self.multiplyinglayer:uddatertext(fuwukaijiang.tb)
              end
              Socketegame._multiplying = fuwukaijiang.tb              
          elseif fuwukaijiang.cmd == "userIcon" then
              
              local addprobabilitysequence = transition.sequence({
                    cc.ScaleTo:create(0.1,0.90,0.90),
                    cc.ScaleTo:create(0.1,1.05,1.05),             
                })
              transition.execute(self.addprobability,addprobabilitysequence,{
                           delay = 0.1,
                           onComplete = function ()                    
                              local openmoneylayer = historyprobabilitylayer.new(fuwukaijiang.icons)
                                            :pos(0, 0)
                                            :addTo(self) 
                              self.probabilitymove = false
                             end
                          })
          elseif fuwukaijiang.cmd == "newuser" then
            --------------玩家动态
            self.userIcons:updatenewItem(fuwukaijiang.name)
            self.userIcons:Intoroomanimation(fuwukaijiang.name,0)
            self.probabilitynumber:setString(self.probabilitynumber:getString() + 1)
          elseif fuwukaijiang.cmd == "deleteuser" then
            self.userIcons:deletequeue(fuwukaijiang.name)
            --[[
            local tmep = self.userIcons:getspritetext1Pos(fuwukaijiang.name)
            if tmep then
               self.userIcons:deletenewItem(tmep)
               self.userIcons:Intoroomanimation(fuwukaijiang.name,1)
               self.probabilitynumber:setString(self.probabilitynumber:getString() - 1)
            end
            ]]--
          elseif fuwukaijiang.cmd == "forcedleave" then
            if self.runingtimeSchedule then
              transition.removeAction(self.runingtimeSchedule)
              self.runingtimeSchedule = nil
            end
            if self.dengdaijiazai then
             self:lodingremoveformmain()
            end
            if not self.dengdaijiazai then
               self.dengdaijiazai = lodingwaitlayer.new(false,true)
                          :pos(0, 0)
                          :addTo(self)
            end         
          -- elseif fuwukaijiang.cmd == "reconnect" then
          --   local age = {cmd = "heartbeat"}
          --   SEND(age)
          elseif fuwukaijiang.cmd == "returnHall" then
            if not fuwukaijiang.data then
              self.cutisMOveBut = false
              return
            end
            if fuwukaijiang.alms and not Socketegame._almsreturnroom then
              Socketegame._almsreturnroom = true
            end
            self.cutisMOveBut = false
            Socketegame._multiplying = nil
            Socketegame._orandbreaklineRunning = false
            --关闭倒计时计时器
            if self.runingtimeSchedule then
              transition.removeAction(self.runingtimeSchedule)
              self.runingtimeSchedule = nil
            end
            --重新计时心跳
            Socketegame._diaoyongSchedule("open")         
            local cutgamescene= gamescene.new()
            display.replaceScene(cutgamescene,"fade",0)
          end

        end     
      -----for循环
      end      
    end
    if event.name == "SOCKET_TCP_CONNECT_FAILURE" then
      --断开服务器    
      Socketegame:close()
      Socketegame = nil
      print("3scnene_FAILURE")
    end
  end
  return fun
end

--处理粘包问题
function Playscene:disposeStickpackage(str)
  -- body
  local lan = 1
  local con
  while true do
    --todo
    len = tonumber(str:sub(1,4))
    --print("len",len)
    con = str:sub(5,len+4)
    --print("con",con)
    str = str:sub(len + 5, -1)
    --print("str",str)
    if #str<=0 then
      --todo
      break
    end
  end
  return con
end

--添加下注信息提示
function Playscene:addCanChoosePlant(fff)
    local plant = usercard.new(fff)
      :align(display.LEFT_TOP, display.cx, display.cy )
      :addTo(self)
      :scale(0.75)
    plant:init()
end

--网络通信
function Playscene:setSocketTransmission(fun)
  -- body
  print("3scneneSocketTransmission")  
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_DATA",fun)
  --Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CONNECT_FAILURE",fun)
  --Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CONNECTED",fun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CLOSED",fun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CLOSE",fun)
end


function Playscene:addLuckyfruit()
	-- body
  local open = false
  self.onmove = false
  local login = {
     normal = "But/playgamecutnor.png",
     pressed = "But/playgamecutpress.png",
     disabled = "But/playgamecutnor.png"
    }
    local Scrollview
    local okButton = nil    
    okButton = cc.ui.UIPushButton.new(login, {scale9 = true})
         :setButtonSize(110,50)        
         :onButtonClicked(function ()
            --更改按钮显示
            if self.onmove then
                return 
            end

            if  not open then
                self.onmove = true
                open = true
                --[[
                self.record = luckylayer.new({1,5,8,6,5,8,4,5,6,1,2,4})
                    :pos(display.left + 80, display.top + 66)

                local emptyNode = cc.Node:create()
                emptyNode:addChild(self.record)
                local bound = self.record:getboundingbox()
                bound.width = 85
                bound.height = 559

                transition.moveTo(self.record, {x = display.left + 80, y =  display.top - 234, time = 0.5})
                schedule.performWithDelayGlobal(function ()
                      self.onmove = false
                    end , 0.6 )

                Scrollview = cc.ui.UIScrollView.new({viewRect = bound})
                    :addScrollNode(emptyNode)
                    :setDirection(cc.ui.UIScrollView.DIRECTION_HORIZONTAL)
                    --:onScroll(handler(self, self.scrollListener))
                    :addTo(self)
                ---动画效果演示
                ]]--
                --一局只发送一次请求
                if not self.myuserCardbool then
                  self.myuserCardbool = true
                    local  token = {         
                    cmd = "getLuckyFruits",
                  }
                  SEND(token)
                else
                  local daxiaosize = 200/5
                  if  not self.openrecord   then
                    self.record = luckylayer.new({9},daxiaosize)
                            :pos(display.left + 105, display.top + 30)
                  else
                    if #self.openrecord < 5 then
                        daxiaosize = (#self.openrecord) * (300/5)
                    else
                        daxiaosize = 200
                    end            
                    self.record = luckylayer.new(self.openrecord,daxiaosize)
                            :pos(display.left + 105, display.top + 30)
                  end
                  --self.luckyopen = true
                  local emptyNode = cc.Node:create()
                  emptyNode:addChild(self.record)
                  local bound = self.record:getboundingbox()
                  bound.width = 105
                  bound.height = 210
                  transition.moveTo(self.record, {x = display.left + 105, y =  display.top -15 - 234 + 300 - daxiaosize -300 -30, time = 0.5})
                  self:performWithDelay(function ()
                        self.onmove = false
                      end , 0.6 )         
                  self.Scrollview = cc.ui.UIScrollView.new({viewRect = bound})
                      :addScrollNode(emptyNode)
                      :setDirection(cc.ui.UIScrollView.DIRECTION_HORIZONTAL)
                      :pos(0, 270)
                      :addTo(self)
                end

                okButton:setButtonLabel("normal", cc.ui.UILabel.new({
                    UILabelType = 2 ,
                    text = "收起记录",
                    size = 24,
                    color = cc.c3b(0,0,0),
                  }))
                okButton:setButtonLabel("pressed", cc.ui.UILabel.new({
                      UILabelType = 2 ,
                      text = "收起记录",
                      size = 24,
                      color = cc.c3b(0,0,0),
                    }))
                okButton:setButtonLabel("disabled", cc.ui.UILabel.new({
                      UILabelType = 2 ,
                      text = "收起记录",
                      size = 24,
                      color = cc.c3b(0,0,0),
                    }))
              else
                self.onmove = true
                open = false
                local posysition = self.record.recorddaxiao
                transition.moveTo(self.record, {x = display.left + 105, y = display.top  -15 + 66 + posysition, time = 0.5})
                self:performWithDelay(function ()
                      self:removeChild(self.Scrollview)
                      self.onmove = false
                    end , 0.6 )

                okButton:setButtonLabel("pressed", cc.ui.UILabel.new({
                      UILabelType = 2 ,
                      text = "历史记录",
                      size = 24,
                      color = cc.c3b(0,0,0),
                    }))
                okButton:setButtonLabel("disabled", cc.ui.UILabel.new({
                      UILabelType = 2 ,
                      text = "历史记录",
                      size = 24,
                      color = cc.c3b(0,0,0),
                    }))
                okButton:setButtonLabel("normal", cc.ui.UILabel.new({
                    UILabelType = 2 ,
                    text = "历史记录",
                    size = 24,
                    color = cc.c3b(0,0,0),
                  }))
              end
            end)
        :addTo(self)        
        okButton:setAnchorPoint(cc.p(1,0.5))
        okButton:setButtonLabel("pressed", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "历史记录",
              size = 24,
              color = cc.c3b(0,0,0),
            }))
        okButton:setButtonLabel("disabled", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "历史记录",
              size = 24,
              color = cc.c3b(0,0,0),
            }))
        okButton:setButtonLabel("normal", cc.ui.UILabel.new({
            UILabelType = 2 ,
            text = "历史记录",
            size = 24,
            color = cc.c3b(0,0,0),
          }))
        okButton:setPosition(display.left + 109, display.top - 75 -100 +40)
end

--断线游戏开始，准备时间，1秒前
function Playscene:breaklineRunning(bettime,offToucho)
  --获取下注时间
  local time = bettime
  --下注时间冷却
  local xiazhulengqie = true
  --下注时间
  self.openMove = true
  ---[[
  --下注时间 不能上下庄
  self.mybanker.gameplay = true
  --不能下庄了
  self.mybanker.offTouth = false
  --]]
  --[[
  if offToucho then
  
  else
    --下注面板开启监听
    for _,v in ipairs(self.gameview.xiazhu) do
      v:offToucho(true)
    end
  end
  ]]--
  --倒计时计时器
  self.runingtimeSchedule = nil
  self.runingtimeSchedule = self:schedule(function ()
    time = time - 1
      if time == 0 and self.fruitfuwuqi then
          self.reminder:setString("开奖期间")
          self.Preparetime:setString(0)
          --下注面板关闭监听，不在接收下注信息
          for _,v in ipairs(self.gameview.xiazhu) do
            v:closeToucho(true)
          end
          --根据从服务器接收到的水果，开始转盘
          self.gameview:setopenkaijiang(self.fruitfuwuqi,10)
          --当前开奖水果设置为空
          self.fruitfuwuqi = nil
          --关闭倒计时计时器
          if self.runingtimeSchedule then
            transition.removeAction(self.runingtimeSchedule)
            self.runingtimeSchedule = nil
          end
      elseif time == 1 then
          --下注面板关闭监听，不在接收下注信息
          for _,v in ipairs(self.gameview.xiazhu) do
            v:closeToucho(true)
          end
      elseif time == -1 then
          --接收水果失败
          self.Preparetime:setString(0) 
          --关闭倒计时计时器
          if self.runingtimeSchedule then
            transition.removeAction(self.runingtimeSchedule)
            self.runingtimeSchedule = nil
          end
      else
          self.Preparetime:setString(time)
      end    
  end,1)
end


function Playscene:PrepareCountdown(time,status)
  -- body
  if not time then
    --
    time = 50
  elseif time < 0 then
    time = 0
  end
  local textreminder
  if status then
    if status == "readytime" then
      textreminder = "准备阶段"
    elseif status == "bettime" then
      textreminder = "下注时间"
    elseif status == "playgame" then
      textreminder = "开奖期间"
    end
  else
    textreminder = "准备阶段"
  end 
  
  --进入房间前从服务器接收准备时间
  --倒计时 
  local timelogo = display.newSprite("timecon.png")
      :pos(display.right-30,display.top-10)
      :addTo(self)
  timelogo:setAnchorPoint(cc.p(1,1))
  timelogo:setScale(1)
  --倒计时演示文本 
  self.Preparetime = nil
  self.Preparetime = display.newTTFLabel(
        { text = time,
          font = "Arial",
          size = 38,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(0,0,0) })
        --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
        :pos(timelogo:getContentSize().width *0.5 , timelogo:getContentSize().height*0.5 )
        :addTo(timelogo)

  --文字提示
  self.reminder = display.newTTFLabel(
        { text = textreminder,
          font = "Arial",
          size = 20,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
        :pos(display.right-56,display.top-75)
        :addTo(self)

  --UI 测试不开倒计时
  -- self:RunningCountdown(time)
  -------------
end


--开启倒计时，并且游戏开始
function Playscene:RunningCountdown(bettime)
  --第二轮有参数传进来的时候
  --第一轮准备时间不为空时
  --获取准备时间
  local time = bettime
  if self.Preparetime then
    --todo
    --获取准备时间
    -- local time = self.Preparetime:getString()
    --下注时间冷却
    local xiazhulengqie = true
    ---[[
    -- self.runingtimeSchedule = schedule.scheduleGlobal(function ( )
    self.runingtimeSchedule = self:schedule(function ()
        time = time - 1
        if time == -10 and self.fruitfuwuqi then
            self.reminder:setString("开奖期间")
            self.Preparetime:setString(0)
            --下注面板关闭监听，不在接收下注信息
            for _,v in ipairs(self.gameview.xiazhu) do
              v:closeToucho(true)
            end
            --根据从服务器接收到的水果，开始转盘
            self.gameview:setopenkaijiang(self.fruitfuwuqi,10)
            --当前开奖水果设置为空
            self.fruitfuwuqi = nil
            --关闭倒计时计时器
            if self.runingtimeSchedule then
              transition.removeAction(self.runingtimeSchedule)
              self.runingtimeSchedule = nil
            end           
            -- schedule.unscheduleGlobal(self.runingtimeSchedule)
        elseif time == -9 then
            self.Preparetime:setString(time + 10)
            --下注面板关闭监听，不在接收下注信息
            -- for _,v in ipairs(self.gameview.xiazhu) do
            --   v:closeToucho(true)
            -- end
        elseif time == -11 then
            --连接失败
            self.Preparetime:setString(0) 
            --关闭倒计时计时器
            if self.runingtimeSchedule then
              transition.removeAction(self.runingtimeSchedule)
              self.runingtimeSchedule = nil
            end
        else
            --其他时间更新倒计时显示
            if time < 0 then
              --更新倒计时文字提示
              self.Preparetime:setString(time + 10) 
            else            
              self.Preparetime:setString(time)
              if time == 1 then
                --下注时间 不能上下庄
                -- self.mybanker.offTouth = true
                --准备时间为1秒的时候
                self.openMove = true
              end
              if time == 0 then
                  print("下注时间")         
                  self.reminder:setString("下注时间")
                  --下注时间和开奖时间不能退出,返回按钮吞噬监听
                  self.openMove = true
                  --下注时间 不能上下庄
                  self.mybanker.gameplay = true
                  --准备时间为1秒的时候
                  --不能下庄了
                  self.mybanker.offTouth = false
                  --下注面板开启监听
                  if self.mybanker.mychildbanker then
                    for _,v in ipairs(self.gameview.xiazhu) do
                      v:offToucho(true)
                    end
                  end                  
              end 
            end
        end    
      end , 1)
  end
end

function Playscene:Confirmexit()
    local node = display.newNode()
    local Item = cc.LayerColor:create(
        cc.c4b(math.random(250),
            math.random(250),
            math.random(250),
            250))
    -- Item:setContentSize(400, 300)  
    -- node:addChild(Item)
    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)
    node:setContentSize(display.width,display.height)
    node:ignoreAnchorPointForPosition(false)                 
    node:setAnchorPoint(cc.p(0.5,0.5))
    node:setPosition(display.cx , display.cy)  

    self:addChild(node)
    Item:setContentSize(400, 300)
    Item:ignoreAnchorPointForPosition(false)
    Item:setAnchorPoint(cc.p(0.5,0.5))  
    Item:setPosition(node:getContentSize().width/2,node:getContentSize().height/2)
    node:addChild(Item)

    local spritetext1 = display.newTTFLabel(
    { text = "游戏开始不能退出 \n请到准备时间正常退出",
      --font = "MarkerFelt",
      size = 30,
      align = cc.TEXT_ALIGNMENT_RIGHT,
      color = cc.c3b(255,255,255) })      
    --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
        :align(display.CENTER,node:getContentSize().width/2,node:getContentSize().height/2)
    node:addChild(spritetext1)

    local cunmoney
    cunmoney = display.newSprite("gamescene/buyconfirm.png")
        :align(display.CENTER,node:getContentSize().width/2 ,node:getContentSize().height/2.5)
        :addTo(node)
    cunmoney:setTouchEnabled(true)
    cunmoney:setTouchSwallowEnabled(true)
    cunmoney:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if event.name == "began" then
          local sequence = transition.sequence({
              cc.ScaleTo:create(0.1,0.9,0.9),
              cc.ScaleTo:create(0.2,1.0,1.0),             
          })        
          transition.execute(cunmoney,sequence,{
                       delay = 0,
                       onComplete = function ()
                        node:removeFromParent()
                        end})           
        end
    end)
end

function Playscene:onEnter()

end

function Playscene:onExit()
end


return Playscene