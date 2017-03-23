

local schedule = require(cc.PACKAGE_NAME .. ".scheduler")

--等待预加载界面
local lodingwait = class("lodingwait", function()
	return display.newNode()
end)

function lodingwait:ctor(value,failure,login)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(150)

    -- if conditions then
    --   --todo
    -- end
    self:addlodingwaitanimation()

    if value then
       self:addtextloding() 
    end
    if failure then
      self:createnickname()
    end
    if login then
      self:reslogin()
    end
end

function lodingwait:removeselfformparent()
    self:removeFromParent()
end

function lodingwait:addlodingwaitanimation()
    display.addSpriteFrames("banker/lodingwait.plist", "banker/lodingwait.png")
    local sprite = display.newSprite("#lodingwait01.png")
    sprite:setPosition(self.bg:getContentSize().width/2 ,self.bg:getContentSize().height/2 )
    self.bg:addChild(sprite)
    --display.setAnimationCache(animKey,animation)
    local frames = display.newFrames("lodingwait%02d.png", 1, 12)
    local animation = display.newAnimation(frames, 1 / 12) -- 0.5 秒播放 8 桢
    sprite:playAnimationForever(animation) -- 播放一次动画
end

function lodingwait:addtextloding()
    local lodingtext = display.newTTFLabel(
        { text = "断线重新连接中...",
          font = "Arial",
          size = 25,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        :align(display.CENTER,self.bg:getContentSize().width/2 ,self.bg:getContentSize().height/2 - 150)
        :addTo(self.bg)
end

function lodingwait:createnickname()
    Socketegame._Touristbool = false
    
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

    local node
    node = display.newNode()
    -----------------------------------------------------------------------  
    local loginmap = display.newSprite("mian/loginbg.png")
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
 
    local tishi = display.newTTFLabel(
        { text = "该账号在别的地方登录",
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
           local sequence = transition.sequence({
              cc.ScaleTo:create(0.05,0.9,0.9),
              cc.ScaleTo:create(0.05,1.1,1.1),
              cc.ScaleTo:create(0.05,0.3,0.3),
              })        
              transition.execute(node,sequence,{
                           delay = 0,
                           onComplete = function ()                              
                              -- node:removeFromParent()
                              -- self:getParent():chaoshifun()                              
                              -- --回到登录界面
                              -- NUMBERSendMove = 1       
                              -- local cutmainscene= mainscene.new()
                              -- display.replaceScene(cutmainscene,"fade",1)
                              --断开服务器连接
                              self:performWithDelay(function ()
                                cc.Director:getInstance():endToLua()
                                end , 0.2) 
                            end})

              end)
         :align(display.CENTER, loginmap:getContentSize().width/2 , loginmap:getContentSize().height/5 )
         :addTo(loginmap)

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

function lodingwait:reslogin()

    Socketegame._Touristbool = false

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

    local node
    node = display.newNode()
    -----------------------------------------------------------------------  
    local loginmap = display.newSprite("mian/loginbg.png")
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
 
    local tishi = display.newTTFLabel(
        { text = "掉线了,请重新登录",
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
           local sequence = transition.sequence({
              cc.ScaleTo:create(0.05,0.9,0.9),
              cc.ScaleTo:create(0.05,1.1,1.1),
              cc.ScaleTo:create(0.05,0.3,0.3),
              })        
              transition.execute(node,sequence,{
                           delay = 0,
                           onComplete = function ()                              
                              -- node:removeFromParent()
                              self:getParent():chaoshifun()                              
                              --回到登录界面
                              NUMBERSendMove = 1       
                              local cutmainscene= mainscene.new()
                              display.replaceScene(cutmainscene,"fade",1)
                            end})
              end)
         :align(display.CENTER, loginmap:getContentSize().width/2 , loginmap:getContentSize().height/5 )
         :addTo(loginmap)

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


return lodingwait