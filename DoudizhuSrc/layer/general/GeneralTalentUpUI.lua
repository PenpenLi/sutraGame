local GeneralTalentUpUI = class("GeneralTalentUpUI", cocosMake.viewBase)

--规范
GeneralTalentUpUI.ui_resource_file = {"generaltalentupUI_VS"}--cocos studio生成的csb
GeneralTalentUpUI.StarRes = "common/label/lb_w36.png"
GeneralTalentUpUI.ListViewCellSize = { width = 465,height = 104}
GeneralTalentUpUI.Res_CSB = "csb/generalItem.csb"
GeneralTalentUpUI.Res_1 = "common/label/lb_w42_5.png"
GeneralTalentUpUI.Res_2 = "common/label/lb_w37.png"
GeneralTalentUpUI.CELL_TAG = 100
GeneralTalentUpUI.ui_binding_file = {--控件绑定
    panel_VS = {name="generaltalentupUI_VS"},
    btn_esc = {name="generaltalentupUI_VS.btn_esc",event="touch",method="OnEscClick"}, 
    btn_up = {name="generaltalentupUI_VS.btn_up",event="touch",method="OnLevelUpClick"},
    btn_detail = {name="generaltalentupUI_VS.btn_detail",event="touch",method="OnDetailClick"},
    btn_csDet = {name="generaltalentupUI_VS.panel4.btn",event="touch",method="OnCloseDetailClick"},
    lb_cost = {name="generaltalentupUI_VS.tip.cost"},
    panel1 = {name="generaltalentupUI_VS.panel1"},
    panel2 = {name="generaltalentupUI_VS.panel2"},
    panel3 = {name="generaltalentupUI_VS.panel3"},
    panel4 = {name="generaltalentupUI_VS.panel4"},
    pn_sv = {name="generaltalentupUI_VS.panel4.sv"},
    img_type = {name="generaltalentupUI_VS.panel1.img_type"},
    lb_lvl = {name="generaltalentupUI_VS.panel1.lb_lvl"},
    lb_name = {name="generaltalentupUI_VS.panel1.lb_name"},
    pn_body = {name="generaltalentupUI_VS.panel1.body"},
    stars = {name="generaltalentupUI_VS.panel1.stars"},
    tips = {name="generaltalentupUI_VS.panel1.tip"},
    lb_grade = {name="generaltalentupUI_VS.panel1.tip.lb_lv"},
    lb_des = {name="generaltalentupUI_VS.panel1.tip.lb_des"},
    pn_prop = {name="generaltalentupUI_VS.panel2.prop"},
    box = {name="generaltalentupUI_VS.panel3.item1.btn"},
    tx = {name="generaltalentupUI_VS.panel3.item1.btn.img"},
    lb_MaxNum1 = {name="generaltalentupUI_VS.panel3.item1.lb_maxNum"},
    lb_MaxNum2 = {name="generaltalentupUI_VS.panel3.item2.lb_maxNum"},
    lb_Num1 = {name="generaltalentupUI_VS.panel3.item1.lb_num"},
    lb_Num2 = {name="generaltalentupUI_VS.panel3.item2.lb_num"},
    tips = {name="generaltalentupUI_VS.panel1.tip"},
    ---------------------------------------------------------------------
    lb_prop_1_1 = {name="generaltalentupUI_VS.panel2.prop.prop_1_1"},
    lb_prop_1_2 = {name="generaltalentupUI_VS.panel2.prop.prop_1_2"},
    lb_prop_1_3 = {name="generaltalentupUI_VS.panel2.prop.prop_1_3"},
    lb_prop_1_4 = {name="generaltalentupUI_VS.panel2.prop.prop_1_4"},
    ---------------------------
    lb_prop_1_1_1 = {name="generaltalentupUI_VS.panel2.prop.prop_1_1_1"},
    lb_prop_1_2_1 = {name="generaltalentupUI_VS.panel2.prop.prop_1_2_1"},
    lb_prop_1_3_1 = {name="generaltalentupUI_VS.panel2.prop.prop_1_3_1"},
    lb_prop_1_4_1 = {name="generaltalentupUI_VS.panel2.prop.prop_1_4_1"},
    ---------------------------
    lb_prop_2_1 = {name="generaltalentupUI_VS.panel2.prop.prop_2_1"},
    lb_prop_2_2 = {name="generaltalentupUI_VS.panel2.prop.prop_2_2"},
    lb_prop_2_3 = {name="generaltalentupUI_VS.panel2.prop.prop_2_3"},
    lb_prop_2_4 = {name="generaltalentupUI_VS.panel2.prop.prop_2_4"},
    ---------------------------
    lb_prop_2_1_1 = {name="generaltalentupUI_VS.panel2.prop.prop_2_1_1"},
    lb_prop_2_2_1 = {name="generaltalentupUI_VS.panel2.prop.prop_2_2_1"},
    lb_prop_2_3_1 = {name="generaltalentupUI_VS.panel2.prop.prop_2_3_1"},
    lb_prop_2_4_1 = {name="generaltalentupUI_VS.panel2.prop.prop_2_4_1"}
}

