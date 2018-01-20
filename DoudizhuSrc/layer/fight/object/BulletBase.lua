local BulletBase = class("BulletBase", require(luaFile.ObjectBase))
BulletBase[".isclass"] = true


local FLY = "fly"
local POWER = "power"

function BulletBase:ctor(param)
    self:setType(param.objectType)
    

    self.speed = param.bulletSpeed--test code   
    
    self.owner = param.leader--归属单位
    self.target = param.target--目标单位
    --print("self.bullet.own.name： " .. self.owner.roleData.name)
    self.powerValue = tonumber(param.power)
    self.camp = param.camp
    self.bullet = param.bullet[1]
    self.picPos_attack = param.picPos_attack or {0,0}
    --self.bullet = "tx_attack_07"--test code
    self:initPosition(self.owner, self.target, self.owner:getBulletAttackOffset())
end


function BulletBase:initPosition(res, dest, offsetBeginPos)
    local tx,ty = dest:getPosition()
    local ox,oy = res:getPosition()
    local bPos = dest:getBeBulletAttackOffset()

    
    local targetPosition = cc.p(tx+bPos.x, ty+bPos.y)
    self.targetPosition = targetPosition
    self.targetKey = dest:getKey()
    
    local myPosition = cc.p(ox+offsetBeginPos.x, oy+offsetBeginPos.y)
    self.myPosition = myPosition
    
    self:setDirection(ox <= self.targetPosition.x and ObjectDefine.Direction.right or ObjectDefine.Direction.left)
    
    if self.direction == ObjectDefine.Direction.left then
        myPosition.x = myPosition.x - 2 * offsetBeginPos.x
    end

    self:setPosition(myPosition)
    self:setAnchorPoint(cc.p(0.5, 0.5))

    
    local ag = math.abs(targetPosition.y - myPosition.y) / cc.pGetDistance(myPosition, targetPosition)
    ag = math.deg(math.asin(ag))
    
    if (myPosition.y > targetPosition.y and myPosition.x > targetPosition.x) or 
    (myPosition.y < targetPosition.y and myPosition.x < targetPosition.x) then ag = -ag end
    
    self:setRotation(ag)
end

--[[
args: range
--]]
function BulletBase:setTanshe(args)
    self.tansheInfo = args
end

function BulletBase:setDirection(dir)
    if dir == ObjectDefine.Direction.left then
       self:setFlippedX(false)
    elseif dir == ObjectDefine.Direction.right then
       self:setFlippedX(true)
    end
     
    self.direction = dir--朝向
end
function BulletBase:setDirectionByBullet(node)
    if self.direction == ObjectDefine.Direction.left then
       node:setFlippedX(false)
    elseif self.direction == ObjectDefine.Direction.right then
       node:setFlippedX(true)
    end
end


--伤害输出函数
function BulletBase:power()
    if self.objectManager_:objectIsLife(self.targetKey) then
        self.target:beAttack(self.powerValue, self.owner, transHurtType(self.hurtType))
    end
end

--受击特效
function BulletBase:playAttackEffect(callback)
    --self:playFinish() --test code
    self:playSpriteFrames_power(function() if callback then callback() end end)
end

function BulletBase:move(time, moveFinishCallback)
    if self.bullet == "tx_attack_004" or self.bullet == "tx_attack_004b" then
        local flyH = 60
        local distanceW = cc.pGetDistance(self.targetPosition, self.myPosition)
        local ag = math.abs(self.targetPosition.y - self.myPosition.y) / distanceW
        ag = math.deg(math.asin(ag))

        local offset = {}
        offset.y = ( (90-ag)/90 )*flyH
        offset.x = (ag/90)*distanceW

        local controlPoint_1 = cc.p(self.myPosition.x , self.myPosition.y + offset.y)
        local controlPoint_2 = cc.p(self.targetPosition.x , self.targetPosition.y + offset.y)
        local targetPos = cc.p(self.targetPosition.x, self.targetPosition.y)

        if self.myPosition.x > self.targetPosition.x then
            if self.myPosition.y > self.targetPosition.y then
                controlPoint_1.x = controlPoint_1.x - offset.x
                controlPoint_2.x = controlPoint_2.x 
            else
                controlPoint_1.x = controlPoint_1.x 
                controlPoint_2.x = controlPoint_2.x + offset.x
            end
        else
            if self.myPosition.y > self.targetPosition.y then
                controlPoint_1.x = controlPoint_1.x + offset.x 
                controlPoint_2.x = controlPoint_2.x
            else
                controlPoint_1.x = controlPoint_1.x 
                controlPoint_2.x = controlPoint_2.x - offset.x
            end
        end
    
        local sequence = transition.sequence({
                    cc.BezierTo:create(time, {controlPoint_1, controlPoint_2, targetPos}),
                    cc.CallFunc:create(function() if moveFinishCallback then moveFinishCallback() end end )
                })
        self:runAction(sequence)

    else
        transition.moveTo(self, {x=self.targetPosition.x, y=self.targetPosition.y, time=time, onComplete=moveFinishCallback})
    end
    --[[
    local bezier2 ={
    cc.p((self.targetPosition.x - self.myPosition.x)/2, (self.targetPosition.y - self.myPosition.y)/2),  
    cc.p((self.targetPosition.x - self.myPosition.x)/2, (self.targetPosition.y - self.myPosition.y)/2),
    cc.p(self.targetPosition.x - self.myPosition.x, self.targetPosition.y - self.myPosition.y)
  }
    local action = cc.BezierBy:create(time*3, bezier2)
    transition.execute(self, action, {onComplete=moveFinishCallback})
    --]]
