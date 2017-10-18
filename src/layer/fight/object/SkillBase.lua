local SkillBase = class("SkillBase", require(luaFile.ObjectBase))
SkillBase[".isclass"] = true

local st_none = 0
local st_really = 1
local st_playing = 2
local st_playingEff = 3
local st_Over = 4
function SkillBase:ctor(param)
    self.direction = ObjectDefine.Direction.none--朝向
    self.skeleton = nil
    self.spriteFrameAnimation = nil

    --print("添加技能单位，skillID= " .. param.skillID)
    self.skillID = param.skillID
    self.skillInfo = DataManager.getSkillByID(param.skillID)--技能信息
    
    self.owner = param.leader--归属单位
    self.ownerKey = self.owner:getKey()
    self.spriteFrameCache = {}
    self.state_ = st_none
    self.camp = param.camp
    self.completeCallback = param.completeCallback
    self.targetBuffList = {}
    self.selfBuffList = {}
    self.skillPowerEff = param.skillPowerEff and param.skillPowerEff[1] or ""
    self.flyPos_skill = param.flyPos_skill and param.flyPos_skill or {0,0}
    self.picPos_skil = param.picPos_skil and param.picPos_skil or {0,0}
    self.skillFlySpeed = param.skillFlySpeed or 600
    self.skillPowerScale = param.skillPowerScale or 1
    
    self:init(param)
end

function SkillBase:isInAirLayer()
    return self.skillInfo.layer == 2
end
function SkillBase:isInFightLayer()
    return self.skillInfo.layer == 0
end
function SkillBase:isInGroundLayer()
    return self.skillInfo.layer == 1
end

--伤害输出函数，子类重载
function SkillBase:power()
end

--技能释放结束回调
function SkillBase:finishCallback()
end

function SkillBase:init(param)
    self:setType(param.objectType)
    self:parseBuff()
    
    
    local x,y = self.owner:getPosition()
    self:setPosition(cc.p(x,y))

    if DEBUG > 1 then
        --self.owner.skeleton:setColor(cc.c3b(255,0,0))
        --self.owner:setLocalZOrder(1024)
    end

end

--处理BUFF
function SkillBase:parseBuff()    
    local buffList = string.split(self.skillInfo.buffId, ",")
    for i=1,#buffList do
        --print("1处理技能BUFF=." .. buffList[i]..".")
        if buffList[i] == "" then
            break
        end
        local buffID = tonumber(buffList[i])
        if buffID ~= 0 or buffList[i] == "" then
            local buffInfo = DataManager.getBuffDataByID(buffID)
            if tonumber(buffInfo.stateObject) == 5 then
                table.insert(self.selfBuffList, buffID)
            
            else
                table.insert(self.targetBuffList, buffID)
            end
        end
    end
end

function SkillBase:setDPSEvent()
    
    --伤害输出间隔,
    self.skillInfo.dpsduration = self.skillInfo.dpsduration/1000--毫秒
    local function delayCallback()
        if self.state_ == st_playing then
            self:power()
            self:playFinish()
        end
    end
    local function scheduleCallback()
        if self.state_ == st_playing then
            self:power()
        end
    end

    if self.skillInfo.continueTime < 0.1 then
        performWithDelay(self, delayCallback, self.skillInfo.dpsduration)
    else
        schedule(self, scheduleCallback, self.skillInfo.dpsduration)
    end
end

function SkillBase:getCamp()
    return self.camp
end

function SkillBase:setDurationState()
    self.skillInfo.continueTime = self.skillInfo.continueTime/1000--如果为零，那么无持续，一次性输出攻击
    local function delayCallback()
        self:playFinish()
    end
    if self.skillInfo.continueTime > 0.00 then
        performWithDelay(self, delayCallback, self.skillInfo.continueTime > 0.00 and self.skillInfo.continueTime or 0.1)
    end
end

function SkillBase:setDirection(dir)
    if dir == ObjectDefine.Direction.left then
        self:setFlipX(true)
    elseif dir == ObjectDefine.Direction.right then
        self:setFlipX(false)
    end
     --self:setFlipX(true)
    self.direction = dir--朝向
end

function SkillBase:removeSelf()
    self.objectManager_:removeObject(self, true)
end

function SkillBase:playFinish()
    self:finishCallback()
    self.state_ = st_Over

    if self.skillPowerEff == "" then
        self:removeSelf()
    end
end

