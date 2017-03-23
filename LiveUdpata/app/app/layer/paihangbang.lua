
--排行榜界面
local paihangbang = class("paihangbang", function()
	return display.newNode()
end)

function paihangbang:ctor(value)

	--两个都不给点击
    self.inMove = false

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(150)

    -- local bgsprire = display.newSprite("dengdai/bg4.png")
    local bgsprire = display.newSprite("gamescene/rankinglist.png")
    bgsprire:setPosition(self.bg:getContentSize().width/2,self.bg:getContentSize().height/2-10)
    self.bg:addChild(bgsprire)

    self.lv = cc.ui.UIListView.new {
        --bg = "dengdai/dengdaibg.png",
        bgScale9 = true,
        viewRect = cc.rect(0.5, 0.5, 400, 200),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        --scrollbarImgV = "bar.png"
        }
    --self.lv:ignoreAnchorPointForPosition(false) 
    --self.lv:setAnchorPoint(cc.p(0.5,0.5))
    self.lv:setPosition(self.bg:getContentSize().width/2 - 200 + 81,self.bg:getContentSize().height/2 - 90 - 62)
    self.bg:addChild(self.lv)
    --for i,fruit in ipairs(self.luckyrecord) do
        --local item = self.lv:newItem()
        --local content      
        --content = display.newSprite("ziti.png")
        --item:addContent(content)
        --item:setItemSize(450, 1200)
        --self.lv:addItem(item)
    --end
    --sself.lv:reload()

    local imagesdaybang
    local moneydaybang
    local moneyzhongbang
    self.opendaybang = false
    self.openzhongbang = true
    local imageszhongbang = {
       -- on = "dengdai/preenor.png",
       -- off = "dengdai/normal.png",
       on = "gamescene/allrankingclose.png",
       off = "gamescene/allrankingopen.png",
       }
    moneyzhongbang = cc.ui.UICheckBoxButton.new(imageszhongbang)
        --:onButtonStateChanged(
        :setButtonSelected(true)
        :onButtonClicked(function ()
        --:onButtonStateChanged(function (event)
        
            moneyzhongbang:setButtonSelected(not moneyzhongbang:isButtonSelected())            
            if self.isMove then
                moneyzhongbang:setButtonSelected(not moneyzhongbang:isButtonSelected())
                return true
            end
            if self.openzhongbang then
                moneyzhongbang:setButtonSelected(true)
                return true
            end
            if next(Socketegame._zhongbanglvitem) ~= nil then
                print("重磅")
                if next(self.lv.items_) ~= nil then
                    self.lv:removeAllItems()
                end
                --self.lv:removeAllItems()
                if self.personalsprire then
                    self.personalsprire:removeFromParent()
                end
                 
                self:addzhongbanglvitem(Socketegame._zhongbanglvitem)

                self.openzhongbang = true
                self.opendaybang = false
                
                moneydaybang:setButtonSelected(false)
                moneyzhongbang:setButtonSelected(true)
                --self.personalsprire:removeFromParent() 
                return true
            end 
  
            self.openzhongbang = true
            self.opendaybang = false 

            if next(self.lv.items_) ~= nil then
                self.lv:removeAllItems()
            end
            if self.personalsprire then
                self.personalsprire:removeFromParent()
            end
            --self:adddaybanglvitem({5,8,6,4,2,9})
            self:addlodinganimation()
            local age = {cmd = "getTotalyRank"}
            SEND(age)

            moneydaybang:setButtonSelected(false)
            moneyzhongbang:setButtonSelected(true)
        end)
        :align(display.LEFT_CENTER, self.bg:getContentSize().width/2 - 355,self.bg:getContentSize().height/2 - 60)
        :addTo(self.bg)

    imagesdaybang = {
       -- off = "dengdai/daymoneynor.png",
       -- on = "dengdai/daymoneypree.png",
       off = "gamescene/dayrankingopen.png",
       on = "gamescene/dayrankingclose.png",
       }
    moneydaybang = cc.ui.UICheckBoxButton.new(imagesdaybang)
        --:setButtonSelected(true)
        :onButtonClicked(function ()
            if self.inMove  then
                moneydaybang:setButtonSelected(not moneydaybang:isButtonSelected())
                return true
            end
            if self.opendaybang then
                moneydaybang:setButtonSelected(true)
                return true
            end
            if next(Socketegame._daybanglvitem) ~= nil then
                --print("天磅")
                if next(self.lv.items_) ~= nil then
                    -- print("ddddd")
                    self.lv:removeAllItems()
                end
                if self.personalsprire then
                    self.personalsprire:removeFromParent()
                end
                self:adddaybanglvitem(Socketegame._daybanglvitem)
                self.opendaybang = true 
                self.openzhongbang = false 
                
                moneyzhongbang:setButtonSelected(false)
                moneydaybang:setButtonSelected(true)
                -- self.personalsprire:removeFromParent()
                return true
            end
            self.opendaybang = true 
            self.openzhongbang = false
            if next(self.lv.items_) ~= nil then
                -- print("ddddd")
                self.lv:removeAllItems()
            end
            if self.personalsprire then
                self.personalsprire:removeFromParent()
            end 
            -- self.personalsprire:removeFromParent()
            --self:adddaybanglvitem({5,8,6,4,2,9,5,4,8,96,6,1,5,8,6,2})
            self:addlodinganimation()
            local age = {cmd = "getDailyRank"}
            SEND(age)

            moneyzhongbang:setButtonSelected(false)
            moneydaybang:setButtonSelected(true)
        
        end)
        :align(display.LEFT_CENTER, self.bg:getContentSize().width/2  - 355,self.bg:getContentSize().height/2 + 20)
        :addTo(self.bg)

    --moneyzhongbang:setButtonEnabled(false)
    --moneydaybang:setButtonEnabled(true)
    --self.bg:addChild(self.lv)

    local close = display.newSprite("gamescene/close_btn.png")
        :align(display.CENTER_BOTTOM,self.bg:getContentSize().width/2 + 300,self.bg:getContentSize().height/2 + 140)
        :addTo(self.bg)
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

    ---添加加载动画
    --self:addlodinganimation()
    --吞噬事件
    --self:addtunshi()
    --self:addzhongbanglvitem({5,4,8,6,2,4})

    if next(Socketegame._zhongbanglvitem) ~= nil then
        if next(self.lv.items_) ~= nil then
            -- print("ddddd")
            self.lv:removeAllItems()
        end
        --self.personalsprire:removeFromParent() 
        self:addzhongbanglvitem(Socketegame._zhongbanglvitem)
        self.openzhongbang = true
        self.opendaybang = false      
        moneydaybang:setButtonSelected(false)
        moneyzhongbang:setButtonSelected(true)      
    else
        self:addlodinganimation()
        local age = {cmd = "getTotalyRank"}
        SEND(age) 
    end 
     
end

function paihangbang:addlodinganimation()
	display.addSpriteFrames("dengdai/loding.plist", "dengdai/loding.png")
	self.animationsprite = display.newSprite("#loding01.png")
	self.animationsprite:setPosition(self.bg:getContentSize().width/2 ,self.bg:getContentSize().height/2 )
    self.bg:addChild(self.animationsprite)
    --display.setAnimationCache(animKey,animation)
	local frames = display.newFrames("loding%02d.png", 1, 12)
	local animation = display.newAnimation(frames, 1 / 12) -- 0.5 秒播放 8 桢
	self.animationsprite:playAnimationForever(animation) -- 播放一次动画
end

function paihangbang:removeChildformself()
   self.animationsprite:removeFromParent() 
end

function paihangbang:addtunshi()
	self.tunshi = display.newSprite("dengdai/tunshi.png")
        :align(display.LEFT_CENTER,self.bg:getContentSize().width/2 - 200,self.bg:getContentSize().height/2 + 223)
        :addTo(self.bg,24)
    --self.tunshi:setOpacity(0)
  	--local isMove = false
  	self.tunshi:setTouchEnabled(true)
  	self.tunshi:setTouchSwallowEnabled(true)
end

function paihangbang:addtunshizuobian()
    --self.tunshizuobian = nil
    print("左边")
    self.tunshizuobian = display.newSprite("dengdai/normal.png")
        :align(display.LEFT_CENTER,self.bg:getContentSize().width/2 - 200,self.bg:getContentSize().height/2 + 223)
        :addTo(self,21)
    self.tunshizuobian:setOpacity(0)
    --local isMove = false
    self.tunshizuobian:setTouchEnabled(true)
    self.tunshizuobian:setTouchSwallowEnabled(true)
    self.tunshizuobian:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
    end)
end

function paihangbang:addtunshiyoubian()
    --self.tunshiyoubian = nil
    print("右边")
    self.tunshiyoubian = display.newSprite("dengdai/daymoneynor.png")
        :align(display.LEFT_CENTER , self.bg:getContentSize().width/2 + 2,self.bg:getContentSize().height/2 + 223)
        :addTo(self,22)
    self.tunshiyoubian:setOpacity(0)
    --local isMove = false
    self.tunshiyoubian:setTouchEnabled(true)
    self.tunshiyoubian:setTouchSwallowEnabled(true)
    self.tunshiyoubian:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
    end)
