
local lodingwaitlayer = require("app.layer.lodingwait")
local schedule = require(cc.PACKAGE_NAME .. ".scheduler")

local roomlayer = class("room", function()
	return display.newNode()
end)

function roomlayer:ctor(roomset)

    --存放房间，方便更新人数
    self.roomnumtext = {}
    --吞噬事件
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self.itembool = true

    self.roomlayer = cc.LayerColor:create(cc.c4b(55,55,55,255),display.width,display.height) 
              --:pos(0, 0)             
              :addTo(self)
    self.roomlayer:ignoreAnchorPointForPosition(false)
    self.roomlayer:setAnchorPoint(cc.p(0.5,0.5))
    self.roomlayer:setPosition(cc.p(display.cx,display.cy))

    --180
    local posx = self.roomlayer:getContentSize().width/144 *30
    --135
    local posy = ((self.roomlayer:getContentSize().height/3 *2)/3834) * 1350
    ---建立房间列表    
    local pv = cc.ui.UIPageView.new{
        viewRect = cc.rect(0, 0, self.roomlayer:getContentSize().width/4 *3 ,self.roomlayer:getContentSize().height/3 *2),
        color = cc.c4b(255,255,255,255),
        column = 3, row = 2,
        padding = {left = posx/4, right = posx/4, top = posy/3, bottom = posy/3},
        columnSpace = posx/4, rowSpace = posy/3 }      
        -- :onTouch( function (event)
            -- dump(event, "TestUIPageViewScene - event:")
            -- local listView = event.listView
            -- --发送房间信息
            --   if event.itemIdx and self.itembool then
            --     --加载层
            --     -- event.item:setScale(0.8)
            --     local addprobabilitysequence = transition.sequence({
            --           cc.ScaleTo:create(0.1,0.80,0.80),
            --           cc.ScaleTo:create(0.1,1.00,1.00),             
            --       })
            --     transition.execute(event.item,addprobabilitysequence,{
            --                  delay = 0,
            --                  onComplete = function ()                    
            --                   end
            --                 })
            --     self:getParent().dengdaijiazai = lodingwaitlayer.new()
            --         :pos(0, 0)
            --         :addTo(self:getParent())

            --     self.itembool = false
            --     local  token = {         
            --       cmd = "enterRoom",
            --       index = self.roomnumtext[event.itemIdx].roomID,
            --       name = Socketegame._ID,
            --       uid = Socketegame._UID,
            --      }
            --      --print("==>"..json.encode(token))
            --      SEND(token)
            --   end          
            -- end)
        --:pos(self.roomlayer:getContentSize().width/2,self.roomlayer:getContentSize().height/2)
        --:pos(0, 0)
        :addTo(self.roomlayer,1)
    pv:ignoreAnchorPointForPosition(false)
    pv:setAnchorPoint(cc.p(0,0))
    pv:setPosition(self.roomlayer:getContentSize().width/2 - self.roomlayer:getContentSize().width/8 *3,self.roomlayer:getContentSize().height/2 - self.roomlayer:getContentSize().height/3 )


    --生成房间列表
    for i,v in ipairs(roomset) do
        local item = pv:newItem()
        local content
        local lab
        --自定义颜色房间层
        content = cc.LayerColor:create(
            cc.c4b(math.random(250),
                math.random(250),
                math.random(250),
                250))        
        content:setContentSize(posx, posy)
        content:setTouchEnabled(false)

        lab = display.newTTFLabel({text=(v.nums).."/20",color=c2,align=cc.ui.TEXT_ALIGN_CENTER,size=28})
        lab:setPosition(cc.p(content:getContentSize().width/2,content:getContentSize().height/3))
        content:addChild(lab)

        roomnumlab = display.newTTFLabel({text="房间号:"..(v.roomID),color=c2,align=cc.ui.TEXT_ALIGN_CENTER,size=28})
        roomnumlab:setPosition(cc.p(content:getContentSize().width/2,content:getContentSize().height/3 * 2))
        content:addChild(roomnumlab)
        local temptable = {}
        temptable.roomID = v.roomID
        temptable.roomlab = lab
        table.insert(self.roomnumtext, temptable)      
        item:addChild(content)

        item:setTouchEnabled(true)
        item:setTouchSwallowEnabled(true)
        item:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
              if event.name == "began" then
                 local addprobabilitysequence = transition.sequence({
                      cc.ScaleTo:create(0.1,0.80,0.80),
                      cc.ScaleTo:create(0.1,1.00,1.00),             
                  })
                  transition.execute(item,addprobabilitysequence,{
                               delay = 0,
                               onComplete = function ()                    
                                end
                              })
                  self:getParent().dengdaijiazai = lodingwaitlayer.new()
                      :pos(0, 0)
                      :addTo(self:getParent())

                  self.itembool = false
                  local  token = {         
                    cmd = "enterRoom",
                    index = v.roomID,
                    name = Socketegame._ID,
                    uid = Socketegame._UID,
                   }
                   SEND(token)
              end
           end)
        pv:addItem(item)        
    end
    pv:reload()

    --建立按钮
    --返回 
    self:createbut()
end