function SkillBase:play()
    self.state_ = st_playing
    local function  powerCreate(args)
        self:setDurationState()--设置技能持续时间
        self:setDPSEvent()--设置伤害输出间隔
    end

    --选定目标
    local target = self:getTargetObject()
    if target then
        self.selectTarget = target
        self.selectTargetKey = target:getKey()
        self.targetPosX, self.targetPosY = target:getPosition()
    end

    --如果有fly特效
    if self:haveFlyEff(self.skillPowerEff) and target then
        
        local sx,sy = self:getPosition()
        local ox = tonumber(self.flyPos_skill[1] or 0)
        local oy = tonumber(self.flyPos_skill[2] or 0)
        
        
        local tx,ty = target:getPosition()
        local bPos = target:getBeSkillAttackOffset()

        --设置方向
        self:setDirection(sx < tx and ObjectDefine.Direction.right or ObjectDefine.Direction.left)
        if self.direction == ObjectDefine.Direction.left then
            ox = -ox
        end

        sx = sx + ox
        sy = sy + oy

        tx = tx + bPos.x
        ty = ty + bPos.y

        local dis = cc.pGetDistance(cc.p(sx,sy), cc.p(tx,ty))

        local time = dis/self.skillFlySpeed
        
        self:playSpriteFrames(self.skillPowerEff, "fly")

        if sx > tx then
            self:setFlipX(true)
        end

        self:setPosition(cc.p(sx, sy))
        
        transition.moveTo(self, {x=tx, y=ty, time=time, onComplete=powerCreate})
    else
        powerCreate()
    end
end

function SkillBase:setFlipX(flip)
    if flip then
	    self:setScaleX(-1)
    else
        self:setScaleX(1)
    end
end

function SkillBase:getTargetObject()
    return nil
end

function SkillBase:haveFlyEff(effID)
    local dataFilename = SKILLEFFECT_FRAMES_UIPATH .. "/" .. effID .. "/" .. "fly.plist"
    --local imageFilename = SKILLEFFECT_FRAMES_UIPATH .. "/" .. effID .. "/" .. "fly.png"
    local exist = cc.FileUtils:getInstance():isFileExist(dataFilename)
    return exist
end


function SkillBase:playSpriteFrames(name, frameType, playFinishcallback)
    local effID = name
    local dataFilename = SKILLEFFECT_FRAMES_UIPATH .. "/" .. effID .. "/" .. frameType .. ".plist"
    local imageFilename = SKILLEFFECT_FRAMES_UIPATH .. "/" .. effID .. "/" .. frameType .. ".png"

    if false == cc.FileUtils:getInstance():isFileExist(dataFilename) then
        if playFinishcallback then playFinishcallback() end
        return
    end
    
    --print("技能特效：")
    --print(dataFilename)
    --print(imageFilename)

    if self.playNode then
        self.playNode:removeFromParent(true)
    end
    local playNode = cocosMake.newSprite()
    self.playNode = playNode
    self:addChild(playNode)
    playNode:setScale(1.0)
    playNode:setPosition( cc.p(0,0) )

    local time = 0.1
    local anim,frameSize = roleHelper.getCacheSkillEffectSpriteFrames(effID, frameType)
    --print("skillframe.effID:"..effID..",frameType:"..frameType)
    local function showCompleteCallback()
        if playFinishcallback then playFinishcallback() end
    end
        
    if frameType == "power" and (self.picPos_skil[1] > 0 or self.picPos_skil[2] > 0) then
        local ax = self.picPos_skil[1] / frameSize.width
        local ay = (frameSize.height-self.picPos_skil[2]) / frameSize.height
        playNode:setAnchorPoint(cc.p(ax, ay))
        playNode:setScale( self.skillPowerScale / 1 )
        --print("ax:"..ax..",ay:"..ay.."，frameSize.width："..frameSize.width..",frameSize.height:"..frameSize.height.."self.picPos_skil[1]:"..self.picPos_skil[1]..",self.picPos_skil[2]:"..self.picPos_skil[2])
        --playNode:setAnchorPoint(cc.p(0.5, 0.5))
    else
        playNode:setAnchorPoint(cc.p(0.5, 0.5))
    end
    playNode:playAnimationOnce(anim, {showDelay=0, delay=0, onComplete=showCompleteCallback})
end


function SkillBase:playSkeletonAnimation(effInfo, playFinishcallback)
    local path = "skill"
	local json = SKELETON_ANIMATION_PATH .. "/" .. path .. "/" .. effInfo.res_id ..".json"
    local atlas = SKELETON_ANIMATION_PATH .. "/" .. path .. "/" .. effInfo.res_id ..".atlas"
    
    local playNode = cocosMake.newNode()
    self:addChild(playNode)
    playNode:setScale(effInfo.scale)

 	local skeleton = sp.SkeletonAnimation:create(json, atlas, 1.0)
    skeleton:registerSpineEventHandler(function(event)
        if event.animation == effInfo.anim and event.type == "end" then
            performWithDelay(playNode, function() playNode:removeFromParent(true) playFinishcallback() end , 0.0)
        end
    end, sp.EventType.ANIMATION_END)

    playNode:addChild(skeleton)
    skeleton:setAnimation(0, effInfo.anim, effInfo.loop ~= 0)


    if effInfo.loop ~= 0 and effInfo.duration > 0 then--不循环且duration有值
        performWithDelay(playNode, playFinishcallback, effInfo.duration)
    end
end

return SkillBase

--[[
技能类别：
持续性技能
一次性技能


移动
固定
--]]