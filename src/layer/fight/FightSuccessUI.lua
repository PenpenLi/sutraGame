local FightSuccessUI = class("FightSuccessUI", cocosMake.viewBase)

FightSuccessUI.ui_resource_file = {"fightUI_SuccessVS"}--cocos studio生成的csb

FightSuccessUI.ui_binding_file = {--控件绑定
    panel1 = {name="fightUI_SuccessVS.panel1"},
    pb_exp = {name="fightUI_SuccessVS.panel2.res.pb_exp"},
    lb_exp = {name="fightUI_SuccessVS.panel2.res.lb_exp"},
    lb_lvl = {name="fightUI_SuccessVS.panel2.res.lb_lvl"},
    lb_silver = {name="fightUI_SuccessVS.panel2.res.lb_silver"},
    lb_soul = {name="fightUI_SuccessVS.panel2.res.lb_soul"},
    lb_rwexp = {name="fightUI_SuccessVS.panel2.res.lb_rwexp"},
    --------------------------------------------------------------------
    btn_retry = {name="fightUI_SuccessVS.btn_retry",event="touch",method="OnRetryClick"},                 --再次挑战
    btn_total = {name="fightUI_SuccessVS.btn_total",event="touch",method="OnTotalClick"},                 --伤害统计
    btn_exit = {name="fightUI_SuccessVS.btn_exit",event="touch",method="OnExitClick"}                     --退出
}

FightSuccessUI.notify = {}

function FightSuccessUI:onCreate(param)
    print("FightSuccessUI:onCreate")
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
    self:showReward(param)
end

function FightSuccessUI:showReward(data)
    if data == nil then return end
    local tData = string.split(data.showReward,"|")
    for k,v in pairs(tData) do
        local tlist = string.split(v,"_")
        if tonumber(tlist[1]) == 104 then
            self.lb_rwexp:setString(tostring(tlist[3]))
        elseif tonumber(tlist[1]) == 101 then
            self.lb_silver:setString(tostring(tlist[3]))
        elseif tonumber(tlist[1]) == 107 then
            self.lb_soul:setString(tostring(tlist[3]))
        end
    end
end

function FightSuccessUI:OnEnterCallFunc()
    local pLightNode = self.panel1:getChildByName("light")
    pLightNode:runAction(cc.RepeatForever:create(cc.RotateBy:create(4,360)))
    local scale1 = cc.ScaleTo:create(0.2,1.4)
    local scale2 = cc.ScaleTo:create(0.1,0.8)
    local scale3 = cc.ScaleTo:create(0.1,1.0)
    local tAc = {scale1,scale2,scale3}
    local action1 = cc.Sequence:create(tAc)
    self.panel1:runAction(action1)
end

function FightSuccessUI:onClose()
    print("FightSuccessUI:onClose")
end

function FightSuccessUI:OnRetryClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        Notifier.postNotifty("playFightAgain_notify")

    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function FightSuccessUI:OnTotalClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("FightSuccessUI:OnRetryClick")
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function FightSuccessUI:OnExitClick(event)
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

return FightSuccessUI