local GeneralUI = class("GeneralUI", cocosMake.viewBase)

--规范
GeneralUI.ui_resource_file = {"generalUI_VS"}--cocos studio生成的csb
GeneralUI.StarRes = "common/label/lb_w36.png"
GeneralUI.ui_binding_file = {--控件绑定
    panel_prop = {name="generalUI_VS.prop"},
    panel_1 = {name="generalUI_VS.panel_1"},
    panel_2 = {name="generalUI_VS.panel_2"},
    panel_3 = {name="generalUI_VS.panel_3"},
    btn_esc = {name="generalUI_VS.btn_esc",event="touch",method="OnEscClick"},
    ------------------------------------------------tab-----------------------------------------------------------------
    tab_item1 = {name="generalUI_VS.tab.item1",event="touch",method="OnTabClick"},
    tab_item2 = {name="generalUI_VS.tab.item2",event="touch",method="OnTabClick"},
    tab_item3 = {name="generalUI_VS.tab.item3",event="touch",method="OnTabClick"},
    ----------------------------------------------panel_1---------------------------------------------------------------
    pn_sdrshow = {name="generalUI_VS.panel_1.soldier.img"},
    btn_upsdr = {name="generalUI_VS.panel_1.soldier.btn",event="touch",method="OnClick"},
    btn_sdrdt = {name="generalUI_VS.panel_1.soldier.btn_dt",event="touch",method="OnShowSdrDtClick"},
    btn_upsdrlvl = {name="generalUI_VS.panel_1.btn_uplvl",event="touch",method="OnClick"},
    btn_addsdrnum = {name="generalUI_VS.panel_1.btn_addnum",event="touch",method="OnClick"},
    lb_sdrlvl = {name="generalUI_VS.panel_1.lb_lvl"},
    lb_sdrnum = {name="generalUI_VS.panel_1.lb_num"},
    lb_sdrdes = {name="generalUI_VS.panel_1.lb_des"},
    lb_sdrname = {name="generalUI_VS.panel_1.soldier.name"},
    pn_sdrprop_lv2 = {name="generalUI_VS.prop_sdr.prop_lv2"},
    ------------------------------------------------prop----------------------------------------------------------------
    img_gerlType = {name="generalUI_VS.prop.type"},
    lb_lvl = {name="generalUI_VS.prop.lb_lvl"},
    lb_FC = {name="generalUI_VS.prop.lb_zl"},
    lb_name = {name="generalUI_VS.prop.lb_name"},
                            ------------------------equip--------------------
                            -------------------------------------------------
    stars = {name="generalUI_VS.prop.stars"},
    lb_zl = {name="generalUI_VS.prop.lb_zl"},
    pn_prop_lv1  = {name="generalUI_VS.prop.prop_lv1"},
    pn_prop_lv2  = {name="generalUI_VS.prop.prop_lv2"},
    btn_onekey = {name="generalUI_VS.prop.onekeybtn",event="touch",method="OnClick"},
    btn_jj = {name="generalUI_VS.prop.btn_jj",event="touch",method="OnJJClick"},
    btn_sj = {name="generalUI_VS.prop.btn_sj",event="touch",method="OnSJClick"},
    btn_pre = {name="generalUI_VS.prop.btn_pre",event="touch",method="OnPreClick"},
    btn_next = {name="generalUI_VS.prop.btn_next",event="touch",method="OnNextClick"},
    img_gerl = {name="generalUI_VS.prop.img"},
                            ---------------------prop_lv1--------------------
    lb_force = {name="generalUI_VS.prop.prop_lv1.lb_wl"},
    lb_wit = {name="generalUI_VS.prop.prop_lv1.lb_zl"},
    lb_endurance = {name="generalUI_VS.prop.prop_lv1.lb_nl"},
    lb_agility = {name="generalUI_VS.prop.prop_lv1.lb_mj"},
    btn_detail = {name="generalUI_VS.prop.prop_lv1.btn_detail",event="touch",method="OnShowDetailProp"},
                            -------------------------------------------------
                            ---------------------prop_lv2--------------------
    lb_prop_1_1 = {name="generalUI_VS.prop.prop_lv2.prop_1_1"},
    lb_prop_1_2 = {name="generalUI_VS.prop.prop_lv2.prop_1_2"},
    lb_prop_1_3 = {name="generalUI_VS.prop.prop_lv2.prop_1_3"},
    lb_prop_1_4 = {name="generalUI_VS.prop.prop_lv2.prop_1_4"},
    lb_prop_1_5 = {name="generalUI_VS.prop.prop_lv2.prop_1_5"},

    lb_prop_2_1 = {name="generalUI_VS.prop.prop_lv2.prop_2_1"},
    lb_prop_2_2 = {name="generalUI_VS.prop.prop_lv2.prop_2_2"},
    lb_prop_2_3 = {name="generalUI_VS.prop.prop_lv2.prop_2_3"},
    lb_prop_2_4 = {name="generalUI_VS.prop.prop_lv2.prop_2_4"},
    lb_prop_2_5 = {name="generalUI_VS.prop.prop_lv2.prop_2_5"},
                            -------------------------------------------------
                            ---------------------sdrprop_lv2--------------------
    lb_sdrprop_1_1 = {name="generalUI_VS.prop_sdr.prop_lv2.prop11"},
    lb_sdrprop_1_2 = {name="generalUI_VS.prop_sdr.prop_lv2.prop12"},
    lb_sdrprop_1_3 = {name="generalUI_VS.prop_sdr.prop_lv2.prop13"},
    lb_sdrprop_1_4 = {name="generalUI_VS.prop_sdr.prop_lv2.prop14"},
    lb_sdrprop_2_1 = {name="generalUI_VS.prop_sdr.prop_lv2.prop21"},
    lb_sdrprop_2_2 = {name="generalUI_VS.prop_sdr.prop_lv2.prop22"},
    lb_sdrprop_2_3 = {name="generalUI_VS.prop_sdr.prop_lv2.prop23"},
    lb_sdrprop_2_4 = {name="generalUI_VS.prop_sdr.prop_lv2.prop24"}
                            -------------------------------------------------

    ------------------------------------------------------------------------------------------------------------------
}

