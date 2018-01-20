local CampUI = class("CampUI", cocosMake.viewBase)

--规范
CampUI.ui_resource_file = {"campUI_VS"}--cocos studio生成的csb
CampUI.GeneralAddRes = "csb/generaladd.csb"
CampUI.GeneralInfoRes = "csb/generalinfo.csb"
CampUI.StarRes = "common/label/lb_w22.png"
CampUI.CELL_TAG = 100
CampUI.ListViewCellSize = { width = 870,height = 162}
CampUI.ui_binding_file = {--控件绑定

    btn_item0 = {name="campUI_VS.item0",event="touch",method="OnSortTypeClick"},
    btn_item1 = {name="campUI_VS.item1",event="touch",method="OnSortTypeClick"},
    btn_item2 = {name="campUI_VS.item2",event="touch",method="OnSortTypeClick"},
    btn_item3 = {name="campUI_VS.item3",event="touch",method="OnSortTypeClick"},
    btn_item4 = {name="campUI_VS.item4",event="touch",method="OnSortTypeClick"},
    btn_item5 = {name="campUI_VS.item5",event="touch",method="OnSortTypeClick"},
    --------------------------------------------------------------------------------------------------------------------
    btn_sortrule = {name="campUI_VS.btn_sort",event="touch",method="OnSortRuleClick"},
    btn_sortorder = {name="campUI_VS.btn_order",event="touch",method="OnSortOrderClick"},
    btn_standup = {name="campUI_VS.btn_standup",event="touch",method="OnSetLeaderClick"},
    btn_sell = {name="campUI_VS.btn_sell",event="touch",method="OnSellClick"},
    btn_esc = {name="campUI_VS.btn_esc",event="touch",method="OnEscClick"}
}

CampUI.notify = {"Notifty_CampUI_Show_General","Notifty_CampUI_Show","Notifty_General_Delete","Notifty_General_Update"}--通知

function CampUI:onCreate()
    print("CampUI:onCreate")
    self.iSortRule = 2
    self.iSortOrder = 0
    self.iSortType = 0
    self.iTotalSort = 3
    self:__initShow()
end

function CampUI:onClose()
    print("CampUI:onClose")
end

function CampUI:__initShow()
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)
    self:OnSortTypeClick({state = 2,target=self.btn_item0})
end