GeneralTalentUpUI.notify = {"Notifty_Actor_Set_Prop"}--通知

function GeneralTalentUpUI:onCreate(param)
    print("GeneralTalentUpUI:onCreate")
    self.generalId = param.baseId
    self:__initShow()
end

function GeneralTalentUpUI:onClose()
    print("GeneralTalentUpUI:onClose")
end

function GeneralTalentUpUI:__initSV()
    local general = DataModeManager:getGeneralData(self.generalId)
    local iNum = general:GetProperty(General_Prop_Leaderid)
    local dataT =  DataManager.getLeaderStaticDataByID(iNum)
    iNum = general:GetStaticProperty(General_StaticProp_Beginquelity)
    local dataS = DataManager.getleadersQualityStaticDataByID(iNum)
    local iMaxLv = dataS.lastTalent
    local iCellHight = 80
    local iTitleHight = 50
    local iBottom = 25
    print(self.pn_sv:getDescription())
    local container = self.pn_sv:getInnerContainer()
    local size = container:getContentSize()
    if iMaxLv > 5 then
        size.height = iTitleHight + iCellHight*iMaxLv+iBottom
        self.pn_sv:getInnerContainer():setContentSize(size)
        self.pn_sv:getChildByName("title"):setPositionY(iCellHight*iMaxLv+iBottom)
        self.pn_sv:jumpToTop()
    end
    local iIndex = 0
    for i = 1,iMaxLv,1 do
        local node = self:__GetSVNode(dataT,i)
        if node ~= nil then
            iIndex = iIndex + 1
            self.pn_sv:addChild(node)
            local posY = (iMaxLv-iIndex)*iCellHight+iBottom
            if iMaxLv <= 5 then
                posY = size - iTitleHight - iIndex*iCellHight
            end
            node:setPosition(0,posY)
            node:setTag(iIndex)
        end
    end
end

function GeneralTalentUpUI:BrushSV()
    local general = DataModeManager:getGeneralData(self.generalId)
    local iNum = general:GetProperty(General_Prop_Leaderid)
    local dataT =  DataManager.getLeaderStaticDataByID(iNum)
    iNum = general:GetProperty(General_Prop_Talentlv)
    for i = 1,iNum,1 do
        local node = self.pn_sv:getChildByTag(i)
        if node ~= nil then
            local label = node:getChildByTag(1)
            label:setTextColor(cc.c4b(255,237,211,255))
            label:enableShadow(cc.c4b(41,28,22,255),cc.size())

            label = node:getChildByTag(2)
            label:setTextColor(cc.c4b(93,179,30,255))
            local str = dataT["talent"..i]
            local strList = string.split(str,"_")
            local iNum = tonumber(strList[1])
            if iNum <= 0 then
                return nil
            end
            if tonumber(strList[2]) == 0 then
                str = " ("
            else
                str = "% ("
            end
            str = TxtCache.Prop[iNum]..string.format(TxtCache.GeneralTalentUpUI_Txt_2,tonumber(strList[3]))..str..TxtCache.GeneralTalentUpUI_Txt_3
            label:setString(str)
        end
    end
end

