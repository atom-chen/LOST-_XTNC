
--local schedule = require(cc.PACKAGE_NAME .. ".scheduler")

local mybankerlayer = class("mybankerlayer", function()
	return display.newNode()
end)

function mybankerlayer:ctor(roomset)
    -----264  426
    self.mybankerlayer = cc.LayerColor:create(cc.c4b(55,55,55,255),display.width * 0.27,display.height * 0.35)
              --:pos(0, 0)             
              :addTo(self)
    self.mybankerlayer:ignoreAnchorPointForPosition(false)
    self.mybankerlayer:setAnchorPoint(cc.p(0,0))
    self.mybankerlayer:setScale(0.8)
    self.mybankerlayer:setPosition(cc.p(display.left ,display.bottom))
    
    self.mybankerlayer:setOpacity(0)
    
    self.addbg33 = display.newSprite("But/banker.png")
          :addTo(self.mybankerlayer)
    self.addbg33:setAnchorPoint(cc.p(0,0))
    self.addbg33:setScaleY(1.1)
    self.addbg33:setPosition(cc.p(0 ,0 ))

    --上庄玩家
    self.bankerplay = {}
    --当前庄家
    self.banker = {}
    --当前客户是否在上庄队列了   
    self.boolKamishoqueue = false
    --当前客户端是否是庄家
    self.mychildbanker = false
    --冷却时间关闭按钮监听
    self.cooloffTouth = false
    --游戏开始不给上庄
    self.gameplay = false
    --准备时间为1秒庄家不给下庄
    self.offTouth = false

    self.termLine = nil
    --self:addplay()
    --缺少 playScore = "eqweq" , playTerm = "qwedsa"
    self:createbanker({playID = roomset.banker.name , playGold = roomset.banker.money ,playTerm = roomset.banker.bankerLine})
    
    --self:createbankerplays(self.bankerplay)

    --上庄按钮
    --确定按钮
    -- local login = {
    --  normal = "normal.png",
    --  pressed = "down.png",
    --  disabled = "disable.png"
    -- }
    local login = {
     normal = "mian/PasswordBox.png",
     pressed = "mian/PasswordBox.png",
     disabled = "mian/PasswordBox.png",
    }
    self.okButton = nil   
    self.okButton = cc.ui.UIPushButton.new(login, {scale9 = true})
         :setButtonSize(100,50)
         :setButtonLabel("normal", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "上庄",
              size = 30,
         	  }))
         :setButtonLabel("pressed", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "上庄",
              size = 30,
              color = cc.c3b(255,64,64),
         	  }))
         :setButtonLabel("disabled", cc.ui.UILabel.new({
              UILabelType = 2 ,
              text = "上庄",
              size = 30,
              color = cc.c3b(0,0,0),
         	  }))
         :onButtonClicked(function ()
              if Socketegame._MONEY < 10000000 then
                --
                self:createtishi(5)
                return 
              end
              if self.offTouth then
                return
              end
              --频繁上下庄
              if self.cooloffTouth then
                --
                self:createtishi(4)
                return 
              end
              self.cooloffTouth = true
              self:performWithDelay(function () 
                 self.cooloffTouth = false 
                end , 1)
              if self.gameplay then
                --游戏开始了,不能上下庄
                self:createtishi(2)
                return 
              end
              --如果当前客户端在庄家队列
              if self.boolKamishoqueue then
                --todo
                --发送下庄请求
                local  token = {         
                  cmd = "exitBanker",
                 }
                SEND(token)
                --[[             
                --下庄提示
                self:createtishi(1)
                --下庄,设置当前客户不在庄家队列
                self.boolKamishoqueue = false
                --更新庄家队列
                self:getParent().gameview.playshow:removeplaybankerLine()
                --更改按钮显示
                self.okButton:setButtonLabel("normal", cc.ui.UILabel.new({
                    UILabelType = 2 ,
                    text = "上庄",
                    size = 30,
                  }))
                self.okButton:setButtonLabel("pressed", cc.ui.UILabel.new({
                      UILabelType = 2 ,
                      text = "上庄",
                      size = 30,
                      color = cc.c3b(255,64,64),
                    }))
                self.okButton:setButtonLabel("disabled", cc.ui.UILabel.new({
                      UILabelType = 2 ,
                      text = "上庄",
                      size = 30,
                      color = cc.c3b(0,0,0),
                    }))
                    ]]--
              else
                --todo
                --发送上庄请求
                local  token = {         
                  cmd = "becomeBanker",
                  --uid = Socketegame._UID,
                 }
                SEND(token)
                --[[
                --更新庄家队列
                self:getParent().gameview.playshow:addline()
                --下庄提示
                self:createtishi(0)
                --处在庄家队列
                self.boolKamishoqueue = true
                self.okButton:setButtonLabel("pressed", cc.ui.UILabel.new({
                      UILabelType = 2 ,
                      text = "下庄",
                      size = 30,
                      color = cc.c3b(255,64,64),
                    }))
                self.okButton:setButtonLabel("disabled", cc.ui.UILabel.new({
                      UILabelType = 2 ,
                      text = "下庄",
                      size = 30,
                      color = cc.c3b(0,0,0),
                    }))
                self.okButton:setButtonLabel("normal", cc.ui.UILabel.new({
                    UILabelType = 2 ,
                    text = "下庄",
                    size = 30,
                  }))
                  ]]--
              end              
            end)
         :align(display.CENTER, self.addbg33:getContentSize().width/2 , self.addbg33:getContentSize().height* 0.87 )
         :addTo(self.addbg33)

