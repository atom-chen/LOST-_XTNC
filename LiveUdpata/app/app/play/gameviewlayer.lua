
local picture = require("app.fruit.fruitpicture")
local fff = require("app.fruit.fruitBase")
local playcars = require("app.play.playcars")
local schedule = require(cc.PACKAGE_NAME .. ".scheduler")

local Clearlayer = require("app.play.Clearinglayer")

local gameviewlayer = class("gameviewlayer", function()
	return display.newNode()
end)

function gameviewlayer:ctor(roomset)
    
    --筹码传值
    self.xiazhmoney = 100
    
    --self.updatebanker = false

    self.viewlayer = cc.LayerColor:create(cc.c4b(55,55,55,255),display.width,display.height*0.7)
              --:pos(0, 0)             
              :addTo(self)
    self.viewlayer:ignoreAnchorPointForPosition(false)
    self.viewlayer:setAnchorPoint(cc.p(1,1))
    self.viewlayer:setPosition(cc.p(display.right,display.top  ))
    self.viewlayer:setOpacity(0)
    

    local addbg = display.newSprite("fruitbase/moonaddbg.png")
          -- :align(display.LEFT_BOTTOM,0,10)
          :align(display.CENTER,display.cx,display.cy - display.cx/5.7)
          :addTo(self.viewlayer)
          addbg:setOpacity(150)
          addbg:setScaleX(display.width/960)
    --水果table
    self.fruit = {}
    --open开奖动画
    self.openMove = false
    --下注
    self.xiazhu = {}

    --添加水果
    local bottomY =  self.viewlayer:getContentSize().height/4.7
    local bottomX =  self.viewlayer:getContentSize().width/1.2
    local bottomPosX = self.viewlayer:getContentSize().width * 0.084
    local topY = self.viewlayer:getContentSize().height /1.07
    
    -------------------------------------
    local right1_topY = self.viewlayer:getContentSize().height/3.2
    local right_topPosY = self.viewlayer:getContentSize().height*0.18
    local right2_topY = right1_topY + right_topPosY
    local right3_topY = right2_topY + right_topPosY
    local right4_topY = right3_topY + right_topPosY
    local right1_topX = self.viewlayer:getContentSize().width/1.115
    local right2_topX = self.viewlayer:getContentSize().width/1.11
    local right3_topX = self.viewlayer:getContentSize().width/1.11
    local right4_topX = self.viewlayer:getContentSize().width/1.115
    local left1_topX = self.viewlayer:getContentSize().width/5.8
    local left2_topX = self.viewlayer:getContentSize().width/6
    local left3_topX = self.viewlayer:getContentSize().width/6
    local left4_topX = self.viewlayer:getContentSize().width/5.8
    -------------------------------------

  --下边
  self:addfruitbasetolayer("fruitbase/Sonchifolia",bottomX - 4*bottomPosX, bottomY)
  self:addfruitbasetolayer("fruitbase/Guanbin",bottomX - 3*bottomPosX,bottomY)
  self:addfruitbasetolayer("fruitbase/Musgroom",bottomX - 2*bottomPosX ,bottomY)
  self:addfruitbasetolayer("fruitbase/Sugar",bottomX - bottomPosX ,bottomY)
  self:addfruitbasetolayer("fruitbase/Pumpkin",bottomX,bottomY)   
  --右边
  self:addfruitbasetolayer("fruitbase/Peas",right1_topX,right1_topY)
  self:addfruitbasetolayer("fruitbase/Cabbage",right2_topX, right2_topY)
  self:addfruitbasetolayer("fruitbase/Radish",right3_topX,right3_topY)
  self:addfruitbasetolayer("fruitbase/Sonchifolia",right4_topX,right4_topY)
  
  --上边
  self:addfruitbasetolayer("fruitbase/Guanbin",bottomX ,topY)
  self:addfruitbasetolayer("fruitbase/Musgroom",bottomX - bottomPosX,topY)
  self:addfruitbasetolayer("fruitbase/Sugar",bottomX - 2*bottomPosX,topY)
  self:addfruitbasetolayer("fruitbase/Pumpkin",bottomX - 3*bottomPosX,topY)
  self:addfruitbasetolayer("fruitbase/Peas",bottomX - 4*bottomPosX,topY)
  self:addfruitbasetolayer("fruitbase/Cabbage",bottomX - 5*bottomPosX,topY)
  self:addfruitbasetolayer("fruitbase/Radish",bottomX - 6*bottomPosX,topY)
  self:addfruitbasetolayer("fruitbase/Sonchifolia",bottomX - 7*bottomPosX,topY)
  --左边 
  self:addfruitbasetolayer("fruitbase/Guanbin",left1_topX ,right4_topY)
  self:addfruitbasetolayer("fruitbase/Musgroom",left2_topX,right3_topY)
  self:addfruitbasetolayer("fruitbase/Sugar",left3_topX, right2_topY)
  self:addfruitbasetolayer("fruitbase/Pumpkin", left4_topX,right1_topY)
  --下左三
  self:addfruitbasetolayer("fruitbase/Peas",bottomX - 7*bottomPosX, bottomY)
  self:addfruitbasetolayer("fruitbase/Cabbage",bottomX - 6*bottomPosX, bottomY)
  self:addfruitbasetolayer("fruitbase/Radish",bottomX - 5*bottomPosX, bottomY)  
   
  ---2017/1/12
  -------用户界面
  print("用户界面金币 =",Socketegame._MONEY)
  self.playshow = nil
  self.playshow = playcars.new("But/plays",Socketegame._MONEY)
            -- :pos(display.cx+270,display.cy-230)
            :align(display.CENTER_RIGHT,display.right + 60,display.bottom + 112)
            :addTo(self)

  
  --下注按键触发

  --上1
  local xchaju = 10
  local appp = picture.new("fruitpic/Radish","萝卜(赔率2倍)",RADISH)
           :pos(self.viewlayer:getContentSize().width/2 - display.width/3 ,self.viewlayer:getContentSize().height/2+8)
           :addTo(self.viewlayer)
        --设置赔率
        appp.multiplying = 2
        --appp:addTouchonoroff(true,5000)
        table.insert(self.xiazhu, appp)
  
  
  local papp = picture.new("fruitpic/Cabbage","白菜(赔率4倍)",CABBAGE)
           :pos(self.viewlayer:getContentSize().width/2 - display.width/6,self.viewlayer:getContentSize().height/2+10)
           :addTo(self.viewlayer)
        --设置赔率
        papp.multiplying = 4
        --papp:addTouchonoroff(true,2000)
        table.insert(self.xiazhu, papp)

  local ppap = picture.new("fruitpic/Peas","豌豆(赔率6倍)",PEAS)
           :pos(self.viewlayer:getContentSize().width/2,self.viewlayer:getContentSize().height/2+10)
           :addTo(self.viewlayer)
        --设置赔率
        ppap.multiplying = 6
        --ppap:addTouchonoroff(true,1000)
        table.insert(self.xiazhu, ppap)

  local pppa = picture.new("fruitpic/Pumpkin","南瓜(赔率8倍)",PUMPKIN)
           :pos(self.viewlayer:getContentSize().width/2+display.width/6,self.viewlayer:getContentSize().height/2+10)
           :addTo(self.viewlayer)
        --设置赔率
        pppa.multiplying = 8
        --pppa:addTouchonoroff(true,500)
        table.insert(self.xiazhu, pppa)

  --下1
  local abbb = picture.new("fruitpic/Sugar","甘蔗(赔率10倍)",SUGAR_CANE)
           :pos(self.viewlayer:getContentSize().width/2-display.width/3,self.viewlayer:getContentSize().height/2-110)
           :addTo(self.viewlayer)
        --设置赔率
        abbb.multiplying = 10
        --abbb:addTouchonoroff(true,200)
        table.insert(self.xiazhu, abbb)
  
  local babb = picture.new("fruitpic/Musgroom","蘑菇(赔率12倍)",MUSHROOM)
           :pos(self.viewlayer:getContentSize().width/2 -display.width/6,self.viewlayer:getContentSize().height/2-110)
           :addTo(self.viewlayer)
        --设置赔率
        babb.multiplying = 12
        --babb:addTouchonoroff(true,50)
        table.insert(self.xiazhu, babb)

  local bbab = picture.new("fruitpic/Guanbin","关苍术(赔率14倍)",GUAN_BIN )
           :pos(self.viewlayer:getContentSize().width/2,self.viewlayer:getContentSize().height/2-110)
           :addTo(self.viewlayer)
        --设置赔率
        bbab.multiplying = 14
        --bbab:addTouchonoroff(true,140)
        table.insert(self.xiazhu, bbab)

  local bbba = picture.new("fruitpic/Sonchifolia","一点红(赔率16倍)",EMILIA_SONCHIFOLIA )
           :pos(self.viewlayer:getContentSize().width/2+display.width/6,self.viewlayer:getContentSize().height/2-110)
           :addTo(self.viewlayer)
        --设置赔率
        bbba.multiplying = 16
        --bbba:addTouchonoroff(true,80)
        table.insert(self.xiazhu, bbba)

      
    --计时器,[1] = 循环计时
    -- self.starlight = {}
    self.starlooplight = nil

    self:setinitialvalue(self.xiazhmoney)
          
