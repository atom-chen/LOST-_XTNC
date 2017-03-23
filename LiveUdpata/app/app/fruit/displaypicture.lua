

local createpicturelayer = require("app.layer.createpicture")
--头像图片，
local displaypicture = class("displaypicture", function ()
	return display.newNode()
end)

function displaypicture:ctor(value)
	
	self.photonumber = value
    --创建精灵
    local fruitBasepath = "displaypicture/boy"..value..".png"
    --print(fruitBasepath)
    self.fruit = display.newSprite(fruitBasepath)
    		:align(display.LEFT_BOTTOM,0,0)
    		:addTo(self,5)
    self.fruit:setScale(0.8)
    self:setContentSize(cc.size(self.fruit:getContentSize().width *0.5, self.fruit:getContentSize().height*0.5 ))
    self:setAnchorPoint(cc.p(0.5,0.5))

    self:addlodingwaitanimation()
    self:addTouchonoroff(true)
end

function displaypicture:uddatapicture(number)
	self.fruit:removeFromParent()
	local temp = "displaypicture/boy"..number..".png"
	self.fruit = display.newSprite(temp)
    		:align(display.LEFT_BOTTOM,0,0)
    		:addTo(self,5)
    self.fruit:setScale(0.8) 		
end
--动画
function displaypicture:addlodingwaitanimation()
    display.addSpriteFrames("displaypicture/picture.plist", "displaypicture/picture.png")
    local sprite = display.newSprite("#01.png")
    		:align(display.LEFT_BOTTOM,0,0)
    		:addTo(self,10)
   	sprite:setScale(0.8)
    --display.setAnimationCache(animKey,animation)
    local frames = display.newFrames("%02d.png", 1, 16)
    local animation = display.newAnimation(frames, 1 / 10) -- 0.5 秒播放 8 桢
    sprite:playAnimationForever(animation) -- 播放一次动画
end

--是否添加监听(开启)
function displaypicture:addTouchonoroff(open)
	-- body
  	if open then
		--添加监听,吞噬事件
		self:setTouchEnabled(true)
		self:setTouchSwallowEnabled(true)
		self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
			if event.name == "began" then
				print("chdii")
				self:getParent():getParent().createpicture = createpicturelayer.new(Socketegame._diaplaypictrue)
	                  :pos(0, 0)
	                  :addTo(self:getParent():getParent())
			end
		end)	
  	end
end

return displaypicture