GeneralUI.notify = {"Notifty_GeneralUI_Show","Notifty_General_Update"}--通知

function GeneralUI:onCreate(param)
    print("GeneralUI:onCreate")
    
    self.dataList = {}
    self.dataList = self:loadDataList(param.data)
    
    self.gerlIndex = {}
    self.gerlIndex = self:loadDataList(param.index)
    self:__initShow()
end

function GeneralUI:loadDataList(param)
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

function GeneralUI:onClose()
    print("GeneralUI:onClose")
end

function GeneralUI:__initShow()
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)
    self.panel_2:setVisible(false)
    self.panel_3:setVisible(false)
    self.pn_prop_lv2:setScale(0)
    self.pn_sdrprop_lv2:setScale(0)
    self.lb_zl:getVirtualRenderer():setAdditionalKerning(-6.0)
    self:OnTabClick({target = self.tab_item1,state = 2})
    
    if table.getn(self.dataList[1]) <= 2 then
        self.btn_pre:setEnabled(false)
        self.btn_pre:setColor(cc.c3b(166,166,166))
        self.btn_next:setEnabled(false)
        self.btn_next:setColor(cc.c3b(166,166,166))
    end
    local batchNode = cc.SpriteBatchNode:create("generalUI/hjkhkt.png")
    batchNode:setTag(111)
    self.pn_sdrshow:addChild(batchNode)
    local row = 1
    local cell = 1
    local rowWidth = 40
    local cellWidth = 60
    local offsetX = 30 
    local posX = 170
    local posY = 210
    for i=1,15,1 do
        cell = i%5
        if cell == 0 then cell = 5 end
        row = math.ceil(i/5.0)
        local sprite = cc.Sprite:create("generalUI/hjkhkt.png")
        batchNode:addChild(sprite)
        local iposx = posX - (row-1)*cellWidth + (cell-1)*offsetX
        local iposy = posY - (cell-1)*rowWidth
        sprite:setPosition(iposx,iposy)
        sprite:setTag(i)
    end

    self:ShowGeneral()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function(touch, event) return true end,cc.Handler.EVENT_TOUCH_BEGAN )
	listener:registerScriptHandler(function(touch, event)end,cc.Handler.EVENT_TOUCH_MOVED )
	listener:registerScriptHandler(handler(self,self.OnCloseDetailProp),cc.Handler.EVENT_TOUCH_ENDED )
    listener:setSwallowTouches(false)
    local node = cc.Node:create()
    self:addChild(node)
    local eventDispacher = self:getEventDispatcher()
	eventDispacher:addEventListenerWithSceneGraphPriority(listener,node)
