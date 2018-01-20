local FightFailedUI = class("FightFailedUI", cocosMake.viewBase)

FightFailedUI.ui_resource_file = {"fightUI_FailedVS"}--cocos studio生成的csb

FightFailedUI.ui_binding_file = {--控件绑定
    panel1 = {name="fightUI_FailedVS.panel1"},
    pb_exp = {name="fightUI_FailedVS.panel2.res.pb_exp"},
    lb_exp = {name="fightUI_FailedVS.panel2.res.lb_exp"},
    lb_lvl = {name="fightUI_FailedVS.panel2.res.lb_lvl"},
    btn_tip1 = {name="fightUI_FailedVS.panel2.tipbtn.btn_1",event="touch",method="OnTipBtnClick"},
    btn_tip2 = {name="fightUI_FailedVS.panel2.tipbtn.btn_2",event="touch",method="OnTipBtnClick"},
    btn_tip3 = {name="fightUI_FailedVS.panel2.tipbtn.btn_3",event="touch",method="OnTipBtnClick"},
    --------------------------------------------------------------------
    btn_retry = {name="fightUI_FailedVS.btn_retry",event="touch",method="OnRetryClick"},                 --再次挑战
    btn_total = {name="fightUI_FailedVS.btn_total",event="touch",method="OnTotalClick"},                 --伤害统计
    btn_exit = {name="fightUI_FailedVS.btn_exit",event="touch",method="OnExitClick"}                     --退出
}

FightFailedUI.notify = {}

function FightFailedUI:onCreate()
    print("FightFailedUI:onCreate")
    self.panel1:setScale(0)
    self:OnEnterCallFunc()
    --开启屏蔽层
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)
    local iLvl = DataModeManager:getActor():GetProperty(Actor_Prop_Lvl)
    self.lb_lvl:setString("Lv:"..iLvl)
    local iMaxExp = DataManager.getLevelStaticDataByID(iLvl).exp
    local iExp = DataModeManager:getActor():GetProperty(Actor_Prop_Exp)
    self.pb_exp:setPercent(100*iExp/iMaxExp)
    self.lb_exp:setString(iExp.."/"..iMaxExp)
end

function FightFailedUI:OnEnterCallFunc()
    local pLightNode = self.panel1:getChildByName("light")
    pLightNode:runAction(cc.RepeatForever:create(cc.RotateBy:create(4,360)))
    local scale1 = cc.ScaleTo:create(0.2,1.4)
    local scale2 = cc.ScaleTo:create(0.1,0.8)
    local scale3 = cc.ScaleTo:create(0.1,1.0)
    local tAc = {scale1,scale2,scale3}
    local action1 = cc.Sequence:create(tAc)
    self.panel1:runAction(action1)
end

function FightFailedUI:onClose()
    print("FightFailedUI:onClose")
end

function FightFailedUI:OnRetryClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        Notifier.postNotifty("playFightAgain_notify")

    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function FightFailedUI:OnTotalClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("FightFailedUI:OnRetryClick")
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function FightFailedUI:OnExitClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        --cocosMake.Director:endToLua()
        Notifier.postNotifty("exitFight_notify")

    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function FightFailedUI:OnTipBtnClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))

    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

return FightFailedUI