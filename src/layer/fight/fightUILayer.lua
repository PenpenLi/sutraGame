local fightUILayer = class("fightUILayer", cocosMake.viewBase)
fightUILayer.ui_resource_file = {"fightUI_bottomVS", "fightUI_topVS", "fightBuzhenUI_bottomVS", "fightBuzhenUI_topVS"}

fightUILayer.ui_binding_file = {
left_power={name="fightBuzhenUI_topVS.Panel.left_power"},
right_power={name="fightBuzhenUI_topVS.Panel.right_power"},
right_name={name="fightBuzhenUI_topVS.Panel.right_name"},
left_name={name="fightBuzhenUI_topVS.Panel.left_name"},
btn_back={name="fightBuzhenUI_topVS.Panel.btn_back",event="touch",method="OnBackBtnClick"},

btn_buzhen={name="fightBuzhenUI_bottomVS.Panel.btn_buzhen",event="touch",method="OnBuzhenBtnClick"},
btn_zhenxing={name="fightBuzhenUI_bottomVS.Panel.btn_zhenxing",event="touch",method="OnZhenxingBtnClick"},
btn_fightstart={name="fightBuzhenUI_bottomVS.Panel.btn_fightStart",event="touch",method="OnStartFightBtnClick"},
leaderHead_listviewPanel={name="fightBuzhenUI_bottomVS.Panel.leaderHead_listviewPanel"},

btn_auto={name="fightUI_bottomVS.Panel.btn_auto",event="touch",method="OnAutoBtnClick"},
btn_pause={name="fightUI_topVS.Panel.btn_pause",event="touch",method="OnPauseFightBtnClick"},
speed={name="fightUI_bottomVS.Panel.btn_speed",event="touch",method="OnSpeedFightBtnClick"},
skillBtn_listviewPanel={name="fightUI_bottomVS.Panel.skillBtn_listviewPanel"},
fightSpeedLabel={name="fightUI_bottomVS.Panel.fightSpeed"},

LoadingBar_left={name="fightUI_topVS.Panel.left_hp"},
LoadingBar_right={name="fightUI_topVS.Panel.right_hp"},
taiji_icon={name="fightUI_topVS.Panel.taiji_icon"},
VSTime={name="fightUI_topVS.Panel.time"},
fight_right_name={name="fightUI_topVS.Panel.right_name"},
fight_left_name={name="fightUI_topVS.Panel.left_name"},
leftBuff_1={name="fightUI_topVS.Panel.leftBuff_1"},
leftBuff_2={name="fightUI_topVS.Panel.leftBuff_2"},
leftBuff_3={name="fightUI_topVS.Panel.leftBuff_3"},
leftBuff_4={name="fightUI_topVS.Panel.leftBuff_4"},
leftBuff_5={name="fightUI_topVS.Panel.leftBuff_5"},
leftBuff_6={name="fightUI_topVS.Panel.leftBuff_6"},
rightBuff_6={name="fightUI_topVS.Panel.rightBuff_6"},
rightBuff_5={name="fightUI_topVS.Panel.rightBuff_5"},
rightBuff_4={name="fightUI_topVS.Panel.rightBuff_4"},
rightBuff_3={name="fightUI_topVS.Panel.rightBuff_3"},
rightBuff_2={name="fightUI_topVS.Panel.rightBuff_2"},
rightBuff_1={name="fightUI_topVS.Panel.rightBuff_1"},


}
fightUILayer.notify = {"removeSkillReally_notify", "showFightAccountsUI_notify"}

