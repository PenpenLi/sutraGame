local TollgateUI = class("TollgateUI", cocosMake.viewBase)

--规范
TollgateUI.ui_resource_file = {"tollgetUI_VS"}--cocos studio生成的csb
TollgateUI.RES_1 = "tollgateUI/lb_w160_1.png"
TollgateUI.RES_2 = "tollgateUI/lb_w160_2.png"
TollgateUI.RES_3 = "tollgateUI/lb_w160_3.png"
TollgateUI.RES_4 = "tollgateUI/lb_w394.png"
TollgateUI.RES_5 = "tollgateUI/lb_w394_1.png"
TollgateUI.RES_6 = "tollgateUI/lb_w394_2.png"
TollgateUI.StarRes = "common/label/lb_w36.png"
TollgateUI.BlackStarRes = "tollgateUI/lb_w37.png"
TollgateUI.ui_binding_file = {--控件绑定
    lb_CopyName = {name="tollgetUI_VS.lb_name"},
    lb_GateName = {name="tollgetUI_VS.lb_gatename"},
    lb_restTime = {name="tollgetUI_VS.tollget_info.pn_cost.lb_restTime"},
    lb_costvit = {name="tollgetUI_VS.tollget_info.pn_cost.lb_costvit"},
    lb_silver = {name="tollgetUI_VS.tollget_info.pn_prize.lb_silver"},
    lb_soul = {name="tollgetUI_VS.tollget_info.pn_prize.lb_soul"},
    lb_zl = {name="tollgetUI_VS.tollget_info.pn_prize.lb_zl"},
    btn_esc = {name="tollgetUI_VS.btn_esc",event="touch",method="OnEscClick"},
    ---------------------------------------------------------------------------------------------------
    btn_easy = {name="tollgetUI_VS.btn_easy",event="touch",method="OnShowDiffInfoClick"},
    btn_normal = {name="tollgetUI_VS.btn_normal",event="touch",method="OnShowDiffInfoClick"},
    btn_diff = {name="tollgetUI_VS.btn_diff",event="touch",method="OnShowDiffInfoClick"},
    ---------------------------------------------------------------------------------------------------
    lb_starNum = {name="tollgetUI_VS.star_bar.num"},
    pn_star_bar = {name="tollgetUI_VS.star_bar"},
    pb_star = {name="tollgetUI_VS.star_bar.pb_star"},
    btn_prize1 = {name="tollgetUI_VS.star_bar.prize_1.btn",event="touch",method="OnPrizeClick"},
    btn_prize2 = {name="tollgetUI_VS.star_bar.prize_2.btn",event="touch",method="OnPrizeClick"},
    btn_prize3 = {name="tollgetUI_VS.star_bar.prize_3.btn",event="touch",method="OnPrizeClick"},
    ---------------------------------------------------------------------------------------------------
    btn_batch = {name="tollgetUI_VS.btn_batch",event="touch",method="OnBatchClick"},
    btn_fight = {name="tollgetUI_VS.btn_fight",event="touch",method="OnFightClick"},
    ---------------------------------------------------------------------------------------------------
    btn_left = {name="tollgetUI_VS.pn_list.btn_left",event="touch",method="OnLeftClick"},
    btn_right = {name="tollgetUI_VS.pn_list.btn_right",event="touch",method="OnRightClick"},
    pn_sv = {name="tollgetUI_VS.pn_list.pn_sv"},
    pn_svcontainer = {name="tollgetUI_VS.pn_list.pn_sv.container"}
    ---------------------------------------------------------------------------------------------------
}

TollgateUI.notify = {"Notifty_TollgetUI_fubenReward"}--通知

function TollgateUI:onCreate(param)
    print("TollgateUI:onCreate")
    self.sceneId = param.sceneId
    self.copyId = param.copyId
    self.unlockNum = nil
    self:__initShow()
end

function TollgateUI:onClose()
    print("TollgateUI:onClose")
end

function TollgateUI:__initShow()
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)
    self:showCopyReward()
    local stData = DataManager.getCopyStaticDataByID(self.copyId)
    self.lb_CopyName:setString(stData.name)
    self.stBigGateData = DataManager.getBigGateStaticDataByCopyID(self.copyId)
    self.lb_zl:getVirtualRenderer():setAdditionalKerning(-5.0)
    self.lb_zl:setString("0")
    self.btn_easy:ignoreContentAdaptWithSize(true)
    self.btn_normal:ignoreContentAdaptWithSize(true)
    self.btn_diff:ignoreContentAdaptWithSize(true)

    self:__initSV()
    self:validateSVFocus()
