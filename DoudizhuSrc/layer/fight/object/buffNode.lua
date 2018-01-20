BuffNodeKey_ = 0
local function newKey()
    BuffNodeKey_ = BuffNodeKey_ + 1
    return BuffNodeKey_
end
local buffNode = class("buffNode", cocosMake.Node)

function buffNode:ctor(args)
    self.key = newKey()
    self.owner = nil
    self.buffID = args.id
    local buffInfo = DataManager.getBuffDataByID(args.id)
    self.buffInfo = buffInfo
    self.buffInfo.time = self.buffInfo.time/1000
    self.buffPropertyType = properties.level

    buffInfo.iconID = math.random(1001, 1036)
    local icon = cocosMake.newSprite(ICON_BUFF_UIPATH .. "/" .. buffInfo.iconID .. ".png", 0, 0)
    self:addChild(icon)
    

    self:processByshowEffect(buffInfo)
end

function buffNode:setOwner(obj)
    self.owner = obj
    self.owner:addChild(self)
end

function buffNode:setBuffControl(obj)
    self.buffControl = obj
end

function buffNode:setRmoveCallback(callback)
    self.removeCallback = callback
end

function buffNode:printLog(buffNote)
    local data = self.buffExpressData
    --print(buffNote .. "，参数: " .. data[1] .. "," .. data[2] .. "," .. data[3] .. "," .. data[4])
end

function buffNode:remove()
    self:stopAllActions()

    if self.removeCallback then
        self.removeCallback(self.buffID)
    end

    self.buffControl:buffEffect(false, self.key, self.buffPropertyType)

    self:removeFromParent(true)
end

function buffNode:processByshowEffect(buffInfo)
    local effExpress = buffInfo.effect
    local para = string.split(effExpress, "_")
    local effID = para[1]
    self.effID = effID

    local paraRes = {}
    for i=2,#para do
        table.insert(paraRes, tonumber(para[i]))
    end
    self.buffExpressData = paraRes
end

function buffNode:show()
    local f = self["showEffect_" .. self.effID]
    if f then
        f(self)
    end
    self:starRemoveBuffSchedule()--开始倒计时BUFF关闭
end

function buffNode:starRemoveBuffSchedule()
    performWithDelay(self, function () self:remove() end, self.buffInfo.time)
end


--移动速度
function buffNode:showEffect_10()
    self.buffPropertyType = properties.speed
    self.buffControl:buffEffect(true, self.key, properties.speed, self.buffExpressData[1], self.buffExpressData[2])
end

--生命值
function buffNode:showEffect_5()
    local function schFunc()
        self.owner:addHp(self.buffExpressData[1])
        performWithDelay(self, schFunc, self.buffExpressData[3])
    end
    schFunc()
end

--晕眩
function buffNode:showEffect_14()
    self.owner:setAi(ObjectDefine.Ai.freeze, {time=self.buffInfo.time})
end

--无敌
function buffNode:showEffect_21()
    self.buffPropertyType = properties.god
    self.buffControl:buffEffect(true, self.key, properties.god, self.buffExpressData[1], self.buffExpressData[2])
end

--潜行
function buffNode:showEffect_24()
    self.buffPropertyType = properties.corbet
    self.buffControl:buffEffect(true, self.key, properties.corbet, self.buffExpressData[1], self.buffExpressData[2])
end

return buffNode