end

function gameviewlayer:addfruitbasetolayer(path,x,y)
    local bbabbbb = fff.new(path)
           :pos(x,y)
           :addTo(self.viewlayer)
          --bbabbbb:addTouchonoroff(true)
    table.insert(self.fruit, bbabbbb)
end

function gameviewlayer:aginaplaygame(seropen, opentime)
    ---开奖拉
    self.openjiang = seropen
    local zhonglei
    if (self.openjiang) % 8 == 0 then
      zhonglei = 1
    else
      zhonglei = (9-(self.openjiang) % 8)
    end
    --中奖金额
    local allzhongjiang = (self.xiazhu[zhonglei].multiplying) * (self.xiazhu[zhonglei].Amount) - (self.xiazhu[zhonglei].Amount)
    --获取各个水果下注金额，加载结算面板
    local xiazhufenlei = {}
    for i=1,8 do
      if i ==  zhonglei then
        xiazhufenlei[i] = allzhongjiang
      else
        xiazhufenlei[i] = (self.xiazhu[i].Amount) 
      end
    end
    xiazhufenlei[9] = zhonglei             
    --如果自己是庄家,更新自己个人信息
    if self:getParent().mybanker.mychildbanker then
      self:getParent().fruitclear = Clearlayer.new(xiazhufenlei,self.xiazhu[zhonglei].picturebase,true)
                            :addTo(self:getParent())
    else
      self:getParent().fruitclear = Clearlayer.new(xiazhufenlei,self.xiazhu[zhonglei].picturebase,false)
                            :addTo(self:getParent())
    end            
    self:performWithDelay(function ()
              self:getParent():removeChild(self:getParent().fruitclear)
              --下注面板归零              
              for i,v in ipairs(self.xiazhu) do
                v.playAmount:setString(0)
                v.Amount = 0
                v.isMove = false
                v:updataAllmoney()
              end
      end , opentime)
