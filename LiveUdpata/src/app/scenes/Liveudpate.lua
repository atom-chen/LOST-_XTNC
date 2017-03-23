
local Liveudpate = class("Liveudpate", function()
    return display.newScene("Liveudpate")
end)


function Liveudpate:ctor()

    local mapbg = display.newSprite("mian/background.png")
            :pos(display.cx,display.cy)
            :addTo(self)

    local Hotbg = display.newSprite("gamescene/Hotbg.png")
               :pos(display.cx,display.height/3)
               :addTo(self)
    Hotbg:setScale(0.8)
    self.text = cc.ui.UILabel.new({
            UILabelType = 2, text = "", size = 30,color = cc.c3b(0,0,0)})
        :align(display.CENTER, Hotbg:getContentSize().width/2, Hotbg:getContentSize().height/5 *4)
        :addTo(Hotbg)

    -- self.bendi = cc.ui.UILabel.new({
    --         UILabelType = 2, text = "2", size = 30,color = cc.c3b(0,0,0)})
    --     :align(display.CENTER, Hotbg:getContentSize().width/2, Hotbg:getContentSize().height/5 *3.5)
    --     :addTo(Hotbg)

    self.progression =  cc.ui.UILabel.new({
            UILabelType = 2, text = "", size = 30,color = cc.c3b(0,0,0)})
        :align(display.CENTER, Hotbg:getContentSize().width/2, Hotbg:getContentSize().height/5 *3.5)
        :addTo(Hotbg)

    self.size =  cc.ui.UILabel.new({
            UILabelType = 2, text = "", size = 30,color = cc.c3b(0,0,0)})
        :align(display.CENTER, Hotbg:getContentSize().width/2, Hotbg:getContentSize().height/5 *2.5)
        :addTo(Hotbg)

    self.locad = cc.ui.UILabel.new({
            UILabelType = 2, text = "", size = 30,color = cc.c3b(0,0,0)})
        :align(display.CENTER, Hotbg:getContentSize().width/2, Hotbg:getContentSize().height/5 *2)
        :addTo(Hotbg)
    self.Butbool = false
    local images = {
           normal = "gamescene/buyreturn.png",
           pressed = "gamescene/buyreturn.png",
           disabled = "gamescene/buyreturn.png"
           }
    self.playgame = cc.ui.UIPushButton.new(images,{scale9 = true})
       :setButtonSize(160,80)
       :onButtonClicked(function (event)
            if self.Butbool then
                return
            end
            self:performWithDelay(function ()
            cc.Director:getInstance():endToLua()
            end , 0.2) 
       end)
       :align(display.CENTER,Hotbg:getContentSize().width/3 *2,Hotbg:getContentSize().height/5)
       :addTo(Hotbg)

    self:addhotupdate()  
      
    self.Hotbg = Hotbg

    -- self.Length_size = nil
    
end

function Liveudpate:onRequestCallback(event)
    local request = event.request

    if event.name == "completed" then
        print(request:getResponseHeadersString())
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            --请求结束,但是没有返回200响应代码
            print(code)
            return
        end
        --请求成功
        -- print("response length"..request:getResponseDataLength())
        local response = request:getResponseString()
        self.size:setString("需要下载的文件大小为："..response)
        -- print("=====================>", response)
    elseif event.name == "progress" then
        -- print("progress"..event.dltotal)
    else
        --请求失败
        return
    end

end

function Liveudpate:addhotupdate()
    local writablepath = cc.FileUtils:getInstance():getWritablePath()
    local storagepath = writablepath .. "hotupdate/"
    --[[
    参数1是读取文件地址。
    参数2是下载的资源储存到哪。
    如果要将 project.manifest 放到 res/version 下的话，
    必须设置优先路径 res/version，否则 project.manifest 只能放在res目录下
    ]]
    local am = cc.AssetsManagerEx:create("project.manifest",storagepath)
    am:retain()
    self.am = am 
    self.failedcount = 0
    --获得当前本地版本
    local localManifest = am:getLocalManifest()

    print(localManifest:getVersion())
    print("getPackageUrl",localManifest:getPackageUrl())
    print("getManifestFileUrl",localManifest:getManifestFileUrl())
    print("getVersionFileUrl",localManifest:getVersionFileUrl())
    -- self.bendi:setString("本地版本："..localManifest:getVersion())

    if not am:getLocalManifest():isLoaded() then 
        print("加载本地project.manifest错误.")
        --进登录界面
    else 
        local listener = cc.EventListenerAssetsManagerEx:create(am,function(event)
            self:onUpdateEvent(event)
        end)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener,1)
        am:checkUpdate() 
    end
