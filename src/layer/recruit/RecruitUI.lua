local RecruitUI = class("RecruitUI", cocosMake.viewBase)

--规范
RecruitUI.ui_resource_file = {"RecruitUI_VS"}--cocos studio生成的csb

RecruitUI.ui_binding_file = {--控件绑定
    panel_VS = {name="RecruitUI_VS"},
    item_1 = {name="RecruitUI_VS.item1"},
    item_2 = {name="RecruitUI_VS.item2"},
    item_3 = {name="RecruitUI_VS.item3"},
    lb_cost1 = {name="RecruitUI_VS.item1.tip_1.cost"},
    lb_cost2 = {name="RecruitUI_VS.item2.tip_1.cost"},
    lb_cost3 = {name="RecruitUI_VS.item3.tip_1.cost"},
    btn_esc = {name="RecruitUI_VS.btn_esc",event="touch",method="OnEscClick"}, 
    btn_item1 = {name="RecruitUI_VS.item1.btn",event="touch",method="OnRecruitClick"},
    btn_item2 = {name="RecruitUI_VS.item2.btn",event="touch",method="OnRecruitClick"},
    btn_item3 = {name="RecruitUI_VS.item3.btn",event="touch",method="OnHightRecruitClick"}
}

RecruitUI.notify = {"Notifty_Actor_Set_Prop","Notifty_RecruitUI_Close","Notifty_RecruitUI_Show"}--通知

function RecruitUI:onCreate()
    print("RecruitUI:onCreate")
    self:__initShow()
end

function RecruitUI:onClose()
    print("RecruitUI:onClose")
end

function RecruitUI:__initShow()
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)
    print(iNum)
    local iNum = DataManager.getGeneralStaticDataByID(RECRUIT_LOW_GOLD).value
    self.lb_cost1:setString(tostring(iNum))
    iNum = DataManager.getGeneralStaticDataByID(RECRUIT_MID_INGOT).value
    self.lb_cost2:setString(tostring(iNum))
    iNum = DataManager.getGeneralStaticDataByID(RECRUIT_HIGH_INGOT).value
    self.lb_cost3:setString(tostring(iNum))
    iNum = DataModeManager:getActor():GetProperty(Actor_Prop_LowRecruitFreeNum)
    if iNum > 0 then
        self.item_1:getChildByName("tip_1"):setVisible(false)
        self.item_1:getChildByName("tip_2"):setVisible(true)
        self.item_1:getChildByName("tip_2"):getChildByName("num"):setString(iNum.."")
    else
        self.item_1:getChildByName("tip_1"):setVisible(true)
        self.item_1:getChildByName("tip_2"):setVisible(false)
    end
end

function RecruitUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("RecruitUI:OnEscClick")
        self:getParent():closeFloat({name = luaFile.RecruitUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function RecruitUI:OnHightRecruitClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("RecruitUI:OnHightRecruitClick")
        self:setVisible(false)
        self:getParent():showFloat(luaFile.HightRecruitUI)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function RecruitUI:OnRecruitClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("RecruitUI:OnRecruitClick")
        local pack = networkManager.createPack("leaderRecruit_c")
	    pack.cardType = event.target:getTag()
        pack.expenseType = 2
        if pack.cardType == 1 then
            if DataModeManager:getActor():GetProperty(Actor_Prop_LowRecruitFreeNum) > 0 then
                pack.expenseType = 1
            end
        end
        self.cardType = pack.cardType
	    networkManager.sendPack(pack,handler(self,self.recruitCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function RecruitUI:recruitCallBack(obj)
    if obj.result == ERR_SUCCESS then 
        local general = DataModeManager:getGeneralData(obj.baseIds[1])
        if general ~= nil then
            print("recruitCallBack------success!"..obj.baseIds[1].."  name:"..general:GetStaticProperty(General_StaticProp_Name))
        end
        print("recruitCallBack------success!"..obj.baseIds[1])
        if self.cardType == 1 then
            local iNum = DataModeManager:getActor():GetProperty(Actor_Prop_LowRecruitFreeNum)
            if iNum > 0 then
                self.item_1:getChildByName("tip_1"):setVisible(false)
                self.item_1:getChildByName("tip_2"):setVisible(true)
                self.item_1:getChildByName("tip_2"):getChildByName("num"):setString(iNum.."")
            else
                self.item_1:getChildByName("tip_1"):setVisible(true)
                self.item_1:getChildByName("tip_2"):setVisible(false)
            end
        end
        self:setVisible(false)
        self:getParent():showFloat(luaFile.ShowGeneralUI,{id = obj.baseIds[1],type = self.cardType,showType = 3})
    else 
        Notifier.postNotifty("Notifty_MsgFloatUI_floatErrorCmd",{cmd=obj.result})
        print("recruit------false!") 
    end
end

function RecruitUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_Actor_Set_Prop" and body.propID == Actor_Prop_LowRecruitFreeNum then
        local iNum = DataModeManager:getActor():GetProperty(Actor_Prop_LowRecruitFreeNum)
        if iNum > 0 then
            self.item_1:getChildByName("tip_1"):setVisible(false)
            self.item_1:getChildByName("tip_2"):setVisible(true)
            self.item_1:getChildByName("tip_2"):getChildByName("num"):setString(iNum.."")
        else
            self.item_1:getChildByName("tip_1"):setVisible(true)
            self.item_1:getChildByName("tip_2"):setVisible(false)
        end
    elseif notifyName == "Notifty_RecruitUI_Close" then
        local target = self
        local function closeCall()
            target:getParent():closeFloat({name = luaFile.RecruitUI})
        end
        self:runAction(cc.CallFunc:create(closeCall))
    elseif notifyName == "Notifty_RecruitUI_Show" then
        self:setVisible(body.visible)
    end
end


--------------------------------------------------------------------------------------------------------------------
return RecruitUI

