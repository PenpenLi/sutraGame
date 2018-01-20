--基于spine动画
local Avatar = class("Avatar", require(luaFile.ObjectBase))
Avatar[".isclass"] = true

testIndex = 1--test code
function Avatar:ctor()
    self.direction = ObjectDefine.Direction.none--朝向
    self.skeleton = nil
    self.effSkeletonList = {}
    self.lastPlayAnim = {name="", loop=false}
    self.actionCallback = {}
    self.eventCallback = {}
    self.timeScale = 1.0

    --序列帧Effect播放节点
    self.frameAnimEffectPlayNode = cocosMake.newSprite()
    self:addChild(self.frameAnimEffectPlayNode,1, 1)
      
end

function Avatar:initAvatar(param)
    self.createAvatar = self.createFramesAnimation -- 创建动画节点接口
    self.setTimeScale = self.setTimeScaleWithFrames--速度接口
    self.Play = self.PlayWithFrames--播放动画接口
    self.addEventCallback = self.addEventCallbackWithFrames

    --重定向
    if self:getType() == ObjectDefine.objectType.leader then 
        self.createAvatar = self.createSprineSkeletonAnimation
        self.setTimeScale = self.setTimeScaleWithSpineSkeleton
        self.Play = self.PlayWithSpineSkeleton
        self.addEventCallback = self.addEventCallbackWithSpineSkeleton
    end 
    self:createAvatar(param) 
end

function Avatar:setDirection(dir)
    if dir == ObjectDefine.Direction.left then
        self:setFlipX(true)
    elseif dir == ObjectDefine.Direction.right then
        self:setFlipX(false)
    end

    self.direction = dir--朝向
end

function Avatar:getDirection()
    return self.direction
end

function Avatar:createFramesAnimation(param)
    self.avatarName = param.name
    local skeleton = cocosMake.newSprite()
    self.skeleton = skeleton
    self:addChild(skeleton)
    skeleton:setAnchorPoint(cc.p(0.5, 0))
    self.framesAnimationCache = {}--缓存序列帧动画
    --skeleton:setOpacity(50)
end

function Avatar:createSprineSkeletonAnimation(param)
    local spineName = param.name
    self.avatarName = param.name
    --print("创建人物骨骼动画:" .. spineName)
    local scale = param.scale or 1.0
    local skeleton = roleHelper.getCacheSkeletonAvatar(spineName, scale)
 	self.skeleton = skeleton
    skeleton:setAnchorPoint(cc.p(0.5, 0))--默认锚点
    skeleton:registerSpineEventHandler(function(event)
        --if event.type == 'event' then
        	if self.eventCallback[event.eventData.name] then
        		self.eventCallback[event.eventData.name](event)
        	end
        --end
    end, sp.EventType.ANIMATION_EVENT)

    skeleton:registerSpineEventHandler(function(event)
        --if event.type == 'complete' then
            
        	if self.actionCallback[event.animation] then
                self.actionCallback[event.animation]()
                self.actionCallback[event.animation] = nil
            end
        --end
    end, sp.EventType.ANIMATION_COMPLETE)
    self:addChild(skeleton)
end

function Avatar:setFlipX(flip)
    if flip then
	    self.skeleton:setScaleX(-1)
        self.direction = ObjectDefine.Direction.left
    else
        self.skeleton:setScaleX(1)
        self.direction = ObjectDefine.Direction.right
    end
end

function Avatar:addEventCallbackWithSpineSkeleton(evenName,callback)
    self.eventCallback[evenName] = callback
end

--立刻执行倒计时，不与当前播放的动作关联
function Avatar:addEventCallbackWithFrames(evenName,callback)
    local actionKey = evenName .. "_key"
    local actionData = DataManager.getFightSoldierFramesData(self.avatarName)
    local actionData = tonumber(actionData[actionKey]) * fight_soldier_frames_play_rate
    performWithDelay(self.skeleton, function() if callback then callback() end end, actionData)
end

function Avatar:delEventCallback(evenName)
    self.eventCallback[evenName] = nil
end

function Avatar:setTimeScaleWithSpineSkeleton(s)
    self.timeScale = s or 1.0
    self.skeleton:setTimeScale(self.timeScale)
end
function Avatar:setTimeScaleWithFrames(s)
    self.timeScale = s or 1.0
    --self.skeleton:setTimeScale(self.timeScale)
end

function Avatar:getTimeScale()
    return self.timeScale
end

function Avatar:setColor(clr)
    return self.skeleton:setColor(clr)
end

function Avatar:deleteActionCallback(name)
    self.actionCallback[name] = nil
end

function Avatar:lastPlayAnimationName()
    return self.lastPlayAnim.name
