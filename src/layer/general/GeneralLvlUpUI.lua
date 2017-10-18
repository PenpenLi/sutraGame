local GeneralLvlUpUI = class("GeneralLvlUpUI", cocosMake.viewBase)

--规范
GeneralLvlUpUI.ui_resource_file = {"generallvlupUI_VS"}--cocos studio生成的csb
GeneralLvlUpUI.StarRes = "common/label/lb_w36.png"
GeneralLvlUpUI.ListViewCellSize = { width = 465,height = 104}
GeneralLvlUpUI.Res_CSB = "csb/generalItem.csb"
GeneralLvlUpUI.Res_1 = "common/label/lb_w42_5.png"
GeneralLvlUpUI.Res_2 = "common/label/lb_w42_6.png"
GeneralLvlUpUI.CELL_TAG = 100
GeneralLvlUpUI.ui_binding_file = {--控件绑定
    panel_VS = {name="generallvlupUI_VS"},
    btn_esc = {name="generallvlupUI_VS.btn_esc",event="touch",method="OnEscClick"}, 
    btn_item1 = {name="generallvlupUI_VS.item1",event="touch",method="OnTapClick"},
    btn_item2 = {name="generallvlupUI_VS.item2",event="touch",method="OnTapClick"},
    btn_left = {name="generallvlupUI_VS.panel_2.btn_left",event="touch",method="OnLeftClick"},
    btn_right = {name="generallvlupUI_VS.panel_2.btn_right",event="touch",method="OnRightClick"},
    lb_upnum = {name="generallvlupUI_VS.panel_2.num"},
    lb_soul = {name="generallvlupUI_VS.panel_2.lb_soul"},
    lb_soulcost = {name="generallvlupUI_VS.panel_2.lb_soulcost"},
    btn_up = {name="generallvlupUI_VS.btn_up",event="touch",method="OnLevelUpClick"},
    lb_UpLvl = {name="generallvlupUI_VS.lb_lvl"},
    lb_cost = {name="generallvlupUI_VS.cost"},
    lb_addgerlnum = {name="generallvlupUI_VS.panel_1.num"},
    btn_addgerl = {name="generallvlupUI_VS.panel_1.btn_add",event="touch",method="OnAddGerlClick"},
    pb_exp = {name="generallvlupUI_VS.pb_exp"},
    lb_exp = {name="generallvlupUI_VS.lb_exp"},
    panel1 = {name="generallvlupUI_VS.panel_1"},
    panel2 = {name="generallvlupUI_VS.panel_2"},
    img_type = {name="generallvlupUI_VS.prop.img_type"},
    lb_lvl = {name="generallvlupUI_VS.prop.lb_lvl"},
    lb_name = {name="generallvlupUI_VS.prop.lb_name"},
    pn_body = {name="generallvlupUI_VS.prop.body"},
    stars = {name="generallvlupUI_VS.prop.stars"},
    pn_prop_lv2 = {name="generallvlupUI_VS.prop.prop_lv2"},
    ---------------------------------------------------------------------
    lb_prop_1_1 = {name="generallvlupUI_VS.prop.prop_lv2.prop_1_1"},
    lb_prop_1_2 = {name="generallvlupUI_VS.prop.prop_lv2.prop_1_2"},
    lb_prop_1_3 = {name="generallvlupUI_VS.prop.prop_lv2.prop_1_3"},
    lb_prop_1_4 = {name="generallvlupUI_VS.prop.prop_lv2.prop_1_4"},
    ---------------------------
    lb_prop_1_1_1 = {name="generallvlupUI_VS.prop.prop_lv2.prop_1_1_1"},
    lb_prop_1_2_1 = {name="generallvlupUI_VS.prop.prop_lv2.prop_1_2_1"},
    lb_prop_1_3_1 = {name="generallvlupUI_VS.prop.prop_lv2.prop_1_3_1"},
    lb_prop_1_4_1 = {name="generallvlupUI_VS.prop.prop_lv2.prop_1_4_1"},
    ---------------------------
    lb_prop_2_1 = {name="generallvlupUI_VS.prop.prop_lv2.prop_2_1"},
    lb_prop_2_2 = {name="generallvlupUI_VS.prop.prop_lv2.prop_2_2"},
    lb_prop_2_3 = {name="generallvlupUI_VS.prop.prop_lv2.prop_2_3"},
    lb_prop_2_4 = {name="generallvlupUI_VS.prop.prop_lv2.prop_2_4"},
    ---------------------------
    lb_prop_2_1_1 = {name="generallvlupUI_VS.prop.prop_lv2.prop_2_1_1"},
    lb_prop_2_2_1 = {name="generallvlupUI_VS.prop.prop_lv2.prop_2_2_1"},
    lb_prop_2_3_1 = {name="generallvlupUI_VS.prop.prop_lv2.prop_2_3_1"},
    lb_prop_2_4_1 = {name="generallvlupUI_VS.prop.prop_lv2.prop_2_4_1"}
}