end

function mybankerlayer:youisbanker(cmd)
  --
  if cmd == 1 then
    --self:performWithDelay(function ()
      self.youisbankerspr = display.newSprite("bankerbg.png")
        :pos(self.addbg33:getContentSize().width/6 * 5 , self.addbg33:getContentSize().height* 0.83 )
        :addTo(self.addbg33)
      self.youisbankerspr:setScale(0.1)
      local sequence = transition.sequence({
          cc.ScaleTo:create(0.1,0.9,0.9),
          cc.ScaleTo:create(0.1,1.1,1.1),
          cc.ScaleTo:create(0.1,1.0,1.0),               
      })
      self.youisbankerspr:runAction(sequence)        
      -- transition.execute(self.youisbankerspr,sequence,{
      --              delay = 0,
      --              onComplete = function ()
      --               end})
    --end, 2)
  elseif cmd == 2 then
    --self:performWithDelay(function ()
      if not self.youisbankerspr then
        return
      end
      local sequence = transition.sequence({
          cc.ScaleTo:create(0.1,0.9,0.9),
          cc.ScaleTo:create(0.1,1.1,1.1),
          cc.ScaleTo:create(0.1,0.1,0.1),               
      })       
      transition.execute(self.youisbankerspr,sequence,{
                   delay = 0,
                   onComplete = function ()
                   self.youisbankerspr:removeFromParent()
                  end})
    --end, 2)
  end 
end

function mybankerlayer:getbecomebanker()
    --更新庄家队列
    self:getParent().gameview.playshow:addline()
    
    --处在庄家队列
    self.boolKamishoqueue = true
    self.okButton:setButtonLabel("pressed", cc.ui.UILabel.new({
          UILabelType = 2 ,
          text = "下庄",
          size = 30,
          color = cc.c3b(255,64,64),
        }))
    self.okButton:setButtonLabel("disabled", cc.ui.UILabel.new({
          UILabelType = 2 ,
          text = "下庄",
          size = 30,
          color = cc.c3b(0,0,0),
        }))
    self.okButton:setButtonLabel("normal", cc.ui.UILabel.new({
        UILabelType = 2 ,
        text = "下庄",
        size = 30,
      }))
    --下庄提示
    self:createtishi(0)
end

function mybankerlayer:getexitbanker()

  --下庄,设置当前客户不在庄家队列
  self.boolKamishoqueue = false
  --更新庄家队列
  self:getParent().gameview.playshow:removeplaybankerLine()
  --更改按钮显示
  self.okButton:setButtonLabel("normal", cc.ui.UILabel.new({
      UILabelType = 2 ,
      text = "上庄",
      size = 30,
    }))
  self.okButton:setButtonLabel("pressed", cc.ui.UILabel.new({
        UILabelType = 2 ,
        text = "上庄",
        size = 30,
        color = cc.c3b(255,64,64),
      }))
  self.okButton:setButtonLabel("disabled", cc.ui.UILabel.new({
        UILabelType = 2 ,
        text = "上庄",
        size = 30,
        color = cc.c3b(0,0,0),
      }))

  --下庄提示
  self:createtishi(1)
end

function mybankerlayer:updateokButton()

  --下庄,设置当前客户不在庄家队列
  self.boolKamishoqueue = false
 
  --当前客户端不是庄家
  self.mychildbanker = false

  --更新庄家队列
  self:getParent().gameview.playshow:removeplaybankerLine()

  --更改按钮显示
  self.okButton:setButtonLabel("normal", cc.ui.UILabel.new({
      UILabelType = 2 ,
      text = "上庄",
      size = 30,
    }))
  self.okButton:setButtonLabel("pressed", cc.ui.UILabel.new({
        UILabelType = 2 ,
        text = "上庄",
        size = 30,
        color = cc.c3b(255,64,64),
      }))
  self.okButton:setButtonLabel("disabled", cc.ui.UILabel.new({
        UILabelType = 2 ,
        text = "上庄",
        size = 30,
        color = cc.c3b(0,0,0),
      }))

  --下庄提示
  self:createtishi(3)
  --更改提示
  self:youisbanker(2)
