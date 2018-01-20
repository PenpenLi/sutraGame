local BatchRecruitUI = class("BatchRecruitUI", cocosMake.viewBase)

--规范
BatchRecruitUI.ui_resource_file = {"batchrecuitUI_VS"}--cocos studio生成的csb

BatchRecruitUI.ui_binding_file = {--控件绑定
    btn_retry = {name="batchrecuitUI_VS.btn_retry",event="touch",method="OnBatchRecruitClick"},
    btn_sure = {name="batchrecuitUI_VS.btn_sure",event="touch",method="OnEscClick"},
    lb_cost = {name="batchrecuitUI_VS.tip.cost"},
    tip = {name="batchrecuitUI_VS.tip"},
    panel = {name="batchrecuitUI_VS.panel"},
    light = {name="batchrecuitUI_VS.light"},
    btn_esc = {name="batchrecuitUI_VS.btn_esc",event="touch",method="OnEscClick"},
    lb_txt = {name="batchrecuitUI_VS.txt"}
}

BatchRecruitUI.notify = {"Notifty_BatchRecruitUI_Next"}--通知

function BatchRecruitUI:onCreate(param)
    print("BatchRecruitUI:onCreate")
    self.baseIds = {}
    self.baseIds = self:loadDataList(param.data)
    self:__initShow()
end

function BatchRecruitUI:loadDataList(param)
    if param == nil then
        return {}
    end
    local list = {}
    for k,v in pairs(param) do
        if "table" == type(v) then
            if "number" == type(k) then
                list[k]=self:loadDataList(v)
            else
                list[tostring(k)]=self:loadDataList(v)
            end
        else
            if "number" == type(k) then
                list[k]=v
            else
                list[tostring(k)]=v
            end
        end
    end
    return list
end

function BatchRecruitUI:onClose()
    print("BatchRecruitUI:onClose")
end

function BatchRecruitUI:__initShow()
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)
    local iNum = DataManager.getGeneralStaticDataByID(RECRUIT_TENHIGH_INGOT).value
    self.lb_cost:setString(iNum.."")
    self.btn_retry:setVisible(false)
    self.btn_sure:setVisible(false)
    self.light:stopAllActions()
    self.light:setOpacity(0)
    self.btn_esc:setEnabled(false)
    self:BrushShow()
end

function BatchRecruitUI:__BrushBtnShow()
    local func = function()
        local fadeout = cc.FadeOut:create(0.5)
        local fadein = cc.FadeIn:create(0.5)
        local tAc = {fadein,fadeout}
        local seq = cc.Sequence:create(tAc)
        self.light:runAction(cc.RepeatForever:create(seq))
    end
    local action = cc.CallFunc:create(handler(self,func))
    self.btn_retry:stopAllActions()
    self.btn_retry:setScale(0)
    self.btn_retry:setVisible(true)
    self.btn_sure:stopAllActions()
    self.btn_sure:setScale(0)
    self.btn_sure:setVisible(true)
    self.btn_esc:setEnabled(true)
    local scale1 = cc.ScaleTo:create(0.2,1.2)
    local scale2 = cc.ScaleTo:create(0.1,0.8)
    local scale3 = cc.ScaleTo:create(0.1,1.0)
    local tAc = {scale1:clone(),scale2:clone(),scale3:clone(),action}
    self.btn_retry:runAction(cc.Sequence:create(tAc))
    local tAc1 = {scale1:clone(),scale2:clone(),scale3:clone()}
    self.btn_sure:runAction(cc.Sequence:create(tAc1))
end

function BatchRecruitUI:BrushShow()
    for i = 1,10,1 do
        local node = self.panel:getChildByName("item_"..i)
        node:setVisible(false)
        node:stopAllActions()
        node:setScale(1)
        if node:getChildByTag(111) == nil then
            local sprite = cc.Sprite:create()
            sprite:setAnchorPoint(0.5,0)
            sprite:setPosition(52,6.45)
            sprite:setTag(111)
            node:addChild(sprite)
        end
    end
    self.itemIndex = 0
    self:ShowItem()