GeneralLvlUpUI.notify = {"Notifty_Actor_Set_Prop"}--通知

function GeneralLvlUpUI:onCreate(param)
    print("GeneralLvlUpUI:onCreate")
    self.generalId = param.baseId
    self.uplevel = 0
    self.addexp = 0
    self.upexp = 0
    self.selectGerl={}
    self.upType = 1
    self:__initShow()
end

function GeneralLvlUpUI:onClose()
    print("GeneralLvlUpUI:onClose")
end

function GeneralLvlUpUI:__initShow()
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)
    local general = DataModeManager:getGeneralData(self.generalId)
    local iNum = general:GetStaticProperty(General_StaticProp_Type)
    self.img_type:setTexture("common/label/lb_w38_"..iNum..".png")
    local str = general:GetStaticProperty(General_StaticProp_Name)
    iNum = general:GetProperty(General_Prop_Grade)
    if iNum > 0 then
        str = str.."+"..iNum
    end
    self.lb_name:setString(str)
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
    self.ActorLvl = DataModeManager:getActor():GetProperty(Actor_Prop_Lvl)
    self:BrushProp()
    self:ShowListView()
    self:OnTapClick({target = self.btn_item1,state = 2})
end

function GeneralLvlUpUI:BrushProp()
    local general = DataModeManager:getGeneralData(self.generalId)
    local iNum = general:GetProperty(General_Prop_Level)
    self.lb_lvl:setString("Lv:"..iNum)
    ---------------------------------------------------------
    iNum = general:GetProperty(General_Prop_Physicsattack)
    if iNum <= 0.01 then
        iNum = general:GetProperty(General_Prop_Magicattack)
        self.pn_prop_lv2:getChildByName("prop"):setString(TxtCache.Prop_Txt_2)
    else
        self.pn_prop_lv2:getChildByName("prop"):setString(TxtCache.Prop_Txt_1)
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
    iNum = DataModeManager:getActor():GetProperty(Actor_Prop_LeaderSoul)
    self.lb_soul:setString(iNum.."")
    -----------------------------------------------------------------------------
end

function GeneralLvlUpUI:BrushAddProp()
    local iLvl = self.uplevel
    if iLvl <= 0 then
        self.lb_prop_1_1_1:setString("")
        self.lb_prop_1_2_1:setString("")
        self.lb_prop_1_3_1:setString("")
        self.lb_prop_1_4_1:setString("")
        self.lb_prop_2_1_1:setString("")
        self.lb_prop_2_2_1:setString("")
        self.lb_prop_2_3_1:setString("")
        self.lb_prop_2_4_1:setString("")
        return
    end
    local general = DataModeManager:getGeneralData(self.generalId)
    local iNum = general:GetStaticProperty(General_StaticProp_Physicsattackagress) / 10
    if iNum <= 0.01 then
        iNum = general:GetStaticProperty(General_StaticProp_Magicattackagress) / 10
    end
    self.lb_prop_1_1_1:setString("+"..tostring(iNum*iLvl))
    iNum = general:GetStaticProperty(General_StaticProp_Barmoragress) / 10
    self.lb_prop_1_2_1:setString("+"..tostring(iNum*iLvl))
    iNum = general:GetStaticProperty(General_StaticProp_Opposecritagress) / 10
    self.lb_prop_1_3_1:setString("+"..tostring(iNum*iLvl))
    iNum = general:GetStaticProperty(General_StaticProp_Hitagress) / 10
    self.lb_prop_1_4_1:setString("+"..tostring(iNum*iLvl))
    -----------------------------------------------------------------------------
    iNum = general:GetStaticProperty(General_StaticProp_Hpagress) / 10
    self.lb_prop_2_1_1:setString("+"..tostring(iNum*iLvl))
    iNum = general:GetStaticProperty(General_StaticProp_Bresistanceagress) / 10
    self.lb_prop_2_2_1:setString("+"..tostring(iNum*iLvl))
    iNum = general:GetStaticProperty(General_StaticProp_Critagress) / 10
    self.lb_prop_2_3_1:setString("+"..tostring(iNum*iLvl))
    iNum = general:GetStaticProperty(General_StaticProp_Dodgeagress) / 10
    self.lb_prop_2_4_1:setString("+"..tostring(iNum*iLvl))
