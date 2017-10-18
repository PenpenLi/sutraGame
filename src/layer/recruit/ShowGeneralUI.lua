local ShowGeneralUI = class("ShowGeneralUI", cocosMake.viewBase)

--规范
ShowGeneralUI.ui_resource_file = {"showgeneralUI_VS"}--cocos studio生成的csb
ShowGeneralUI.RES_1 = "common/label/lb_w35.png"
ShowGeneralUI.RES_2 = "common/label/lb_w50.png"
ShowGeneralUI.StarRes = "common/label/lb_w36.png"
ShowGeneralUI.ui_binding_file = {--控件绑定
    panel = {name="showgeneralUI_VS.panel"},
    btn_sure = {name="showgeneralUI_VS.panel.btn_sure",event="touch",method="OnEscClick"}, 
    btn_check = {name="showgeneralUI_VS.panel.btn_check",event="touch",method="OnCheckClick"}, 
    btn_retry = {name="showgeneralUI_VS.panel.btn_retry",event="touch",method="OnRecruitClick"}, 
    lb_name = {name="showgeneralUI_VS.panel.lb_name"},
    img_gerlType = {name="showgeneralUI_VS.panel.type"},
    pn_body = {name="showgeneralUI_VS.panel.body"},
    stars = {name="showgeneralUI_VS.panel.star"},
    node_tip_1 = {name="showgeneralUI_VS.panel.tips.tip_1"},
    node_tip_2 = {name="showgeneralUI_VS.panel.tips.tip_2"}
}

ShowGeneralUI.notify = {"Notifty_ShowGeneralUI_Brush"}--通知

function ShowGeneralUI:onCreate(param)
    print("ShowGeneralUI:onCreate")
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)
    self.generalId = param.id
    self.cardType = param.type
    self.showType = param.showType or 0
    if self.showType == 1 then
        self.node_tip_1:getParent():setVisible(false)
        self.btn_check:setVisible(false)
        self.btn_retry:setVisible(false)
    end
    self:playEffect()
    self:__initShow()
end

function ShowGeneralUI:onClose()
    print("ShowGeneralUI:onClose")
end

function ShowGeneralUI:playEffect()
    self.panel:getChildByName("Sprite_4"):runAction(cc.RepeatForever:create(cc.RotateBy:create(4,360)))
end

function ShowGeneralUI:__initShow()
    local scale1 = cc.ScaleTo:create(0.2,1.4)
    local scale2 = cc.ScaleTo:create(0.1,0.8)
    local scale3 = cc.ScaleTo:create(0.1,1.0)
    local function callBack(target)
        target.btn_sure:setEnabled(true)
        target.btn_check:setEnabled(true)
        target.btn_retry:setEnabled(true)
    end
    local callFunc = cc.CallFunc:create(handler(self,callBack))
    local tAc = {scale1,scale2,scale3,callFunc}
    local action1 = cc.Sequence:create(tAc)
    
    
    self.panel:stopAllActions()
    self.panel:runAction(action1)
    local generalData = DataModeManager:getGeneralData(self.generalId)
    self.lb_name:setString(generalData:GetStaticProperty(General_StaticProp_Name))
    local iNum = generalData:GetStaticProperty(General_StaticProp_Type)
    self.img_gerlType:setTexture("common/label/lb_w38_"..iNum..".png")
    self.pn_body:removeAllChildren()
    local str = generalData:GetStaticProperty(General_StaticProp_Modelid)
    if tostring(str) ~= "0" then
        local json = SKELETON_AVATAR_UI_PATH .. "/" .. str ..".json"
        local atlas = SKELETON_AVATAR_UI_PATH .. "/" .. str ..".atlas"
        print(json.."\n"..atlas)
 	    local skeleton = sp.SkeletonAnimation:create(json, atlas, 1.0)
        if skeleton ~= nil then
            skeleton:setAnchorPoint(0.5,0)
            self.pn_body:addChild(skeleton)
            skeleton:setAnimation(0,ROLE_ATTACK_ANIMATION_NAME,false)
            skeleton:addAnimation(0,ROLE_IDLE_ANIMATION_NAME,true)
        end
    end
    self.stars:removeAllChildren()
    iNum = generalData:GetStaticProperty(General_StaticProp_Beginstar)
    for i = 1,iNum,1 do
        local pstar = cc.Sprite:create(self.StarRes)
        local iwidth = pstar:getContentSize().width
        local iposx = 0 - iwidth * (iNum-1)/2 + iwidth * (i-1)
        pstar:setPosition(iposx,0)
        self.stars:addChild(pstar)
    end
    if self.cardType == 1 then
        iNum = DataModeManager:getActor():GetProperty(Actor_Prop_LowRecruitFreeNum)
        if iNum > 0 then
            self.node_tip_1:setVisible(true)
            self.node_tip_2:setVisible(false)
            self.node_tip_1:getChildByName("num"):setString(iNum.."")
        else
            self.node_tip_1:setVisible(false)
            self.node_tip_2:setVisible(true)
            local stData = DataManager.getGeneralStaticDataByID(RECRUIT_LOW_GOLD)
            self.node_tip_2:getChildByName("num"):setString(tostring(stData.value))
            self.node_tip_2:getChildByName("money"):setScale(1.0)
            self.node_tip_2:getChildByName("money"):setTexture(self.RES_1)
        end
    elseif self.cardType == 2 then
        self.node_tip_1:setVisible(false)
        self.node_tip_2:setVisible(true)
        local stData = DataManager.getGeneralStaticDataByID(RECRUIT_MID_INGOT)
        self.node_tip_2:getChildByName("num"):setString(tostring(stData.value))
        self.node_tip_2:getChildByName("money"):setScale(0.7)
        self.node_tip_2:getChildByName("money"):setTexture(self.RES_2)
    elseif self.cardType == 3 then
        self.node_tip_1:setVisible(false)
        self.node_tip_2:setVisible(true)
        local stData = DataManager.getGeneralStaticDataByID(RECRUIT_HIGH_INGOT)
        self.node_tip_2:getChildByName("num"):setString(tostring(stData.value))
        self.node_tip_2:getChildByName("money"):setScale(0.7)
        self.node_tip_2:getChildByName("money"):setTexture(self.RES_2)
    end
    