function GeneralTalentUpUI:__GetSVNode(dataT,iIndex)
    local node = cc.Node:create()
    local general = DataModeManager:getGeneralData(self.generalId)
    local label = ccui.Text:create("","font/fzy4jw.ttf",24)
    label:setAnchorPoint(0,0)
    label:setPosition(20,37)
    label:setTextColor(cc.c4b(165,159,150,255))
    label:setString(TxtCache.GeneralTalentUpUI_Txt_5..TxtCache.Num[iIndex])
    label:setTag(1)
    node:addChild(label)

    label = ccui.Text:create("","font/fzy4jw.ttf",22)
    label:setAnchorPoint(0,0)
    label:setPosition(20,0)
    label:setTextColor(cc.c4b(165,159,150,255))
    local str = dataT["talent"..iIndex]
    local strList = string.split(str,"_")
    local iNum = tonumber(strList[1])
    if iNum <= 0 then
        return nil
    end
    local iLock = tonumber(dataT["openTalentCondition"..iIndex])
    if tonumber(strList[2]) == 0 then
        str = " ("
    else
        str = "% ("
    end
    str = TxtCache.Prop[iNum]..string.format(TxtCache.GeneralTalentUpUI_Txt_2,tonumber(strList[3]))..str..string.format(TxtCache.GeneralTalentUpUI_Txt_4,iLock)
    label:setString(str)
    label:setTag(2)
    node:addChild(label)
    return node
end

function GeneralTalentUpUI:__initShow()
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)
    local general = DataModeManager:getGeneralData(self.generalId)
    local iNum = general:GetStaticProperty(General_StaticProp_Type)
    self.img_type:setTexture("common/label/lb_w38_"..iNum..".png")
    str = general:GetStaticProperty(General_StaticProp_Modelid)
    if tostring(str) ~= "0" then
        local json = SKELETON_AVATAR_UI_PATH .. "/" .. str ..".json"
        local atlas = SKELETON_AVATAR_UI_PATH .. "/" .. str ..".atlas"
        print(json.."\n"..atlas)
 	    local skeleton = sp.SkeletonAnimation:create(json, atlas, 1.0)
        if skeleton ~= nil then
            skeleton:setAnchorPoint(0.5,0)
            self.pn_body:addChild(skeleton)
            skeleton:setAnimation(0,ROLE_IDLE_ANIMATION_NAME,true)
        end
    end
    iNum = general:GetStaticProperty(General_StaticProp_Beginstar)
    for i = 1,iNum,1 do
        local pstar = cc.Sprite:create(self.StarRes)
        local iwidth = pstar:getContentSize().width
        local iposx = 0 - iwidth * (iNum-1)/2 + iwidth * (i-1)
        pstar:setPosition(iposx,0)
        self.stars:addChild(pstar)
    end
    iNum = general:GetStaticProperty(General_StaticProp_Beginquelity)
    self.box:setTexture("common/label/lb_w104_"..iNum..".png")
    str = general:GetStaticProperty(General_StaticProp_Iconid)
    self.tx:setTexture("image/leaderHeadIcon/"..str..".png")
    self:BrushProp()
    self:BrushAddProp()
    self:__initSV()
    self:BrushSV()
    self.panel4:setVisible(false)
end

function GeneralTalentUpUI:BrushProp()
    local general = DataModeManager:getGeneralData(self.generalId)
    local iNum = general:GetProperty(General_Prop_Level)
    self.lb_lvl:setString("Lv:"..iNum)
    local iNum = general:GetProperty(General_Prop_Grade)
    local str = general:GetStaticProperty(General_StaticProp_Name)
    if iNum > 0 then
        str = str.."+"..iNum
    end
    self.lb_name:setString(str)
    ---------------------------------------------------------
    iNum = general:GetProperty(General_Prop_Physicsattack)
    if iNum <= 0.01 then
        iNum = general:GetProperty(General_Prop_Magicattack)
        self.pn_prop:getChildByName("prop"):setString(TxtCache.Prop_Txt_2)
    else
        self.pn_prop:getChildByName("prop"):setString(TxtCache.Prop_Txt_1)
    end
    self.lb_prop_1_1:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Barmor)
    self.lb_prop_1_2:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Opposecrit)
    self.lb_prop_1_3:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Hit)
    self.lb_prop_1_4:setString(tostring(iNum))
    -----------------------------------------------------------------------------
    iNum = general:GetProperty(General_Prop_Hp)
    self.lb_prop_2_1:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Bresistance)
    self.lb_prop_2_2:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Crit)
    self.lb_prop_2_3:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Dodge)
    self.lb_prop_2_4:setString(tostring(iNum))
    -----------------------------------------------------------------------------
end