end

function GeneralLvlUpUI:countAddExp()
    local exp = 0
    if self.upType == 1 then
        for k,v in pairs(self.selectGerl) do
            exp = exp + v.exp
        end
    else
        if self.uplevel > 0 then
            local general = DataModeManager:getGeneralData(self.generalId)
            local iLvl = general:GetProperty(General_Prop_Level)
            local iexp = general:GetProperty(General_Prop_Exp)
            local ilvlexp = DataManager.getLevelStaticDataByID(iLvl).leaderExp
            exp = ilvlexp - iexp
            for i=1,self.uplevel - 1,1 do
                ilvlexp = DataManager.getLevelStaticDataByID(iLvl+i).leaderExp
                exp = exp + ilvlexp
            end
        end
    end
    self.addexp = exp
end

function GeneralLvlUpUI:BrushAddLvlExp()
    local general = DataModeManager:getGeneralData(self.generalId)
    local iLvl = general:GetProperty(General_Prop_Level)+self.uplevel
    local iMaxLvl = general:GetStaticProperty(General_StaticProp_Endlevel)
    if iLvl >= iMaxLvl then
        self.lb_UpLvl:setString("Lv:MAX")
        self.pb_exp:setPercent(100)
        self.lb_exp:setString("-- / --")
        return
    end
    self.lb_UpLvl:setString("Lv:"..iLvl)
    local iexp = self.upexp
    local iMaxExp = DataManager.getLevelStaticDataByID(iLvl).leaderExp
    local per = (100 * iexp) / iMaxExp
    self.pb_exp:setPercent(per)
    self.lb_exp:setString(iexp.." / "..iMaxExp)
end

function GeneralLvlUpUI:SetUpLvlExp()
    local general = DataModeManager:getGeneralData(self.generalId)
    local iNum = general:GetProperty(General_Prop_Level)
    local iMaxLvl = general:GetStaticProperty(General_StaticProp_Endlevel)
    local iexp = general:GetProperty(General_Prop_Exp)
    local itemp = self.addexp + iexp
    local iUpLvl = 0
    local icurexp = iexp
    if self.addexp == 0 then
        self.uplevel = 0
        self.upexp = iexp
        return
    end
    while(itemp>0) do
        local ilvlexp = DataManager.getLevelStaticDataByID(iNum + iUpLvl).leaderExp
        if ilvlexp ~= nil then
            itemp = itemp - ilvlexp
            if itemp >= 0 then
                iUpLvl = iUpLvl + 1
            end
        else
            itemp = -1
        end
    end
    if iNum + iUpLvl >= iMaxLvl then
        iUpLvl = iMaxLvl - iNum
    end
    if iNum + iUpLvl >= self.ActorLvl then
        iUpLvl = self.ActorLvl - iNum
    end
    itemp = self.addexp + iexp
    for i = 1 , iUpLvl, 1 do
        local ilvlexp = DataManager.getLevelStaticDataByID(iNum + i - 1).leaderExp
        itemp = itemp - ilvlexp
    end
    local ilvlexp = DataManager.getLevelStaticDataByID(iNum + iUpLvl).leaderExp
    if itemp >= ilvlexp then
        itemp = ilvlexp-1
    end
    if iUpLvl < 0 then
        iUpLvl = 0
    end
    self.uplevel = iUpLvl
    self.upexp = itemp
end

function GeneralLvlUpUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralLvlUpUI:OnEscClick")
        if self.isUping == true then
            return
        end
        Notifier.postNotifty("Notifty_GeneralUI_Show",{visible = true})
        self:getParent():closeFloat({name = luaFile.GeneralLvlUpUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralLvlUpUI:OnLeftClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralLvlUpUI:OnLeftClick")
        if self.isUping == true then
            return
        end
        if self.uplevel <= 0 then
            return
        end
        if self.uplevel == 1 then
            local general = DataModeManager:getGeneralData(self.generalId)
            local iLvl = general:GetProperty(General_Prop_Level)
            local iMaxLvl = general:GetStaticProperty(General_StaticProp_Endlevel)
            local tNum = {}
            local iNum1 = self.ActorLvl - iLvl
            local iNum2 = iMaxLvl - iLvl
            local iNum3 = 10
            if iNum3 > iNum2 then
                iNum3 = iNum2
            end
            if iNum3 > iNum1 then
                iNum3 = iNum1
            end
            if iNum3 < 0 then
                iNum3 = 0
            end
            self.uplevel = iNum3
        else
            self.uplevel = self.uplevel - 1
        end
        self:countAddExp()
        self:SetUpLvlExp()
        self:BrushAddLvlExp()
        self:BrushAddProp()
        self:showPanel()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralLvlUpUI:OnRightClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        if self.isUping == true then
            return
        end
        print("GeneralLvlUpUI:OnRightClick")
        if self.uplevel <= 0 then
            return
        end
        if self.uplevel == 10 then
            self.uplevel = 1
        else
            local iRet = self:judgeGerl()
            if iRet == 0 then
                self.uplevel = self.uplevel + 1
            else
                self:FloatMsg(iRet)
                print("GeneralLvlUpUI:OnRightClick"..iRet)
                return
            end
        end
        self:countAddExp()
        self:SetUpLvlExp()
        self:BrushAddLvlExp()
        self:BrushAddProp()
        self:showPanel()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralLvlUpUI:OnTapClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralLvlUpUI:OnTapClick")
        if self.isUping == true then
            return
        end
        if self.holdPanel ~= nil then
            self.holdPanel:setVisible(false)
        end
        if(self.tabItem)then
            self.tabItem:setEnabled(true)
            self.tabItem:getChildByName("select"):setVisible(false)
        end
        self.tabItem = event.target
        self.tabItem:setEnabled(false)
        self.tabItem:getChildByName("select"):setVisible(true)

        local itag = event.target:getTag()
        local strTag = "panel"..itag
        self.holdPanel = self[strTag]
        if self.holdPanel ~= nil then
            self.holdPanel:setVisible(true)
        end
        self.upType = itag
        self:BrushShowPanel()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralLvlUpUI:BrushShowPanel()
    if self.upType == 1 then
        self.selectGerl = {}
        self.myListview:getChildByTag(555):reloadData()
        self.addexp = 0
    else
        self.uplevel = 0
        self.addexp = 0
        if self:judgeGerl() == 0 then
            self.uplevel = 1
        end
        self:countAddExp()
    end
    self:SetUpLvlExp()
    self:BrushAddLvlExp()
    self:BrushAddProp()
    self:showPanel()
end

function GeneralLvlUpUI:showPanel()
    if self.upType == 1 then
        self:__panel1Show()
    else
        self:__panel2Show()
    end
    self.lb_cost:setString((self.addexp).."")
    local iNum = DataModeManager:getActor():GetProperty(Actor_Prop_Silver)
    if self.addexp > iNum then
        self.lb_cost:setTextColor(cc.c3b(255,0,0))
    else
        self.lb_cost:setTextColor(cc.c3b(104,39,0))
    end
end

function GeneralLvlUpUI:__panel1Show()
    self.lb_addgerlnum:setString(#self.selectGerl.." / 8")
end

function GeneralLvlUpUI:__panel2Show()
    self.lb_soulcost:setString((self.addexp).."")
    local iNum = DataModeManager:getActor():GetProperty(Actor_Prop_LeaderSoul)
    if self.addexp > iNum then
        self.lb_soulcost:setTextColor(cc.c3b(255,0,0))
    else
        self.lb_soulcost:setTextColor(cc.c3b(255,241,215))
    end
    self.lb_upnum:setString(self.uplevel.."")
    if self.uplevel <= 1 then
        self.btn_left:getChildByName("tag"):setTexture(self.Res_2)
    else
        self.btn_left:getChildByName("tag"):setTexture(self.Res_1)
    end
end

function GeneralLvlUpUI:OnAddGerlClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        if self.isUping == true then
            return
        end
        self.addexp = 0
        self:SetUpLvlExp()
        if self:judgeGerl() ~= 0 then
            return
        end
        self:autoAddGerl() 
        self.myListview:getChildByTag(555):reloadData()
        self:BrushAddLvlExp()
        self:BrushAddProp()
        self:showPanel()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralLvlUpUI:autoAddGerl()
    local iTag = 0
    self.selectGerl = {}
    for k,v in ipairs(self.dataList) do
        for _,u in ipairs(v) do
            if u.v ~= nil then
                table.insert(self.selectGerl,u)
                self:countAddExp()
                self:SetUpLvlExp()
                iTag = iTag+1
                if iTag >= 8 then
                    return
                end
                if self:judgeGerl() ~= 0 then
                    return
                end
            end
        end
    end
end

function GeneralLvlUpUI:OnLevelUpClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralLvlUpUI:OnLevelUpClick")
        if self.upType == 1 then
            if #self.selectGerl <= 0 then
                Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[15]})
                return
            end
            local iNum = DataModeManager:getActor():GetProperty(Actor_Prop_Silver)
            if iNum < self.addexp then
                self:FloatMsg(6)
                return
            end

        else
            if self.uplevel <= 0 then
                self:FloatMsg(self:judgeGerl())
                return
            end
            local iNum = DataModeManager:getActor():GetProperty(Actor_Prop_Silver)
            if iNum < self.addexp then
                self:FloatMsg(6)
                return
            end
            iNum = DataModeManager:getActor():GetProperty(Actor_Prop_LeaderSoul)
            if iNum < self.addexp then
                self:FloatMsg(7)
                return
            end
        end
        if self.isUping == true then
            return
        end
        self.isUping = true
        local pack = networkManager.createPack("leaderUplevel_c")
	    pack.leaderId = self.generalId
        pack.type = self.upType
        pack.soulType = self.uplevel
        local tlist = {}
        if self.upType == 1 then
            for k,v in ipairs(self.selectGerl) do 
                tlist[k] = v.v
            end
        end
        pack.leaderIds = tlist
	    networkManager.sendPack(pack,handler(self,self.levelUpCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralLvlUpUI:levelUpCallBack(obj)
    self.isUping = false
    if obj.result ~= ERR_SUCCESS then 
        Notifier.postNotifty("Notifty_MsgFloatUI_floatErrorCmd",{cmd=obj.result})
        return 
    end
    if obj.type == 1 then
        self:ShowListView()
    end
    self:BrushProp()
    self:BrushShowPanel()
end

function GeneralLvlUpUI:ShowListView()
    print("GeneralLvlUpUI:ShowListView()")
    self.dataList = self:__ValidListData()
    if self.myListview ~= nil then
        self.myListview:setData(self.dataList)
        return
    end
    if self.panel_clickhelper ~= nil then
        self:removeChild(self.panel_clickhelper)
    end
    self.cellClickItem = nil
    local udateItemFunc = handler(self,self.UpdateCell)
    local createItemFunc = handler(self,self.CreateListCell)
    local clickItemFunc = handler(self,self.OnClickItem)
    local hightlightItemFunc = handler(self,self.OnHightLightItem)
    local unhightlightItemFunc = handler(self,self.OnUnHightLightItem)
    self.myListview = ListView1:create({size = cc.size(465.00,319.00),
                                        pos = cc.p(619.98,234.0),
                                        spacing = 106 ,
                                        direction = ListView1.V, 
                                        createItem = createItemFunc, 
                                        udateItem = udateItemFunc, 
                                        clickItem = clickItemFunc,
                                        hightlightItem = hightlightItemFunc,
                                        unhightlightItem = unhightlightItemFunc})
    self.panel1:addChild(self.myListview)

    self.myListview:setData(self.dataList)
    self.panel_clickhelper = self:buildClickHelper()
    self.panel1:addChild(self.panel_clickhelper)
end

function GeneralLvlUpUI:buildClickHelper()
    local layout = ccui.Layout:create()
    layout:setContentSize(cc.size(465.00,325.00))
    layout:setPosition(619.98,231.31)
    layout:setTouchEnabled(true)
    layout:setSwallowTouches(false)
    return layout
end

function GeneralLvlUpUI:OnHightLightItem(item,index)
    self:OnUnHightLightItem(item,index)
    self.cellClickItem = nil
    local point = self.panel_clickhelper:getTouchBeganPosition()
    local cell = item:getChildByTag(self.CELL_TAG)
    local childrend = cell:getChildren()
    if childrend == nil then
        return
    end
    for _,v in pairs( childrend ) do
        local node = v
        if node ~= nil and node:isVisible() == true then
            local iTag = node:getTag()
            node = node:getChildByName("btn")
            if node == nil then return end
            local temppoint = node:convertToNodeSpace(point)
            local size = node:getContentSize()
            local cellRect = cc.rect(0,0,size.width,size.height)
            if cc.rectContainsPoint(cellRect,temppoint) then
                local iRet = self:CanClickGerl(self.dataList[index][iTag])
                if iRet ~= 0 then
                    self:FloatMsg(iRet)
                    return
                end
                self.cellClickItem = v
                v:setColor(cc.c3b(166,166,166))
                return
            end
        end
    end
end

function GeneralLvlUpUI:FloatMsg(iIndex)
    if iIndex == 1 then
        Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[13]})
    elseif iIndex == 2 then
        Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[12]})
    elseif iIndex == 3 then
        Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[12]})
    elseif iIndex == 4 then
        Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[12]})
    elseif iIndex == 5 then
        Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[14]})
    elseif iIndex == 6 then
        Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[3]})
    elseif iIndex == 7 then
        Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[10]})
    end