end

function ShowGeneralUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ShowGeneralUI:OnEscClick")
        if self.showType == 1 then
            Notifier.postNotifty("Notifty_BatchRecruitUI_Next")
        elseif self.showType == 2 then
            Notifier.postNotifty("Notifty_HightRecruitUI_Show",{visible = true})
        elseif self.showType == 3 then
            Notifier.postNotifty("Notifty_RecruitUI_Show",{visible = true})
        end
        self:getParent():closeFloat({name = luaFile.ShowGeneralUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ShowGeneralUI:OnCheckClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("CampUI:OnCheckClick")
        Notifier.postNotifty("Notifty_RecruitUI_Close")
        Notifier.postNotifty("Notifty_HightRecruitUI_Close")
        self:getParent():showFloat(luaFile.CampUI)
        Notifier.postNotifty("Notifty_CampUI_Show_General",{baseId = self.generalId})
        self:getParent():closeFloat({name = luaFile.ShowGeneralUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ShowGeneralUI:OnRecruitClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ShowGeneralUI:OnRecruitClick")
        self.panel:runAction(cc.ScaleTo:create(0.1,0))
        self.btn_sure:setEnabled(false)
        self.btn_check:setEnabled(false)
        self.btn_retry:setEnabled(false)
        local pack = networkManager.createPack("leaderRecruit_c")
	    pack.cardType = self.cardType
        pack.expenseType = 2
        if pack.cardType == 1 then
            if DataModeManager:getActor():GetProperty(Actor_Prop_LowRecruitFreeNum) > 0 then
                pack.expenseType = 1
            end
        end
	    networkManager.sendPack(pack,handler(self,self.recruitCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ShowGeneralUI:recruitCallBack(obj)
    if obj.result == ERR_SUCCESS then 
        local general = DataModeManager:getGeneralData(obj.baseIds[1])
        if general ~= nil then
            print("recruitCallBack------success!"..obj.baseIds[1].."  name:"..general:GetStaticProperty(General_StaticProp_Name))
        end
        print("recruitCallBack------success!"..obj.baseIds[1])
        self.generalId = obj.baseIds[1]
        self:__initShow()
    else 
        if self.showType == 1 then
            Notifier.postNotifty("Notifty_BatchRecruitUI_Next")
        elseif self.showType == 2 then
            Notifier.postNotifty("Notifty_HightRecruitUI_Show",{visible = true})
        elseif self.showType == 3 then
            Notifier.postNotifty("Notifty_RecruitUI_Show",{visible = true})
        end
        self:getParent():closeFloat({name = luaFile.ShowGeneralUI})
        Notifier.postNotifty("Notifty_MsgFloatUI_floatErrorCmd",{cmd=obj.result})
        print("recruit------false!") 
    end
end

function ShowGeneralUI:handleNotification(notifyName, body)
end


--------------------------------------------------------------------------------------------------------------------
return ShowGeneralUI