function fightUILayer:onCreate(param)
    --[[
    --local visibleOrigin = view:getVisibleOrigin()
    --display.frameSize = {width = sizeInPixels.width, height = sizeInPixels.height}--实际屏幕大小（物理分辨率）
    --display.contentScaleFactor = director:getContentScaleFactor()--
    --display.winSize = {width = viewsize.width, height = viewsize.height}--实际使用分辨率大小
	--display.visibleRect = { leftBottom={x=visibleOrigin.x, y=visibleOrigin.y}, rightTop={x=display.winSize.width-visibleOrigin.x, y=display.winSize.height-visibleOrigin.y} }--实际场景显示Rect(即适配后，中间可以显示到屏幕的区域)
    
    print("=======================")
    print_lua_table(display.frameSize)
    print(display.contentScaleFactor)
    print_lua_table(display.winSize)
    print(display._scaleX)
    print(display._scaleY)
    print("----------------------")
    print_lua_table(display.visibleRect)
    --]]
    --vs血条UI
    self.fightUI_topVS:setPosition(display.visibleRect.topCenter.x, display.visibleRect.topCenter.y)

    --技能UI
    self.fightUI_bottomVS:setPosition(display.visibleRect.bottomCenter.x, display.visibleRect.bottomCenter.y)

    --布阵UI
    self.fightBuzhenUI_topVS:setPosition(display.visibleRect.topCenter.x, display.visibleRect.topCenter.y)

    --布阵底部UI
    self.fightBuzhenUI_bottomVS:setPosition(display.visibleRect.bottomCenter.x, display.visibleRect.bottomCenter.y)

    local spr1 = cocosMake.newSprite("Star.png", display.visibleRect.leftBottom.x, display.visibleRect.leftBottom.y)
	self:addChild(spr1,100)
	
	local spr2 = cocosMake.newSprite("Star.png", display.visibleRect.rightTop.x, display.visibleRect.rightTop.y)
    self:addChild(spr2,100)

    self.LoadingBar_right:setPercent(100)
    self.LoadingBar_left:setPercent(100)

    --激活技能按钮
    self.skillReallyButtonList = {}

    --武将头像上阵
    self.leaderHeadList = {}

    --self.taiji_icon:runAction(cc.RepeatForever:create(cc.RotateBy:create(15,360)))

    self.fightUI_topVS:setVisible(false)
    self.fightUI_bottomVS:setVisible(false)

    self.left_name:setString("我在左边")
    self.right_name:setString("你在右边")
    self.fight_right_name:setString("我在左边")
    self.fight_left_name:setString("你在右边")
    
    self.leftBuff_1:setVisible(false)
    self.leftBuff_2:setVisible(false)
    self.leftBuff_3:setVisible(false)
    self.leftBuff_4:setVisible(false)
    self.leftBuff_5:setVisible(false)
    self.leftBuff_6:setVisible(false)
    self.rightBuff_1:setVisible(false)
    self.rightBuff_2:setVisible(false)
    self.rightBuff_3:setVisible(false)
    self.rightBuff_4:setVisible(false)
    self.rightBuff_5:setVisible(false)
    self.rightBuff_6:setVisible(false)


    --战斗倒计时（秒）
    self.VSTimes = 120
    self.VSTime:setString(timeToDataM(self.VSTimes))

    self.skilllistviewSize = self.skillBtn_listviewPanel:getContentSize()
    self.leadHeadlistviewSize = self.leaderHead_listviewPanel:getContentSize()

    --往后加, 用于技能图标排序
    self.activeSkillKey = 0

    --克制显示层
    self.kezhiLayer = self:showFloat(luaFile.fightKezhiLayer)
end

function fightUILayer:onClose()
    self:StopCountDownVSTime()
end



function fightUILayer:updateCountDownVSTime()
    self.VSTimes = math.max(0, self.VSTimes - 1)
    self.VSTime:setString(timeToDataM(self.VSTimes))
    if self.VSTimes <= 0 then
        self:StopCountDownVSTime()
    end
end

function fightUILayer:starCountDownVSTime()
    local function scheduleFunc()
        self:updateCountDownVSTime()
    end
    self.CountDownVSTimeSchedule = schedule(self, scheduleFunc, 1)
    self.CountDownVSTimeSchedule:setTag(100)
end

function fightUILayer:StopCountDownVSTime()
    if self.CountDownVSTimeSchedule then
        self:stopActionByTag(100)
        self.CountDownVSTimeSchedule = nil
    end
end



function fightUILayer:OnAutoBtnClick(event)
    if event.state == 2 then
        
    end
end

function fightUILayer:OnStartFightBtnClick(event)
    if event.state == 2 then
        if g_fightLogic:canStartFight() then
            print("开始行动===================开始行动")
        
            self:starCountDownVSTime()
            self.fightBuzhenUI_topVS:removeFromParent(true)
            self.fightBuzhenUI_bottomVS:removeFromParent(true)
            self.updateLeftPower = function()end
            self.updateRightPower = function()end
            local function showui()
                self.fightUI_topVS:setVisible(true)
                self.fightUI_bottomVS:setVisible(true)
            end
            performWithDelay(self, showui, 0)
            

            Notifier.postNotifty("startFight_notify")
        end
    end