end

function GeneralLvlUpUI:OnUnHightLightItem(item,index)
    if self.cellClickItem ~= nil then
        self.cellClickItem:setColor(cc.c3b(255,255,255))
    end
end

function GeneralLvlUpUI:OnClickItem(item,index)
    if self.isUping == true then
        return
    end
    if self.cellClickItem == nil then
        return
    end
    local point = self.panel_clickhelper:getTouchEndPosition()
    local node = self.cellClickItem:getChildByName("btn")
    if node == nil then 
        return 
    end
    local temppoint = node:convertToNodeSpace(point)
    local size = node:getContentSize()
    local cellRect = cc.rect(0,0,size.width,size.height)
    if cc.rectContainsPoint(cellRect,temppoint) == false then
        return 
    end

    local itag = self.cellClickItem:getTag()
    local generalID = self.dataList[index][itag].v
    local general = DataModeManager:getGeneralData(generalID)
    if general == nil then return end
    node = self.cellClickItem:getChildByName("tag")
    if node:isVisible() == false then
        table.insert(self.selectGerl,self.dataList[index][itag])
    else
        local pos = 0
        local data = self.dataList[index][itag]
        for k,v in pairs(self.selectGerl) do
            if v.v ~= nil and v.v == data.v then
                pos = k
            end
        end
        if pos ~= 0 then
            table.remove(self.selectGerl,pos)
        end
    end
    node:setVisible(not node:isVisible())
    self:countAddExp()
    self:SetUpLvlExp()
    self:BrushAddLvlExp()
    self:BrushAddProp()
    self:showPanel()
    print("OnClickItem GeneralLvlUpUI :"..general:GetStaticProperty(General_StaticProp_Name))