end

function gameviewlayer:setopenkaijiang(seropen,opentime,again)
  -- body
  if self.openMove then
    --todo
    return
  end
  --之前没有开过游戏
  if not self.openjiang then
    self.openjiang =  seropen
  else
    --关闭前一个记录亮灯
    self.fruit[self.openjiang]:rescoloropen()
    self.openjiang = nil
    self.openjiang = seropen
    --print("FFFF"..self.openjiang)
  end
  if again then
    self:loopnumschedule(opentime,again,self.openjiang+1)
  else
    --10时间转3次，传入结果           
    self:loopnumschedule(opentime,math.random(8,12),self.openjiang+1)
  end
  --10时间转3次，传入结果           
  -- self:loopnumschedule(opentime,math.random(8,12),self.openjiang+1)
  self.openMove = true
  --关闭下注监听
  --for i,v in ipairs(self.xiazhu) do
  --  v.isMove = true
  --end
  self:performWithDelay(function ( )            
              ---开奖拉
              local zhonglei
              if (self.openjiang) % 8 == 0 then
                zhonglei = 1
              else
                zhonglei = (9-(self.openjiang) % 8)
              end
              --中奖金额
              local allzhongjiang = (self.xiazhu[zhonglei].multiplying) * (self.xiazhu[zhonglei].Amount) - (self.xiazhu[zhonglei].Amount)
              --更新玩家金币
              --获取各个水果下注金额，加载结算面板
              local xiazhufenlei = {}
              for i=1,8 do
                if i ==  zhonglei then
                  -- xiazhufenlei[i] = allzhongjiang - self.xiazhu[zhonglei].Amount
                  xiazhufenlei[i] = allzhongjiang
                else
                  xiazhufenlei[i] = (self.xiazhu[i].Amount) 
                end
              end
              xiazhufenlei[9] = zhonglei             
              --如果自己是庄家,更新自己个人信息
              if self:getParent().mybanker.mychildbanker then
                --设置全局金币
                --[[
                print("庄家更新自己个人信息")
                Socketegame._MONEY = self:getParent().scenebanker.money
                self.playshow.playAmount:setString(Socketegame._MONEY)
                self.playshow.Amount = Socketegame._MONEY     
                --]]--
                --self.updatebanker = false
                self:getParent().fruitclear = Clearlayer.new(xiazhufenlei,self.xiazhu[zhonglei].picturebase,true)
                                      :addTo(self:getParent())
              else
                self:getParent().fruitclear = Clearlayer.new(xiazhufenlei,self.xiazhu[zhonglei].picturebase,false)
                                      :addTo(self:getParent())
                --self.playshow:addEnergy(allzhongjiang)
              end
              

              --更新庄家数值(从服务器中获得)
              self:getParent().mybanker:updatebanker(self:getParent().scenebanker.name,self:getParent().scenebanker.money,self:getParent().scenebanker.bankerLine)

      end , opentime + 0.5 )
      self:performWithDelay(function ()
              self.openMove = false
              --撤销结算弹窗
              self:getParent():removeChild(self:getParent().fruitclear)
              --self:getParent().openMove = false
              -- self:getParent().reminder:setString("准备期间")
              --可以上下庄
              --self:getParent().mybanker.gameplay = false
              --下注面板归零              
              for i,v in ipairs(self.xiazhu) do
                v.playAmount:setString(0)
                v.Amount = 0
                v.isMove = false
                --关闭监听
                v:updataAllmoney()
              end
              if #self:getParent().myuserCard ~= 0 then
                for i,g in ipairs(self:getParent().myuserCard) do
                  g:removetishi()
                end
                self:getParent().myuserCard = {}
              end           

      end , opentime + 6)
