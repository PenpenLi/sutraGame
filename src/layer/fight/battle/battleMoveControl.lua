local battleMoveControl = class("battleMoveControl", cocosMake.Layer)

function battleMoveControl:onCreate()
    self.visibleSize = {width = BATTLE_SCENE_SIZE_W, height = BATTLE_SCENE_SIZE_H}--可移动有效范围

    self.viewSize = {}--可视范围

    self.curMovePos = {x=0,y=0}--当前移动的位置
    
    self.manageLayerList = {}
    print("战场大小:" .. self.visibleSize.width .. ", " .. self.visibleSize.height)

    self:createTouchEvent_emBattle()
end

function battleMoveControl:getSizeVisibleSize()
    return self.visibleSize
end

function battleMoveControl:setViewVisibleSize(sz)
    self.viewSize = sz
end
function battleMoveControl:getViewVisibleSize()
    return self.viewSize
end


--layer必须有moveLayer函数
--(moveLayer参数1：移动值
--(moveLayer参数2：类型：1，像素偏移值， 2，百分比偏移值
function battleMoveControl:registerMoveLayer(layer)
    table.insert(self.manageLayerList, layer)
end

function battleMoveControl:tryMove(moveOffset)
    local offset = moveOffset or 0
    local move = self.curMovePos.x + offset
    if move > 0 then
        return false
    elseif move < (-self.visibleSize.width + self.viewSize.width) then
        return false
    end
    return true
end

function battleMoveControl:touchMove(mvOffsetX, mvOffsetY)
    local mx = self:tryMove(mvOffsetX) and mvOffsetX or 0
    local my = 0
    local tryY = self.curMovePos.y + mvOffsetY
    if tryY <= 0 and tryY >= BATTLE_MAP_Y_OFFSET then my = mvOffsetY end
    for k,v in pairs(self.manageLayerList) do
        v:moveLayer(mx, my, 1)
    end
    self.curMovePos.x = self.curMovePos.x + mx
    self.curMovePos.y = self.curMovePos.y + my
end

function battleMoveControl:percentMove(percentValue)
    local mvValue = -( (self.visibleSize.width - self.viewSize.width)*(percentValue/100) )
    mvValue = mvValue - self.curMovePos.x
    self:touchMove(mvValue, 0)
end

function battleMoveControl:createTouchEvent_emBattle()
    self.touchX = 0
    self.touchY = 0
    local function onTouchBegan(touch, event)
        local touchPos = touch:getLocation()

        self.touchX = touchPos.x 
        self.touchY = touchPos.y
        print(touchPos.x,touchPos.y)
        
        if not g_fightLogic:isCommunicateUI() then
            local role = g_fightLogic:getRoleByPositon(cc.p(touchPos.x - self.curMovePos.x - display.visibleRect.leftBottom.x, touchPos.y - display.visibleRect.leftBottom.y))
            self.selectRole = role
            if role then
                self.rolePosX, self.rolePosY = role:getPosition()
                self.roleZOriginal = role:getGlobalZOrder()
                role:setGlobalZOrder_(10)

                g_fightLogic:leaderMoveBegan(role)
            end
        end
        return true
	end

	local function onTouchMoved(touch, event)
        local pos = touch:getLocation()
        if self.selectRole then
            local moveX = pos.x - self.touchX
            local moveY = pos.y - self.touchY
            self.touchX = pos.x
            self.touchY = pos.y

            self.rolePosX = self.rolePosX + moveX
            self.rolePosY = self.rolePosY + moveY
            self.selectRole:setPosition(cc.p(self.rolePosX, self.rolePosY))
            g_fightLogic:leaderMoving()

        else
            local moveX = pos.x - self.touchX
            self.touchX = pos.x
            local moveY = pos.y - self.touchY
            self.touchY = pos.y
            self:touchMove(moveX, moveY)
        end
	end

	local function onTouchEnded(touch, event)
		if self.selectRole then
            self.selectRole:setGlobalZOrder_(self.roleZOriginal)
            g_fightLogic:leaderMoveEnd(self.selectRole)
            self.selectRole = nil
        end        
	end

    local eventDispacher = self:getEventDispatcher()
    if self.moveListener then
        eventDispacher:removeEventListener(self.moveListener)
        self.moveListener = nil
    end
    --注册触摸事件
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
	listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    
	eventDispacher:addEventListenerWithSceneGraphPriority(listener, self)
    self.moveListener = listener
end

function battleMoveControl:createTouchEvent_fighting()
    self.touchX = 0
    self.touchY = 0
    local function onTouchBegan(touch, event)
        --[[
		local target = event:getCurrentTarget()
		local locationInNode = target:convertToNodeSpace(touch:getLocation())
		local s = target:getContentSize()
		local rect = cc.rect(0, 0, s.width, s.height)
		--]]
        local touchPos = touch:getLocation()
        self.touchX = touchPos.x
        self.touchY = touchPos.y

        return true
	end

	local function onTouchMoved(touch, event)
        local moveX = pos.x - self.touchX
        self.touchX = pos.x
        local moveY = pos.y - self.touchY
        self.touchY = pos.y
        self:touchMove(moveX, moveY)
	end

	local function onTouchEnded(touch, event)
		
	end

    local eventDispacher = self:getEventDispatcher()
    if self.moveListener then
        eventDispacher:removeEventListener(self.moveListener)
        self.moveListener = nil
    end
    --注册触摸事件
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
	listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    
	eventDispacher:addEventListenerWithSceneGraphPriority(listener, self)
    self.moveListener = listener
end

return battleMoveControl