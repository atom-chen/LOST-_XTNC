

local lodingwaitlayer = require("app.layer.lodingwait")
--游戏规则界面
local createpicture = class("createpicture", function()
	return display.newNode()
end)

--调用
function createpicture:ctor(temp)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(150)
    
    local userbg = display.newSprite("gamescene/Hotbg.png")
              :pos(self.bg:getContentSize().width/2 ,self.bg:getContentSize().height/1.8)
              :addTo(self.bg)

    --头像
    self.photonumber = temp
    --昵称
    self.nickname = nil
    self.nicknamenode = nil
    self.againuserPassword = nil
    self.nicknameButbool = false
    --更改密码
    self.modifyPassword = ""
    self.everPassword = ""
    self.Passwordnode = nil
    self.PasswordButbool = false
    local tishi = display.newTTFLabel(
        { text = "更换头像",
          font = "Arial",
          size = 30,
          align = cc.ui.TEXT_ALIGN_LEFT,
          color = cc.c3b(0, 0, 0) })
        :align(display.CENTER,self.bg:getContentSize().width/2 ,self.bg:getContentSize().height/6 *4.7)
        :addTo(self.bg)

    ---------测试
    -- local uid = display.newTTFLabel(
    --     { text = "ID:"..Socketegame._ID,
    --       font = "Arial",
    --       size = 38,
    --       align = cc.ui.TEXT_ALIGN_LEFT,
    --       color = cc.c3b(255, 255, 255) })
    --     :align(display.CENTER,self.bg:getContentSize().width/3 * 2 ,self.bg:getContentSize().height/3)
    --     :addTo(self.bg)

    -----------
    local templinshi = "displaypicture/boyupdata"..temp..".png"
    self.displaypictureupdata = display.newSprite(templinshi)
    						  :pos(self.bg:getContentSize().width/2 ,self.bg:getContentSize().height/3 *1.9)
    						  :addTo(self.bg)
    --[[
    self.pv = cc.ui.UIPageView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        -- bg = "sunset.png",
        viewRect = cc.rect(80, 80, 340, 480),
        column = 3, row = 3,
        bCirc = false,
        padding = {left = 20, right = 20, top = 70, bottom = 70},
        columnSpace = 10, rowSpace = 10}
        --:onTouch(handler(self, self.touchListener))
        -- :onTouch( function (event)
        --      --dump(event, "TestUIPageViewScene - event:")
        --     local listView = event.listView
        --       if event.itemIdx then
        --       	--print(event.itemIdx)
        --         self.photonumber = event.itemIdx
        --       	self:uddatapicture(event.itemIdx)
        --       end          
        --     end)
        :pos(self.bg:getContentSize().width/18 ,self.bg:getContentSize().height/15)
        :addTo(self.bg)

    -- add items
    for i=1,9 do
        local item = self.pv:newItem()
        local content
        content = cc.LayerColor:create()
            -- cc.c4b(math.random(250),
            --     math.random(250),
            --     math.random(250),
            --     250))
        local temp = "displaypicture/boyupdata"..i..".png"
        local picture = display.newSprite(temp)
        picture:setAnchorPoint(cc.p(0,0))
        content:addChild(picture)
        content:setContentSize(90, 105)
        content:setTouchEnabled(false)
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
                  self.photonumber = i
                  self:uddatapicture(i)
              end
           end)
        self.pv:addItem(item)        
    end
    self.pv:reload()
    ]]--
    ---------------------
    local numberpicture = self.photonumber
    local leftpicture = display.newSprite("displaypicture/upgrade1.png")
        :align(display.CENTER,self.displaypictureupdata:getPositionX() - 100 ,self.bg:getContentSize().height/3 *2)
        :addTo(self.bg)
    local leftpictureisMove = false
    leftpicture:setTouchEnabled(true)
    leftpicture:setTouchSwallowEnabled(true)
    leftpicture:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  leftpictureisMove then
            return 
        end
        if event.name == "began" then
            leftpictureisMove = true
            local buyreturnsequence = transition.sequence({
                cc.ScaleTo:create(0.1,0.9,0.9),
                cc.ScaleTo:create(0.1,1.0,1.0),
                })        
            transition.execute(leftpicture,buyreturnsequence,{
                delay = 0,
                onComplete = function ()                             
                  leftpictureisMove = false
                  if numberpicture - 1 >= 1 then
                    numberpicture = numberpicture -1
                    self.photonumber = self.photonumber - 1
                  else
                    numberpicture = 9
                    self.photonumber = 9
                  end
                  self:uddatapicture(self.photonumber)
                end})        
              
        end
    end)

    local rightpicture = display.newSprite("displaypicture/upgrade0.png")
        :align(display.CENTER,self.displaypictureupdata:getPositionX() + 100 ,self.bg:getContentSize().height/3 *2)
        :addTo(self.bg)
    local rightpictureisMove = false
    rightpicture:setTouchEnabled(true)
    rightpicture:setTouchSwallowEnabled(true)
    rightpicture:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if  rightpictureisMove then
            return 
        end
        if event.name == "began" then
            rightpictureisMove = true
            local buyreturnsequence = transition.sequence({
                cc.ScaleTo:create(0.1,0.9,0.9),
                cc.ScaleTo:create(0.1,1.0,1.0),
                })        
            transition.execute(rightpicture,buyreturnsequence,{
                delay = 0,
                onComplete = function ()                             
                  rightpictureisMove = false
                  if numberpicture + 1 <= 9 then
                    numberpicture = numberpicture + 1
                    self.photonumber = self.photonumber + 1
                  else
                    numberpicture = 1
                    self.photonumber = 1
                  end
                  self:uddatapicture(self.photonumber)
                end})        
              
        end
    end)
    ---------------------

    local login = {
     normal = "gamescene/buyconfirm.png",
     pressed = "gamescene/buyconfirm.png",
     disabled = "gamescene/buyconfirm.png",
    }
    --确定按钮    
    local qutButton 
    qutButton = cc.ui.UIPushButton.new(login, {scale9 = true})
         :setButtonSize(160,80)
         :onButtonClicked(function ()       
              if self.photonumber ~= Socketegame._diaplaypictrue then
                  local sequence = transition.sequence({
                        cc.ScaleTo:create(0.1,0.9,0.9),
                        cc.ScaleTo:create(0.1,1.1,1.1),
                        cc.ScaleTo:create(0.1,1.0,1.0),
                    })
                  qutButton:runAction(sequence)
                  --发送数据
                  local taken = {}
                  taken.type = "lua"
                  --print("Session = ",Session)
                  taken.session = Session
                  taken.command = "changePhoto"
                  taken.data = self.photonumber
                  Session = Session + 1
                  Socketegame:send(PACK_AGE(taken))
                  Socketegame._diaplaypictrue = self.photonumber
                  self:getParent().dengdaijiazai = lodingwaitlayer.new()
                    :pos(0, 0)
                    :addTo(self:getParent()) 
              end                     
            end)
         :align(display.CENTER, self.bg:getContentSize().width/3 *2 ,self.bg:getContentSize().height/2.3 )
         :addTo(self.bg)

  --更换昵称
  local nicknameButtonbool = false
  local Passwordpng = {
     normal = "gamescene/upname.png",
     pressed = "gamescene/upname.png",
     disabled = "gamescene/upname.png",
    }
  local nicknameButton 
  nicknameButton = cc.ui.UIPushButton.new(Passwordpng, {scale9 = true})
         :setButtonSize(180,60)
         :onButtonClicked(function ()
            if nicknameButtonbool then
              return
            end
            local sequence = transition.sequence({
                  cc.ScaleTo:create(0.1,0.9,0.9),
                  cc.ScaleTo:create(0.1,1.1,1.1),
                  cc.ScaleTo:create(0.1,1.0,1.0),
              })
            nicknameButton:runAction(sequence)
            nicknameButtonbool = true
            self:createnickname()
            self:performWithDelay(function ()
              nicknameButtonbool = false
            end, 1)
            end)
         :align(display.CENTER, self.bg:getContentSize().width/2,self.bg:getContentSize().height/2.3)
         :addTo(self.bg)

  --更换密码Changepassword
  local PasswordButtonbool = false
  local Passwordpng = {
     normal = "gamescene/Changepassword.png",
     pressed = "gamescene/Changepassword.png",
     disabled = "gamescene/Changepassword.png",
    }
  local PasswordButton 
  PasswordButton = cc.ui.UIPushButton.new(Passwordpng, {scale9 = true})
         :setButtonSize(180,60)
         :onButtonClicked(function ()
               if PasswordButtonbool then
                 return
               end
               local sequence = transition.sequence({
                  cc.ScaleTo:create(0.1,0.9,0.9),
                  cc.ScaleTo:create(0.1,1.1,1.1),
                  cc.ScaleTo:create(0.1,1.0,1.0),
                })
               PasswordButton:runAction(sequence)
               PasswordButtonbool = true
               self:createPassword()
               self:performWithDelay(function ()
                 PasswordButtonbool = false
               end, 1)
            end)
         :align(display.CENTER, self.bg:getContentSize().width/3 ,self.bg:getContentSize().height/2.3 )
         :addTo(self.bg)

  --如果是游客
  if Socketegame._Touristbool then
    PasswordButton:setColor(cc.c4b(180,180,180,255))
    PasswordButton:setButtonEnabled(false)

    nicknameButton:setColor(cc.c4b(180,180,180,255))
    nicknameButton:setButtonEnabled(false)
  end

	local close = display.newSprite("close_btn.png")
        :align(display.CENTER_BOTTOM,self.bg:getContentSize().width/2 + 260,self.bg:getContentSize().height/2 + 150)
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
	                   delay = 0.2,
	                   onComplete = function ()

		                  self:removeFromParent()
	                    end})           
	    end
 	end)  