end

---设置下注筹码
function gameviewlayer:setinitialvalue(value)
  -- body
  for i,v in ipairs(self.xiazhu) do
    --print(i,v)
    v.chipnumber = value
    --如果换了筹码的时候
    v.isMove = false
  end
  --print("sdadada") 
end

--设置下注上限
function gameviewlayer:setbetupmoney(value)
  -- body
  for i,v in ipairs(self.xiazhu) do
    --print(i,v)
    print(v.picturebase,value[i])
    v.bankerupmoney = value[i]
    --开启监听
    --v:addTouchonoroff(true,v.chipnumber)
  end
end

--提示
function gameviewlayer:createtishi(upormoney)
  -- body
  local fruittishi = display.newSprite("fruitpic/tishi.png")
        :pos(self.viewlayer:getPositionX()/2 , self.viewlayer:getPositionY()/2 - 100)
        :addTo(self.viewlayer,20)
  
  if upormoney == 0 then
    --todo
    display.newTTFLabel(
        { text = "不够钱啦",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  elseif upormoney == 2 then
    --todo
    display.newTTFLabel(
        { text = "庄家,不能下注",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  else
    --todo
    display.newTTFLabel(
        { text = "庄家不够钱赔啦",
          --font = "MarkerFelt",
          size = 18,
          --align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(255,255,255) })
        :pos(fruittishi:getContentSize().width *0.5, fruittishi:getContentSize().height*0.5)
        :addTo(fruittishi)
  end
  
  transition.moveBy(fruittishi, { y = 50, time = 1})
  transition.fadeTo(fruittishi, {opacity = 50, time = 1})
  self:performWithDelay(function ()
                self.viewlayer:removeChild(fruittishi)
                end , 1)
end


--传入计时器下标必须为2,亮灯时间,是否循环，（否-开奖结果）
function gameviewlayer:bbbabbb_star(number,time,period,lottery)
  -- body
  --for i=1,5 do
  --循环周期
  if period then
    --todo
    -- print("self.starlight"..#self.fruit)
    local No_light
    local number_No = number
    No_light = 1

    for i=1,24 do
       if i == 1 then
         self.fruit[No_light]:setopenlight(true,true,time)
         No_light = No_light + 1
       else
         self:performWithDelay(function ()
            -- print(No_light)
            self.fruit[No_light]:setopenlight(true,true,time)
            No_light = No_light + 1
         end,time * i ) 
       end
    end 
  else
    if lottery then
      --todo
      local No_light
      local number_No = number
      No_light = 1
      --如果开奖为1
      if lottery == 1 then
        --todo
        -- print("dawafsfsdcxv")
        self.fruit[No_light]:setopenlight(true,false,time)
      else
        for i=1,lottery do
           if i == 1 then
               self.fruit[No_light]:setopenlight(true,true,time)
               No_light = No_light + 1
           elseif i == lottery then
               self:performWithDelay(function ()
                  self.fruit[No_light]:setopenlight(true,false,time)
                  No_light = No_light + 1
               end,time * lottery) 
           else
               self:performWithDelay(function ()
                  self.fruit[No_light]:setopenlight(true,true,time)
                  No_light = No_light + 1               
               end,time * i ) 
           end
        end
      end
    end   
  end
end

--传入循环时间,循环次数,（开奖结果）
function gameviewlayer:loopnumschedule(looptime,loopmunber,looplottery)
  -- body
  local dividetime = self:dividemunbertime(looptime,loopmunber)
  local all = 0
  for i,v in ipairs(dividetime) do
    --print(i,v)
    all = all + v
    print(i,v,all)
  end 
  local onetime = dividetime[1]
  for i=1,(loopmunber) do
    if i == 1 then
      self:bbbabbb_star(2,dividetime[1]/25,true) 
    elseif i == loopmunber then
      if loopmunber <= 6 then
        loopmunber = 6
      end
      self:performWithDelay(function ( )
        self:bbbabbb_star(2,dividetime[i]/looplottery,false,looplottery-1)        
      end , onetime )
    else
      self:performWithDelay(function ( )
        self:bbbabbb_star(2,dividetime[i]/25,true)
        -- self:bbbabbb_star(2,looptime/24,true)        
      end , onetime )
      onetime = onetime + dividetime[i]
    end  
  end
end

---衰减等分时间点，取24个值
function gameviewlayer:dividemunbertime(alltime,allmunber)
  -- body
  local muntime = {}
  local dividetime = {}
  local endtime = {}
  
  local divide_time = alltime/allmunber
  --当allmunber = 单数
  if (allmunber % 2) == 1 then
    --todo
    local divide_no = allmunber/2 - 0.5
    local previous = divide_no
    for i=1,allmunber do
      --print(i)
      if i<= divide_no then
        --todo
        muntime[i] = divide_time * (1 / (i+1))
        endtime[i] = divide_time - muntime[i]
      elseif i == divide_no + 1 then
        --todo
        endtime[i] = divide_time

      else
        --todo
        endtime[i] = divide_time + muntime[previous]
        previous = previous - 1
      end
    end
  end
  --当allmunber = 双数
  if (allmunber % 2) == 0 then
    --todo
    local divide_no = allmunber/2 
    local previous = divide_no
    for i=1,allmunber do
      --print(i)s
      if i<= divide_no then
        --todo
        muntime[i] = divide_time * (1 / (i+1))
        endtime[i] = divide_time - muntime[i]      
      else
        --todo
        endtime[i] = divide_time + muntime[previous]
        previous = previous - 1
      end
    end
  end
  
  --[[--
  local all = 0
  for i,v in ipairs(endtime) do
    --print(i,v)
    all = all + v
    print(i,v,all)
  end
  ]]
  
  return endtime
end

return gameviewlayer