end
function Avatar:PlayWithSpineSkeleton(name,callback,loop)
    --print("播放骨骼动画："..name .. ",rolename:"..(self.roleProperty.name or ""))
    if self.lastPlayAnim.name == name and self.lastPlayAnim.loop == loop then
    else
        self.actionCallback[name] = callback
	    self.skeleton:setAnimation(0,name,loop)
        self.lastPlayAnim.name = name 
        self.lastPlayAnim.loop = loop
    end
end
function Avatar:PlayWithFrames(name,callback,loop)
    --print("播放角色序列帧动作："..name .. ", avatarName:" .. self.avatarName)
    if self.lastPlayAnim.name == name and self.lastPlayAnim.loop == loop then
    else
        if self.lastPlayAnim.action then
            self.skeleton:stopAction( self.lastPlayAnim.action )
        end
        --增加动作缓存
        if not self.framesAnimationCache[name] then
            local anim,framesize = roleHelper.getCacheFrameAvatar(self.avatarName, name)
            local apos = string.split( DataManager.getFightSoldierFramesData(self.avatarName)[name .. "_picPos" ], "," )
            local anchorPos = cc.p(0.5, 0)

            if true then
                anchorPos.x = tonumber(apos[1]) / framesize.width
                anchorPos.y = (framesize.height - tonumber(apos[2])) / framesize.height
            else
                anchorPos.x = (framesize.width - tonumber(apos[1])) / framesize.width
                anchorPos.y = (framesize.height - tonumber(apos[2])) / framesize.height
            end

            self.framesAnimationCache[name] = {}
            self.framesAnimationCache[name].anchorPos = anchorPos
            self.framesAnimationCache[name].anim = anim
            self.framesAnimationCache[name].anim:retain()
        end

        self.lastPlayAnim.name = name
        self.lastPlayAnim.loop = loop
        if loop then
            self.lastPlayAnim.action = self.skeleton:playAnimationForever(self.framesAnimationCache[name].anim)
        else
            self.lastPlayAnim.action = self.skeleton:playAnimationOnce(self.framesAnimationCache[name].anim, {showDelay=0, delay=0, onComplete=callback})
        end
        self.skeleton:setAnchorPoint(self.framesAnimationCache[name].anchorPos)
        
    end
end


function Avatar:PlayByName(actionName)
	self.skeleton:setSlotsToSetupPose()
	if actionName == nil or actionName == "" then
		self:PlayIdle(function ()end,true)
	else
		local function callback()
			self:PlayIdle(function ()end,true)
		end
		self:Play(actionName,callback,false)
	end
end

function Avatar:PlayAngry(callback,loop)
	self.skeleton:setSlotsToSetupPose()
	self:Play("angry",callback,loop)
end

function Avatar:PlayEffectSkeleton(spineName, callback, isLoop)
    --if true then return true end 
    --print("播放特效骨骼动画 : " .. spineName)
    if self.actionCallback == nil then
		self.actionCallback = {}
	end
	if callback then self.actionCallback[spineName] = callback end

    local name = "play"
    local effSkeleton = self.effSkeletonList[spineName]
    if not effSkeleton then
	    local json = SKELETON_EFFECT_ANIMATION_PATH .. "/" .. spineName ..".json"
        local atlas = SKELETON_EFFECT_ANIMATION_PATH .. "/" .. spineName ..".atlas"

        effSkeleton = sp.SkeletonAnimation:create(json, atlas, 1.0)
        self.effSkeletonList[spineName] = effSkeleton
        self:addChild(effSkeleton)
    end
    effSkeleton:setAnimation(0,name and name or "attack", isLoop and true or false)
    effSkeleton:setScaleX(self.direction ~= ObjectDefine.Direction.left and 1 or -1)
end

function Avatar:clearEffectSkeleton(name)
    if not name then
        for k,v in pairs(self.effSkeletonList) do
            v:removeFromParent(true)
        end
        self.effSkeletonList = {}

    elseif self.effSkeletonList[name] then
        self.effSkeletonList[name]:removeFromParent(true)
        self.effSkeletonList[name] = nil
    end        
end

function Avatar:PlayBuffEffectFrameAnimation(frameName, isLoop, callback)
    --if true then return true end 
    --print("播放特效序列帧动画 : " .. frameName)

    local anim, framesize = roleHelper.getCacheBuffEffectSpriteFrames(frameName)
    if anim then
        self.frameAnimEffectPlayNode:setVisible(true)
        if not isLoop then
            local function completeCallback()
                self.frameAnimEffectPlayNode:setVisible(false)
            end
            self.frameAnimEffectPlayNode:playAnimationOnce(anim, {showDelay=0, delay=0, onComplete=completeCallback})
        else
            self.frameAnimEffectPlayNode:playAnimationForever(anim)
        end

        local offset = self:getBeBulletAttackOffset()
        self.frameAnimEffectPlayNode:setPosition(offset.x, offset.y+5)

        self.frameAnimEffectPlayNode:setScaleX(self.direction ~= ObjectDefine.Direction.left and 1 or -1)
    end
end

return Avatar