end

function mybankerlayer:bankerQueue()
    -- self.boolKamishoqueue = true
    self.okButton:setButtonLabel("pressed", cc.ui.UILabel.new({
          UILabelType = 2 ,
          text = "下庄",
          size = 30,
          color = cc.c3b(255,64,64),
        }))
    self.okButton:setButtonLabel("disabled", cc.ui.UILabel.new({
          UILabelType = 2 ,
          text = "下庄",
          size = 30,
          color = cc.c3b(0,0,0),
        }))
    self.okButton:setButtonLabel("normal", cc.ui.UILabel.new({
        UILabelType = 2 ,
        text = "下庄",
        size = 30,
      }))
end


--ID，金币，成绩，连任
---play= {playID = "" , playGold = "" , playScore = "" , playTerm = ""}
function mybankerlayer:createbanker(play)
	local ttfSize = 20
	local ttfColor = cc.c3b(255, 255, 255)
  local banzhuangjia = display.newTTFLabel(
        { text = "庄家:",
          font = "Arial",
          size = 26,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = ttfColor })
        :align(display.LEFT_CENTER, self.addbg33:getContentSize().width/5.5 , self.addbg33:getContentSize().height /4 *2.35)
        :addTo(self.addbg33)

    local playID = display.newTTFLabel(
        { text = play.playID,
          font = "Arial",
          size = 26,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = ttfColor })
        :align(display.LEFT_CENTER, banzhuangjia:getPositionX() + banzhuangjia:getContentSize().width , self.addbg33:getContentSize().height /4 *2.35)
        :addTo(self.addbg33)
    table.insert(self.banker, playID)


    local bankerjinbi = display.newTTFLabel(
        { text = "金币:",
          font = "Arial",
          size = 26,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = ttfColor })
        :align(display.LEFT_CENTER, self.addbg33:getContentSize().width/5.5 , self.addbg33:getContentSize().height /4 *1.5)
        :addTo(self.addbg33)

    local playGold = display.newTTFLabel(
        { text = play.playGold,
          font = "Arial",
          size = 26,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = ttfColor })
        :align(display.LEFT_CENTER, bankerjinbi:getPositionX() + bankerjinbi:getContentSize().width , self.addbg33:getContentSize().height /4 *1.5)
        :addTo(self.addbg33)
    table.insert(self.banker, playGold) 

    local bankerrenqi = display.newTTFLabel(
        { text = "任期:",
          font = "Arial",
          size = 26,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = ttfColor })
        :align(display.LEFT_CENTER, self.addbg33:getContentSize().width/5.5 , self.addbg33:getContentSize().height /5.6 )
        :addTo(self.addbg33)

    local playTerm = display.newTTFLabel(
        { text = play.playTerm,
          font = "Arial",
          size = 26,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = ttfColor })
        :align(display.LEFT_CENTER, bankerrenqi:getPositionX() + bankerrenqi:getContentSize().width , self.addbg33:getContentSize().height /5.6 )
        :addTo(self.addbg33)
    --playTerm:setString("2048")
    table.insert(self.banker, playTerm)
    
end

--更新庄家信息,参数为名字，金钱
function mybankerlayer:updatebanker(name,money,term)
  -- body
  self.banker[1]:setString(name)
  self.banker[2]:setString(money)
  self.banker[3]:setString(term)
  --验证是否自己为庄家 
end

function mybankerlayer:updatemychildbanker(vales)
  --如果自己为庄家,设置当前客户端为庄家
  if vales and (not self.mychildbanker) then
    self.mychildbanker = true
    --成为庄家提示
    self:becomebanker()
    --更改提示
    self:youisbanker(1)
  elseif not vales and self.mychildbanker then
    --更改提示
    --更新庄家队列
    --self:getParent().gameview.playshow:removeplaybankerLine()
    self:youisbanker(2)
    self.mychildbanker = false
  end
  --更新庄家队列
  self:getParent().gameview.playshow:removeplaybankerLine()
end

