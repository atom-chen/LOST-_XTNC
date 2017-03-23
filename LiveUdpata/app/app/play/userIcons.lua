
--用户动态更新界面
local userIcons = class("userIcons", function()
	return display.newNode()
end)

function userIcons:ctor(Viewvalue)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)    
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(0)

    self.usertable = {}

    self.userIconsItems_ = {}
    self.lv = cc.ui.UIListView.new {
        -- bg = "dengdai/dengdaibg.png",
        bgScale9 = true,
        viewRect = cc.rect(5, 5, 100, 250),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        -- scrollbarImgV = "bar.png",
        }
    
    --self.lv:ignoreAnchorPointForPosition(false) 
    --self.lv:setAnchorPoint(cc.p(0.5,0.5))
    self.lv:setPosition(self.bg:getContentSize().width - 100,self.bg:getContentSize().height/2 - 50)
    self.bg:addChild(self.lv) 

    -- self:updatenewItem()
    if Viewvalue then
        for i,v in ipairs(Viewvalue) do
            local item = self.lv:newItem()
            local content
            local sprite  
            local spritetext1
            content = cc.LayerColor:create()
                -- cc.c4b(math.random(250),
                --     math.random(250),
                --     math.random(250),
                --     250))
            content:setContentSize(85, 40)
            content:ignoreAnchorPointForPosition(false)
            content:setAnchorPoint(cc.p(0.5,0.5))

            sprite = display.newSprite("dengdai/paihangbangbar1.png")
            sprite:setPosition(content:getContentSize().width/2, content:getContentSize().height/2)
            content:addChild(sprite)
            sprite:setOpacity(155)

            spritetext1 = display.newTTFLabel(
            { text = v,
              --font = "MarkerFelt",
              size = 12,
              align = cc.TEXT_ALIGNMENT_RIGHT,
              color = cc.c3b(255,255,255) })      
            --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
                :align(display.LEFT_CENTER,5, content:getContentSize().height/2)
            content:addChild(spritetext1)
            item:addContent(content)
            item:setItemSize(85,40)

            table.insert(self.userIconsItems_ , spritetext1)    
            self.lv:addItem(item)
        end
        self.lv:reload()
    end

end


function userIcons:updatenewItem(value)
  
    local item = self.lv:newItem()
    local content
    local sprite  
    local spritetext1
    content = cc.LayerColor:create()
        -- cc.c4b(math.random(250),
        --     math.random(250),
        --     math.random(250),
        --     250))
    content:setContentSize(85, 40)
    content:ignoreAnchorPointForPosition(false)
    content:setAnchorPoint(cc.p(0.5,0.5))

    sprite = display.newSprite("dengdai/paihangbangbar1.png")
    sprite:setPosition(content:getContentSize().width/2, content:getContentSize().height/2)
    content:addChild(sprite)
    sprite:setOpacity(155)
    spritetext1 = display.newTTFLabel(
    { text = value,
      --font = "MarkerFelt",
      size = 12,
      align = cc.TEXT_ALIGNMENT_RIGHT,
      color = cc.c3b(255,255,255) })      
    --spritetext1:setAnchorPoint(cc.p(0.5,0.5))
        :align(display.LEFT_CENTER,5, content:getContentSize().height/2)
    content:addChild(spritetext1)
    item:addContent(content)
    item:setItemSize(85,40)
    table.insert(self.userIconsItems_ , spritetext1)    
    self.lv:addItem(item)
    -- self.lv:elasticScroll()
    self.lv:reload()
end

function userIcons:deletequeue(name)
  if next(self.usertable) ~= nil then  
    table.insert(self.usertable,name)
  else
    table.insert(self.usertable,name)
    self:opendeletefun()
  end
end

function userIcons:opendeletefun()
    local deleteschedule 
    deleteschedule = self:schedule(function ()
      local No1userIcons = table.remove(self.usertable,1)
      local tmep = self:getspritetext1Pos(No1userIcons)
      if tmep then
        self:deletenewItem(tmep)
        self:Intoroomanimation(No1userIcons,1)
        self:getParent().probabilitynumber:setString(self:getParent().probabilitynumber:getString() - 1)    
        if next(self.usertable) == nil then
          transition.removeAction(deleteschedule)
        end
      end
    end, 0.5)
end

function userIcons:deletenewItem(pos)
    if next(self.lv.items_) ~= nil then
        self.lv:removeItem(self.lv.items_[pos],false)
    end
    table.remove(self.userIconsItems_ , pos)
end

function userIcons:getspritetext1Pos(value)
    for i,v in ipairs(self.userIconsItems_) do
        if v:getString() == value then
            return i
        end       
    end
    return false
end

function userIcons:Intoroomanimation(name,upormoney)
    local fruittishi = display.newSprite("dengdai/Intoroomanimation.png")
    fruittishi:setPosition(self.bg:getContentSize().width/6 * 4.8, self.bg:getContentSize().height/2)
    self.bg:addChild(fruittishi)
    local height
    if name then
        display.newTTFLabel(
            { text = name,
              -- font = "MarkerFelt",
              size = 24,
              --align = cc.TEXT_ALIGNMENT_CENTER,
              color = cc.c3b(0,0,0) })
            :pos(fruittishi:getContentSize().width *0.47, fruittishi:getContentSize().height/4 * 2.8)
            :addTo(fruittishi)
    end 
    if upormoney == 0 then
        display.newTTFLabel(
            { text = "进入房间",
              --font = "MarkerFelt",
              size = 20,
              --align = cc.TEXT_ALIGNMENT_CENTER,
              color = cc.c3b(227,23,13) })
            :pos(fruittishi:getContentSize().width/3 *2, fruittishi:getContentSize().height/4)
            :addTo(fruittishi)
        height = 100
    elseif upormoney == 1 then
        display.newTTFLabel(
            { text = "退出房间",
              --font = "MarkerFelt",
              size = 20,
              --align = cc.TEXT_ALIGNMENT_CENTER,
              color = cc.c3b(227,23,13) })
            :pos(fruittishi:getContentSize().width/3 * 2, fruittishi:getContentSize().height/4)
            :addTo(fruittishi)
        height = -100
    end
    local sequence1 = transition.sequence({
                      cc.MoveBy:create(0.5, cc.p(0, -height)),
                      cc.ScaleTo:create(0.1,0.9,0.9),
                      cc.ScaleTo:create(0.1,1.0,1.0),
                      cc.ScaleTo:create(0.1,0.2,0.2),
                      })
    transition.execute(fruittishi,sequence1,{
                           delay = 0,
                           onComplete = function ()
                                fruittishi:removeFromParent()
                            end})

end



return userIcons