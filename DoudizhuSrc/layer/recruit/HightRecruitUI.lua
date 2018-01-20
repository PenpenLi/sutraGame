local HightRecruitUI = class("HightRecruitUI", cocosMake.viewBase)

--规范
HightRecruitUI.ui_resource_file = {"hightRecruitUI_VS"}--cocos studio生成的csb

HightRecruitUI.ui_binding_file = {--控件绑定
    item_1 = {name="hightRecruitUI_VS.panel1",event="touch",method="OnRecruitClick"},
    item_2 = {name="hightRecruitUI_VS.panel2",event="touch",method="OnBatchRecruitClick"},
    lb_cost1 = {name="hightRecruitUI_VS.panel1.tip_1.num"},
    lb_cost2 = {name="hightRecruitUI_VS.panel2.tip_1.num"},
    lb_time = {name="hightRecruitUI_VS.panel1.tip_3.time"},
    tip_1 = {name="hightRecruitUI_VS.panel1.tip_1"},
    tip_2 = {name="hightRecruitUI_VS.panel1.tip_2"},
    btn_esc = {name="hightRecruitUI_VS.btn_esc",event="touch",method="OnEscClick"},
    lb_txt = {name="hightRecruitUI_VS.txt"}
}

HightRecruitUI.notify = {"Notifty_Actor_Set_Prop","Notifty_HightRecruitUI_Close","Notifty_HightRecruitUI_Show","Notifty_HightRecruitUI_Shadow"}--通知

function HightRecruitUI:onCreate(param)
    print("HightRecruitUI:onCreate")
    self:__initShow()
end

function HightRecruitUI:onClose()
    print("HightRecruitUI:onClose")
end

function HightRecruitUI:__initShow()
    self.colorLayer = cocosMake.newLayerColor()
    self:addChild(self.colorLayer)
    self.colorLayer:setLocalZOrder(-1)
    self.colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    self.colorLayer:setTouchEnabled(true)
    local iNum = DataManager.getGeneralStaticDataByID(RECRUIT_TENHIGH_INGOT).value
    self.lb_cost2:setString(iNum.."")
    iNum = DataManager.getGeneralStaticDataByID(RECRUIT_HIGH_INGOT).value
    self.lb_cost1:setString(iNum.."")
    iNum = DataManager.getGeneralStaticDataByID(RECRUIT_GOODHIGH_INGOT).value
    iNum = iNum - DataModeManager:getActor():GetProperty(Actor_Prop_HighRecruitNum)
    self.lb_txt:setString(string.format(TxtCache.HightRecruitUI_Txt,iNum))
    self.tip_2:setVisible(false)
end

function HightRecruitUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("HightRecruitUI:OnEscClick")
        Notifier.postNotifty("Notifty_RecruitUI_Show",{visible = true})
        self:getParent():closeFloat({name = luaFile.HightRecruitUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function HightRecruitUI:OnRecruitClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("HightRecruitUI:OnRecruitClick")
        local pack = networkManager.createPack("leaderRecruit_c")
	    pack.cardType = 3
        pack.expenseType = 2
        self.cardType = pack.cardType
	    networkManager.sendPack(pack,handler(self,self.recruitCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function HightRecruitUI:OnBatchRecruitClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("HightRecruitUI:OnBatchRecruitClick")
        local pack = networkManager.createPack("leaderRecruit_c")
	    pack.cardType = 4
        pack.expenseType = 2
        self.cardType = pack.cardType
	    networkManager.sendPack(pack,handler(self,self.batchRecruitCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function HightRecruitUI:recruitCallBack(obj)
    if obj.result == ERR_SUCCESS then
        local general = DataModeManager:getGeneralData(obj.baseIds[1])
        if general ~= nil then
            print("recruitCallBack------success!"..obj.baseIds[1].."  name:"..general:GetStaticProperty(General_StaticProp_Name))
        end
        print("recruitCallBack------success!"..obj.baseIds[1])
        self:setVisible(false)
        self:getParent():showFloat(luaFile.ShowGeneralUI,{id = obj.baseIds[1],type = self.cardType,showType = 2})
    else 
        Notifier.postNotifty("Notifty_MsgFloatUI_floatErrorCmd",{cmd=obj.result})
        print("recruit------false!") 
    end
end

function HightRecruitUI:batchRecruitCallBack(obj)
    if obj.result == ERR_SUCCESS then 
        self:getParent():showFloat(luaFile.BatchRecruitUI,{data = obj.baseIds})
        self.colorLayer:setVisible(false)
    else 
        Notifier.postNotifty("Notifty_MsgFloatUI_floatErrorCmd",{cmd=obj.result})
        print("recruit------false!") 
    end
end

function HightRecruitUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_Actor_Set_Prop" and body.propID == Actor_Prop_HighRecruitNum then
        local iNum = DataManager.getGeneralStaticDataByID(RECRUIT_GOODHIGH_INGOT).value
        iNum = iNum - DataModeManager:getActor():GetProperty(Actor_Prop_HighRecruitNum)
        self.lb_txt:setString(string.format(TxtCache.HightRecruitUI_Txt,iNum))
    elseif notifyName == "Notifty_HightRecruitUI_Close" then
        local target = self
        local function closeCall()
            target:getParent():closeFloat({name = luaFile.HightRecruitUI})
        end
        self:runAction(cc.CallFunc:create(closeCall))
    elseif notifyName == "Notifty_HightRecruitUI_Show" then
        self:setVisible(body.visible)
    elseif notifyName == "Notifty_HightRecruitUI_Shadow" then
        self.colorLayer:setVisible(body.visible)
    end
end

--------------------------------------------------------------------------------------------------------------------
return HightRecruitUI