end

function GeneralUI:ShowGeneral()
    local cell = self.gerlIndex.cell
    local row = self.gerlIndex.row
    local generalID = self.dataList[cell][row].v
    local general = DataModeManager:getGeneralData(generalID)
    if general == nil then return end
    self.img_gerl:removeAllChildren()
    local str = general:GetStaticProperty(General_StaticProp_Modelid)
    if tostring(str) ~= "0" then
        local json = SKELETON_AVATAR_UI_PATH .. "/" .. str ..".json"
        local atlas = SKELETON_AVATAR_UI_PATH .. "/" .. str ..".atlas"
        print(json.."\n"..atlas)
 	    local skeleton = sp.SkeletonAnimation:create(json, atlas, 1.0)
        if skeleton ~= nil then
            skeleton:setAnchorPoint(0.5,0)
            self.img_gerl:addChild(skeleton)
            skeleton:setAnimation(0,ROLE_IDLE_ANIMATION_NAME,true)
        end
    end

    local iNum = general:GetStaticProperty(General_StaticProp_Type)
    
    self.img_gerlType:setTexture("common/label/lb_w38_"..iNum..".png")
    str = general:GetStaticProperty(General_StaticProp_Name)
    iNum = general:GetProperty(General_Prop_Grade)
    if iNum > 0 then
        str = str.."+"..iNum
    end
    self.lb_name:setString(str)
    iNum = general:GetStaticProperty(General_StaticProp_Force)
    self.lb_force:setString(tostring(iNum))
    iNum = general:GetStaticProperty(General_StaticProp_Wit)
    self.lb_wit:setString(iNum)
    iNum = general:GetStaticProperty(General_StaticProp_Endurance)
    self.lb_endurance:setString(tostring(iNum))
    iNum = general:GetStaticProperty(General_StaticProp_Agility)
    self.lb_agility:setString(tostring(iNum))

    
    self:__BrushPropShow(general)
    
    iNum = general:GetProperty(General_Prop_ArmId)
    local soldier = DataModeManager:getSoldierData(iNum)
    if soldier ~= nil then
        self:__BrushSdrPropShow(soldier)
    end
    
    iNum = general:GetStaticProperty(General_StaticProp_Beginstar)
    self.stars:removeAllChildren()
    for i = 1,iNum,1 do
        local pstar = cc.Sprite:create(self.StarRes)
        local iwidth = pstar:getContentSize().width
        local iposx = 0 - iwidth * (iNum-1)/2 + iwidth * (i-1)
        pstar:setPosition(iposx,0)
        self.stars:addChild(pstar)
    end
end