end

function BatchRecruitUI:ShowItem()
    if self.itemIndex >= 10 then
        self:__BrushBtnShow()
        return
    end
    self.itemIndex = self.itemIndex + 1
    local node = self.panel:getChildByName("item_"..self.itemIndex)
    node:setVisible(true)
    
    local scale1 = cc.ScaleTo:create(0.2,0.8)
    local scale2 = cc.ScaleTo:create(0.1,1.1)
    local scale3 = cc.ScaleTo:create(0.1,1.0)
    local delay = cc.DelayTime:create(0.2)
    local func1 = handler(self,self.ShowItem)
    local func2 = handler(self,self.ShowGeneral)
    local sprite = node:getChildByTag(111)
    local general = DataModeManager:getGeneralData(self.baseIds[self.itemIndex])
    if general == nil then
        node:setVisible(false)
        self:ShowItem()
        return
    end
    local iNum = general:GetStaticProperty(General_StaticProp_Beginquelity)
    node:setTexture("common/label/lb_w104_"..iNum..".png")
    local str = general:GetStaticProperty(General_StaticProp_Iconid)
    sprite:setTexture("image/leaderHeadIcon/"..str..".png")
    node:setScale(1.3)
    if iNum >= 5 then
        local callFunc = cc.CallFunc:create(func2)
        local tAc = {scale1,scale2,scale3,callFunc}
        local action1 = cc.Sequence:create(tAc)
        node:runAction(action1)
    else
        local tAc = {scale1,scale2,scale3}
        local action1 = cc.Sequence:create(tAc)
        local callFunc = cc.CallFunc:create(func1)
        local tAc1 = {delay,callFunc}
        local action2 = cc.Sequence:create(tAc1)
        local tAc2 = {action1,action2}
        local action = cc.Spawn:create(tAc2)
        node:runAction(action)
    end
end

function BatchRecruitUI:ShowGeneral()
    local baseId = self.baseIds[self.itemIndex]
    if baseId ~= nil then
        self:setVisible(false)
        Notifier.postNotifty("Notifty_HightRecruitUI_Show",{visible = false})
        self:getParent():showFloat(luaFile.ShowGeneralUI,{id = baseId,type = 3,showType = 1})
        Notifier.postNotifty("Notifty_ShowGeneralUI_Brush")
    else
        self:ShowItem()
    end
end

function BatchRecruitUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("BatchRecruitUI:OnEscClick")
        Notifier.postNotifty("Notifty_HightRecruitUI_Shadow",{visible = true})
        self:getParent():closeFloat({name = luaFile.BatchRecruitUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function BatchRecruitUI:OnBatchRecruitClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("BatchRecruitUI:OnBatchRecruitClick")
        local pack = networkManager.createPack("leaderRecruit_c")
	    pack.cardType = 4
        pack.expenseType = 2
        self.cardType = pack.cardType
	    networkManager.sendPack(pack,handler(self,self.batchRecruitCallBack),true,0)
        self.btn_retry:setVisible(false)
        self.btn_sure:setVisible(false)
        self.light:stopAllActions()
        self.light:setOpacity(0)
        self.btn_esc:setEnabled(false)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function BatchRecruitUI:batchRecruitCallBack(obj)
    if obj.result == ERR_SUCCESS then 
        self.baseIds = self:loadDataList(obj.baseIds)
        self:BrushShow()
    else 
        Notifier.postNotifty("Notifty_MsgFloatUI_floatErrorCmd",{cmd=obj.result})
        print("recruit------false!") 
        self:__BrushBtnShow()
    end
end

function BatchRecruitUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_BatchRecruitUI_Next" then
        self:setVisible(true)
        Notifier.postNotifty("Notifty_HightRecruitUI_Show",{visible = true})
        self:ShowItem()
    elseif notifyName == "Notifty_BatchRecruitUI_Next" then
        
    end
end

--------------------------------------------------------------------------------------------------------------------
return BatchRecruitUI