end

function Liveudpate:onUpdateEvent(event)
    local eventCode = event:getEventCode()

    local assetId = event:getAssetId()
    local percent = event:getPercent()
    local percentByFile = event:getPercentByFile()
    local message = event:getMessage()
    printInfo("游戏更新("..eventCode.."):"..", assetId->"..assetId..", percent->"..percent..", percentByFile->"..percentByFile..", message->"..message)
    if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
        self.text:setString("找不到本地manifest文件.")
        self._perent = 100
        --进登录界面 
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
        -- self.text:setString("正在更新文件 : "..event:getAssetId())
        -- self.progression:setString("更新进度条的进度："..event:getPercent())
        --print("更新进度 : ",event:getPercent())
        if event:getAssetId() == cc.AssetsManagerExStatic.VERSION_ID then 
            --print("文件版本 : ",event:getPercent())
        elseif event:getAssetId() == cc.AssetsManagerExStatic.MANIFEST_ID then
            --print("文件Manifest : ",event:getPercent())
        else 
            --print("进度条的进度 : ",event:getPercent())
            self.progression:setString("更新进度条的进度："..string.format("%0.2d", event:getPercent()).."%")
            --跳进度
            self._perent = event:getPercentByFile()
            self.progression:setString("更新进度条的进度："..string.format("%0.2d", self._perent).."%")
            
        end
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
            eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
        self.text:setString("远程资源清单文件下载失败")
        self._perent = 100
        --print("资源清单文件解析失败 ")
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE then 
        self.locad:setString("已经是最新版本,正在进入游戏...")
        self._perent = 100
        self.Butbool = true
        self.playgame:setOpacity(0)
        -- local images = {
        --    normal = "gamescene/buyconfirm.png",
        --    pressed = "gamescene/buyconfirm.png",
        --    disabled = "gamescene/buyconfirm.png"
        --    }
        -- local playgame = cc.ui.UIPushButton.new(images,{scale9 = true})
        --    :setButtonSize(160,80)
        --    :onButtonClicked(function (event)
        self:performWithDelay(function ()
            cc.LuaLoadChunksFromZIP("res/game.zip")
            require("app.netScoket.Socketgame")
            mainscene = require("app.scenes.MainScene")
            local Game = mainscene.new()
            display.replaceScene(Game)
        end, 1)
           -- end)
           -- :align(display.CENTER,self.Hotbg:getContentSize().width/3,self.Hotbg:getContentSize().height/5)
           -- :addTo(self.Hotbg) 
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
        self.text:setString("更新到最新版本,可以进入游戏")
        self._perent = 100
        -- package.loaded["app.scenes.MainScene"] = nil
        -- package.preload["app.scenes.MainScene"] = nil
        -- app:run()
        cc.FileUtils:getInstance():purgeCachedEntries()
        cc.LuaLoadChunksFromZIP("res/game.zip")
        require("app.netScoket.Socketgame")
        mainscene = require("app.scenes.MainScene")
        local Game = mainscene.new()
        display.replaceScene(Game)

    elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
        self.text:setString("更新过程中遇到错误")
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.NEW_VERSION_FOUND  then
        self.locad:setString("发现新版本，是否升级到" .. self.am:getRemoteManifest():getVersion().."版本")
        self.size:setString("需要下载的文件大小为：".."120K")
        -- local request = network.createHTTPRequest(handler(self, self.onRequestCallback),"http://192.168.80.20:3000/hotupdate/res_size.html","GET")
        -- request:start()
        local images = {
           normal = "gamescene/buyconfirm.png",
           pressed = "gamescene/buyconfirm.png",
           disabled = "gamescene/buyconfirm.png"
           }
        local playgame = cc.ui.UIPushButton.new(images,{scale9 = true})
           :setButtonSize(160,80)
           :onButtonClicked(function (event)
                self.am:update()
           end)
           :align(display.CENTER,self.Hotbg:getContentSize().width/3,self.Hotbg:getContentSize().height/5)
           :addTo(self.Hotbg) 
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FAILED  then
        self.text:setString("更新失败")
        if self.failedcount > 10 then 
            self._perent = 100
        else 
            self.failedcount = self.failedcount + 1
            self.am:downloadFailedAssets()  --如果有的文件更新失败,连续更新10次,超过十次还是进游戏
        end
    end 
end


function Liveudpate:onEnter()
end

function Liveudpate:onExit()
end

return Liveudpate