end


function createpicture:createnickname()
  -- self.againuserPassword
  -- local node 
    self.nicknameButbool = false
    self.nicknamenode = display.newNode()
    -----------------------------------------------------------------------  
    local loginmap = display.newSprite("But/loginbg.png")
            -- :pos(node:getContentSize().width/2,node:getContentSize().height/2)
            -- :addTo(node)
    self.nicknamenode:setTouchEnabled(true)
    self.nicknamenode:setTouchSwallowEnabled(true)
    self.nicknamenode:setContentSize(loginmap:getContentSize().width + 600,loginmap:getContentSize().height + 400)
    self.nicknamenode:ignoreAnchorPointForPosition(false)                 
    self.nicknamenode:setAnchorPoint(cc.p(0.5,0.5))
    self.nicknamenode:setPosition(display.cx , display.height + 400 )

    self:addChild(self.nicknamenode)
    
    loginmap:setPosition(self.nicknamenode:getContentSize().width/2,self.nicknamenode:getContentSize().height/2)
    self.nicknamenode:addChild(loginmap)
 
    local tishi = display.newTTFLabel(
        { text = "更换昵称",
          font = "Arial",
          size = 34,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,loginmap:getContentSize().width/2 ,loginmap:getContentSize().height/5 * 4)
        :addTo(loginmap)

    local userNICHENG = display.newSprite("dengdai/Intoroomanimation.png")
            :pos(loginmap:getContentSize().width/2 ,loginmap:getContentSize().height/5 * 3)
            :addTo(loginmap)
    local NICHENG = display.newTTFLabel(
        { text = Socketegame._NICHENG,
          font = "Arial",
          size = 30,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER, userNICHENG:getContentSize().width/2 ,userNICHENG:getContentSize().height/2)
        :addTo(userNICHENG)

    -- local againuserPassword 
    self.againuserPassword = cc.ui.UIInput.new({
        --UIInputType = 2,
        image = "mian/PasswordBox.png",
        size = cc.size(200,35),
        color = cc.c4b(0,0,0,255),
        x = loginmap:getContentSize().width/2 ,
        y = loginmap:getContentSize().height/5 * 2,
        listener = function(event)
            if event == "began" then
                
            elseif event == "ended" then
             
            elseif event == "return" then
  
            elseif event == "changed" then
                --检验密码是否过短或过长
                local str = self.againuserPassword:getText()
                local len , count = self:utfstrlan(str)
                -- print("长度",len,"中文",count)
                if count > 24 then
                  self.againuserPassword:setText("")
                  self:createtishi(0)
                  return
                end
                if len > 10 then
                  --todo
                  self.againuserPassword:setText("")
                  self:createtishi(0)
                elseif len < 1 then
                  --todo
                  self.againuserPassword:setText("")
                  self:createtishi(2)
                else
                  self.nickname = str
                end
            end
        end
    })
    self.againuserPassword:setPlaceHolder("点击修改昵称")
    -- self.againuserPassword:setInputFlag(0)
    self.againuserPassword:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self.againuserPassword:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    loginmap:addChild(self.againuserPassword)
    

    --文字提示
    -- display.newTTFLabel(
    --     { text = "输入账号",
    --       font = "Arial",
    --       size = 24,
    --       align = cc.TEXT_ALIGNMENT_CENTER,
    --       color = cc.c3b(255, 255, 255) })
    --     :align(display.CENTER,loginmap:getContentSize().width/3*2-160 ,loginmap:getContentSize().height/5 * 4)
    --     :addTo(loginmap)


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
            if self.againuserPassword:getText() == Socketegame._NICHENG then
              self:createtishi(4)
              return 
            end
            if self.nicknameButbool then
               return
            end
            if self.againuserPassword:getText() ~= "" then
                self.nicknameButbool = true
                
                local taken = {}
                taken.type = "lua"
                --print("Session = ",Session)
                taken.session = Session
                taken.command = "setNickname"
                taken.data = self.nickname 
                Session = Session + 1
                Socketegame:send(PACK_AGE(taken))
            else
               self:createtishi(2)
            end

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
              transition.execute(self.nicknamenode,sequence,{
                           delay = 0,
                           onComplete = function ()                              
                              self.nicknamenode:removeFromParent()
                              self.nicknamenode = nil
                            end})

              end)
         :align(display.LEFT_CENTER, loginmap:getContentSize().width/4 * 3 - 45, loginmap:getContentSize().height/5 )
         :addTo(loginmap)

         local sequence = transition.sequence({
            cc.MoveTo:create(0.2,cc.p(display.width/2,display.height/2) ),
            cc.ScaleTo:create(0.1,0.9,0.9),
            cc.ScaleTo:create(0.1,1.1,1.1),
            cc.ScaleTo:create(0.1,1.0,1.0),
        })        
        transition.execute(self.nicknamenode,sequence,{
                     delay = 0,
                     onComplete = function ()
                      end})
end

function createpicture:createPassword()
  -- self.againuserPassword
  -- local node 
    self.PasswordButbool = false
    self.Passwordnode = display.newNode()
    -----------------------------------------------------------------------  
    local loginmap = display.newSprite("But/loginbg.png")
            -- :pos(node:getContentSize().width/2,node:getContentSize().height/2)
            -- :addTo(node)
    self.Passwordnode:setTouchEnabled(true)
    self.Passwordnode:setTouchSwallowEnabled(true)
    self.Passwordnode:setContentSize(loginmap:getContentSize().width + 600,loginmap:getContentSize().height + 400)
    self.Passwordnode:ignoreAnchorPointForPosition(false)                 
    self.Passwordnode:setAnchorPoint(cc.p(0.5,0.5))
    self.Passwordnode:setPosition(display.cx , display.height + 400 )

    self:addChild(self.Passwordnode)
    
    loginmap:setPosition(self.Passwordnode:getContentSize().width/2,self.Passwordnode:getContentSize().height/2)
    self.Passwordnode:addChild(loginmap)
 
    local tishi = display.newTTFLabel(
        { text = "更改密码",
          font = "Arial",
          size = 34,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,loginmap:getContentSize().width/2 ,loginmap:getContentSize().height/5 * 4)
        :addTo(loginmap)

    -- local userNICHENG = display.newSprite("dengdai/Intoroomanimation.png")
    --         :pos(loginmap:getContentSize().width/2 ,loginmap:getContentSize().height/5 * 3)
    --         :addTo(loginmap)
    -- local NICHENG = display.newTTFLabel(
    --     { text = Socketegame._NICHENG,
    --       font = "Arial",
    --       size = 30,
    --       align = cc.TEXT_ALIGNMENT_CENTER,
    --       color = cc.c3b(255, 255, 255) })
    --     :align(display.CENTER, userNICHENG:getContentSize().width/2 ,userNICHENG:getContentSize().height/2)
    --     :addTo(userNICHENG)

    --更改密码
    -- self.modifyPassword = nil
    -- self.everPassword = nil

    local username
    username = cc.ui.UIInput.new({
          image = "mian/PasswordBox.png",
          linstener = nil,
          x = loginmap:getContentSize().width/2 ,
          y = loginmap:getContentSize().height/5 * 3,
          size = cc.size(200,35),
          listener = function(event, username)
            if event == "began" then
                
            elseif event == "ended" then
             
            elseif event == "return" then
              self.everPassword = username:getText()
            elseif event == "changed" then

            end
        end
       })
     username:setOpacity(240)
     --username:setFontColor(cc.c4b(0,0,0,255))
     username:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
     username:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
     username:setPlaceHolder("输入原密码")
     loginmap:addChild(username)

    local userPassword 
    userPassword = cc.ui.UIInput.new({
        --UIInputType = 2,
        image = "mian/PasswordBox.png",
        size = cc.size(200,35),
        --color = cc.c4b(0,0,0,255),
        x = loginmap:getContentSize().width/2 ,
        y = loginmap:getContentSize().height/5 * 2,
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
                  self:createtishi(7)
                elseif len >= 13 then
                  --todo
                  userPassword:setText("")
                  self:createtishi(6)
                elseif len < 6 then
                  --todo
                  userPassword:setText("")
                  self:createtishi(5)
                else
                  self.modifyPassword = userPassword:getText()
                end
            end
        end
    })
    userPassword:setPlaceHolder("输入新密码")
    userPassword:setInputFlag(0)
    userPassword:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    userPassword:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    loginmap:addChild(userPassword)
    
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
              if self.modifyPassword == "" or self.everPassword == "" then
                self:createtishi(8)
                return
              end
              if self.everPassword == self.modifyPassword then
                --密码未改变
                self:createtishi(9)
                return 
              end
              if self.PasswordButbool then
                 return
              end
              if self.modifyPassword ~= "" then
                  self.PasswordButbool = true               
                  local taken = {}
                  taken.type = "lua"
                  --print("Session = ",Session)
                  taken.session = Session
                  taken.command = "setPassword"
                  taken.data = {old = crypto.md5(self.everPassword, false) , new = crypto.md5(self.modifyPassword, false) }
                  Session = Session + 1
                  Socketegame:send(PACK_AGE(taken))
              end
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
              transition.execute(self.Passwordnode,sequence,{
                           delay = 0,
                           onComplete = function ()                              
                              self.Passwordnode:removeFromParent()
                              self.Passwordnode = nil
                            end})

              end)
         :align(display.LEFT_CENTER, loginmap:getContentSize().width/4 * 3 - 45, loginmap:getContentSize().height/5 )
         :addTo(loginmap)

         local sequence = transition.sequence({
            cc.MoveTo:create(0.2,cc.p(display.width/2,display.height/2) ),
            cc.ScaleTo:create(0.1,0.9,0.9),
            cc.ScaleTo:create(0.1,1.1,1.1),
            cc.ScaleTo:create(0.1,1.0,1.0),
        })        
        transition.execute(self.Passwordnode,sequence,{
                     delay = 0,
                     onComplete = function ()

                      end})
end

function createpicture:Closenode()
   if self.nicknamenode then
     self:getParent():createtishi(2)
     Socketegame._NICHENG = self.nickname
     self:getParent():updateusenameID((self.nickname))
     self.nicknamenode:removeFromParent()
     self.nicknamenode = nil
   end
end

function createpicture:removePasswordnode()
  if self.Passwordnode then
     self:createtishi(3)
     self.Passwordnode:removeFromParent()
     self.Passwordnode = nil
  end
end

function createpicture:Passwordnodeshibai(number)
   self.PasswordButbool = false
   self:createtishi(number)
end

function createpicture:Closeshibai(  )
   self.nicknameButbool = false
   self:createtishi(1)
   self.againuserPassword:setText("")
end

function createpicture:removeslef()
  self:removeFromParent()
end

function createpicture:uddatapicture(number)
	self.displaypictureupdata:removeFromParent()
	local temp = "displaypicture/boyupdata"..number..".png"
	self.displaypictureupdata = display.newSprite(temp)
    						  :pos(self.bg:getContentSize().width/2 ,self.bg:getContentSize().height/3 *1.9)
    						  :addTo(self.bg)
end


function createpicture:touchListener(event)
    dump(event, "TestUIPageViewScene - event:")
    local listView = event.listView
    if 3 == event.itemIdx then
    	print("sssss")
        listView:removeItem(event.item, true)
    else
        -- event.item:setItemSize(120, 80)
    end
end

function createpicture:createtishi( upormoney )

  local fruittishi = display.newSprite("fruitpic/tishi.png")
        :pos(display.cx  , display.cy )
        :addTo(self,10)

  if upormoney == 0 then
    --todo
    display.newTTFLabel(
        { text = "昵称长度超过6",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 1 then
    --todo
    display.newTTFLabel(
        { text = "昵称已存在",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 2 then
    --todo
    display.newTTFLabel(
        { text = "昵称为空",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 3 then
    --todo
    display.newTTFLabel(
        { text = "更换成功",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 4 then
    --todo
    display.newTTFLabel(
        { text = "昵称未发生改变",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 5 then
    --todo
    display.newTTFLabel(
        { text = "密码过短,需大于6",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 6 then
    display.newTTFLabel(
          { text = "密码长度超过15",
            --font = "MarkerFelt",
            size = 18,
            --align = cc.TEXT_ALIGNMENT_CENTER,
            color = cc.c3b(255,255,255) })
          :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
          :addTo(fruittishi)
  elseif upormoney == 7 then
    --todo
    display.newTTFLabel(
        { text = "不能含有中文",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 8 then
    display.newTTFLabel(
        { text = "密码为空",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 9 then
    display.newTTFLabel(
        { text = "密码未改变",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 10 then
    display.newTTFLabel(
        { text = "更换失败",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 11 then
    display.newTTFLabel(
        { text = "原密码不正确",
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

--字符串检查，和中文检查
function createpicture:utfstrlan( input )
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

return createpicture