end

function TollgateUI:showCopyReward()
    local stData = DataManager.getCopyStaticDataByID(self.copyId)
    local mgr = DataModeManager:getTollGateDataMgr()
    local data = mgr:getData({sceneId = self.sceneId,copyId = self.copyId})

    self.lb_starNum:setString(data.star.."")
    local iMaxStar = stData.firstStarCondition
    if iMaxStar < stData.secondStarCondition then
        iMaxStar = stData.secondStarCondition
    end
    if iMaxStar < stData.thirdStarCondition then
        iMaxStar = stData.thirdStarCondition
    end
    self.pb_star:setPercent(100*data.star/iMaxStar)
    local iNum = stData.firstStarCondition
    if iNum ~= 0 then
        local prize1 = self.btn_prize1:getParent()
        prize1:setVisible(true)
        local posX = self.pb_star:getPositionX()
        posX = posX+self.pb_star:getContentSize().width * iNum/iMaxStar
        prize1:setPosition(posX,prize1:getPositionY())
        prize1:getChildByName("num"):setString(iNum.."")
        if data.starReward1 ~= nil then
            if data.starReward1 == 3 then
                self.btn_prize1:setVisible(false)
                prize1:getChildByName("tag"):setVisible(true)
            else
                prize1:getChildByName("tag"):setVisible(false)
            end
        else
            prize1:getChildByName("tag"):setVisible(false)
        end
    else
        local prize1 = self.btn_prize1:getParent()
        prize1:setVisible(false)
    end
    iNum = stData.secondStarCondition
    if iNum ~= 0 then
        local prize2 = self.btn_prize2:getParent()
        prize2:setVisible(true)
        local posX = self.pb_star:getPositionX()
        posX = posX+self.pb_star:getContentSize().width * iNum/iMaxStar
        prize2:setPosition(posX,prize1:getPositionY())
        prize2:getChildByName("num"):setString(iNum.."")
        if data.starReward2 ~= nil then
            if data.starReward2 == 3 then
                self.btn_prize2:setVisible(false)
                prize2:getChildByName("tag"):setVisible(true)
            else
                prize2:getChildByName("tag"):setVisible(false)
            end
        else
            prize2:getChildByName("tag"):setVisible(false)
        end
    else
        local prize2 = self.btn_prize2:getParent()
        prize2:setVisible(false)
    end
    iNum = stData.secondStarCondition
    if iNum ~= 0 then
        local prize3 = self.btn_prize3:getParent()
        prize3:setVisible(true)
        local posX = self.pb_star:getPositionX()
        posX = posX+self.pb_star:getContentSize().width * iNum/iMaxStar
        prize3:setPosition(posX,prize1:getPositionY())
        prize3:getChildByName("num"):setString(iNum.."")
        if data.starReward3 ~= nil then
            if data.starReward3 == 3 then
                self.btn_prize3:setVisible(false)
                prize3:getChildByName("tag"):setVisible(true)
            else
                prize3:getChildByName("tag"):setVisible(false)
            end
        else
            prize3:getChildByName("tag"):setVisible(false)
        end
    else
        local prize3 = self.btn_prize3:getParent()
        prize3:setVisible(false)
    end
end

function TollgateUI:__initSV()
    local size = self.pn_sv:getContentSize()
    local iLen = table.getn(self.stBigGateData)
    local width = size.width + (iLen-1)*184.5
    self.pn_svcontainer:setContentSize(width,size.height)
    for k,v in ipairs(self.stBigGateData) do 
        local node = self:__getGateNode(k,v.id)
        self.pn_svcontainer:addChild(node)
        local posx = (k-1)*184.5 + size.width * 0.5
        node:setPosition(posx,0)
    end
    if self.unlockNum == nil then
        self.unlockNum = #(self.stBigGateData)
    end
    self.sv_clickhelper = self:buildClickHelper()
    self.pn_sv:addChild(self.sv_clickhelper)
end

function TollgateUI:buildClickHelper()
    local layout = ccui.Layout:create()
    layout:setContentSize(self.pn_sv:getContentSize())
    layout:setTouchEnabled(true)
    layout:setSwallowTouches(false)
    layout:onTouch(handler(self,self.OnMoveList))
    return layout
end

