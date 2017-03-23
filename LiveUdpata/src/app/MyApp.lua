
require("config")
require("cocos.init")
require("framework.init")
require("framework.cc.init")
-- require("app.netScoket.Socketgame")

require("framework.audio")
-- gamescene = require("app.scenes.GameScene")
-- mainscene = require("app.scenes.MainScene")
-- playscene = require("app.scenes.Playscene")

---文件储存
gamestate = require("framework.cc.utils.GameState")
ByteArray = require("framework.cc.utils.ByteArray")

local MyApp = class("MyApp", cc.mvc.AppBase)
function MyApp:ctor()
    MyApp.super.ctor(self)
    --记住密码与加密
    gamestate.init(function (param)
      local returuValue = nil
      if param.errorCode then
        print("error code:% d",param.errorCode)
      else
        if param.name == "save" then
          local str = json.encode(param.values)
          str = crypto.encryptXXTEA(str, "abcd")
          -- local str = crypto.md5(param.values, false)
          returuValue = {data = str}
        elseif param.name == "load" then
          local str = crypto.decryptXXTEA(param.values.data, "abcd")
          --print("param.values.data",param.values.data)
          returuValue =  json.decode(str)
          print("str",str)
          -- print("returuValue",returuValue)
        end
      end
      return returuValue
    end,"data.txt","1234")
    
    --[[
    Touristtate.init(function (param)
      local returuValue = nil
      if param.errorCode then
        print("error code:% d",param.errorCode)
      else
        if param.name == "save" then
          local str = json.encode(param.values)
          str = crypto.encryptXXTEA(str, "abcd")
          -- local str = crypto.md5(param.values, false)
          returuValue = {data = str}
        elseif param.name == "load" then
          local str = crypto.decryptXXTEA(param.values.data, "abcd")
          --print("param.values.data",param.values.data)
          returuValue =  json.decode(str)
          print("str",str)
          -- print("returuValue",returuValue)
        end
      end
      return returuValue
    end,"Tourist.txt","1234")
    --]]  
end

function MyApp:run()
    local writePath = cc.FileUtils:getInstance():getWritablePath() 
    local searchPaths = cc.FileUtils:getInstance():getSearchPaths() 
    cc.FileUtils:getInstance():addSearchPath(writePath .. "hotupdate/res/")
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.Director:getInstance():setContentScaleFactor(640/CONFIG_SCREEN_HEIGHT)
    --self:enterScene("Playscene")
    self:enterScene("Liveudpate")
    --print("sadadwewqq")
end

return MyApp
