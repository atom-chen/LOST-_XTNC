


local playcars = class("playcars", function ()
	-- body
	--print("fruitBase")
	return display.newNode()
end)


function playcars:ctor(path,money)
   

   --初始金币
   self.Amount = money
   self.bankerLine = "0"
   self.playbankerLine = nil
   	--创建精灵
    local fruitBasepath = path..".png"
    --print(fruitBasepath)
    self.playcars = display.newSprite(fruitBasepath)
    		:align(display.LEFT_BOTTOM,0,0)
    		:addTo(self)
    self.playcars:setScale(0.88)
    self.playcars:setScaleX(0.8)
    self:setContentSize(cc.size(self.playcars:getContentSize().width, self.playcars:getContentSize().height))
    self:setAnchorPoint(cc.p(0.5,0.5))
    self:addtext()
end

function playcars:addtext()
  
	local temp = "displaypicture/boy"..Socketegame._diaplaypictrue..".png"
  self.fruit = display.newSprite(temp)
        :pos(self.playcars:getContentSize().width/5 * 3.9 , self.playcars:getContentSize().height/2)
        :addTo(self.playcars)
  
  self.playAmount = display.newTTFLabel(
        { text = self.Amount,
          font = "Arial",
          size = 26,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = ttfColor })
        --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
        :align(display.LEFT_CENTER,self.playcars:getContentSize().width /3.6, self.playcars:getContentSize().height/6.1)
        :addTo(self.playcars)
   
    local name = display.newTTFLabel(
        { text = Socketegame._NICHENG,
          font = "Arial",
          size = 26,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
        :align(display.CENTER,self.playcars:getContentSize().width/2, self.playcars:getContentSize().height * 0.85  )
        :addTo(self.playcars)

    local fruitpictureBase = display.newTTFLabel(
        { text = "金币:",
          font = "Arial",
          size = 26,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
        :align(display.LEFT_CENTER,self.playcars:getContentSize().width /15, self.playcars:getContentSize().height/6 )
        :addTo(self.playcars)

    self.scoretext = display.newTTFLabel(
        { text = "成绩:".."0",
          font = "Arial",
          size = 26,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255, 255, 255) })
        --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
        :align(display.LEFT_CENTER,self.playcars:getContentSize().width /15, self.playcars:getContentSize().height/1.6 )
        :addTo(self.playcars)

end

function playcars:addline()
  self.playbankerLine = display.newTTFLabel(
    { text = "",
      font = "Arial",
      size = 26,
      align = cc.TEXT_ALIGNMENT_CENTER,
      color = display.COLOR_RED })
    --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
    :pos(self.playcars:getContentSize().width /3.2, self.playcars:getContentSize().height/2.6)
    :addTo(self.playcars)
end

function playcars:addEnergy(money)
	-- body
  Socketegame._MONEY = Socketegame._MONEY + money
  self.Amount= self.Amount + money
	self.playAmount:setString(self.Amount)
end

function playcars:loseEnergy(money)
	-- body
  --更新玩家金币数量
  Socketegame._MONEY = Socketegame._MONEY - money
  self.Amount= self.Amount - money
	self.playAmount:setString(self.Amount)
end

function playcars:updateplaymoney(money)
  --一把结算更新玩家金币
  Socketegame._MONEY = money
  self.Amount= money
  self.playAmount:setString(self.Amount)
end

function playcars:setplaybankerLine(Line)
  --
  self.playbankerLine:setString("排庄:".."第"..(Line).."位")
end

function playcars:removeplaybankerLine()
  if not self.playbankerLine then
    return
  end
  -- self.playcars:removeChild(self.playbankerLine)
  self.playbankerLine:removeFromParent()
  self.playbankerLine = nil
end

function playcars:setscore(value)
  self.scoretext:setString("成绩:"..value)
end

return playcars