function GeneralTalentUpUI:BrushAddProp()
    local general = DataModeManager:getGeneralData(self.generalId)
    local iLvl = general:GetProperty(General_Prop_Grade)
    local iNum = general:GetStaticProperty(General_StaticProp_Beginquelity)
    local iMaxLvl = DataManager.getleadersQualityStaticDataByID(iNum).lastAdvance
    local tList = DataManager.getAdvanceStaticData(iNum)
    if iLvl >= iMaxLvl or tList == nil or next(tList) == nil then
        self.lb_prop_1_1_1:setString("")
        self.lb_prop_1_2_1:setString("")
        self.lb_prop_1_3_1:setString("")
        self.lb_prop_1_4_1:setString("")
        self.lb_prop_2_1_1:setString("")
        self.lb_prop_2_2_1:setString("")
        self.lb_prop_2_3_1:setString("")
        self.lb_prop_2_4_1:setString("")
        self.lb_MaxNum1:setString("/ 0")
        self.lb_MaxNum2:setString("/ 0")
        self.lb_Num1:setString("0 ")
        self.lb_Num1:setTextColor(cc.c3b(255,241,215))
        self.lb_Num2:setString("0 ")
        self.lb_Num2:setTextColor(cc.c3b(255,241,215))
        self.lb_cost:getParent():setVisible(false)
        self.tips:setVisible(false)
        return
    end
    self.tips:setVisible(true)
    iLvl = iLvl + 1
    local iaddnum = DataManager.getGeneralStaticDataByID(TALENT_ADD_VALUE).value / 10
    local imultnum = DataManager.getGeneralStaticDataByID(TALENT_UNIT_VALUE).value / 10
    local general = DataModeManager:getGeneralData(self.generalId)
    iNum = general:GetStaticProperty(General_StaticProp_Physicsattackagress) / 10
    if iNum <= 0.01 then
        iNum = general:GetStaticProperty(General_StaticProp_Magicattackagress) / 10
    end
    self.lb_prop_1_1_1:setString("+"..tostring((iaddnum + imultnum*iLvl) * iNum * iLvl / 2))
    iNum = general:GetStaticProperty(General_StaticProp_Barmoragress) / 10
    self.lb_prop_1_2_1:setString("+"..tostring((iaddnum + imultnum*iLvl) * iNum * iLvl / 2))
    iNum = general:GetStaticProperty(General_StaticProp_Opposecritagress) / 10
    self.lb_prop_1_3_1:setString("+"..tostring((iaddnum + imultnum*iLvl) * iNum * iLvl / 2))
    iNum = general:GetStaticProperty(General_StaticProp_Hitagress) / 10
    self.lb_prop_1_4_1:setString("+"..tostring((iaddnum + imultnum*iLvl) * iNum * iLvl / 2))
    -----------------------------------------------------------------------------
    iNum = general:GetStaticProperty(General_StaticProp_Hpagress) / 10
    self.lb_prop_2_1_1:setString("+"..tostring((iaddnum + imultnum*iLvl) * iNum * iLvl / 2))
    iNum = general:GetStaticProperty(General_StaticProp_Bresistanceagress) / 10
    self.lb_prop_2_2_1:setString("+"..tostring((iaddnum + imultnum*iLvl) * iNum * iLvl / 2))
    iNum = general:GetStaticProperty(General_StaticProp_Critagress) / 10
    self.lb_prop_2_3_1:setString("+"..tostring((iaddnum + imultnum*iLvl) * iNum * iLvl / 2))
    iNum = general:GetStaticProperty(General_StaticProp_Dodgeagress) / 10
    self.lb_prop_2_4_1:setString("+"..tostring((iaddnum + imultnum*iLvl) * iNum * iLvl / 2))

    iNum = general:GetProperty(General_Prop_Leaderid)
    local dataT =  DataManager.getLeaderStaticDataByID(iNum)
    local generalList = DataModeManager:getActor():GetPart(Actor_Part_General):getAllMode()
    local icount = 0
    for k,v in pairs(generalList) do
        local gerl = DataModeManager:getGeneralData(v)
        if gerl:GetProperty(General_Prop_Leaderid) == iNum and gerl:getBaseID() ~= self.generalId then
            if gerl:GetProperty(General_Prop_Level) == 1 and gerl:GetProperty(General_Prop_Grade) == 0 then
                icount = icount + 1
            end
        end
    end
    self.lb_MaxNum1:setString("/ "..tList[iLvl].advanceCost)
    local str = tList[iLvl].porpCost
    local strList = string.split(str,"_")
    self.lb_MaxNum2:setString("/ "..strList[3])
    self.lb_Num1:setString(icount.." ")
    if icount >= tList[iLvl].advanceCost then
        self.lb_Num1:setTextColor(cc.c3b(75,176,0))
    else
        self.lb_Num1:setTextColor(cc.c3b(197,23,0))
    end
    self.lb_Num2:setString("0 ")
    self.lb_Num2:setTextColor(cc.c3b(197,23,0))
    str = tList[iLvl].goldCost
    strList = string.split(str,"_")
    self.lb_cost:setString(strList[3])
    iNum = DataModeManager:getActor():GetProperty(Actor_Prop_Silver)
    if tonumber(strList[3]) > iNum then
        self.lb_cost:setTextColor(cc.c3b(255,0,0))
    else
        self.lb_cost:setTextColor(cc.c3b(104,39,0))
    end
    iLvl = general:GetProperty(General_Prop_Talentlv) + 1
    local iLock = tonumber(dataT["openTalentCondition"..iLvl])
    self.lb_grade:setString("+"..iLock)
    str = dataT["talent"..iLvl]
    strList = string.split(str,"_")
    iNum = tonumber(strList[1])
    if iNum <= 0 then
        self.tips:setVisible(false)
        return
    end
    str = ""
    if tonumber(strList[2]) == 1 then
        str = "%"
    end
    self.lb_des:setString(TxtCache.Prop[iNum]..TxtCache.GeneralTalentUpUI_Txt_1..strList[3]..str.."(")