end

function GeneralLvlUpUI:CanClickGerl(param)
    if #self.selectGerl >= 8 and self:containItem(param) == false then
        return 5
    end
    if self:judgeGerl() ~= 0 and self:containItem(param) == false then
        return self:judgeGerl()
    end
    return 0
end

function GeneralLvlUpUI:containItem(data)
    for _,v in pairs(self.selectGerl) do
        if v.v ~= nil and v.v == data.v then
            return true
        end
    end
    return false
end

function GeneralLvlUpUI:judgeGerl()
    local general = DataModeManager:getGeneralData(self.generalId)
    local ilvl = general:GetProperty(General_Prop_Level)
    local iMaxLvl = general:GetStaticProperty(General_StaticProp_Endlevel)
    local ilvlexp= DataManager.getLevelStaticDataByID(ilvl + self.uplevel ).leaderExp
    local iexp = self.upexp
    if ilvl >= iMaxLvl then
        return 1
    end
    if ilvl + self.uplevel > self.ActorLvl then
        return 2
    elseif ilvl + self.uplevel == self.ActorLvl then
        if self.upType == 1 then
            if iexp >= ilvlexp - 1 then return 3 end
        else
            return 4
        end
    end
    return 0
end

function GeneralLvlUpUI:__ValidListData()
    print("_____________________________________________ValidListData")
    local actor = DataModeManager:getActor()
    local part = actor:GetPart(Actor_Part_General)
    local generalList = part:getAllMode()
    local tlist = {}
    for _,v in pairs(generalList) do
        local general = DataModeManager:getGeneralData(v)
        local iQuelity = general:GetStaticProperty(General_StaticProp_Beginquelity)
        if  iQuelity <= 2 and v ~= self.generalId then
            local iLen = table.getn(tlist)
            local iExp = self:GeneralToExp(v)
            tlist[iLen+1] = {}
            tlist[iLen+1] = {v = v,exp = iExp}
        end
    end
    table.sort(tlist,handler(self,self.SortFunc))
    local tRetlist={}
    local itag = 1
    local irow = 1
    local iLen = table.getn(tlist)
    tRetlist[1] = {}
    local iMaxRow = 4
    for i = 1,iLen do
        if itag > iMaxRow then 
            itag = 1 
            irow = irow + 1
            tRetlist[irow] = {}
        end
        local item = tlist[i]
        tRetlist[irow][itag] = item
        itag = itag + 1
    end
    return tRetlist