end

function fightUILayer:OnZhenxingBtnClick(event)
    if event.state == 2 then
        Notifier.postNotifty("changeTactics_notify")
    end
end

function fightUILayer:OnBuzhenBtnClick(event)
    if event.state == 2 then
        Notifier.postNotifty("autoEmbattle_notify")
    end
end

function fightUILayer:OnBackBtnClick(event)
    if event.state == 2 then
        if g_fightLogic:isFightReally() then
            Notifier.postNotifty("exitFight_notify")
        end
    end
end


function fightUILayer:OnPauseFightBtnClick(event)
    if event.state == 2 then
        local speed = g_fightLogic:getFightSpeed()
        
        local tips = nil
        if speed > 0 then
            self.originalSpeed = speed
            speed = 0
        else
            speed = self.originalSpeed
        end
        g_fightLogic:setFightSpeed(speed)
    end
end

function fightUILayer:OnSpeedFightBtnClick(event)
    if event.state == 2 then
        
        local speed = g_fightLogic:getFightSpeed()
        print("speed:" .. speed)
        local tips = nil
        if speed == 1 then
            speed = 1.5
            tips = "X2"
        elseif speed == 2 then
            speed = 1
            tips = "X1"
        end
        self.fightSpeedLabel:setString(tips)
        g_fightLogic:setFightSpeed(speed)
    end
end


function fightUILayer:showFightAccountsWinUI(args)
    self:showFloat(luaFile.FightSuccessUI,args)
end
function fightUILayer:showFightAccountsLoseUI()
    self:showFloat(luaFile.FightFailedUI)
end

function fightUILayer:setLeftHp(value)
    self.LoadingBar_left:setPercent(value)
end

function fightUILayer:setRightHp(value)
    self.LoadingBar_right:setPercent(value)
end

function fightUILayer:handleNotification(notifyName, body)
    
    if notifyName == "removeSkillReally_notify" then
        self:removeActiveSkillButton(body.skillID)

    elseif notifyName == "showFightAccountsUI_notify" then
        self:StopCountDownVSTime()
        local function schFunc()
            if body.isWin then
                self:showFightAccountsWinUI(body)
            else
                self:showFightAccountsLoseUI()
            end
        end
        performWithDelay(self, schFunc, 4)
    end

end

function fightUILayer:updateVSHPUI(body)

    local own_max, own_now, enemy_max, enemy_now = g_fightLogic:getVSHP()
    self:setLeftHp(own_now/own_max*100)
    self:setRightHp(enemy_now/enemy_max*100)
end

function fightUILayer:removeLeaderHeadListview()
    if not tolua.isnull(self.leaderHeadLayer) and self.leaderHeadLayer then 
        self.leaderHeadLayer.touchLayer:removeFromParent(true)
        self.leaderHeadLayer:removeFromParent(true)
        self.leaderHeadLayer = nil
    end
end

--战场上的角色下阵
function fightUILayer:downerLeaderFromBattle(role, callback)
    local x,y = display.visibleRect.bottomCenter.x, display.visibleRect.bottomCenter.y
    local rx, ry = role:getPosition()
    local cPos = role:getParent():convertToWorldSpace(cc.p(rx,ry))
    role:setGlobalZOrder(10)
    local t = cc.pGetDistance(cc.p(x,y), cc.p(rx,ry))/(660)
    
    local sequence = transition.sequence({
            cc.CallFunc:create(function()  role.skeleton:runAction(CCFadeOut:create(t)) end),
            CCMoveBy:create(t, cc.p(x-cPos.x, y-cPos.y)),
            cc.CallFunc:create(function() 
                if callback then callback() end 
            end
        )})
    role:runAction(sequence)
end

function fightUILayer:updateLeaderHeadListviewWithAddRole(roleID, baseId)
    self:removeLeaderHeadListview()
    local newRoleList = {}
    for k,v in pairs(self.reallyToFightHeroList) do
         table.insert(newRoleList,v)
    end
    table.insert(newRoleList,{roleID=roleID, baseID=baseId})

    self:showLeaderHeadListview(newRoleList)