function roomlayer:createtishi(upormoney)
  -- body
  local fruittishi = display.newSprite("fruitpic/tishi.png")
        :pos(self.roomlayer:getPositionX()/2  + 100, self.roomlayer:getPositionY()/5)
        :addTo(self.roomlayer)
  
  if upormoney == 0 then
    --todo
    display.newTTFLabel(
        { text = "房间正在游戏中",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  end

  transition.moveBy(fruittishi, { y = 30, time = 1})
  transition.fadeTo(fruittishi, {opacity = 50, time = 1})
  self:performWithDelay(function ()
                fruittishi:removeFromParent()
                --self.roomlayer:removeChild(fruittishi)
                end , 1)
end

function roomlayer:uddateroom(value)
	--更新房间
	self.roomnumtext = {}
    for i=1,#(value) do
        local item = pv:newItem()
        local content
        local lab
        local roomnumlab
        --自定义颜色房间层
        content = cc.LayerColor:create(
            cc.c4b(math.random(250),
                math.random(250),
                math.random(250),
                250))        
        content:setContentSize(posx, posy)
        content:setTouchEnabled(false)

        lab = display.newTTFLabel({text=(value[i]).."/20",color=c2,align=cc.ui.TEXT_ALIGN_CENTER,size=28})
        lab:setPosition(cc.p(content:getContentSize().width/2,content:getContentSize().height/3))
        content:addChild(lab)
        roomnumlab = display.newTTFLabel({text="房间号:"..i,color=c2,align=cc.ui.TEXT_ALIGN_CENTER,size=28})
        roomnumlab:setPosition(cc.p(content:getContentSize().width/2,content:getContentSize().height/3 * 2))
        content:addChild(roomnumlab)
        table.insert(self.roomnumtext, lab)
        item:addChild(content)
        pv:addItem(item)        
    end
    pv:reload()
end

function roomlayer:createbut()
	--建立按钮
    --返回 
    local login = {
     normal = "gamescene/buyreturn.png",
     pressed = "gamescene/buyreturn.png",
     disabled = "gamescene/buyreturn.png"
     }
     --返回
    local exitButton = cc.ui.UIPushButton.new(login, {scale9 = true})
             :setButtonSize(160,80)
             :setButtonLabel("normal", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 34,
                  color = cc.c3b(0,0,0),
             	  }))
             :setButtonLabel("pressed", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 34,
                  color = cc.c3b(255,255,255),
             	  }))
             :setButtonLabel("disabled", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 34,
                  color = cc.c3b(0,0,0),
             	  }))
             :onButtonClicked(function ()
             	  -- body.roomtable
                --获取网络接收回调函数,并加入监听
                  local  token = {         
                    cmd = "returnHall",
                   }
                   SEND(token)
                  self:getParent().roomtable = false
                  self:removeroomlayer()
                  end)
             :align(display.LEFT_CENTER,   40, self.roomlayer:getContentSize().height - 60 )
             :addTo(self.roomlayer,2)
    local quickpng = {
      normal = "gamescene/quickButton.png",
      pressed = "gamescene/quickButton.png",
      disabled = "gamescene/quickButton.png",
     }
     --快速坐下
    local quickButton = cc.ui.UIPushButton.new(quickpng, {scale9 = true})
             :setButtonSize(120,120)
             :setButtonLabel("normal", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 30,
                  color = cc.c3b(0,0,0),
             	  }))
             :setButtonLabel("pressed", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 30,
                  color = cc.c3b(255,255,255),
             	  }))
             :setButtonLabel("disabled", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 30,
                  color = cc.c3b(0,0,0),
             	  }))
             :onButtonClicked(function ()
              ---[[
                self:getParent().dengdaijiazai = lodingwaitlayer.new()
                    :pos(0, 0)
                    :addTo(self:getParent())

             	  local  token = {         
                  cmd = "quickEnterRoom",
                 }
                 SEND(token)
                --]]--
             	end)
             :align(display.LEFT_CENTER,   self.roomlayer:getContentSize().width -220 , 70 )
             :addTo(self.roomlayer,2)

    local ctearoom = {
      normal = "gamescene/ctearoomButton.png",
      pressed = "gamescene/ctearoomButton.png",
      disabled = "gamescene/ctearoomButton.png",
     }
     --新建房间
    local ctearoomButton = cc.ui.UIPushButton.new(ctearoom, {scale9 = true})
             :setButtonSize(120,120)
             :setButtonLabel("normal", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 30,
                  color = cc.c3b(0,0,0),
             	  }))
             :setButtonLabel("pressed", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 30,
                  color = cc.c3b(255,255,255),
             	  }))
             :setButtonLabel("disabled", cc.ui.UILabel.new({
                  UILabelType = 2 ,
                  text = "",
                  size = 30,
                  color = cc.c3b(0,0,0),
             	  }))
             :onButtonClicked(function ()
             	  self:getParent().dengdaijiazai = lodingwaitlayer.new()
                    :pos(0, 0)
                    :addTo(self:getParent())

                local  token = {         
                  cmd = "createNewRoom",
                 }
                 SEND(token)
             	  end)
             :align(display.LEFT_CENTER,  100 , 70 )
             :addTo(self.roomlayer,2)
end

function roomlayer:removeroomlayer()
  print("dawdawdw")
  local fundata = self:getParent():onStatus()
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_DATA",fundata)
  self:getParent().roomtable = false
  self:getParent().createroom:removeFromParent()
  -- self:getParent():removeChild(self:getParent().createroom)
end


return roomlayer