end

----每日榜单
function paihangbang:adddaybanglvitem(value)
 
    self.personalsprire = display.newSprite("dengdai/personal.png")
    self.personalsprire:setPosition(self.bg:getContentSize().width/2 + 81,self.bg:getContentSize().height/3 -10 - 59)
    self.bg:addChild(self.personalsprire)

	for i,v in ipairs(value) do
        if i == 1 then
            local personaltext1 = display.newTTFLabel(
                { text = v.user_dayly_name,
                  --font = "MarkerFelt",
                  size = 18,
                  align = cc.TEXT_ALIGNMENT_RIGHT,
                  color = cc.c3b(255,255,255) })      
                --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
                    :align(display.LEFT_CENTER,43, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext1)

            local personaltext2 = display.newTTFLabel(
                { text = v.user_dayly,
                  --font = "MarkerFelt",
                  size = 18,
                  align = cc.TEXT_ALIGNMENT_RIGHT,
                  color = cc.c3b(255,255,255) })      
                --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
                    :align(display.LEFT_CENTER,self.personalsprire:getContentSize().width/2, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext2)
            if v.rank == 1000 then
                v.rank = "-"
            end
            local personaltext3
            if v.rank == 1 then
                personaltext3 = display.newSprite("dengdai/No1.png")
                personaltext3:setAnchorPoint(cc.p(0.5,0.5))
                personaltext3:setPosition(20, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext3)
            elseif v.rank == 2 then
                personaltext3 = display.newSprite("dengdai/No2.png")
                personaltext3:setAnchorPoint(cc.p(0.5,0.5))
                personaltext3:setPosition(20, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext3)
            elseif v.rank == 3 then
                personaltext3 = display.newSprite("dengdai/No3.png")
                personaltext3:setAnchorPoint(cc.p(0.5,0.5))
                personaltext3:setPosition(20, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext3)
            else
                personaltext3 = display.newTTFLabel(
                { text = v.rank ,
                  --font = "MarkerFelt",
                  size = 22,
                  align = cc.TEXT_ALIGNMENT_RIGHT,
                  color = cc.c3b(255,255,255) })
                personaltext3:setAnchorPoint(cc.p(0.5,0.5))
                personaltext3:setPosition(20, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext3)
            end
            
        else
            local item = self.lv:newItem()
            local content
            local sprite  
            local spritetext1
            local spritetext3    
            content = cc.LayerColor:create()
                -- cc.c4b(math.random(250),
                --     math.random(250),
                --     math.random(250),
                --     250))
            content:setContentSize(350, 40)
            content:ignoreAnchorPointForPosition(false)
            content:setAnchorPoint(cc.p(0.5,0.5))

            sprite = display.newSprite("dengdai/paihangbangbar.png")
            sprite:setPosition(content:getContentSize().width/2, content:getContentSize().height/2)
            content:addChild(sprite)

            spritetext1 = display.newTTFLabel(
            { text = v.user_dayly_name,
              --font = "MarkerFelt",
              size = 18,
              align = cc.TEXT_ALIGNMENT_RIGHT,
              color = cc.c3b(255,255,255) })      
            --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
                :align(display.LEFT_CENTER,43, content:getContentSize().height/2)
            content:addChild(spritetext1)

            spritetext2 = display.newTTFLabel(
            { text = v.user_dayly,
              --font = "MarkerFelt",
              size = 18,
              align = cc.TEXT_ALIGNMENT_RIGHT,
              color = cc.c3b(255,255,255) })      
            --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
                :align(display.LEFT_CENTER,content:getContentSize().width/2, content:getContentSize().height/2)
            content:addChild(spritetext2)


            if v.rank == 1 then
                spritetext3 = display.newSprite("dengdai/No1.png")
                spritetext3:setAnchorPoint(cc.p(0.5,0.5))
                spritetext3:setPosition(20, content:getContentSize().height/2)
                content:addChild(spritetext3)
            elseif v.rank == 2 then
                spritetext3 = display.newSprite("dengdai/No2.png")
                spritetext3:setAnchorPoint(cc.p(0.5,0.5))
                spritetext3:setPosition(20, content:getContentSize().height/2)
                content:addChild(spritetext3)
            elseif v.rank == 3 then
                spritetext3 = display.newSprite("dengdai/No3.png")
                spritetext3:setAnchorPoint(cc.p(0.5,0.5))
                spritetext3:setPosition(20, content:getContentSize().height/2)
                content:addChild(spritetext3)
            else
                spritetext3 = display.newTTFLabel(
                { text = v.rank ,
                  --font = "MarkerFelt",
                  size = 22,
                  align = cc.TEXT_ALIGNMENT_RIGHT,
                  color = cc.c3b(255,255,255) })
                spritetext3:setAnchorPoint(cc.p(0.5,0.5))
                spritetext3:setPosition(20, content:getContentSize().height/2)
                content:addChild(spritetext3)
            end

            item:addContent(content)
            item:setItemSize(350,40)
            self.lv:addItem(item)
        end
    end
    self.lv:reload()

    

    
