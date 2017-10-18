local comboSkillLayer = class("comboSkillLayer", cocosMake.viewBase)
comboSkillLayer.ui_resource_file = {}
comboSkillLayer.ui_binding_file = {}
comboSkillLayer.notify = {"playComboSkill_notify"}

local blackLayer_z = 10000
function comboSkillLayer:onCreate()
    self.playSkillQueue = {}
    self.lock = false--锁住playSkillQueue

    self.blackLayer = cocosMake.newLayer(cc.c4b(0,0,0,255*0.2))
    self.blackLayer:setGlobalZOrder(blackLayer_z)
    
    
    self:addChild(self.blackLayer)
    self.blackLayer:setVisible(false)
end

function comboSkillLayer:onClose()
end

function comboSkillLayer:handleNotification(notifyName, body)
    if notifyName == "playComboSkill_notify" then
        print("***********************")
        print_lua_table(body)
        table.insert(self.playSkillQueue, {role=body.role, tab=body.tab, completeCallback=body.completeCallback})
        self:playSkillPush()
    end
end

function comboSkillLayer:unTouch()
    local eventDispacher = self:getEventDispatcher()
    if self.touchListener then
        eventDispacher:removeEventListener(self.touchListener)
        self.touchListener = nil
    end

    local function onTouchBegan(touch, event)
        return false
	end

    --注册触摸事件
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
	--listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	--listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    
	eventDispacher:addEventListenerWithSceneGraphPriority(listener, self)
    self.touchListener = listener
end

--弃用
function comboSkillLayer:playSkillPush1111()
    if #self.playSkillQueue <= 0 then
        return
    end
    
    local role = self.playSkillQueue[1].role
    local skillID = self.playSkillQueue[1].skillID
    local completeCallback = self.playSkillQueue[1].completeCallback
    table.remove(self.playSkillQueue, 1)
    
    self.blackLayer:setVisible(true)
    

    local pushLayer = cocosMake.newLayer()
    self:addChild(pushLayer)

    local comboBG = cocosMake.newSprite("res/skillBG.png")
    comboBG:setPosition(cc.p(display.visibleRect.center.x, display.visibleRect.center.y))
    self:addChild(comboBG, 1)
    self.comboBG = comboBG

    local roleImage = cocosMake.newSprite("res/skillRole.png")
    roleImage:setPosition(cc.p(display.visibleRect.center.x - 200, display.visibleRect.center.y))
    self:addChild(roleImage, 2)
    self.roleImage = roleImage

    local textImage = cocosMake.newSprite("res/skillName.png")
    textImage:setPosition(cc.p(display.visibleRect.center.x + 200, display.visibleRect.center.y))
    self:addChild(textImage, 3)
    self.textImage = textImage

    
    local leftMoveX = display.winSize.width

    self.comboBG:setPositionX(self.comboBG:getPositionX() - leftMoveX)
    self.roleImage:setPositionX(self.roleImage:getPositionX() - leftMoveX)
    self.textImage:setPositionX(self.textImage:getPositionX() - leftMoveX)

    local setSpeed = 0.05/g_fightLogic:getFightSpeed()
    cocosMake.setGameSpeed(setSpeed)

    self.blackLayer:setGlobalZOrder(9999)
    pushLayer:setGlobalZOrder(9999)
    self.comboBG:setGlobalZOrder(9999)
    self.roleImage:setGlobalZOrder(9999)
    self.textImage:setGlobalZOrder(9999)

    local function onComplete()
        cocosMake.setGameSpeed(g_fightLogic:getFightSpeed())

        if completeCallback then completeCallback() end

        self.blackLayer:setVisible(false)
        self.blackLayer:setTouchEnabled(false)

        pushLayer:removeFromParent(true)
        self.comboBG:removeFromParent(true)
        self.roleImage:removeFromParent(true)
        self.textImage:removeFromParent(true)
        
    end

    local stayTime = 1.2
    local sequence_bg = transition.sequence({
            CCMoveBy:create(0.3*setSpeed, cc.p(leftMoveX, 0)),
            CCMoveBy:create(stayTime*setSpeed, cc.p(10, 0)),
            CCMoveBy:create(0.3*setSpeed, cc.p(-leftMoveX + 10, 0))
        })
    local sequence_role = transition.sequence({
            CCDelayTime:create(0.5*setSpeed),
            CCMoveBy:create(0.3*setSpeed, cc.p(leftMoveX, 0)),
            CCMoveBy:create((stayTime-0.5)*setSpeed, cc.p(10, 0)),
            CCMoveBy:create(0.3*setSpeed, cc.p(-leftMoveX + 10, 0))
        })
    local sequence_text = transition.sequence({
            CCDelayTime:create(0.5*setSpeed),
            CCMoveBy:create(0.3*setSpeed, cc.p(leftMoveX, 0)),
            CCMoveBy:create((stayTime-0.5)*setSpeed, cc.p(10, 0)),
            CCMoveBy:create(0.3*setSpeed, cc.p(-leftMoveX + 10, 0)),
            cc.CallFunc:create(onComplete)
        })
   self.comboBG:runAction(sequence_bg)
   self.roleImage:runAction(sequence_role)
   self.textImage:runAction(sequence_text)