function TollgateUI:__getGateNode(key,id)
    local node = ccui.Widget:create()
    node:setTag(key)
    local btn = ccui.ImageView:create(self.RES_1)
    btn:setTag(1111)
    btn:setAnchorPoint(0.5,0)
    node:addChild(btn)
    local size = btn:getContentSize()
    local sprite0 = cc.Sprite:create(self.RES_2)
    sprite0:setPosition(size.width*0.5,size.height*0.5)
    btn:addChild(sprite0)
    local sprite = cc.Sprite:create(self.RES_3)
    sprite:setPosition(size.width*0.5,size.height*0.5)
    btn:addChild(sprite)
    
    btn:setTouchEnabled(true)
    btn:onTouch(handler(self,self.OnTollgateClick))
    
    btn:setScale(0.7)
    local stars = cc.Node:create()
    node:addChild(stars)
    local mgr = DataModeManager:getTollGateDataMgr()
    local gateData = mgr:getBigGateData({sceneId = self.sceneId,copyId = self.copyId,gateId = id})
    if gateData == nil or next(gateData.gateExtentSnaps) == nil then
        sprite0:setColor(cc.c3b(166,166,166))
        btn:setColor(cc.c3b(166,166,166))
        btn:setEnabled(false)
        --[[local pstar = cc.Sprite:create(self.BlackStarRes)
        pstar:setAnchorPoint(0.5,0)
        pstar:setPosition(0,0)
        stars:addChild(pstar)]]--
        if self.unlockNum == nil or self.unlockNum > key then
            self.unlockNum = key
        end
    else
        local iNum = gateData.star
        for i = 1,iNum,1 do
            local pstar = cc.Sprite:create(self.StarRes)
            pstar:setAnchorPoint(0.5,0)
            local iwidth = pstar:getContentSize().width
            local iposx = 0 - iwidth * (iNum-1)/2 + iwidth * (i-1)
            pstar:setPosition(iposx,0)
            stars:addChild(pstar)
        end
    end
    return node
end

function TollgateUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("TollgateUI:OnEscClick")
        self:getParent():closeFloat({name = luaFile.TollgateUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function TollgateUI:OnTollgateClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        if self.moveEnable == true then
            return
        end
        print("TollgateUI:OnTollgateClick")
        self:focusSV(event.target:getParent())
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function TollgateUI:OnShowDiffInfoClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("TollgateUI:OnShowDiffInfoClick")
        self:showDiffInfo(event.target:getTag())
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function TollgateUI:showDiffInfo(iDiff)
    local iTag = self.focusNode:getTag()
    local data = self.stBigGateData[iTag]
    self.HoldGateData = nil
    local mgr = DataModeManager:getTollGateDataMgr()
    local gateData = mgr:getBigGateData({sceneId = self.sceneId,copyId = self.copyId,gateId = data.id})
    if gateData == nil or next(gateData.gateExtentSnaps) == nil then return end
    local smallGateData = nil
    for k,v in pairs(gateData.gateExtentSnaps) do
        if v.type == iDiff then
            smallGateData = v
        end
    end
    if smallGateData == nil then return end
    self.HoldGateData = smallGateData
    local stData = DataManager.getSmallGateStaticDataByID(smallGateData.id)
    self.lb_costvit:setString(stData.physicalCost)
    local rewardStr = stData.reward
    local rewards = string.split(rewardStr,"|")
    for _,v in pairs(rewards) do 
        local prizeInfo = string.split("_")
        local iNum = tonumber(prizeInfo[1])
        if iNum == 101 then
            self.lb_silver:setString(prizeInfo[3])
        elseif iNum == 107 then
            self.lb_soul:setString(prizeInfo[3])
        end
    end
    self.lb_zl:setString(stData.Recompower)
    local tlist = {[1]={v = 0,btn = self.btn_easy},[2]={v = 0,btn = self.btn_normal},[3]={v = 0,btn = self.btn_diff}}
    
    for k,v in pairs(gateData.gateExtentSnaps) do
        tlist[tonumber(v.type)].v = 1
        local bVisible = (v.grade ~= nil and v.grade > 0)
        tlist[tonumber(v.type)].btn:getChildByName("star"):setVisible(bVisible)
        tlist[tonumber(v.type)].btn:setEnabled(true)
        tlist[tonumber(v.type)].btn:loadTexture(self.RES_4)
        self:showGrade(tlist[tonumber(v.type)].btn,v.grade)
    end
    for k,v in pairs(tlist) do
        if v.v <= 0 then
            v.btn:getChildByName("star"):setVisible(false)
            v.btn:loadTexture(self.RES_6)
            v.btn:setEnabled(false)
            v.btn:getChildByName("grade"):setVisible(false)
        end
    end
    if iDiff == 1 then
        self.btn_easy:loadTexture(self.RES_5)
    elseif iDiff == 2 then
        self.btn_normal:loadTexture(self.RES_5)
    elseif iDiff == 3 then
        self.btn_diff:loadTexture(self.RES_5)
    end
end

function TollgateUI:OnPrizeClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("TollgateUI:OnPrizeClick")
        self:showFloat(luaFile.StarRewardUI,{sceneId = self.sceneId,copyId = self.copyId,type = event.target:getTag()})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function TollgateUI:fubenStarReward(obj)
    if obj.starType == 1 and obj.starState == 3 then
        self.btn_prize1:setVisible(false)
        self.btn_prize1:getParent():getChildByName("tag"):setVisible(true)
    elseif obj.starType == 2 and obj.starState == 3 then
        self.btn_prize2:setVisible(false)
        self.btn_prize2:getParent():getChildByName("tag"):setVisible(true)
    elseif obj.starType == 3 and obj.starState == 3 then
        self.btn_prize3:setVisible(false)
        self.btn_prize3:getParent():getChildByName("tag"):setVisible(true)
    end
end

function TollgateUI:EnterFight(customsID)
    local actor = DataModeManager:getActor()
    local part = actor:GetPart(Actor_Part_General)
    local tGeneralList = part:getAllMode()

    local heroList = {}
    for _,v in pairs(tGeneralList) do
	    local general = DataModeManager:getGeneralData(v)
	    local fightData = general:GetFightData()
        fightData.baseId = v
        fightData.general = general
        table.insert(heroList, fightData)
    end

    if #heroList == 0 then
        local label = cocosMake.newLabel("当前没有武将", 0, 0)
        label:setColor(cc.c3b(255,0,210))
        self:addChild(label)
        label:setGlobalZOrder(1)
        label:setPosition(cc.p(display.visibleRect.center.x, display.visibleRect.center.y))
        performWithDelay(self, function(args) label:removeFromParent(true) end, 1.5)
        return false
    end
    

    local fightDirector = LayerManager.show(luaFile.fightDirector)
    self.fightDirector = fightDirector
    fightDirector:setFightArgs({heros=heroList, customsID=customsID})
end

function TollgateUI:OnFightClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("TollgateUI:OnFightClick")
        if self.HoldGateData == nil then
            return
        end
        local gateId = self.HoldGateData.id--关卡ID
        
        local function requestCallback()
            self:EnterFight(gateId)
        end

        local pack = networkManager.createPack("enterBattle_c")
	    pack.gateId = gateId
	    networkManager.sendPack(pack, requestCallback, true, 0)
        --LayerManager.show(luaFile.LoginUI)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function TollgateUI:OnBatchClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("TollgateUI:OnBatchClick")
        if self.HoldGateData == nil then
            return
        end
        local pack = networkManager.createPack("battleEnd_c")
	    pack.gateId = self.HoldGateData.id
        pack.grade = 3
	    networkManager.sendPack(pack,function()end,true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function TollgateUI:OnLeftClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("TollgateUI:OnLeftClick")
        if self.focusNode == nil then 
            return
        end
        local iTag = self.focusNode:getTag()
        if iTag - 1 < 1 then
            return
        end
        local node = self.pn_svcontainer:getChildByTag(iTag-1)
        if node ~= nil then
            self:focusSV(node)
        end
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function TollgateUI:OnRightClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("TollgateUI:OnRightClick")
        if self.focusNode == nil then 
            return
        end
        local iTag = self.focusNode:getTag()
        if iTag + 1 >= self.unlockNum then
            return
        end
        local node = self.pn_svcontainer:getChildByTag(iTag+1)
        if node ~= nil then
            self:focusSV(node)
        end
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function TollgateUI:OnMoveList(event)
    if event.state and event.state == 0 then
        self.moveEnable = false
        self.svBeganPos = cc.p(self.pn_svcontainer:getPosition())
    elseif event.state and event.state == 1 then
        local pos = event.target:getTouchBeganPosition()
        pos = event.target:convertToNodeSpace(pos)
        local pos1 = event.target:getTouchMovePosition()
        pos1 = event.target:convertToNodeSpace(pos1)
        local pos2 = self.svBeganPos
        local pos3 = cc.pSub(pos1,pos)
        pos3.y = 0
        if math.abs(pos3.x) > 50 then
            self.moveEnable = true
            if self.focusNode ~= nil then
                self.focusNode:getChildByTag(1111):runAction(cc.ScaleTo:create(0.1,0.7))
                self.focusNode = nil
            end
        end
        if self.moveEnable ~= true then
            return
        end
        self.pn_svcontainer:setPosition(cc.pAdd(pos2,pos3))

    elseif event.state and event.state == 2 then
        if self.moveEnable == true then
            self:validateSVFocus()
        end
    elseif event.state and event.state == 3 then
        if self.moveEnable == true then
            self:validateSVFocus()
        end
    end
end

function TollgateUI:validateSVFocus()
    local children = self.pn_svcontainer:getChildren()
    local posX = self.pn_svcontainer:getPositionX()
    local halfWidth = self.pn_sv:getContentSize().width * 0.5
    local minX = nil
    local focus = nil
    for _,v in pairs(children) do 
        if v:getTag() < self.unlockNum then
            local childPosX = v:getPositionX()
            local vx = childPosX + posX
            local num = math.abs(halfWidth - vx)
            if minX == nil then
                focus = v
                minX = num
            elseif num < minX then
                focus = v
                minX = num
            end
        end
    end
    self:focusSV(focus)
end

function TollgateUI:focusSV(target)
    if target == nil then
        return
    end
    if self.focusNode ~= nil then
        self.focusNode:getChildByTag(1111):runAction(cc.ScaleTo:create(0.1,0.7))
        self.focusNode = nil
    end
    local posX = self.pn_svcontainer:getPositionX()
    local halfWidth = self.pn_sv:getContentSize().width * 0.5
    local tagPosX = target:getPositionX()
    self.pn_svcontainer:stopAllActions()
    
    self.pn_svcontainer:runAction(cc.MoveTo:create(0.1,cc.p(halfWidth - (posX + tagPosX) + posX,0)))
    self.focusNode = target
    local btn = self.focusNode:getChildByTag(1111)
    btn:runAction(cc.ScaleTo:create(0.1,1))
    local iTag = target:getTag()
    if iTag <=1 then
        self.btn_left:setColor(cc.c3b(166,166,166))
        self.btn_left:setEnabled(false)
    else
        self.btn_left:setColor(cc.c3b(255,255,255))
        self.btn_left:setEnabled(true)
    end
    if iTag >= self.unlockNum-1 then
        self.btn_right:setColor(cc.c3b(166,166,166))
        self.btn_right:setEnabled(false)
    else
        self.btn_right:setColor(cc.c3b(255,255,255))
        self.btn_right:setEnabled(true)
    end
    self:showTollGateData()
    self:showDiffInfo(1)
end

function TollgateUI:showTollGateData()
    local iTag = self.focusNode:getTag()
    local data = self.stBigGateData[iTag]
    local mgr = DataModeManager:getTollGateDataMgr()
    local gateData = mgr:getBigGateData({sceneId = self.sceneId,copyId = self.copyId,gateId = data.id})
    print("showTollGateData :"..self.sceneId..":"..self.copyId..":"..data.id)
    self.lb_restTime:setString(gateData.amount.."")
    self.lb_GateName:setString(data.name)
end

function TollgateUI:showGrade(btn,grade)
    local pGrade = btn:getChildByName("grade") 
    if grade == nil or grade <= 0 then
        pGrade:setVisible(false)
        return
    end
    pGrade:setVisible(true)
    pS1 = pGrade:getChildByName("s_1")
    pS2 = pGrade:getChildByName("s_2")
    pS3 = pGrade:getChildByName("s_3")
    if grade == 1 then
        pS1:setPosition(cc.p(35,34))
        pS2:setVisible(false)
        pS3:setVisible(false)
    elseif grade == 2 then
        pS1:setPosition(cc.p(45,34))
        pS2:setScale(1)
        pS2:setPosition(cc.p(27,34))
        pS2:setVisible(true)
        pS3:setVisible(false)
    else
        pS1:setPosition(cc.p(38,49))
        pS2:setScale(0.85)
        pS2:setPosition(cc.p(20,30))
        pS2:setVisible(true)
        pS3:setScale(0.85)
        pS3:setPosition(cc.p(49,30))
        pS3:setVisible(true)
    end
end

function TollgateUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_TollgetUI_fubenReward" then
        self:fubenStarReward(body.data)
    end
end
--------------------------------------------------------------------------------------------------------------------
return TollgateUI

