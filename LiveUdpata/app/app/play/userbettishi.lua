
--local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
--下注消息
local  userCard = class("userCard", function ()
     return display.newNode()
end)

function userCard:ctor(type)
	--消息文本
	self.usertext = type
	self.userCard = display.newSprite("bankerbet.png")
         :align(display.CENTER_BOTTOM,0,0)
         :addTo(self)

  local besechina = {"萝卜","白菜","豌豆","南瓜","甘蔗","蘑菇","关苍术","一点红"}
  local spritetext1 = display.newTTFLabel(
        { text = self.usertext.name,
          --font = "MarkerFelt",
          size = 18,
          align = cc.TEXT_ALIGNMENT_RIGHT,
          color = cc.c3b(255,255,255) })
        --:pos(self.userCard:getContentSize().width/5, self.userCard:getContentSize().height*0.5)
        :addTo(self.userCard)
        spritetext1:setAnchorPoint(cc.p(0,0.5))
        spritetext1:setPosition(35, self.userCard:getContentSize().height*0.5)

  local pox1 = 45 + spritetext1:getContentSize().width
  
  local spritetext2 = display.newTTFLabel(
        { text = besechina[self.usertext.fruit],
          --font = "MarkerFelt",
          size = 18,
          align = cc.TEXT_ALIGNMENT_RIGHT,
          color = cc.c3b(255,255,255) })
        --:pos(self.userCard:getContentSize().width/5 *2 , self.userCard:getContentSize().height*0.5)
        :addTo(self.userCard)
        spritetext2:setAnchorPoint(cc.p(0,0.5))
        spritetext2:setPosition(pox1, self.userCard:getContentSize().height*0.5)
  local pox2 = pox1 + 10 + spritetext2:getContentSize().width
  local spritetext3 = display.newTTFLabel(
        { text = "金额："..(self.usertext.money),
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_RIGHT,
          color = cc.c3b(255,255,255) })
        --:pos(self.userCard:getContentSize().width/5 * 3, self.userCard:getContentSize().height*0.5)
        :addTo(self.userCard)
        spritetext3:setAnchorPoint(cc.p(0,0.5))
        spritetext3:setPosition( pox2, self.userCard:getContentSize().height*0.5)

  self:setContentSize(self.userCard:getContentSize())
  self:setAnchorPoint (cc.p(0.5,0.5))
end

function userCard:init()
	if #self:getParent().myuserCard < 4 then
      	transition.moveTo(self, {x = display.cx  , y = 110 + #self:getParent().myuserCard * 25, time = 0.1})
       	--加入队列中
       	table.insert(self:getParent().myuserCard,self)
  else
      --移除
      local No1myuserCard = table.remove(self:getParent().myuserCard,1)
      No1myuserCard:removeFromParent()
      for i = 1 , 3 do
          if self:getParent().myuserCard[i] then
             transition.moveBy(self:getParent().myuserCard[i], {x = 0, y = -25, time = 0.1})                               
          end
      end 
      transition.moveTo(self, {x = display.cx , y = 110 + #self:getParent().myuserCard * 25, time = 0.1})
     	--加入队列中
     	table.insert(self:getParent().myuserCard,self)                                                                   
	end
end

function userCard:removetishi()
  self:removeFromParent()
end

return userCard