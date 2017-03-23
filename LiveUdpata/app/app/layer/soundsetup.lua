
--音效设置界面
local soundsetup = class("soundsetup", function()
	return display.newNode()
end)

function soundsetup:ctor(value)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255),display.width,display.height)
                   :pos(display.width/2,display.height/2)
    self.bg:ignoreAnchorPointForPosition(false)                 
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.bg)
    self.bg:setOpacity(150)

    local bgsprire = display.newSprite("gamescene/setup.png")
    bgsprire:setPosition(self.bg:getContentSize().width/2,self.bg:getContentSize().height/2-10)
    self.bg:addChild(bgsprire)

    local soundbut
    local imagessoundbut = {
       on = "gamescene/soundbg.png",
       off = "gamescene/allrankingopen.png",
       }
    soundbut = cc.ui.UICheckBoxButton.new(imagessoundbut)
        :setButtonSelected(true)
        --:onButtonClicked(function ()                
        --end)
        :align(display.LEFT_CENTER, self.bg:getContentSize().width/2  - 355,self.bg:getContentSize().height/2 + 20)
        :addTo(self.bg)
    soundbut:setButtonEnabled(false)

    local SLIDERIMAGES = {
    bar = "gamescene/LoadingBarbg.png",
    button = "gamescene/LoadingBar.png",
    }
    -- local loadBar
    -- audio.playMusic("Sound/Gamebgm.wav", true)
    local MusicVolume = audio.getMusicVolume()
    local huadongtiao
    huadongtiao = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, SLIDERIMAGES, {scale9 = true})
        :onSliderValueChanged(function(event)
        	-- print(tonumber(string.format("%0.01f",huadongtiao:getSliderValue()/100)))
        	audio.setMusicVolume( tonumber(string.format("%0.01f",huadongtiao:getSliderValue()/100)) )       
            -- loadBar:setPercent(tonumber(string.format("%0.0f",self.huadongtiao:getSliderValue()/self.huadongtiao.max_ * 100) ))
        end)
        :setSliderSize(375, 30)
        :setSliderValue(0)
        :align(display.CENTER ,self.bg:getContentSize().width/1.8,self.bg:getContentSize().height/2.1)
        :addTo(self.bg) 
    huadongtiao:setSliderValue(MusicVolume * 100)
              
    local huadongtiao2
    huadongtiao2 = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, SLIDERIMAGES, {scale9 = true})
        :onSliderValueChanged(function(event)         
            -- loadBar:setPercent(tonumber(string.format("%0.0f",self.huadongtiao:getSliderValue()/self.huadongtiao.max_ * 100) ))
        end)
        :setSliderSize(375, 30)
        :setSliderValue(0)
        :align(display.CENTER ,self.bg:getContentSize().width/1.8,self.bg:getContentSize().height/3.5)
        :addTo(self.bg) 
    

    -- loadBar = cc.ui.UILoadingBar.new({
    --   scale9 = true,
    --   capInsets = cc.rect(0,0,10,10),
    --   image = "gamescene/LoadingBarnor.png",
    --   viewRect = cc.rect(0,0,383,30),
    --   percent = 0,
    --   })
    --   -- :pos(self.huadongtiao:getContentSize().width/2,self.huadongtiao:getContentSize().height/2)
    --   :align(display.LEFT_CENTER,0,0)
    --   :addTo(self.huadongtiao)

    local imagesYesorNo = {
       on = "gamescene/Yes.png",
       off = "gamescene/No.png",
       }
    local YesorNobut
    YesorNobut = cc.ui.UICheckBoxButton.new(imagesYesorNo)
        :setButtonSelected(true)
        :onButtonClicked(function () 
            if YesorNobut:isButtonSelected() then
            	audio.stopMusic(false)
                Socketegame._Music = true
            else
                Socketegame._Music = false
            	if value then
            		audio.playMusic("Sound/Gamebgm.wav",true)
            		return
            	end
            	audio.playMusic("Sound/Datingbgm.mp3",true)
            end
        end)
        :align(display.CENTER, self.bg:getContentSize().width/1.5,self.bg:getContentSize().height/1.8)
        :addTo(self.bg)
    if audio.isMusicPlaying() then
        YesorNobut:setButtonSelected(false)
    end
        
    local YesorNobut2
    YesorNobut2 = cc.ui.UICheckBoxButton.new(imagesYesorNo)
        :setButtonSelected(true)
        :onButtonClicked(function () 
                 
        end)
        :align(display.CENTER, self.bg:getContentSize().width/1.5,self.bg:getContentSize().height/2.8)
        :addTo(self.bg)

    local soundbgyy = display.newSprite("gamescene/soundbgyy.png")
        :align(display.CENTER, self.bg:getContentSize().width/2,self.bg:getContentSize().height/1.8)
        :addTo(self.bg)
    local soundYX = display.newSprite("gamescene/soundYX.png")
        :align(display.CENTER, self.bg:getContentSize().width/2.16,self.bg:getContentSize().height/2.6)
        :addTo(self.bg)

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
     
end

return soundsetup