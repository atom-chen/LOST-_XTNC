

--结算界面
local Clearinglayer = class("Clearinglayer", function()
	return display.newNode()
end)

function Clearinglayer:ctor(value,jieguo,banker)

    --self.createUse = nil
    --self.isfun = 2
    --self.createusebool = true
    --获得金币
    self.allmoney = 0
    --吞噬事件
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    
    self.Clear = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.Clear:ignoreAnchorPointForPosition(false)                 
    self.Clear:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.Clear)
    self.Clear:setOpacity(150)


    local spr = display.newSprite("clear.png")
    		:align(display.BOTTOM_CENTER,self.Clear:getContentSize().width/2,self.Clear:getContentSize().height/3)
    		:addTo(self.Clear)
    --self.fruitpic:setScale(1)
    
    local fruittextpox = self.Clear:getContentSize().width /2
    local fruittextpoy = self.Clear:getContentSize().height/5
    
    local allclearmoney = 0
    if not banker then
      --如果不是庄家
      for i,v in ipairs(value) do
        --print(i,v)
        if i ~= #value then
            --todo
            if i ~= value[#value] then
              --todo
              value[i] = -v
              allclearmoney = allclearmoney - v
            else
              --todo
              allclearmoney = allclearmoney + v
            end
        end
      end
    else
      --庄家
      for i,v in ipairs(value) do
        --print(i,v)
        if i ~= #value then
            --todo
            if i ~= value[#value] then
              --todo
              --value[i] = v
              allclearmoney = allclearmoney + v
            else
              --todo
              value[i] = -v
              allclearmoney = allclearmoney - v
            end
        end
      end
      self.allmoney = allclearmoney
    end
    

    --萝卜
    self:setfruittext(value[1],fruittextpox - 70,4*fruittextpoy -30)
    
    --白菜
    self:setfruittext(value[2],fruittextpox + 130,4*fruittextpoy -30)
    
    --豌豆
    self:setfruittext(value[3],fruittextpox - 70,4*fruittextpoy - 75)
    
    --南瓜
    self:setfruittext(value[4],fruittextpox + 130,4*fruittextpoy -75)

    --甘蔗
    self:setfruittext(value[5],fruittextpox - 70,4*fruittextpoy - 120)

    --蘑菇
    self:setfruittext(value[6],fruittextpox + 130,4*fruittextpoy -120)

    --苍术
    self:setfruittext(value[7],fruittextpox - 70,4*fruittextpoy - 165)

    --点红
    self:setfruittext(value[8],fruittextpox + 130,4*fruittextpoy -165)

    --self:setfruittext(0)
    --输赢判断
    if allclearmoney < 0 then
      --todo 
      textcolor = cc.c3b(227,23,13) 
      self:openfruittext("输咯",textcolor)
    elseif allclearmoney == 0 then
      --todo
      textcolor = cc.c3b(34,139,34)
      self:openfruittext("平",textcolor)
    else
      --todo
      textcolor = cc.c3b(127,255, 0)
      self:openfruittext("赢了",textcolor)
    end

    self:setfruittext(allclearmoney,fruittextpox ,2*fruittextpoy + 10,true)

    ---
    --开奖结果
    local openjiangjieguo = display.newTTFLabel(
        { text = jieguo,
          font = "Arial",
          size = 20,
          align = cc.TEXT_ALIGNMENT_LEFT,
          color = cc.c3b(127,255, 0)} )
        --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
        :pos(fruittextpox ,2*fruittextpoy + 52)
        :addTo(self.Clear)

    ---确定按钮
    local images = {
     normal = "normal.png",
     pressed = "down.png",
     disabled = "disable.png"
     }
   ---------------------
   
   local imabutt = cc.ui.UIPushButton.new(images,{scale9 = true})
                 :setButtonSize(240,60)
                 :setButtonLabel("normal",cc.ui.UILabel.new({
                    UILabelType = 2,
                    text = "确定",
                    size = 18,
                    color = cc.c3b(0,0,0)
                 }))
                 :setButtonLabel("pressed",cc.ui.UILabel.new({
                    UILabelType = 2,
                    text = "确定",
                    size = 18,
                    color = cc.c3b(255,64,64)
                 }))
                 :setButtonLabel("disabled",cc.ui.UILabel.new({
                    UILabelType = 2,
                    text = "确定",
                    size = 18 ,
                    color = cc.c3b(0,0,0)  
                 }))
                 :onButtonClicked(function (event)
                            if event.name == "CLICKED_EVENT" then
                              self:chilckbutton()
                            end
                        end)
                 :pos(fruittextpox ,fruittextpoy*1.2)
                 :addTo(self.Clear)


    local fruitname = {"Radish","Cabbage","Peas","Pumpkin","Sugar","Musgroom","Guanbin","Sonchifolia"}
    local path = "fruitbase/"..fruitname[value[9]]..".png"
    local fruitnamespr = display.newSprite(path)
        :align(display.BOTTOM_CENTER,self.Clear:getContentSize().width/2.7 ,self.Clear:getContentSize().height/3 +20)
        :addTo(self.Clear)

end

function Clearinglayer:getallmoney()
  return self.allmoney
end

function Clearinglayer:chilckbutton()
  self:getParent():removeChild(self:getParent().fruitclear)
end

function Clearinglayer:openfruittext(fruittext,bbj)
  local fruittextpox = self.Clear:getContentSize().width /2
  local fruittextpoy = self.Clear:getContentSize().height/5

  display.newTTFLabel(
        { text = fruittext,
          font = "Arial",
          size = 25,
          align = cc.TEXT_ALIGNMENT_LEFT,
          color = bbj })
        --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
        :pos(fruittextpox + 170, 4*fruittextpoy + 15)
        :addTo(self.Clear)
end

function Clearinglayer:setfruittext(base,x,y,allopen)
	-- body
  if base < 0 then
    --todo
    --ase = base
    textcolor = cc.c3b(227,23,13) 
  elseif base == 0 then
    --todo
    base = " "..-base
    textcolor = cc.c3b(34,139,34)
  else
    --base = "+"..base
    textcolor = cc.c3b(127,255, 0)
  end
	if allopen then
    display.newTTFLabel(
          { text = base,
            font = "Arial",
            size = 38,
            align = cc.TEXT_ALIGNMENT_LEFT,
            color = textcolor })
          --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
          :pos(x, y)
          :addTo(self.Clear)  
  else
    display.newTTFLabel(
          { text = base,
            font = "Arial",
            size = 20,
            align = cc.TEXT_ALIGNMENT_LEFT,
            color = textcolor })
          --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
          :pos(x, y)
          :addTo(self.Clear)  
  end     
end



return Clearinglayer