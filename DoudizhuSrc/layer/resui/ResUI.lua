local ResUI = class("ResUI", cocosMake.viewBase)

--规范
ResUI.ui_resource_file = {"mainUI_topVS"}--cocos studio生成的csb

ResUI.ui_binding_file = {--控件绑定
    panel_TopVS = {name="mainUI_topVS"},
    -------------------------------------------mainUI_topVS-------------------------------------------------------------
    btn_silver = {name="mainUI_topVS.res_1",event="touch",method="OnBuySilverClick"},                                 --银币
    btn_gold = {name="mainUI_topVS.res_2",event="touch",method="OnBuyGoldClick"},                                   --金币
    btn_strength = {name="mainUI_topVS.res_3",event="touch",method="OnBuyStrengthClick"},                               --体力
    btn_stamina = {name="mainUI_topVS.res_4",event="touch",method="OnBuyStaminaClick"},                                --耐力
    lb_silver = {name="mainUI_topVS.res_1.num"},
    lb_gold = {name="mainUI_topVS.res_2.num"},
    lb_strength = {name="mainUI_topVS.res_3.num"},
    lb_stamina = {name="mainUI_topVS.res_4.num"}
}

ResUI.notify = {"Notifty_Actor_Create","Notifty_Actor_Set_Prop"}--通知

ResUI.btnJZClickCallFuc = {}

function ResUI:onCreate()
    print("ResUI:onCreate")
    self.panel_TopVS:setAnchorPoint(1,1)
    self.panel_TopVS:setPosition(1280,720)
    self:__initShow()
end

function ResUI:test(obj)
    print("test true")
end

function ResUI:onClose()
    print("ResUI:onClose")
end

function ResUI:__initShow()
    self.lb_silver:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Silver).."")
    self:__regularizeLBWidth(self.lb_silver,160)
    self.lb_gold:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Gold).."")
    self:__regularizeLBWidth(self.lb_gold,160)
    self.lb_strength:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Body).."")
    self:__regularizeLBWidth(self.lb_strength,160)
    self.lb_stamina:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Endurance).."")
    self:__regularizeLBWidth(self.lb_stamina,160)
end

function ResUI:__BrushPropShow(param)
    if param == nil then return end
    if param.propID == Actor_Prop_Silver then
        self.lb_silver:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Silver).."")
        self:__regularizeLBWidth(self.lb_silver,160)
    elseif param.propID == Actor_Prop_Gold then
        self.lb_gold:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Gold).."")
        self:__regularizeLBWidth(self.lb_gold,160)
    elseif param.propID == Actor_Prop_Body then
        self.lb_strength:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Body).."")
        self:__regularizeLBWidth(self.lb_strength,160)
    elseif param.propID == Actor_Prop_Endurance then
        self.lb_stamina:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Endurance).."")
        self:__regularizeLBWidth(self.lb_stamina,160)
    end
end

function ResUI:__regularizeLBWidth(obj,width)
    local size = obj:getContentSize()
    if size.width > width then
        obj:setScaleX(width/size.width)
    end
end

function ResUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_Actor_Create" then
        self:__initShow()
    elseif notifyName == "Notifty_Actor_Set_Prop" then
        self:__BrushPropShow(body)
    end
end

function ResUI:OnBuySilverClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ResUI:OnBuySilverClick")
        local pack = networkManager.createPack("testData_c")
        pack.testStr = "101_1_10000"
	    networkManager.sendPack(pack,function() end,true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ResUI:OnBuyGoldClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ResUI:OnBuyGoldClick")
        local pack = networkManager.createPack("testData_c")
        pack.testStr = "103_1_1000"
	    networkManager.sendPack(pack,function() end,true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ResUI:OnBuyStrengthClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ResUI:OnBuyStrengthClick")
        local pack = networkManager.createPack("testData_c")
        pack.testStr = "106_1_200"
	    networkManager.sendPack(pack,function() end,true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ResUI:OnBuyStaminaClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ResUI:OnBuyStaminaClick")
        local pack = networkManager.createPack("testData_c")
        pack.testStr = "102_1_200"
	    networkManager.sendPack(pack,function() end,true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end
--------------------------------------------------------------------------------------------------------------------
return ResUI

