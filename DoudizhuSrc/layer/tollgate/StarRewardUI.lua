local StarRewardUI = class("StarRewardUI", cocosMake.viewBase)

--规范
StarRewardUI.ui_resource_file = {"starRewardUI_VS"}--cocos studio生成的csb
StarRewardUI.Res_1 = "common/label/lb_w35.png"
StarRewardUI.Res_2 = "common/label/lb_w59.png"
StarRewardUI.Res_3 = "common/label/lb_w50.png"
StarRewardUI.Res_4 = "common/label/lb_w36.png"
StarRewardUI.Res_5 = "common/label/lb_w90_3.png"
StarRewardUI.Res_6 = "common/label/lb_w46.png"
StarRewardUI.RES_7 = "common/label/lb_w50_1.png"
StarRewardUI.RES_8 = "common/label/lb_w50_2.png"
StarRewardUI.ui_binding_file = {--控件绑定
    -------------------------------------------starRewardUI_VS-------------------------------------------------------------
    btn_esc = {name="starRewardUI_VS.btn_esc",event="touch",method="OnEscClick"},
    btn_deal = {name="starRewardUI_VS.btn_deal",event="touch",method="OnDealClick"},
    lb_curStar = {name="starRewardUI_VS.num1"},
    lb_maxStar = {name="starRewardUI_VS.num2"},
    pn_reward = {name="starRewardUI_VS.reward"},
    tag_1 = {name="starRewardUI_VS.tag_1"},
    tag_2 = {name="starRewardUI_VS.tag_2"}
}

StarRewardUI.notify = {}--通知

StarRewardUI.btnJZClickCallFuc = {}

function StarRewardUI:onCreate(param)
    print("StarRewardUI:onCreate")
    self.sceneId = param.sceneId
    self.copyId = param.copyId
    self.rewardType = param.type
    self:__initShow()
end

function StarRewardUI:onClose()
    print("StarRewardUI:onClose")
end

function StarRewardUI:__initShow()
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)
    local mgr = DataModeManager:getTollGateDataMgr()
    local copyData = mgr:getData({sceneId = self.sceneId,copyId = self.copyId})
    local stData = DataManager.getCopyStaticDataByID(self.copyId)
    local reward = nil 
    local star = copyData.star
    local maxStar = 0
    local rewardState = 0
    if self.rewardType == 1 then
        reward = stData.starRewarda
        maxStar = stData.firstStarCondition
        rewardState = copyData.starReward1
    elseif self.rewardType == 1 then
        reward = stData.starRewardb
        maxStar = stData.secondStarCondition
        rewardState = copyData.starReward2
    elseif self.rewardType == 1 then
        reward = stData.starRewardc
        maxStar = stData.thirdStarCondition
        rewardState = copyData.starReward3
    end
    if rewardState == 1 then
        self.tag_2:setVisible(false) 
        self.tag_1:setVisible(true)
        self.dealState = 1
    elseif rewardState == 2 then
        self.tag_2:setVisible(false)
        self.tag_1:setVisible(false)
        self.dealState = 2
    elseif rewardState == 3 then
        self.tag_2:setVisible(true)
        self.tag_1:setVisible(false)
        self.dealState = 1  
    end
    if self.dealState == 1 then
        self.btn_deal:getChildByName("Text_4"):setString(TxtCache.StarRewardUI_Btn_Txt_1)
    elseif self.dealState == 2 then
        self.btn_deal:getChildByName("Text_4"):setString(TxtCache.StarRewardUI_Btn_Txt_2)
    end
    self.lb_curStar:setString(star.." /")
    self.lb_maxStar:setString(maxStar)
    if star >= maxStar then
        self.lb_curStar:setTextColor(cc.c4b(117,210,7,255))
    end
    self:showReward(reward)
end

function StarRewardUI:showReward(data)
    local rewards = string.split(data,"|")
    local iSize = #rewards
    for k,v in ipairs(rewards) do
        local node = self:__getRewardNode(v)
        local iwidth = 125
        local posX = 0 - iwidth * (iSize-1)/2 + iwidth * (k-1)
        node:setPosition(posX,0)
        self.pn_reward:addChild(node)
    end
end

function StarRewardUI:__getRewardNode(data)
    local reward = string.split(data,"_")
    local iconRes = nil
    local isRes = false
    local node = cc.Sprite:create(self.Res_5)
    if tonumber(reward[1]) == 101 then
        iconRes = self.Res_1
        isRes = true
    elseif tonumber(reward[1]) == 102 then
        iconRes = self.RES_7
        isRes = true
    elseif tonumber(reward[1]) == 103 then
        iconRes = self.Res_3
        isRes = true
    elseif tonumber(reward[1]) == 104 then
        iconRes = self.Res_6
        isRes = true
    elseif tonumber(reward[1]) == 106 then
        iconRes = self.RES_8
        isRes = true
    elseif tonumber(reward[1]) == 107 then
        iconRes = self.Res_2
        isRes = true
    end
    local size = node:getContentSize()
    local sprite = cc.Sprite:create(iconRes)
    sprite:setPosition(size.width*0.5,size.height*0.5)
    local node_size = node:getContentSize()
    local sprite_size = sprite:getContentSize()
    sprite:setScale((node_size.width-10)/sprite_size.width)
    node:addChild(sprite)
    if isRes == true then 
        local label = ccui.Text:create(reward[3],"font/fzy4jw.ttf",22)
        label:setAnchorPoint(1,0)
        label:setPosition(85,0)
        label:setTextColor(cc.c4b(239,235,212,255))
        label:enableOutline(cc.c4b(79,34,1,255),2)
        node:addChild(label)
    end
    return node
end

function StarRewardUI:handleNotification(notifyName, body)

end

function StarRewardUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("StarRewardUI:OnEscClick")
        self:getParent():closeFloat({name = luaFile.StarRewardUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function StarRewardUI:OnDealClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("StarRewardUI:OnDealClick")
        if self.dealState == 2 then
            local pack = networkManager.createPack("fubenStarReward_c")
	        pack.id = self.copyId
            pack.starType = self.rewardType
	        networkManager.sendPack(pack,handler(self,self.starRewardCallBack),true,0)
        else
            self:getParent():closeFloat({name = luaFile.StarRewardUI})
        end
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function StarRewardUI:starRewardCallBack(obj)
    DataModeManager:getTollGateDataMgr():UpdateCopyRewardData(obj)
    local rewardState = obj.starState
    if rewardState == 1 then
        self.tag_2:setVisible(false) 
        self.tag_1:setVisible(true)
        self.dealState = 1
    elseif rewardState == 2 then
        self.tag_2:setVisible(false)
        self.tag_1:setVisible(false)
        self.dealState = 2
    elseif rewardState == 3 then
        self.tag_2:setVisible(true)
        self.tag_1:setVisible(false)
        self.dealState = 1  
    end
    if self.dealState == 1 then
        self.btn_deal:getChildByName("Text_4"):setString(TxtCache.StarRewardUI_Btn_Txt_1)
    elseif self.dealState == 2 then
        self.btn_deal:getChildByName("Text_4"):setString(TxtCache.StarRewardUI_Btn_Txt_2)
    end
    Notifier.postNotifty("Notifty_TollgetUI_fubenReward",{data = obj})
end
--------------------------------------------------------------------------------------------------------------------
return StarRewardUI