--提示
function mybankerlayer:createtishi(upormoney)
  -- body
  local fruittishi = display.newSprite("fruitpic/tishi.png")
        :pos(self.mybankerlayer:getContentSize().width/2 , self.mybankerlayer:getContentSize().height/2)
        :addTo(self.mybankerlayer)
  
  if upormoney == 0 then
    --todo
    display.newTTFLabel(
        { text = "上庄成功,正在排队",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 1 then
    --todo
    display.newTTFLabel(
        { text = "排队下庄成功",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 2 then
    --todo
    display.newTTFLabel(
        { text = "游戏开始,操作失败",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 3 then
    --todo
    display.newTTFLabel(
        { text = "已下庄,不再是庄家",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 4 then
    --todo
    display.newTTFLabel(
        { text = "请勿频繁操作",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 5 then
    --todo
    display.newTTFLabel(
        { text = "金币少于1千万",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  end

  transition.moveBy(fruittishi, { y = 60, time = 1})
  transition.fadeTo(fruittishi, {opacity = 50, time = 1})
  self:performWithDelay(function ()
                fruittishi:removeFromParent()
                end , 1)
end

function mybankerlayer:becomebanker()
  -- body
  --成为庄家提示
  local fruittishi = display.newSprite("fruitpic/tishi.png")
        :pos(display.cx  , display.cy/3 )
        :addTo(self:getParent(),15)
  --if upormoney == 0 then
    --todo
    display.newTTFLabel(
        { text = "你已成为庄家",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)

  transition.moveBy(fruittishi, { y = 80, time = 3})
  transition.fadeTo(fruittishi, {opacity = 50, time = 3})
  self:performWithDelay(function ()
                self:getParent():removeChild(fruittishi)
                end , 3)
  --end
end
--[[
function mybankerlayer:setbanker(bankeruser)
	-- body
  if bankeruser then
    --todo
    --电脑人坐庄
    for i,plays in ipairs(self.banker) do
      --print(i)
      if i == 1 then
        --todo
        plays:setString(bankeruser.playID)
      elseif i == 2 then
        --todo
        plays:setString(bankeruser.playGold)
      elseif i == 3 then
          --todo
          plays:setString(bankeruser.playScore)
      elseif i== 4 then
        --todo
        plays:setString(bankeruser.playTerm)
      end
   end
  else
    --todo
    --玩家上庄
  	if #self.bankerplay ~= 0 then
  		--todo
           for i,plays in ipairs(self.banker) do
             	--print(i)
              if i == 1 then
             	  --todo
             	  plays:setString(self.bankerplay[1].playID)
              elseif i == 2 then
             		--todo
             		plays:setString(self.bankerplay[1].playGold)
              elseif i == 3 then
             	    --todo
             	    plays:setString(self.bankerplay[1].playScore)
             	elseif i== 4 then
             		--todo
             		plays:setString(self.bankerplay[1].playTerm)
             	end
           end
           table.remove(self.bankerplay,1)
           --self.lv:removeItem(1, true)
    end
  end
end
]]--

--[[
function mybankerlayer:addplay()
	-- body
	for i=1,20 do
		--print(i)
		local ba = {playID = "林东雄" , playGold = i + 2048, playScore = 0, playTerm = 0 }
		table.insert(self.bankerplay, ba)
	end
end
]]--

--bankerplay = {play,play,play}
--[[
function mybankerlayer:createbankerplays(bankerplay)
	-- body
	local posy = self.mybankerlayer:getContentSize().height/2
	local posx = self.mybankerlayer:getContentSize().width/8 *7
  local labelSize = 20

	self.lv = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        bg = "bankerok.png",
        bgScale9 = true,
        viewRect = cc.rect(0, 0, 213, 190),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = "bar.png"}
        --:onTouch(handler(self, self.touchListener))
        :pos(0,0)
        :addTo(self.mybankerlayer)
    --print(#bankerplay)
    for i,plays in ipairs(bankerplay) do
        local item = self.lv:newItem()
        local content
        --print("i = "..i)

        if 1 == i then
            content = cc.ui.UILabel.new(
                    {text = i..":  "..plays.playID.."庄家",
                    size = 20,
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    color = display.COLOR_BLACK})       
        else
        	--print("i = "..i)
            content = cc.ui.UILabel.new(
                    {text = i..":  "..plays.playID,
                    size = 20,
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    color = display.COLOR_BLACK})
        end
        item:addContent(content)
        item:setItemSize(120, 38)
        --print(content:getString())
        self.lv:addItem(item)
    end
    self.lv:reload()

end
]]--

--[[
function mybankerlayer:setcontentString(contentitems_)
  -- body
  print(#contentitems_)
  for i,playcontent in ipairs(contentitems_) do
    if i<9 then
       --todo

       local context = string.sub(playcontent:getContent():getString(),2,-1)
       playcontent:getContent():setString(i..context)      
    else
       --todo
       local context = string.sub(playcontent:getContent():getString(),3,-1)
       playcontent:getContent():setString(i..context)
    end 
  end
end
]]--

return mybankerlayer