end

function GeneralTalentUpUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralTalentUpUI:OnEscClick")
        Notifier.postNotifty("Notifty_GeneralUI_Show",{visible = true})
        self:getParent():closeFloat({name = luaFile.GeneralTalentUpUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralTalentUpUI:OnDetailClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralTalentUpUI:OnDetailClick")
        self.panel4:setVisible(true)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralTalentUpUI:OnCloseDetailClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralTalentUpUI:OnCloseDetailClick")
        self.panel4:setVisible(false)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralTalentUpUI:OnLevelUpClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralTalentUpUI:OnLevelUpClick")
        local general = DataModeManager:getGeneralData(self.generalId)
        local iGrade = general:GetProperty(General_Prop_Grade)
        local iNum = general:GetStaticProperty(General_StaticProp_Beginquelity)
        local iMaxGrade = DataManager.getleadersQualityStaticDataByID(iNum).lastAdvance
        local tList = DataManager.getAdvanceStaticData(iNum)
        if iGrade >= iMaxGrade or tList == nil or next(tList) == nil  then
            Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[23]})
            return
        end
        local iSilver = tonumber(self.lb_cost:getString())
        local iHoldSilver = DataModeManager:getActor():GetProperty(Actor_Prop_Silver)
        if iSilver > iHoldSilver then
            Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[3]})
            return
        end
        local iNum1 = tostring(self.lb_Num1:getString())
        local iMaxNum1 = tostring(self.lb_MaxNum1:getString())
        if iNum1 < iMaxNum1 then
            Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[24]})
            return
        end
        local iLockLvl = tList[iGrade + 1].leaderLevel
        local iLvl = general:GetProperty(General_Prop_Level)
        if iLvl < iLockLvl then
            local str = string.format(TxtCache.FloatMsg[25],iLockLvl)
            Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = str})
            return
        end
        local pack = networkManager.createPack("leaderUpgrade_c")
	    pack.leaderId = self.generalId
	    networkManager.sendPack(pack,handler(self,self.levelUpCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralTalentUpUI:levelUpCallBack(obj)
    if obj.result ~= ERR_SUCCESS then 
        Notifier.postNotifty("Notifty_MsgFloatUI_floatErrorCmd",{cmd=obj.result})
        return 
    end
    self:BrushAddProp()
    if obj.type == 2 then
        Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg= TxtCache.FloatMsg[9]})
        return
    end
    self:BrushProp()
    self:BrushSV()
end

function GeneralTalentUpUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_Actor_Set_Prop" and body.propID == Actor_Prop_Silver then
        local iNum1 = tonumber(self.lb_cost:getString())
        local iNum2 = DataModeManager:getActor():GetProperty(Actor_Prop_Silver)
        if iNum1 > iNum2 then
            self.lb_cost:setTextColor(cc.c3b(255,0,0))
        else
            self.lb_cost:setTextColor(cc.c3b(104,39,0))
        end
    end
end

--------------------------------------------------------------------------------------------------------------------
return GeneralTalentUpUI

