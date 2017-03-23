
local SocketTCP = require("framework.cc.net.SocketTCP")
local schedule = require(cc.PACKAGE_NAME .. ".scheduler")
--网关
-- ServerIP = "192.168.80.246"
-- Serverport = 8192

--云ip
ServerIP = "139.199.220.181"
Serverport = 8192

--测试ip
-- ServerIP = "192.168.83.185"
-- Serverport = 8192

-- 林东雄
-- ServerIP = "192.168.80.20"
-- Serverport = 8192
Session = 1

Socketegame = SocketTCP.new(ServerIP,Serverport,false)


--预加载开启心跳包

--存储变量
--math.randomseed(tostring(os.time()):reverse():sub(1, 7))
--玩家ID 等标识

---[[
--玩家ID
Socketegame._ID = nil
--玩家金币
Socketegame._MONEY = nil

Socketegame._SUBID = nil
--玩家UID 
Socketegame._UID = nil
---玩家昵称
Socketegame._NICHENG = nil
--庄家信息
Socketegame._roomtable = {}
--玩家头像
Socketegame._diaplaypictrue = 3
--可否领取救济金
Socketegame._alms = false
--在房间退出领取救济金
Socketegame._almsreturnroom = false
--排行榜
Socketegame._daybanglvitem = {}
Socketegame._zhongbanglvitem = {}
--概率
Socketegame._multiplying = {}
Socketegame._orandbreaklineRunning = false

--是否是第一次注册账号
Socketegame._isoneLogin = false
--上一把是否存在输赢
Socketegame._OffMoney = nil

--保存上一把的成绩
Socketegame._score = nil
--上一把下注信息
Socketegame._betstb = nil 
--所有人下注
Socketegame._Allbetstb = nil
--是否播放音乐
Socketegame._Music = false

--游客
Socketegame._TouristID = ""
Socketegame._TouristPassword = ""
Socketegame._Touristbool = false

-- print(Socketegame._zhongbanglvitem)
-- if next(Socketegame._zhongbanglvitem) == nil then 
--   print("ddddd")
-- end
--]]--

--[[
Socketegame._ID = "444"
Socketegame._MONEY = 444
Socketegame._UID = 444
Socketegame._roomtable = {banker = {name = "小册子" , money = 88888} }
--]]--

--事件
--数据传输前
Socketegame._onTransmissionBefoteEvent = function (event)   
  if event.name == "SOCKET_TCP_CONNECTED" then
   end
  if event.name == "SOCKET_TCP_DATA" then
  end 
end

--数据传输后
Socketegame._onTransmissionAfterEvent = function ()
	-- body
end


--设置数据传输前回调函数
Socketegame.setonTransmissionBefoteEvent = function (fun)
	-- body
	--print("setonTransmissionBefoteEvent")
	Socketegame._onTransmissionBefoteEvent = fun
end

--设置数据传输后回调函数
--Socketegame.setonTransmissionAfterEvent = function (fun)
	-- body
	--Socketegame._onTransmissionAfterEvent = fun
--end



function Socketegame.addevent_()
	-- body
	--连接成功
	Socketegame:addEventListener(SocketTCP.EVENT_CONNECTED , Socketegame._onTransmissionBefoteEvent,1)

	--print(Socketegame._onTransmissionBefoteEvent)
	--网络即将关闭
	Socketegame:addEventListener(SocketTCP.EVENT_CLOSE , Socketegame._onTransmissionBefoteEvent,2)

	--网络连接关闭
	Socketegame:addEventListener(SocketTCP.EVENT_CLOSED, Socketegame._onTransmissionBefoteEvent,3)

	--网络连接失败
	Socketegame:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, Socketegame._onTransmissionBefoteEvent,4)

	--网络连接，收到消息
	Socketegame:addEventListener(SocketTCP.EVENT_DATA, Socketegame._onTransmissionBefoteEvent,5)
end

Socketegame.addevent_()


