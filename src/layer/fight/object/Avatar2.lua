--基于spine动画
local Avatar = class("Avatar", require(luaFile.ObjectBase))
Avatar[".isclass"] = true

function Avatar:ctor()
    self.direction = ObjectDefine.Direction.none--朝向
    self.skeleton = nil
    self.effSkeletonList = {}
    self.lastPlayAnim = {name="", loop=false}
    self.frameActionList = {}
    self.actionCallback = {}
    self.eventCallback = {}
end

function Avatar:init()
    
end

function Avatar:initAvatar(param)
    self:createSkeletonAnim({name = param and param.name or "", scale = param and param.scale or 1.0})
end

function Avatar:setDirection(dir)
    if dir == ObjectDefine.Direction.left then
        self:setFlipX(true)
    elseif dir == ObjectDefine.Direction.right then
        self:setFlipX(false)
    end
     --self:setFlipX(true)
    self.direction = dir--朝向
end

function Avatar:getDirection()
    return self.direction
end

--创建spine对象
function Avatar:createSkeletonAnim(param)
    local spineName = param.name
   
    print("创建人物骨骼动画:" .. spineName)
    local scale = param.scale or 1.0
    local path = "avatar"
	local json = SKELETON_ANIMATION_PATH .. "/" .. path .. "/" .. spineName ..".json"
    local atlas = SKELETON_ANIMATION_PATH .. "/" .. path .. "/" .. spineName ..".atlas"
    
 	local skeleton = sp.SkeletonAnimation:create(json, atlas, scale)
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
    --local x,y,r = skeleton:getSponePositionAndRotation("bone9")
end

function Avatar:setFlipX(flip)
    if flip then
	    self.skeleton:setScaleX(-1)
    else
        self.skeleton:setScaleX(1)
    end
end


function Avatar:addEventCallback(evenName,callback)
    self.eventCallback[evenName] = callback
end
function Avatar:delEventCallback(evenName)
    self.eventCallback[evenName] = nil
end

function Avatar:setTimeScale(s)
    self.skeleton:setTimeScale(s or 1.0)
end

function Avatar:getTimeScale()
    return self.skeleton:getTimeScale()
end

function Avatar:setColor(clr)
    return self.skeleton:setColor(clr)
end

function Avatar:deleteActionCallback(name)
    self.actionCallback[name] = nil
end

function Avatar:Play(name,callback,loop)
	if self.actionCallback == nil then
		self.actionCallback = {}
	end
	if callback then self.actionCallback[name] = callback end

    if self.lastPlayAnim.name == name and self.lastPlayAnim.loop == true then
    else
	    self.skeleton:setAnimation(0,name,loop)
        self.lastPlayAnim.name = name 
        self.lastPlayAnim.loop = loop
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

function Avatar:PlayEffectSkeleton(spineName, callback)
    print("播放特效骨骼动画 : " .. spineName)
    if self.actionCallback == nil then
		self.actionCallback = {}
	end
	if callback then self.actionCallback[spineName] = callback end

    local name = "play"
    local effSkeleton = self.effSkeletonList[spineName]
    if not effSkeleton then
	    local path = "spineEffect"
	    local json = SKELETON_ANIMATION_PATH .. "/" .. path .. "/" .. spineName ..".json"
        local atlas = SKELETON_ANIMATION_PATH .. "/" .. path .. "/" .. spineName ..".atlas"

        effSkeleton = sp.SkeletonAnimation:create(json, atlas, 1.0)
        self.effSkeletonList[spineName] = effSkeleton
        self.skeleton:addChild(effSkeleton)
    end
    effSkeleton:setAnimation(0,name and name or "attack", false)
end

function Avatar:clearEffectSkeleton()
    for k,v in pairs(self.effSkeletonList) do
        v:removeFromParent(true)
    end
    self.effSkeletonList = {}
end

return Avatar