end

----金币总榜
function paihangbang:addzhongbanglvitem(value)


    self.personalsprire = display.newSprite("dengdai/personal.png")
    self.personalsprire:setPosition(self.bg:getContentSize().width/2 + 81,self.bg:getContentSize().height/3 -10 - 59)
    self.bg:addChild(self.personalsprire)

    for i,v in ipairs(value) do
        if i == 1 then
            local personaltext1 = display.newTTFLabel(
                { text = v.user_total_name,
                  --font = "MarkerFelt",
                  size = 18,
                  align = cc.TEXT_ALIGNMENT_RIGHT,
                  color = cc.c3b(255,255,255) })      
                --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
                    :align(display.LEFT_CENTER,43, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext1)

            local personaltext2 = display.newTTFLabel(
                { text = v.user_total,
                  --font = "MarkerFelt",
                  size = 18,
                  align = cc.TEXT_ALIGNMENT_RIGHT,
                  color = cc.c3b(255,255,255) })      
                --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
                    :align(display.LEFT_CENTER,self.personalsprire:getContentSize().width/2, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext2)
            if v.rank == 1000 then
                v.rank = "-"
            end
            local personaltext3
            if v.rank == 1 then
                personaltext3 = display.newSprite("dengdai/No1.png")
                personaltext3:setAnchorPoint(cc.p(0.5,0.5))
                personaltext3:setPosition(20, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext3)
            elseif v.rank == 2 then
                personaltext3 = display.newSprite("dengdai/No2.png")
                personaltext3:setAnchorPoint(cc.p(0.5,0.5))
                personaltext3:setPosition(20, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext3)
            elseif v.rank == 3 then
                personaltext3 = display.newSprite("dengdai/No3.png")
                personaltext3:setAnchorPoint(cc.p(0.5,0.5))
                personaltext3:setPosition(20, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext3)
            else
                personaltext3 = display.newTTFLabel(
                { text = v.rank ,
                  --font = "MarkerFelt",
                  size = 22,
                  align = cc.TEXT_ALIGNMENT_RIGHT,
                  color = cc.c3b(255,255,255) })
                personaltext3:setAnchorPoint(cc.p(0.5,0.5))
                personaltext3:setPosition(20, self.personalsprire:getContentSize().height/2)
                self.personalsprire:addChild(personaltext3)
            end
        else
            local item = self.lv:newItem()
            local content
            local sprite  
            local spritetext1
            local spritetext3    
            content = cc.LayerColor:create()
                -- cc.c4b(math.random(250),
                --     math.random(250),
                --     math.random(250),
                --     250))
            content:setContentSize(350, 40)
            content:ignoreAnchorPointForPosition(false)
            content:setAnchorPoint(cc.p(0.5,0.5))

            sprite = display.newSprite("dengdai/paihangbangbar.png")
            sprite:setPosition(content:getContentSize().width/2, content:getContentSize().height/2)
            content:addChild(sprite)

            spritetext1 = display.newTTFLabel(
            { text = v.user_total_name,
              --font = "MarkerFelt",
              size = 18,
              align = cc.TEXT_ALIGNMENT_RIGHT,
              color = cc.c3b(255,255,255) })      
            --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
                :align(display.LEFT_CENTER,43, content:getContentSize().height/2)
            content:addChild(spritetext1)

            spritetext2 = display.newTTFLabel(
            { text = v.user_total,
              --font = "MarkerFelt",
              size = 18,
              align = cc.TEXT_ALIGNMENT_RIGHT,
              color = cc.c3b(255,255,255) })      
            --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
                :align(display.LEFT_CENTER,content:getContentSize().width/2, content:getContentSize().height/2)
            content:addChild(spritetext2)

            if v.rank == 1 then
                spritetext3 = display.newSprite("dengdai/No1.png")
                spritetext3:setAnchorPoint(cc.p(0.5,0.5))
                spritetext3:setPosition(20, content:getContentSize().height/2)
                content:addChild(spritetext3)
            elseif v.rank == 2 then
                spritetext3 = display.newSprite("dengdai/No2.png")
                spritetext3:setAnchorPoint(cc.p(0.5,0.5))
                spritetext3:setPosition(20, content:getContentSize().height/2)
                content:addChild(spritetext3)
            elseif v.rank == 3 then
                spritetext3 = display.newSprite("dengdai/No3.png")
                spritetext3:setAnchorPoint(cc.p(0.5,0.5))
                spritetext3:setPosition(20, content:getContentSize().height/2)
                content:addChild(spritetext3)
            else
                spritetext3 = display.newTTFLabel(
                { text = v.rank ,
                  --font = "MarkerFelt",
                  size = 22,
                  align = cc.TEXT_ALIGNMENT_RIGHT,
                  color = cc.c3b(255,255,255) })
                spritetext3:setAnchorPoint(cc.p(0.5,0.5))
                spritetext3:setPosition(20, content:getContentSize().height/2)
                content:addChild(spritetext3)
            end

            item:addContent(content)
            item:setItemSize(350,40)
            self.lv:addItem(item)
        end
    end
    self.lv:reload()

    -- self.personalsprire = display.newSprite("dengdai/personal.png")
    -- self.personalsprire:setPosition(self.bg:getContentSize().width/2,self.bg:getContentSize().height/3 -10)
    -- self.bg:addChild(self.personalsprire)

    
end

return paihangbang