--Socketegame:connect()
--last = ""
--解包
--##########################################################
---[[
local last = ""
local Socketdata

function updatalastandSocketdata()
  last = ""
  Socketdata = nil
end

-----解包包，取大小，
local function unpack_package(text)
  local size = #text
  if size < 2 then
    return nil, text
  end
  local s = text:byte(1) * 256 + text:byte(2)
  if size < s+2 then
    return nil, text
  end
  return text:sub(3,2+s), text:sub(3+s)
end


local function unpack_f(f)

  local function try_recv(last)
    local result
    result, last = f(last)
    if result then
      return result, last
    end
    local r = Socketdata
    Socketdata = nil
    if not r then
      return nil, last
    end
    if r == "" then
      error "Server closed"
    end
    return f(last .. r)
  end
  
  -----------------------------------------
  return function()
    local counter = 1
    while true do
      local result
      --
      result, last = try_recv(last)
      if result then
      	-- print("counter:",counter)
      	counter = counter + 1
        return result
      end
    end
  end
end

local readpackage = unpack_f(unpack_package)

-- local function readMultPackage ()
READ = function (data)
  Socketdata = data
  local packPool = {}
  local readCount = 1
  while true do  
    local peintonePack = readpackage()
    print("<==sock",peintonePack)
    local onePack = json.decode(peintonePack)
    table.insert(packPool, onePack)   
    -- print(string.format("==> readCount:%d",readCount))
    if #last > 0 then
    	print("last:", #last)
    end
    if Socketdata then
    	-- print("Socketdata:", #Socketdata)
    end
    readCount = readCount + 1
    if 0 <= #last and nil == Socketdata then
      return packPool
    end
  end
end
--*********************************************************]]
--[[
READ = function (Socketdata)
	--
	local tmp = Socketdata
	--print("原始包：", crypto.encodeBase64(tmp))
	--print("data包: ",crypto.encodeBase64(event.data))
	local last = ""
	local function unpack_package(text)
		local size = #text
		if size < 2 then
			return nil, text
		end
		local s = text:byte(1) * 256 + text:byte(2)
		if size < s+2 then
			return nil, text
		end
		return text:sub(3,2+s), text:sub(3+s)
	end
	local function unpack_f(f)
		local function try_recv(fd, last)
			local result
			result, last = f(last)
			if result then
				return result, last
			end
			local r = tmp
			if not r then
				return nil, last
			end
			if r == "" then
				error "Server closed"
			end
			return f(last .. r)
		end
		return function()
			--local counter = 0
			while true do
				--print("counter:",counter)
				local result
				result, last = try_recv(fd, last)
				if result then
					return result
				end
				
			end
		end
	end
	local readpackage = unpack_f(unpack_package)
	sockData = readpackage()
	print("<==sock",sockData)
	return json.decode(sockData)
end
]]--

--打包
PACK_AGE = function ( tablevalue )
	-- body
	print("==>PACK_AGE",json.encode(tablevalue))
	local package = string.pack(">P", json.encode(tablevalue))
	if package then
		--todo
		return package
	end
end
----发送数据
SEND = function ( tb ) -- body
  local tablevales = {}
  tablevales.type = "lua"
  print("Session = ",Session)
  tablevales.session = Session
  tablevales.data = tb
  tablevales.command= tb.cmd
  Socketegame:send(PACK_AGE(tablevales))
  Session = Session + 1 
end

--数据传输
Socketegame._onTransmission = function (event)
  if event.name == "SOCKET_TCP_CONNECTED" then

  end
  if event.name == "SOCKET_TCP_CONNECT_FAILURE" then

  end
end
---保存函数
Socketegame._onTransmissionAfterEvent = function (event)
  
end

--设置数据传输后回调函数
Socketegame.setonTransmissionAfterEvent = function (fun)
  Socketegame._onTransmissionAfterEvent = fun
  --添加进入监听启用函数
  Socketegame.setonTransmission(Socketegame._onTransmissionAfterEvent)
end

--设置重连函数
Socketegame.setonTransmission = function (fun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CONNECTED",fun)
  Socketegame:reviseEvebtListenersByeventName("SOCKET_TCP_CONNECT_FAILURE",fun)
end
---心跳包
SENDHENDBEAT = function ()
  local tablevales = {}
  tablevales.type = 1
  Socketegame:send(PACK_AGE(tablevales))
end

NUMBERSendMove = 1
SendMove = function ()
  if NUMBERSendMove == 1 then
    local age = {cmd = "heartbeat"}
    SEND(age)
    NUMBERSendMove = 2  
  end   
end

--调用心跳检测函数
Socketegame._hendDetectionfunc = function ()
  
end

Socketegame._sethendDetectionfunc = function (fun)
  Socketegame._hendDetectionfunc = fun
end
--心跳
Socketegame._Schedulehend = nil

--超时
Socketegame._Allschedulehend = nil

--Socketegame 
Socketegame._diaoyongSchedule = function (instruction)
   local timeschedule
   local chaoshitime
   --print("函数")
   --超时
   local ChaoshiSchedule = function ()
      -- print("超时 = ")
      if Socketegame._Allschedulehend then
          schedule.unscheduleGlobal(Socketegame._Allschedulehend)
          Socketegame._Allschedulehend = nil
          chaoshitime = 0
          local function chaoshitimeupdata (dt)
            chaoshitime = chaoshitime + 1
            print("超时 = ",chaoshitime)
            if chaoshitime == 20 then
                Socketegame._hendDetectionfunc("chaoshi")
                if Socketegame._Allschedulehend then
                  schedule.unscheduleGlobal(Socketegame._Allschedulehend)
                  Socketegame._Allschedulehend = nil
                end
            end
          end 
          Socketegame._Allschedulehend = schedule.scheduleGlobal(chaoshitimeupdata, 1)
      else
          chaoshitime = 0
          local function chaoshitimeupdata (dt)
              chaoshitime = chaoshitime + 1
              print("超时 = ",chaoshitime)
              if chaoshitime == 20 then
                Socketegame._hendDetectionfunc("chaoshi")
                if Socketegame._Allschedulehend then
                  schedule.unscheduleGlobal(Socketegame._Allschedulehend)
                  Socketegame._Allschedulehend = nil
                end               
              end
          end
          Socketegame._Allschedulehend = schedule.scheduleGlobal(chaoshitimeupdata, 1)
      end
   end

   --重新连接
   local openSchedule = function ()
      if Socketegame._Schedulehend then
          schedule.unscheduleGlobal(Socketegame._Schedulehend)
          Socketegame._Schedulehend = nil
          timeschedule = 0
          local function timeupdata (dt)
            timeschedule = timeschedule + 1
            -- print("timeschedule = ",timeschedule)
            if timeschedule == 8 then
              -- Socketegame._hendDetectionfunc()
              if Socketegame._Schedulehend then
                schedule.unscheduleGlobal(Socketegame._Schedulehend)
                Socketegame._Schedulehend = nil
              end             
              Socketegame:disconnect()
              Socketegame:connect()
              print("与服务器连接中断")
              --开始计算超时
              ChaoshiSchedule()
              Socketegame._hendDetectionfunc()
            -- elseif timeschedule == 11 then
            --     schedule.unscheduleGlobal(Socketegame._Schedulehend)
            --     Socketegame:connect()
            end
          end 
          --print("ssssssssssssssssssssssssssss")
          Socketegame._Schedulehend = schedule.scheduleGlobal(timeupdata, 1)
      else
          timeschedule = 0
          local function timeupdata (dt)
              timeschedule = timeschedule + 1
              -- print("timeschedule = ",timeschedule)
              if timeschedule == 8 then
                -- Socketegame._hendDetectionfunc()
                if Socketegame._Schedulehend then
                  schedule.unscheduleGlobal(Socketegame._Schedulehend)
                  Socketegame._Schedulehend = nil
                end              
                Socketegame:disconnect()
                Socketegame:connect()
                --开始计算超时
                ChaoshiSchedule()
                Socketegame._hendDetectionfunc()
                print("与服务器连接中断")
              -- elseif timeschedule == 11 then
              --   schedule.unscheduleGlobal(Socketegame._Schedulehend)
              --   Socketegame:connect()
              end
          end
          Socketegame._Schedulehend = schedule.scheduleGlobal(timeupdata, 1)
      end
   end
   if instruction == "open" then
      openSchedule()
   end 
end
--
--解包接收数据
SESSRESULT = function ( table )
  --print("包个数：",#table)
  if table[1].ok then
    --todo
    if table[1].result then
      -- if table[1].result == true then
      --   return {cmd = "false"}
      -- else        
    	return table[1].result
      -- end
    else
    	return
    end   
  else
    --todo
    print("result = 接收数据不规范")
    return {cmd = "false"}
  end
end

SESSRETABLENO1 = function ( table )
  --
  --print("包个数：",#table)
  if table.ok then
    --todo
    if table.result then
    	--todo
    	return table.result
    else
    	return
    end   
  else
    print("result = 接收数据不规范")
    return {cmd = "false"}
  end
end