end
function fightUILayer:updateLeaderHeadListviewWithDelRole(roleID)
    self:removeLeaderHeadListview()
    local newRoleList = {}
    for k,v in pairs(self.reallyToFightHeroList) do
        if v.roleID ~= roleID then
            table.insert(newRoleList,v)
        end
    end

    self:showLeaderHeadListview(newRoleList)
end

function fightUILayer:showKezhiLayer(followLeader, sitePoslist, kezhiSite, beikezhiSite, zhongkeSite, beizhongkeSite)
    self.kezhiLayer:setKezhi(followLeader, sitePoslist, kezhiSite, beikezhiSite, zhongkeSite, beizhongkeSite)
end
function fightUILayer:unshowKezhiLayer()
    self.kezhiLayer:unshowKezhiLayer()
end
function fightUILayer:kezhiMovingLayer()
    self.kezhiLayer:movingUpdate()
end

function fightUILayer:showLeaderHeadListview(listData)
    self:removeLeaderHeadListview()
    self.reallyToFightHeroList = DeepCopy( listData )

    local widthHead = 120
    local heightHead = 100
    local dataNum = #listData
    local showHeadMaxWidth = widthHead*7
    local leaderHeadLayer = cocosMake.newLayer()
    self.leaderHeadLayer = leaderHeadLayer
    local leaderHeadLayerSize = cc.size(widthHead*dataNum, self.leadHeadlistviewSize.height)--队列Size
    leaderHeadLayer:setContentSize(leaderHeadLayerSize)
    self.leaderHead_listviewPanel:addChild(leaderHeadLayer)

    local touchLayer = cocosMake.newLayer()
    --local touchLayer = cc.LayerColor:create(cc.c4b(200,0,0,150))
    touchLayer:setPosition(self.leaderHead_listviewPanel:getPosition())
    touchLayer:setContentSize(self.leaderHead_listviewPanel:getContentSize())
    self.fightBuzhenUI_bottomVS.Panel:addChild(touchLayer, 2)
    leaderHeadLayer.touchLayer = touchLayer

    local imgsprList = {}
    for i=1, dataNum do
        local imgspr = BoxMgr.GetGeneralInfoBox(listData[i].baseID, {nametype=1})
        imgspr:setAnchorPoint(cc.p(0,0))
        imgspr:setPosition((i-1)*widthHead, 30)
        imgspr:setContentSize(cc.size(88, 60))
        imgspr.id = listData[i].roleID
        leaderHeadLayer:addChild(imgspr)
        imgsprList[i] = imgspr
    end

    local touchX = 0
    local touchY = 0
    local touchBegin = cc.p(0,0)
    local listviewX, listviewY = self.leaderHead_listviewPanel:getPosition()
    local function onTouchBegan(touch, event)
        local touchPos = touch:getLocation()
        touchX = touchPos.x
        touchY = touchPos.y
        touchBegin.x = touchPos.x
        touchBegin.y = touchPos.y
        
        --不在范围内
        local sz = leaderHeadLayerSize
        if touchX < listviewX or touchX > (self.leadHeadlistviewSize.width+listviewX) or touchY < listviewY or touchY > (sz.height+listviewY) then
            return false
        end

        local head = nil
        local pos = leaderHeadLayer:convertToNodeSpace(touchPos)
        for k,v in pairs(imgsprList) do
            local sz = v:getContentSize()
            local posx,posy = v:getPosition()
            if pos.x > posx and pos.x < (posx+sz.width) and pos.y > posy and pos.y < (posy+sz.height) then
                head = v
                break
            end
        end
        if head then
            local function selectHero()
                leaderHeadLayer.delaySch = nil
                
                self.selectReallyToFightRoleID = head.id --选中的角色
                local heroInfo = DataManager.getLeaderStaticDataByID(head.id)
                
                local json = SKELETON_AVATAR_UI_PATH .. "/" .. heroInfo.modelId ..".json"
                local atlas = SKELETON_AVATAR_UI_PATH .. "/" .. heroInfo.modelId ..".atlas"
                local skeleton = sp.SkeletonAnimation:create(json, atlas, scale or 1)
                
                hero = skeleton
                hero:setPosition(touchPos)
                g_fightLogic:setselectHeroToFight(hero, head.id)
                --g_fightLogic:leaderMoveBegan(hero, head.id)
            end
            leaderHeadLayer.delaySch = performWithDelay(leaderHeadLayer, selectHero, 0.1)
        end
        return true
    end
    local function onTouchMoved(touch, event)
        local pos = touch:getLocation()

        --移动超过一定视为滑动
        if leaderHeadLayer.delaySch and cc.pGetDistance(touchBegin, pos) > 10 then
            leaderHeadLayer:stopAction( leaderHeadLayer.delaySch )
            leaderHeadLayer.delaySch = nil
        end

        local moveX = pos.x - touchX
        local moveY = pos.y - touchY
        touchX = pos.x
        touchY = pos.y
        local selectHero = g_fightLogic:getselectHeroToFight()
        if selectHero then
            local x, y = selectHero.hero:getPosition()
            selectHero.hero:setPosition(x+moveX, y+moveY)
            g_fightLogic:leaderMoving()

        else
            local x = leaderHeadLayer:getPosition()
            leaderHeadLayer:setPositionX( math.max(math.min(-(leaderHeadLayerSize.width-showHeadMaxWidth), 0), math.min(0, x+moveX)) )
        end
    end
    local function onTouchEnded(touch, event)
        if leaderHeadLayer.delaySch then
            leaderHeadLayer:stopAction( leaderHeadLayer.delaySch )
            leaderHeadLayer.delaySch = nil
        end

        local selectHero = g_fightLogic:getselectHeroToFight()
        if selectHero then
            local res = g_fightLogic:selectHeroToFight()
            g_fightLogic:unselectHeroToFight()
            Notifier.postNotifty("notify_communicateUI", {ing=false})
            self.selectReallyToFightRoleID = nil
        end
    end

    local eventDispacher = touchLayer:getEventDispatcher()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler( onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler( onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler( onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    eventDispacher:addEventListenerWithSceneGraphPriority(listener, touchLayer)
    touchLayer:setTouchEnabled(true)
end

function fightUILayer:updateLeaderReallyIcon()
    local beginX = 0
    local beginY = 40
    local width = 150

    local index = 0
    for k,v in pairs(self.leaderHeadList) do
        v.btn:setPosition(beginX + width*index, beginY)
        index = index + 1
    end
end

function fightUILayer:activeSkill(skillID, player, clickCallback)
    if not skillID then
        assert(false, "增加激活技能按钮的skillID为空")
        return
    end
    local haveSkill = false
    for k,v in pairs(self.skillReallyButtonList) do
        if v.skillID == skillID then
            haveSkill = true
            break
        end
    end
    if haveSkill then
        print("有重复的技能施放按钮：" .. skillID)
        return
    end

    local function clickCallbackFunc()
        if g_fightLogic:isFighting() and clickCallback then
            clickCallback()
        end
    end
    local btn = self:createActiveSkillButton(skillID, clickCallbackFunc)
    self:addActiveSkillButton(btn)
end

local activeSkillButton_gapWidth = 20
local activeSkillButton_speed = 990

function fightUILayer:removeActiveSkillButton(skillID)
    local button = nil
    local tableK = nil
    for k,v in pairs(self.skillReallyButtonList) do 
        if v.skillID == skillID then
            tableK = k
            button = v
        end
    end
    if not button then
        return 
    end

    table.remove(self.skillReallyButtonList, tableK)
    button:removeFromParent(true)

    self:updateActiveSkillButton()
end

function fightUILayer:updateActiveSkillButton()
    local cnt = 0
    local moveX = 0
    local function sort(a,b)
        return a.key < b.key
    end
    table.sort(self.skillReallyButtonList, sort)

    for k,v in pairs(self.skillReallyButtonList) do
        if cnt > 5 then
            break
        end
        v:stopAllActions()
        moveX = self.skilllistviewSize.width - cnt*(v:getContentSize().width + activeSkillButton_gapWidth)
        transition.moveTo(v, {x=moveX, y=0, time=math.abs(moveX - v:getPositionX())/activeSkillButton_speed, onComplete=function() end})
        cnt = cnt + 1
    end
end

function fightUILayer:addActiveSkillButton(btn)
    btn:setAnchorPoint(cc.p(1,0))
    btn:setPosition(0,0)

    
    local sequence = transition.sequence({
            CCShow:create(),
            CCFadeOut:create(0.0),
            CCFadeIn:create(0.5),
            CCFadeOut:create(0.5)
        })
    local action = cc.RepeatForever:create(sequence)
    btn.light:runAction(action)
    

    local function completeCallback (args)
        self:updateActiveSkillButton()
    end

    
    local move = self.skilllistviewSize.width - table.nums(self.skillReallyButtonList)*(btn:getContentSize().width + activeSkillButton_gapWidth)
    transition.moveTo(btn, {x=move, y=0, time=move/activeSkillButton_speed, onComplete=completeCallback})
    
    self.skillBtn_listviewPanel:addChild(btn)
    table.insert(self.skillReallyButtonList, btn)
end

function fightUILayer:createActiveSkillButton(skillID, clickCallback)
    local skillInfo = DataManager.getSkillByID(skillID)
    local img = "image/skillIcon/" .. skillInfo.iconId .. ".png"
    
    local btnBG = cocosMake.newSprite("fightUI/lb_w102.png")
    btnBG.skillID = skillID
    btnBG.key = self.activeSkillKey
    self.activeSkillKey = self.activeSkillKey + 1
    local conSize = btnBG:getContentSize()

    local light = cocosMake.newSprite("fightUI/y89876.png")
    light:setPosition(conSize.width/2, conSize.height/2)
    light:setVisible(false)
    btnBG.light = light
    btnBG:addChild(light)

    local btn = cocosMake.newButton(img, img, img, 0, 0, clickCallback)
    btn:setPosition(conSize.width/2, conSize.height/2)
    btnBG:addChild(btn)
    btn:setGlobalZOrder(1200) 
    return btnBG
end



function fightUILayer:showStartGameLayer(startCallback)
    local startGameLayer = cocosMake.newLayer()
    self:addChild(startGameLayer)
    startGameLayer:setLocalZOrder(10)
    
    local fightLogic = cocosMake.newSprite("fightUI/anniu-80_80.png", display.visibleRect.center.x, display.visibleRect.center.y)
    fightLogic:setScale(3.0)
    startGameLayer:addChild(fightLogic)

    local function  schFunc(args)
        self:removeLeaderHeadListview()

        startGameLayer:removeFromParent(true)
        if startCallback then startCallback() end
    end
    performWithDelay(self, schFunc, 0.5)
end

function fightUILayer:initUI()
    self.fightSpeedLabel:setString("X" .. g_fightLogic:getFightSpeed())

    self.left_power:setString(0)
    self.right_power:setString(0)
end

function fightUILayer:updateLeftPower(p)
    self.left_power:setString(math.floor(p))
end
function fightUILayer:updateRightPower(p)
    self.right_power:setString(math.floor(p))
end

function fightUILayer:showLoadingFightSceneLayer()
    local loadingFightSceneLayer = cocosMake.newLayerColor()
    self.loadingFightSceneLayer = loadingFightSceneLayer
    self:addChild(loadingFightSceneLayer)
    loadingFightSceneLayer:setLocalZOrder(100)
    loadingFightSceneLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    loadingFightSceneLayer:setTouchEnabled(true)

    
    local bg = cocosMake.newSprite("MainSceneBg.jpg")
    bg:setAnchorPoint(cc.p(0,0))
    bg:setPosition(display.visibleRect.leftBottom.x,display.visibleRect.leftBottom.y)
    loadingFightSceneLayer:addChild(bg)

    local label = cocosMake.newLabel("正在加载战斗场景。。。", 0, 0)
    loadingFightSceneLayer:addChild(label)
    label:setLocalZOrder(9999)
    label:setPosition(cc.p(display.visibleRect.center.x, display.visibleRect.center.y))
end

function fightUILayer:hideLoadingFightSceneLayer()
    if self.loadingFightSceneLayer then
        self.loadingFightSceneLayer:removeFromParent(true)
        self.loadingFightSceneLayer = nil
    end
end

return fightUILayer