function GeneralUI:__BrushSdrPropShow(soldier)
    local iNum = soldier:GetProperty(Soldier_Prop_Amount)
    self.lb_sdrnum:setString(tostring(iNum))
    local batchNode = self.pn_sdrshow:getChildByTag(111)
    for i = 1,iNum,1 do
        local node = batchNode:getChildByTag(i)
        if node ~= nil then
            node:setOpacity(255)
        end
    end
    for i = iNum+1,15,1 do
        local node = batchNode:getChildByTag(i)
        if node ~= nil then
            node:setOpacity(120)
        end
    end
    self.lb_sdrdes:setTextAreaSize(cc.size(340,100))
    local str = soldier:GetStaticProperty(Soldier_StaticProp_Description)
    self.lb_sdrdes:setString(str)
    str = soldier:GetStaticProperty(Soldier_StaticProp_Name)
    self.lb_sdrname:setString(str)
    iNum = soldier:GetProperty(Soldier_Prop_Level)
    self.lb_sdrlvl:setString(tostring(iNum))
    -----------------------------------------------------------------------
    iNum = soldier:GetProperty(Soldier_Prop_Physicsattack)
    if iNum <= 0.01 then
        iNum = soldier:GetProperty(Soldier_Prop_Magicattack)
        self.pn_sdrprop_lv2:getChildByName("prop"):setString(TxtCache.Prop_Txt_4)
    else
        self.pn_sdrprop_lv2:getChildByName("prop"):setString(TxtCache.Prop_Txt_3)
    end
    self.lb_sdrprop_1_1:setString(tostring(iNum))
    iNum = soldier:GetProperty(Soldier_Prop_Barmor)
    self.lb_sdrprop_1_2:setString(tostring(iNum))
    iNum = soldier:GetProperty(Soldier_Prop_Crit)
    self.lb_sdrprop_1_3:setString(tostring(iNum))
    iNum = soldier:GetProperty(Soldier_Prop_Dodge)
    self.lb_sdrprop_1_4:setString(tostring(iNum))
    iNum = soldier:GetProperty(Soldier_Prop_Hit)
    self.lb_sdrprop_2_1:setString(tostring(iNum))
    iNum = soldier:GetProperty(Soldier_Prop_Bresistance)
    self.lb_sdrprop_2_2:setString(tostring(iNum))
    iNum = soldier:GetProperty(Soldier_Prop_Hp)
    self.lb_sdrprop_2_3:setString(tostring(iNum))
    iNum = soldier:GetProperty(Soldier_Prop_Opposecrit)
    self.lb_sdrprop_2_4:setString(tostring(iNum))
end

function GeneralUI:__BrushPropShow(general)
    local iNum = general:GetProperty(General_Prop_Physicsattack)
    if iNum <= 0.01 then
        iNum = general:GetProperty(General_Prop_Magicattack)
        self.pn_prop_lv2:getChildByName("prop"):setString(TxtCache.Prop_Txt_4)
    else
        self.pn_prop_lv2:getChildByName("prop"):setString(TxtCache.Prop_Txt_3)
    end
    self.lb_prop_1_1:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Barmor)
    self.lb_prop_1_2:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Opposecrit)
    self.lb_prop_1_3:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Hit)
    self.lb_prop_1_4:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Endhurt)
    self.lb_prop_1_5:setString(tostring(iNum))

    iNum = general:GetProperty(General_Prop_Level)
    self.lb_lvl:setString("Lv:"..iNum)

    -----------------------------------------------------------------------------
    iNum = general:GetProperty(General_Prop_Hp)
    self.lb_prop_2_1:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Bresistance)
    self.lb_prop_2_2:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Crit)
    self.lb_prop_2_3:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Dodge)
    self.lb_prop_2_4:setString(tostring(iNum))
    iNum = general:GetProperty(General_Prop_Offsethurt)
    self.lb_prop_2_5:setString(tostring(iNum))
    ------------------------------------------------------------------------------
    iNum = general:GetProperty(General_Prop_FC)
    self.lb_zl:setString(tostring(iNum))
end

function GeneralUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_GeneralUI_Show" then
        self:setVisible(body.visible)
        self.isShowing = not body.visible
    elseif notifyName == "Notifty_GeneralUI_Brush" then
        self.dataList = {}
        self.dataList = self:loadDataList(param.data)
    
        self.gerlIndex = {}
        self.gerlIndex = self:loadDataList(param.index)
        if table.getn(self.dataList[1]) <= 2 then
            self.btn_pre:setEnabled(false)
            self.btn_pre:setColor(cc.c3b(166,166,166))
            self.btn_next:setEnabled(false)
            self.btn_next:setColor(cc.c3b(166,166,166))
        end
    elseif notifyName == "Notifty_General_Update" then
        self:ShowGeneral()
    end
end

function GeneralUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralUI:OnEscClick")
        Notifier.postNotifty("Notifty_CampUI_Show",{visible = true})
        self:getParent():closeFloat({name = luaFile.GeneralUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralUI:OnShowSdrDtClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralUI:OnShowDetailProp")
        if self.pn_sdrprop_lv2:getScaleX()> 0.01 then
            self.pn_sdrprop_lv2:stopAllActions()
            self.pn_sdrprop_lv2:runAction(cc.ScaleTo:create(0.1,0.0))
        else
            self.pn_sdrprop_lv2:stopAllActions()
            self.pn_sdrprop_lv2:runAction(cc.ScaleTo:create(0.1,1.0))
        end
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralUI:OnShowDetailProp(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralUI:OnShowDetailProp")
        if self.pn_prop_lv2:getScaleX()> 0.01 then
            self.pn_prop_lv2:stopAllActions()
            self.pn_prop_lv2:runAction(cc.ScaleTo:create(0.1,0.0))
        else
            self.pn_prop_lv2:stopAllActions()
            self.pn_prop_lv2:runAction(cc.ScaleTo:create(0.1,1.0))
        end
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralUI:OnCloseDetailProp()
    self.pn_prop_lv2:stopAllActions()
    self.pn_prop_lv2:runAction(cc.ScaleTo:create(0.1,0.0))
    self.pn_sdrprop_lv2:stopAllActions()
    self.pn_sdrprop_lv2:runAction(cc.ScaleTo:create(0.1,0.0))
end

function GeneralUI:OnNextClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralUI:OnNextClick")
        local cell = self.gerlIndex.cell
        local row = self.gerlIndex.row
        if row >= table.getn(self.dataList[cell]) then
            if cell >= table.getn(self.dataList) then
                cell = 1
                row = 1
            else
                cell = cell+1
                row = 1
                if self.dataList[cell][row].v == nil then
                    cell = 1
                    row = 1
                end
            end
        else
            row = row + 1
            if self.dataList[cell][row].v == nil then
                cell = 1
                row = 1
            end
        end
        if self.dataList[cell][row].v == nil then
            return
        end
        self.gerlIndex.cell = cell
        self.gerlIndex.row = row
        self:ShowGeneral()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralUI:OnPreClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralUI:OnPreClick")
        local cell = self.gerlIndex.cell
        local row = self.gerlIndex.row
        local general = self.dataList[cell][row].v
        if row <=1 then
            if cell <= 1 then
                cell = table.getn(self.dataList)
                row = table.getn(self.dataList[cell])
                if self.dataList[cell][row].v == nil then
                    row = row - 1
                end
            else
                cell = cell-1
                row = table.getn(self.dataList[cell])
            end
        else
            row = row -1
        end
        if self.dataList[cell][row].v == nil then
            return
        end
        self.gerlIndex.cell = cell
        self.gerlIndex.row = row
        self:ShowGeneral()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralUI:OnTabClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralUI:OnTabClick")
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
        local strTag = "panel_"..itag
        self.holdPanel = self[strTag]
        if self.holdPanel ~= nil then
            self.holdPanel:setVisible(true)
        end
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralUI:OnJJClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralUI:OnJJClick")
        local cell = self.gerlIndex.cell
        local row = self.gerlIndex.row
        local generalID = self.dataList[cell][row].v
        local func = function()
            self:getParent():showFloat(luaFile.GeneralTalentUpUI,{baseId = generalID})
        end
        local action = cc.CallFunc:create(func)
        self:runAction(action)
        self:setVisible(false)
        self.isShowing = true
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralUI:OnSJClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralUI:OnSJClick")
        if self.isShowing == true then return end
        local cell = self.gerlIndex.cell
        local row = self.gerlIndex.row
        local generalID = self.dataList[cell][row].v
        local func = function()
            self:getParent():showFloat(luaFile.GeneralLvlUpUI,{baseId = generalID})
            print("CallFunc GeneralLvlUpUI")
        end
        local action = cc.CallFunc:create(func)
        self:runAction(action)
        self:setVisible(false)
        self.isShowing = true
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function GeneralUI:OnClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("GeneralUI:OnClick")
        Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[1]})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

--------------------------------------------------------------------------------------------------------------------
return GeneralUI

