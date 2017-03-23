


local schedule = require(cc.PACKAGE_NAME .. ".scheduler")
local ttfSize = 20
local ttfColor = cc.c3b(0, 0, 0)

--水果图片，
local fruitpicture = class("fruitpicture", function ()
	-- body
	return display.newNode()
end)

function fruitpicture:ctor(path,base,settype)
	-- body
    --倍率，默认为0
    self.multiplying = 0
    --金额，根据当前选择设置金额
    self.Amount = 0
    --获得筹码
    self.chipnumber = 0
    --默认
    self.rescolor = nil
    --亮了
    self.openlight = false
    --是否在播放动画
    self.isMove = false
    --更新所有玩家的金币
    self.allmoney = 0
    --庄家上限
    self.bankerupmoney = 88888888
    --设置类型
    if settype then
      --todo
      self.settype = settype
    end    
    if base then
    	--todo
    	self.picturebase = base
    end

    --创建精灵
    local fruitBasepath = path..".png"
    
    self.fruitpic = cc.LayerColor:create(cc.c4b(55,55,55,255),150,110)
        :align(display.TOP_RIGHT,0,0)
        :addTo(self)
    self.fruitpic:setScale(1)
    self.fruitpic:setOpacity(0)


    self:setContentSize(cc.size(self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5 ))
    self:setAnchorPoint(cc.p(0,0))
    
    
    
    local fruitaddbase = display.newSprite(fruitBasepath)
        :align(display.BOTTOM_LEFT ,0,0)
        :addTo(self.fruitpic)

    local fruitaddbase = display.newSprite("fruitpic/money.png")
        :align(display.BOTTOM_LEFT ,0,0)
        :addTo(self.fruitpic)

    self:addtext()

    --self:createtishi(8, 8,0,0)
    --self:addTouchonoroff(true,self.chipnumber)

end

--关闭监听
function fruitpicture:closeToucho(notoroff)
	-- body
	if notoroff then
		--todo
		self:setTouchEnabled(false)
	end	
end

--开启监听
function fruitpicture:offToucho(notoroff)
  -- body
  if notoroff then
    --todo
    self:addTouchonoroff(true)
  end 
end

--是否添加监听(开启，金额)
function fruitpicture:addTouchonoroff(open)
	-- body
  	if open then
		--todo
		--添加监听,吞噬事件
		self:setTouchEnabled(true)
		self:setTouchSwallowEnabled(true)
		self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
				--body
				--正在播放动画
        --当下注超过庄家承受能力
        if (self.Amount + self.chipnumber) > self.bankerupmoney then
            --todo
            --self:closeToucho(true)
            self.isMove = true
            self:getParent():getParent():createtishi(1)
            --print("达到上限")
        end
        --当余额为o
        if (Socketegame._MONEY - self.chipnumber) < 0 then
          --todo
          self.isMove = true
          self:getParent():getParent():createtishi(0)
        end
        --当当前客户端为庄家时，提示
        if self:getParent():getParent():getParent().mybanker.mychildbanker then
          --todo
          self.isMove = true
          self:getParent():getParent():createtishi(2)
        end
				if  self.isMove then
            --print(" kai da le ")
            return 
        end
				if event.name == "began" then
					--todo
					self.isMove = true				
					local sequence = transition.sequence({
					    cc.ScaleTo:create(0.1,0.95,0.95),
					    cc.ScaleTo:create(0.1,1.01,1.01),					    
					})	
          transition.execute(self.fruitpic,sequence,{
                       delay = 0,
                       onComplete = function ()
                         self.isMove = false
                         end
                      })           
          self:setplayAmounttext(self.chipnumber)
          print("self.chipnumber"..self.chipnumber)
          self:setfruitmoney(self.chipnumber)
				end
			end)	

  	end
end

function fruitpicture:setfruitmoney(betmoney)
  -- body
  local  token = {         
            cmd = "bet",           
            fruit = self.settype,
            money = betmoney,
            }
  --print("==>"..json.encode(token))
  SEND(token)
end


function fruitpicture:addtext()
	-- body
	self.playAmount = display.newTTFLabel(
        { text = self.Amount,
          font = "Arial",
          size = ttfSize,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = ttfColor })
        --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
        :pos(self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5 -35)
        :addTo(self.fruitpic)


    local allmoneybg = display.newSprite("fruitpic/allmoney.png")
        :align(display.CENTER ,self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height/1.2)
        :addTo(self.fruitpic)

    self.allmoneytext = display.newTTFLabel(
        { text = "0",
          font = "Arial",
          size = ttfSize,
          align = cc.TEXT_ALIGNMENT_CENTER,
          color = cc.c3b(0, 0, 0) })
        --:align(cc.TEXT_ALIGNMENT_LEFT, self.fruitpic:getContentSize().width *0.5, self.fruitpic:getContentSize().height*0.5)
        :pos(allmoneybg:getContentSize().width/2, allmoneybg:getContentSize().height/2)
        :addTo(allmoneybg)

end

function fruitpicture:setplayAmounttext(money)
   self.Amount= self.Amount + money
   self.playAmount:setString(self.Amount)
   self:getParent():getParent().playshow:loseEnergy(money) 
end


function fruitpicture:BnakeraddEnergy(money)
  self.Amount= self.Amount + money
	self.playAmount:setString(self.Amount)
end

function fruitpicture:setAllmoney(money)
  self.allmoney = self.allmoney + money 
  self.allmoneytext:setString(self.allmoney)
end

function fruitpicture:updataAllmoney()
  self.allmoney = 0
  self.allmoneytext:setString("0")
end

return fruitpicture