end

function GeneralLvlUpUI:GeneralToExp(baseId)
    local general = DataModeManager:getGeneralData(baseId)
    local iQuelity = general:GetStaticProperty(General_StaticProp_Beginquelity)
    local iLvl = general:GetProperty(General_Prop_Level)
    local iValue1 = DataManager.getGeneralStaticDataByID(LEADER_QUELITY_BASE_LEVEL_NUMBER).value
    local iValue2 = DataManager.getGeneralStaticDataByID(LEADER_LEVER_VALUE).value
    local iExp = iValue1 * iQuelity + iValue2 * (iLvl - 1) * iQuelity
    return iExp
end

function GeneralLvlUpUI:UpdateCell(cell,index)
    local tlist = self.dataList[index]
    if tlist == nil then
        tlist = {}
    end
    local iMaxCell = 4
    for i = 1,#tlist do
        local node = nil
        node = cell:getChildByTag(i)
        self:__UpdateListItem(node,tlist[i])
        node:setVisible(true)
        node:setPosition(108*(i-1)+70,52)
    end
    local iBegin = #tlist + 1
    local iEnd = iMaxCell
    for i = iBegin,iEnd,1 do
        local node = nil
        node = cell:getChildByTag(i)
        if node ~= nil then
            node:setVisible(false)
        end
    end
end


function GeneralLvlUpUI:CreateListCell(index)
    local cell = cc.Node:create()
    cell:setContentSize(self.ListViewCellSize)

    local tlist = self.dataList[index]
    if tlist == nil then
        tlist = {}
    end
    local iMaxCell = 4
    for i = 1,iMaxCell,1 do
        local node = nil
        node = self:__GetListItem()
        node:setPosition(108*(i-1)+70,52)
        node:setTag(i)
        cell:addChild(node)
    end
    for i = 1,#tlist do
        local node = nil
        node = cell:getChildByTag(i)
        self:__UpdateListItem(node,tlist[i])
        node:setVisible(true)
        node:setPosition(108*(i-1)+70,52)
    end
    local iBegin = #tlist + 1
    local iEnd = iMaxCell
    for i = iBegin,iEnd,1 do
        local node = nil
        node = cell:getChildByTag(i)
        if node ~= nil then
            node:setVisible(false)
        end
    end
    return cell
end

function GeneralLvlUpUI:__UpdateListItem(node,param)
    local general = DataModeManager:getGeneralData(param.v)
    local tag = node:getChildByName("tag")
    local btn = node:getChildByName("btn")
    local num = node:getChildByName("num")
    local img = node:getChildByName("img")
    tag:setVisible(self:containItem(param))
    num:setString(param.exp.."")
    local str = general:GetStaticProperty(General_StaticProp_Iconid)
    img:setTexture("image/leaderHeadIcon/"..str..".png")
    local iNum = general:GetStaticProperty(General_StaticProp_Beginquelity)
    btn:setTexture("common/label/lb_w104_"..iNum..".png")
end

function GeneralLvlUpUI:__GetListItem()
    local node = cc.CSLoader:createNode(self.Res_CSB)
    return node
end

function GeneralLvlUpUI:SortFunc(itemA,itemB)
    return itemA.exp > itemB.exp
end

function GeneralLvlUpUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_Actor_Set_Prop" and body.propID == Actor_Prop_Silver then
        if self.isUping ~= true then
            self:showPanel()
        end
    end
end

--------------------------------------------------------------------------------------------------------------------
return GeneralLvlUpUI