end

--弹射攻击效果
function BulletBase:playTanshe()
    local eList = {}
    local targetList = {}
    if self.camp == ObjectDefine.Camp.own then
        eList = self.objectManager_:getEnemyObjectList()
    else
        eList = self.objectManager_:getOwnObjectList()
    end

    local mx,my = self:getPosition()
    for k,v in pairs(eList) do
        local vx,vy = v:getPosition()
        local dis = cc.pGetDistance(cc.p(mx,my), cc.p(vx, vy))
        if tonumber(self.tansheInfo.range) >= dis and self.target ~= v then
            table.insert(targetList, v)
        end
    end
    
    if #targetList == 0 then
        self:playFinish()
        return false
    end
    local t = math.random(1, #targetList)
    self.target = targetList[t]
    self:initPosition(self, self.target, cc.p(0,0))
    self.tansheInfo = nil
    self:play()
end

function BulletBase:play()
    local dis = cc.pGetDistance(self.myPosition, self.targetPosition)
    local time = dis/self.speed

    local function callbackFunc()
        self:hideSpriteFrames_fly()
        if self.objectManager_:objectIsLife(self.targetKey) then    
            self:power()
        end
        
        if self.tansheInfo then
            self:playTanshe()
            performWithDelay(self, function() self:playAttackEffect() end, 0)
        else
            performWithDelay(self, function() self:playAttackEffect(function() self:playFinish() end ) end, 0)
        end
    end
    
    self:playSpriteFrames_fly(true)
    self:move(time, callbackFunc)
end

function BulletBase:playFinish()
   self.objectManager_:removeObject(self, true)
end


function BulletBase:playSpriteFrames_power(playFinishcallback)
    local dataFilename = BULLET_FRAMES_UIPATH .. "/" .. self.bullet .. "/" .. POWER .. ".plist"
    local imageFilename = BULLET_FRAMES_UIPATH .. "/" .. self.bullet .. "/" .. POWER .. ".png"
    
    local playNode = cocosMake.newSprite()
    playNode:setAnchorPoint(cc.p(0.5,0.5))
    playNode:setPosition(cc.p(0.5,0.5))
    self:addChild(playNode)
    local x = createKeyWithString(self.bullet .. POWER)%9999
    playNode:setGlobalZOrder(x)    
    
    --print("远程特效：")
    --print(dataFilename)
    --print(imageFilename)

    local function finishCallback()
        playNode:removeFromParent(true)
        playNode = nil
        if playFinishcallback then playFinishcallback() end
    end
    
    --print("self.bullet:"..self.bullet..",owner job:"..self.owner:getJob()..",name:"..self.owner.roleProperty.name)
    local anim,frameSize = roleHelper.getCacheBulletSpriteFrames(self.bullet, POWER)
    if anim then
        playNode:playAnimationOnce(anim, {showDelay=0, delay=0, onComplete=finishCallback})
    else
        finishCallback()
    end
end

function BulletBase:playSpriteFrames_fly(loop, playFinishcallback)
    local dataFilename = BULLET_FRAMES_UIPATH .. "/" .. self.bullet .. "/" .. FLY .. ".plist"
    local imageFilename = BULLET_FRAMES_UIPATH .. "/" .. self.bullet .. "/" .. FLY .. ".png"
    local playNode = cocosMake.newSprite()
    playNode:setAnchorPoint(cc.p(0.5,0.5))
    playNode:setPosition(cc.p(0.5,0.5))
    self:addChild(playNode)
    self.playNode_fly = playNode
    local x = createKeyWithString(self.bullet .. FLY)%9999
    playNode:setGlobalZOrder(x)
    self:setDirectionByBullet(playNode)

    --print("远程特效：")
    --print(dataFilename)
    --print(imageFilename)

    local function finishCallback()
        if playFinishcallback then playFinishcallback() end
    end
    local anim,frameSize = roleHelper.getCacheBulletSpriteFrames(self.bullet, FLY)
    if anim then
        playNode:playAnimationOnce(anim, {showDelay=0, delay=0, onComplete=finishCallback})
    else
        finishCallback()
    end
end
function BulletBase:hideSpriteFrames_fly()
    if self.playNode_fly then
        self.playNode_fly:setVisible(false)
        self.playNode_fly:removeFromParent(true)
        self.playNode_fly = nil
    end
end


return BulletBase