function CampUI:OnSortRuleClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("CampUI:OnSortRuleClick")
        self.iSortRule = (self.iSortRule+1)%self.iTotalSort
        local textLabel = event.target:getChildByName("txt")
        if self.iSortRule == 0 then
            textLabel:setString(TxtCache.CampUI_Btn_Txt_3)
        elseif self.iSortRule == 1 then
            textLabel:setString(TxtCache.CampUI_Btn_Txt_4)
        elseif self.iSortRule == 2 then
            textLabel:setString(TxtCache.CampUI_Btn_Txt_5)
        end
        self:ShowListView()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function CampUI:OnSortTypeClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("CampUI:OnSortTypeClick")
        self.iSortType = event.target:getTag()
        if(self.sortItem)then
            self.sortItem:setEnabled(true)
            self.sortItem:getChildByName("select"):setVisible(false)
        end
        self.sortItem = event.target
        self.sortItem:setEnabled(false)
        self.sortItem:getChildByName("select"):setVisible(true)
        self:ShowListView()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function CampUI:OnSortOrderClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("CampUI:OnSortOrderClick")
        local textLabel = event.target:getChildByName("txt")
        if self.iSortOrder == 0 then
            self.iSortOrder = 1
            textLabel:setString(TxtCache.CampUI_Btn_Txt_1)
        else 
            self.iSortOrder = 0
            textLabel:setString(TxtCache.CampUI_Btn_Txt_2)
        end
        self:ShowListView()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function CampUI:OnSetLeaderClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("CampUI:OnSetLeaderClick")
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function CampUI:OnSellClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("CampUI:OnSellClick")
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function CampUI:OnGeneralClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("CampUI:OnGeneralClick")
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function CampUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("CampUI:OnEscClick")
        self:getParent():closeFloat({name = luaFile.CampUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function CampUI:ShowListView()
    print("CampUI:ShowListView()")
    self.dataList = self:__ValidListData()
    if self.myListview ~= nil then
        self.myListview:setData(self.dataList)
        return
        --self:removeChild(self.myListview)
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
    self.myListview = ListView1:create({size = cc.size(865,370),
                                        pos = cc.p(209,164),
                                        spacing = 180 ,
                                        direction = ListView1.V, 
                                        createItem = createItemFunc, 
                                        udateItem = udateItemFunc, 
                                        clickItem = clickItemFunc,
                                        hightlightItem = hightlightItemFunc,
                                        unhightlightItem = unhightlightItemFunc})
    self:addChild(self.myListview)

    self.myListview:setData(self.dataList)
    self.panel_clickhelper = self:buildClickHelper()
    self:addChild(self.panel_clickhelper)
end

function CampUI:buildClickHelper()
    local layout = ccui.Layout:create()
    layout:setContentSize(cc.size(865.00,370.00))
    layout:setPosition(209.00,164.00)
    layout:setTouchEnabled(true)
    layout:setSwallowTouches(false)
    return layout
end

function CampUI:OnHightLightItem(item,index)
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
            node = node:getChildByName("btn")
            if node == nil then return end
            local temppoint = node:convertToNodeSpace(point)
            local size = node:getContentSize()
            local cellRect = cc.rect(0,0,size.width,size.height)
            if cc.rectContainsPoint(cellRect,temppoint) then
                self.cellClickItem = v
                v:setColor(cc.c3b(166,166,166))
                return
            end
        end
    end
end

function CampUI:OnUnHightLightItem(item,index)
    if self.cellClickItem ~= nil then
        self.cellClickItem:setColor(cc.c3b(255,255,255))
    end
end

function CampUI:OnClickItem(item,index)
    if self.cellClickItem == nil then
        return
    end
    if self.isShowing == true then return end
    print("CampUI:OnClickItem")
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
    if itag > 6 then
        print("do ADD GeneralList Size")
        return
    end
    local generalID = self.dataList[index][itag].v
    local general = DataModeManager:getGeneralData(generalID)
    self.cellClickItem = nil
    if general == nil then return end
    self.isShowing = true
    local func = function()
        self:getParent():showFloat(luaFile.GeneralUI,{data = self.dataList,index = {cell = index,row = itag}})
        print("CallFunc GeneralUI")
    end
    local action = cc.CallFunc:create(func)
    self:runAction(action)
    self:setVisible(false)
    self.showGerlId = generalID
    print("OnClickItem General :"..general:GetStaticProperty(General_StaticProp_Name))
end

function CampUI:__ValidListData()
    print("_____________________________________________ValidListData")
    local actor = DataModeManager:getActor()
    local part = actor:GetPart(Actor_Part_General)
    local generalList = part:getAllMode()
    local tlist = {}
    for _,v in pairs(generalList) do
        local general = DataModeManager:getGeneralData(v)
        if self.iSortType == 0 or self.iSortType == general:GetStaticProperty(General_StaticProp_Type) then
            local iLen = table.getn(tlist)
            tlist[iLen+1] = v
        end
    end
    table.sort(tlist,handler(self,self.SortFunc))
    local tRetlist={}
    local itag = 1
    local irow = 1
    local iLen = table.getn(tlist)
    tRetlist[1] = {}
    for i = 1,iLen do
        if itag > 6 then 
            itag = 1 
            irow = irow + 1
            tRetlist[irow] = {}
        end
        local item = tlist[i]
        tRetlist[irow][itag] = {t = 0,v = item}
        itag = itag + 1
    end
    iLen = table.getn(tRetlist)
    if table.getn(tRetlist[iLen]) < 6 then
        tRetlist[iLen][table.getn(tRetlist[iLen])+1] = {t=1,v=nil}
    else
        tRetlist[iLen+1] = {}
        tRetlist[iLen+1][1] = {t=1,v=nil}
    end
    return tRetlist
end

function CampUI:UpdateCell(cell,index)
    local tlist = self.dataList[index]
    if tlist == nil then
        print("tlist is nil")
        return
    end
    local addNode = nil
    for i = 1,table.getn(tlist) do
        local generalNode = nil
        if tlist[i].t == 0 then
            generalNode = cell:getChildByTag(i)
            self:__UpdateListItem(generalNode,tlist[i].v)
        else
            generalNode = cell:getChildByTag(7)
            addNode = generalNode
        end
        generalNode:setVisible(true)
        generalNode:setPosition(140*(i-1)+82.5,81)
    end
    local iBegin = table.getn(tlist) + 1
    local iEnd = 7
    if addNode ~= nil then
        iBegin = table.getn(tlist)
        iEnd = 6
    end
    for i = iBegin,iEnd,1 do
        local generalNode = nil
        generalNode = cell:getChildByTag(i)
        if generalNode ~= nil then
            generalNode:setVisible(false)
        end
    end
end


function CampUI:CreateListCell(index)
    local cell = cc.Node:create()
    cell:setContentSize(self.ListViewCellSize)

    local tlist = self.dataList[index]
    if tlist == nil then
        print("tlist is nil")
        return
    end
    for i = 1,7,1 do
        local generalNode = nil
        if i ~= 7 then
            generalNode = self:__GetListItem()
            generalNode:setTag(i)
        else
            generalNode = self:__GetAddListSizeItem()
            generalNode:setTag(6+1)
        end
        generalNode:setPosition(140*(i-1)+82.5,81)
        cell:addChild(generalNode)
    end
    local addNode = nil
    for i = 1,table.getn(tlist) do
        local generalNode = nil
        if tlist[i].t == 0 then
            generalNode = cell:getChildByTag(i)
            self:__UpdateListItem(generalNode,tlist[i].v)
        else
            generalNode = cell:getChildByTag(7)
            addNode = generalNode
        end
        generalNode:setVisible(true)
        generalNode:setPosition(140*(i-1)+82.5,81)
    end
    local iBegin = table.getn(tlist) + 1
    local iEnd = 7
    if addNode ~= nil then
        iBegin = table.getn(tlist)
        iEnd = 6
    end
    for i = iBegin,iEnd,1 do
        local generalNode = nil
        generalNode = cell:getChildByTag(i)
        if generalNode ~= nil then
            generalNode:setVisible(false)
        end
    end
    return cell
end

function CampUI:__GetAddListSizeItem()
    local node = cc.CSLoader:createNode(self.GeneralAddRes)
    local info = node:getChildByName("info")
    return node
end

function CampUI:__UpdateListItem(node,param)
    local general = DataModeManager:getGeneralData(param)
    local Armtype = node:getChildByName("type")
    local btn = node:getChildByName("btn")
    local lvl = node:getChildByName("lvl")
    local star = node:getChildByName("star")
    local box = node:getChildByName("box")
    local tx = node:getChildByName("tx")
    local name = node:getChildByName("lb_name")
    local iNum = general:GetStaticProperty(General_StaticProp_Type)
    if iNum >= 1 and iNum <= 5 then
        Armtype:setTexture("common/label/lb_w38_"..iNum..".png")
    end
    local str = general:GetStaticProperty(General_StaticProp_Name)
    iNum = general:GetProperty(General_Prop_Grade)
    if iNum > 0 then
        str = str.."+"..iNum
    end
    name:setString(str)
    iNum = general:GetProperty(General_Prop_Level)
    local iMax = general:GetStaticProperty(General_StaticProp_Endlevel)
    lvl:setString("Lv:"..iNum)
    iNum = general:GetStaticProperty(General_StaticProp_Beginstar)
    for i = 1,iNum,1 do
        local pstar = star:getChildByTag(i)
        pstar:setVisible(true)
        if pstar ~= nil then
            local iwidth = pstar:getContentSize().width - 6
            local iposx = 0 - iwidth * (iNum-1)/2 + iwidth * (i-1)
            pstar:setPosition(iposx,0)
        end
    end
    for i = iNum+1,5,1 do
        local pstar = star:getChildByTag(i)
        if pstar ~= nil then
            pstar:setVisible(false)
        end
    end
    iNum = general:GetStaticProperty(General_StaticProp_Beginquelity)
    box:setTexture("common/label/lb_w104_"..iNum..".png")
    local str = general:GetStaticProperty(General_StaticProp_Iconid)
    tx:setTexture("image/leaderHeadIcon/"..str..".png")
end

function CampUI:__GetListItem()
    local node = cc.CSLoader:createNode(self.GeneralInfoRes)
    local star = node:getChildByName("star")
    local iNum = 5
    for i = 1,iNum,1 do
        local pstar = cc.Sprite:create(self.StarRes)
        local iwidth = pstar:getContentSize().width - 6
        local iposx = 0 - iwidth * (iNum-1)/2 + iwidth * (i-1)
        pstar:setPosition(iposx,0)
        pstar:setTag(i)
        star:addChild(pstar)
    end
    return node
end

function CampUI:SortFunc(generalIDA,generalIDB)
    local generalA = DataModeManager:getGeneralData(generalIDA)
    local generalB = DataModeManager:getGeneralData(generalIDB)
    if self.iSortRule == 0 then
        return self:SortFunc_1(generalA,generalB)
    elseif  self.iSortRule == 1 then
        return self:SortFunc_2(generalA,generalB)
    elseif  self.iSortRule == 2 then
        return self:SortFunc_3(generalA,generalB)
    end
end

function CampUI:SortFunc_1(generalA,generalB)
    local iQuelityA = generalA:GetStaticProperty(General_StaticProp_Beginquelity)
    local iQuelityB = generalB:GetStaticProperty(General_StaticProp_Beginquelity)
    local ret = iQuelityA > iQuelityB
    if iQuelityA == iQuelityB then
        local iFCA = generalA:GetProperty(General_Prop_FC)
        local iFCB = generalB:GetProperty(General_Prop_FC)
        ret = iFCA > iFCB
        if iFCA == iFCB then
            local iLvlA = generalA:GetProperty(General_Prop_Level)
            local iLvlB = generalB:GetProperty(General_Prop_Level)
            ret = iLvlA > iLvlB
            if iLvlA == iLvlB then
                local iStarA = generalA:GetProperty(General_StaticProp_Beginstar)
                local iStarB = generalB:GetProperty(General_StaticProp_Beginstar)
                ret = iStarA > iStarB
            end
        end
    end
    if self.iSortOrder == 0 then
        return ret
    else 
        return not ret
    end
end

function CampUI:SortFunc_2(generalA,generalB)
    local iLvlA = generalA:GetProperty(General_Prop_Level)
    local iLvlB = generalB:GetProperty(General_Prop_Level)
    local ret = iLvlA > iLvlB
    if iLvlA == iLvlB then
        local iQuelityA = generalA:GetStaticProperty(General_StaticProp_Beginquelity)
        local iQuelityB = generalB:GetStaticProperty(General_StaticProp_Beginquelity)
        ret = iQuelityA > iQuelityB
        if iQuelityA == iQuelityB then
            local iFCA = generalA:GetProperty(General_Prop_FC)
            local iFCB = generalB:GetProperty(General_Prop_FC)
            ret = iFCA > iFCB
            if iFCA == iFCB then
                local iStarA = generalA:GetProperty(General_StaticProp_Beginstar)
                local iStarB = generalB:GetProperty(General_StaticProp_Beginstar)
                ret = iStarA > iStarB
            end
        end
    end
    if self.iSortOrder == 0 then
        return ret
    else 
        return not ret
    end
end

function CampUI:SortFunc_3(generalA,generalB)
    local iFCA = generalA:GetProperty(General_Prop_FC)
    local iFCB = generalB:GetProperty(General_Prop_FC)
    local ret = iFCA > iFCB
    if iFCA == iFCB then
        local iQuelityA = generalA:GetStaticProperty(General_StaticProp_Beginquelity)
        local iQuelityB = generalB:GetStaticProperty(General_StaticProp_Beginquelity)
        ret = iQuelityA > iQuelityB
        if iQuelityA == iQuelityB then
            local iLvlA = generalA:GetProperty(General_Prop_Level)
            local iLvlB = generalB:GetProperty(General_Prop_Level)
            ret = iLvlA > iLvlB
            if iLvlA == iLvlB then
                local iStarA = generalA:GetProperty(General_StaticProp_Beginstar)
                local iStarB = generalB:GetProperty(General_StaticProp_Beginstar)
                ret = iStarA > iStarB
            end
        end
    end
    if self.iSortOrder == 0 then
        return ret
    else 
        return not ret
    end
end

function CampUI:ShowGeneral(baseId)
    for k,v in pairs(self.dataList) do
        for j,u in pairs(v) do
            if u.v ~= nil and u.v == baseId then
                self:getParent():showFloat(luaFile.GeneralUI,{data = self.dataList,index = {cell = k,row = j}})
                self:setVisible(false)
            end
        end
    end
end

function CampUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_CampUI_Show_General" then
        self:ShowGeneral(body.baseId)
        return
    elseif notifyName == "Notifty_CampUI_Show" then
        self:setVisible(body.visible)
        self.isShowing = not body.visible
    elseif notifyName == "Notifty_General_Delete" then
        self:ShowListView()
        for k,v in pairs(self.dataList) do
            for j,u in pairs(v) do
                if u.v ~= nil and u.v == baseId then
                    Notifier.postNotifty("Notifty_GeneralUI_Brush",{data = self.dataList,index = {cell = k,row = j}})
                end
            end
        end
    elseif notifyName == "Notifty_General_Update" then
        self.myListview:setData(self.dataList)
    end
end
--------------------------------------------------------------------------------------------------------------------
return CampUI