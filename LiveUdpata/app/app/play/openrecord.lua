
--幸运水果记录
local openrecord = class("openrecord", function()
	return display.newNode()
end)

function openrecord:ctor(value,daxiao)

	--self:setTouchEnabled(true)
    --self:setTouchSwallowEnabled(true)
    self:setContentSize(cc.size(100, 300 ))
    self:setAnchorPoint(cc.p(1,0.5))

    --local  = 1
	--幸运水果记录
	self.luckyrecord = value
    self.recorddaxiao = daxiao

	self.lucky = {"萝卜","白菜","豌豆","南瓜","甘蔗","蘑菇","关苍术","一点红","空"}
	-- local changdu = #self.luckyrecord
	-- if #self.luckyrecord <= 8 then
	-- 	--todo
	-- end
    if not daxiao then
        daxiao = 300
    end
	self.lv = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        bg = "bankerok.png",
        bgScale9 = true,
        viewRect = cc.rect(0, 0, 100, self.recorddaxiao),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        -- scrollbarImgV = "bar.png"
        }
        --:onTouch(handler(self, self.touchListener))
        :pos(0,0)
        :addTo(self)
    for i,fruit in ipairs(self.luckyrecord) do
        local item = self.lv:newItem()
        local content
        --print(self.lucky[fruit])
        
        content = cc.ui.UILabel.new(
                {text = i..":  "..self.lucky[fruit],
                size = 15,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_BLACK})
        item:addContent(content)
        item:setItemSize(120, 38)
        --print(content:getString())
        self.lv:addItem(item)
    end
    self.lv:reload()

    --local emptyNode = cc.Node:create()
    --emptyNode:addChild(self.lv)

	--local bound = self.lv:getBoundingBox()
    --bound.width = 85
    --bound.height = 300

    --cc.ui.UIScrollView.new({viewRect = bound})
        --:addScrollNode(emptyNode)
        --:setDirection(cc.ui.UIScrollView.DIRECTION_HORIZONTAL)
        --:onScroll(handler(self, self.scrollListener))
        --:addTo(self)
end

function openrecord:getboundingbox()
	-- body
	return self.lv:getBoundingBox()
end

return openrecord