end

function comboSkillLayer:playSkillPush()
    if #self.playSkillQueue <= 0 then
        return
    end
    print("playSkillPush")
    local role = self.playSkillQueue[1].role
    local skillTab = self.playSkillQueue[1].tab
    local completeCallback = self.playSkillQueue[1].completeCallback
    table.remove(self.playSkillQueue, 1)
    
    local blackLayer = self.blackLayer
    
    local rPos = role:getParent():convertToWorldSpace(cc.p(role:getPosition()))

    local skill_jiaodiguang_spr = cocosMake.newSprite()
    skill_jiaodiguang_spr:setPosition(rPos)
    skill_jiaodiguang_spr:setGlobalZOrder(blackLayer_z+2)
    blackLayer:addChild(skill_jiaodiguang_spr)

    local skill_beiguang_spr = cocosMake.newSprite()
    skill_beiguang_spr:setScale(2)
    skill_beiguang_spr:setPosition(cc.p(rPos.x, rPos.y-110))
    skill_beiguang_spr:setAnchorPoint(cc.p(0.5,0))
    skill_beiguang_spr:setGlobalZOrder(blackLayer_z+2)
    blackLayer:addChild(skill_beiguang_spr)

    local setSpeed = 0.05/g_fightLogic:getFightSpeed()
    local skillNameSpr = nil
    local rolez = role:getGlobalZOrder()

    local function onComplete()
        cocosMake.setGameSpeed(g_fightLogic:getFightSpeed())
        role:setGlobalZOrder_(rolez)

        if completeCallback then completeCallback() end

        blackLayer:setVisible(false)
        blackLayer:setTouchEnabled(false)

        skill_jiaodiguang_spr:removeFromParent(true)
        skill_beiguang_spr:removeFromParent(true)
        skillNameSpr:removeFromParent(true)
    end

    local function f1()
        blackLayer:setVisible(true)
        self.blackLayer:registerScriptTouchHandler(function() return true end,false,0,true)
        self.blackLayer:setTouchEnabled(true)

        cocosMake.setGameSpeed(setSpeed)
        role:setGlobalZOrder_(blackLayer_z*2)
    end
    local function f2()
        local function completePlay()
            skill_jiaodiguang_spr:setVisible(false)
            local anim = roleHelper.getCacheSkillComboEffectSpriteFrames(2, setSpeed)
            skill_beiguang_spr:playAnimationOnce(anim, {showDelay=0, delay=0, onComplete=onComplete})

            skillNameSpr = cocosMake.newSprite( SKILL_NAME_UI_PATH .. "/" .. skillTab .. ".png" )
            skillNameSpr:setPosition(rPos.x+0, rPos.y+147)
            skillNameSpr:setScale(2)
            local spawn = cc.Spawn:create(CCMoveBy:create(0.04/setSpeed, cc.p(0, 220)), CCScaleBy:create(0.14/setSpeed, 1.5))
            local sequence = transition.sequence({
                    spawn,
                    cc.DelayTime:create(0.48/setSpeed),
                    CCFadeOut:create(0.32/setSpeed)
                })
            skillNameSpr:runAction(sequence)
            skillNameSpr:setGlobalZOrder(blackLayer_z+2)
            blackLayer:addChild(skillNameSpr)   
        end
        local anim = roleHelper.getCacheSkillComboEffectSpriteFrames(1, setSpeed)
        skill_jiaodiguang_spr:playAnimationOnce(anim, {showDelay=0, delay=0, onComplete=completePlay})
    end


    local sequence_action = transition.sequence({
            cc.CallFunc:create(f1),
            cc.CallFunc:create(f2)
        })
    

   blackLayer:runAction(sequence_action)
end


return comboSkillLayer
