local ItemPackageUI = class("ItemPackageUI", cocosMake.viewBase)

--规范
ItemPackageUI.ui_resource_file = {"packageUI_itemVS"}--cocos studio生成的csb
ItemPackageUI.ListViewCellSize = { width = 469,height = 95}
ItemPackageUI.Res_CSB = "csb/iteminfo.csb"
ItemPackageUI.Res_1 = "common/label/lb_w42_5.png"
ItemPackageUI.Res_2 = "common/label/lb_w42_6.png"
ItemPackageUI.CELL_TAG = 100
ItemPackageUI.ui_binding_file = {--控件绑定
    box = {name="packageUI_itemVS.box"},
    img_item = {name="packageUI_itemVS.img"},
    lb_size = {name="packageUI_itemVS.lb_size"},
    lb_name = {name="packageUI_itemVS.lb_name"},
    lb_des = {name="packageUI_itemVS.lb_des"},
    lb_num = {name="packageUI_itemVS.lb_num"},
    panel = {name="packageUI_itemVS.bg.panel"},
    btn_add = {name="packageUI_itemVS.btn_add",event="touch",method="OnClick"},
    btn_showuse = {name="packageUI_itemVS.btn_use",event="touch",method="OnShowUseClick"},
    btn_showbtchsell = {name="packageUI_itemVS.btn_sell",event="touch",method="OnShowBatchSellClick"},
    btn_showsell = {name="packageUI_itemVS.btn_sell_0",event="touch",method="OnShowSellClick"},
    btn_esc = {name="packageUI_itemVS.btn_esc",event="touch",method="OnEscClick"},
    --------------------------------------pn_num
    pn_use_num = {name="packageUI_itemVS.panel_use.pn_num"},
    btn_right = {name="packageUI_itemVS.panel_use.pn_num.btn_right",event="touch",method="OnRightClick"},
    btn_left = {name="packageUI_itemVS.panel_use.pn_num.btn_left",event="touch",method="OnLeftClick"},
    lb_usenum = {name="packageUI_itemVS.panel_use.pn_num.num"},
    --------------------------------------panel_use
    panel_use= {name="packageUI_itemVS.panel_use"},
    btn_use = {name="packageUI_itemVS.panel_use.btn_use",event="touch",method="OnUseClick"},
    btn_use_hide = {name="packageUI_itemVS.panel_use.btn_hide",event="touch",method="OnUseHideClick"},
    lb_usedes = {name="packageUI_itemVS.panel_use.lb_des"},
    box_pu = {name="packageUI_itemVS.panel_use.box"},
    img_pu = {name="packageUI_itemVS.panel_use.img"},
    lb_usename = {name="packageUI_itemVS.panel_use.lb_name"},
    --------------------------------------panel_sell
    panel_sell = {name="packageUI_itemVS.panel_sell"},
    lb_silver = {name="packageUI_itemVS.panel_sell.lb_silver"},
    btn_sure = {name="packageUI_itemVS.panel_sell.btn_sure",event="touch",method="OnSureClick"},
    btn_cancle = {name="packageUI_itemVS.panel_sell.btn_cancel",event="touch",method="OnCancelClick"},
    --------------------------------------panel_sell_1
    panel_sell_1 = {name="packageUI_itemVS.panel_sell_1"},
    lb_sellName = {name="packageUI_itemVS.panel_sell_1.lb_name"},
    lb_sellsilver = {name="packageUI_itemVS.panel_sell_1.lb_silver"},
    box_sell = {name="packageUI_itemVS.panel_sell_1.box"},
    img_sell = {name="packageUI_itemVS.panel_sell_1.img"},
    panel_sell_num = {name="packageUI_itemVS.panel_sell_1.pn_num"},
    btn_sell_right = {name="packageUI_itemVS.panel_sell_1.pn_num.btn_right",event="touch",method="OnSellRightClick"},
    btn_sell_left = {name="packageUI_itemVS.panel_sell_1.pn_num.btn_left",event="touch",method="OnSellLeftClick"},
    lb_sell_num = {name="packageUI_itemVS.panel_sell_1.pn_num.num"},
    btn_sell = {name="packageUI_itemVS.panel_sell_1.btn_sell",event="touch",method="OnSellClick"},
    btn_sell_hide = {name="packageUI_itemVS.panel_sell_1.btn_hide",event="touch",method="OnSellHideClick"}
}

ItemPackageUI.notify = {"Notifty_Actor_Create","Notifty_Actor_Set_Prop"}--通知

ItemPackageUI.btnJZClickCallFuc = {}

function ItemPackageUI:onCreate()
    print("ItemPackageUI:onCreate")
    self:__initShow()
end

function ItemPackageUI:onClose()
    print("ItemPackageUI:onClose")
end

function ItemPackageUI:__initShow()
    self.colorLayer = cocosMake.newLayerColor()
    self:addChild(self.colorLayer)
    self.colorLayer:setLocalZOrder(-1)
    self.colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    self.colorLayer:setTouchEnabled(true)
    self.cell = -1
    self.row = -1
    self.itemId = -1
    self.useNum = 1
    self.selectItem = {}
    self.selling = false
    self.holdClear = false
    self:ShowListView()
    self:BrushPackageSize()
end

function ItemPackageUI:BrushPackageSize()
    local actor = DataModeManager:getActor()
    local part = actor:GetPart(Actor_Part_Item)
    local isize = part:getSize()
    local icount = part:getModeCount()
    self.lb_size:setString(icount.."/"..isize)
end

function ItemPackageUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnEscClick")
        self:getParent():closeFloat({name = luaFile.ItemPackageUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnClick")
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnSureClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnSureClick")
        self.sellNum = #(self.selectItem)
        self.soldNum = 0
        if self.sellNum <=0 then
            return
        end
        self.colorLayer:setLocalZOrder(1)
        if self:containItem(self.itemId) == true then
            self.holdClear = true
        end
        for k,v in pairs(self.selectItem) do
            local pack = networkManager.createPack("sell_c")
            pack.thisid = v.v
            pack.num = v.n
	        networkManager.sendPack(pack,handler(self,self.BatchSellCallBack),true,0)
        end
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnCancelClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnCancelClick")
        self.panel_sell:setVisible(false)
        self.btn_showbtchsell:setVisible(true)
        self.selectItem = {}
        self.myListview:setData(self.dataList)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnShowBatchSellClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnShowBatchSellClick")
        self.holdClear = false
        self.selectItem = {}
        self.lb_silver:setString("0")
        self.panel_sell:setVisible(true)
        self.panel_sell_1:setVisible(false)
        self.panel_use:setVisible(false)
        self.selling = true
        event.target:setVisible(false)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnSellHideClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnSellHideClick")
        self.panel_sell_1:setVisible(false)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnShowSellClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnSellClick")
        if self.itemId == -1 then 
            self.panel_sell_1:setVisible(false)
            return
        end 
        self.selling = false
        self.panel_use:setVisible(false)
        self.panel_sell:setVisible(false)
        self.btn_showbtchsell:setVisible(true)
        if self.selectItem  ~= nil and #(self.selectItem)>0 then 
            self.selectItem = {}
            self.myListview:setData(self.dataList)
        end
        local item = DataModeManager:getItemData(self.itemId)
        local iHoldNum = item:GetProperty(Item_Prop_Num)
        self.sellNum = iHoldNum
        self:SellbrushNum()
        self.panel_sell_1:setVisible(not self.panel_sell_1:isVisible())
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnSellClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnSellClick")
        if self.itemId == -1 then 
            self.panel_sell_1:setVisible(false)
            return
        end 
        self.colorLayer:setLocalZOrder(1)
        local item = DataModeManager:getItemData(self.itemId)
        local iHoldNum = item:GetProperty(Item_Prop_Num)
        if self.sellNum >= iHoldNum then
            self.holdClear = true
        end
        local pack = networkManager.createPack("sell_c")
        pack.thisid = self.itemId
        pack.num = self.sellNum
	    networkManager.sendPack(pack,handler(self,self.SellCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:SellCallBack(obj)
    self.colorLayer:setLocalZOrder(-1)
    if self.holdClear == true then
        self.holdClear = false
        self.itemId = -1
        self.panel_use:setVisible(false)
        self.panel_sell:setVisible(false)
        self.btn_showbtchsell:setVisible(true)
        self.panel_sell_1:setVisible(false)
        
    end
    self:showItem()
    self.selectItem = {}
    self:ShowListView()
    self:BrushPackageSize()
end

function ItemPackageUI:BatchSellCallBack(obj)
    self.soldNum = self.soldNum + 1
    if self.soldNum >= self.sellNum then
        self.colorLayer:setLocalZOrder(-1)
        self.selectItem = {}
        self:ShowListView()
        self:BrushPackageSize()
    end
end

function ItemPackageUI:OnUseHideClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnUseHideClick")
        self.panel_use:setVisible(false)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnShowUseClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnShowUseClick")
        if self.itemId == -1 then 
            self.panel_use:setVisible(false)
            return
        end
        self.selling = false
        self.panel_sell_1:setVisible(false)
        self.panel_sell:setVisible(false)
        self.btn_showbtchsell:setVisible(true)
        if self.selectItem  ~= nil and #(self.selectItem)>0 then 
            self.selectItem = {}
            self.myListview:setData(self.dataList)
        end
        self.useNum = 1
        self:brushNum()
        self.panel_use:setVisible(not self.panel_use:isVisible())
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnUseClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnUseClick")
        if self.itemId == -1 then 
            self.panel_use:setVisible(false)
            return
        end
        self.colorLayer:setLocalZOrder(1)
        local pack = networkManager.createPack("onUse_c")
        pack.thisid = self.itemId
	    pack.num = self.useNum
	    networkManager.sendPack(pack,handler(self,self.onUseCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:onUseCallBack(obj)
    self.colorLayer:setLocalZOrder(-1)
    if self.holdClear == true then
        self.holdClear = false
        self.itemId = -1
        self.panel_sell:setVisible(false)
        self.btn_showbtchsell:setVisible(true)
        self.panel_sell_1:setVisible(false)
    end
    self.panel_use:setVisible(false)
    self:showItem()
    self.selectItem = {}
    self:ShowListView()
    self:BrushPackageSize()
end

function ItemPackageUI:OnSellLeftClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnSellLeftClick")
        if self.sellNum <= 0 then
            return
        end
        if self.itemId == -1 then return end
        if self.sellNum == 1 then
            local item = DataModeManager:getItemData(self.itemId)
            local iHoldNum = item:GetProperty(Item_Prop_Num)
            self.sellNum = iHoldNum
        else
            self.sellNum = self.sellNum - 1
        end
        self:SellbrushNum()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnSellRightClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnSellRightClick")
        if self.sellNum <= 0 then
            return
        end
        if self.itemId == -1 then return end
        local item = DataModeManager:getItemData(self.itemId)
        local iHoldNum = item:GetProperty(Item_Prop_Num)
        if self.sellNum == iHoldNum then
            self.sellNum = 1
        else
            self.sellNum = self.sellNum + 1
        end
        self:SellbrushNum()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:SellbrushNum()
    if self.itemId == -1 then return end
    local item = DataModeManager:getItemData(self.itemId)
    local iHoldNum = item:GetProperty(Item_Prop_Num)
    local price = item:GetStaticProperty(Item_StaticProp_Saleprice)
    if self.sellNum <= 1 then
        self.btn_sell_left:getChildByName("tag"):setTexture(self.Res_2)
    else
        self.btn_sell_left:getChildByName("tag"):setTexture(self.Res_1)
    end
    self.lb_sell_num:setString(self.sellNum.."/"..iHoldNum)
    self.lb_sellsilver:setString(self.sellNum * price.."")
end

function ItemPackageUI:OnLeftClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnLeftClick")
        if self.useNum <= 0 then
            return
        end
        if self.itemId == -1 then return end
        if self.useNum == 1 then
            local item = DataModeManager:getItemData(self.itemId)
            local iHoldNum = item:GetProperty(Item_Prop_Num)
            self.useNum = iHoldNum
        else
            self.useNum = self.useNum - 1
        end
        self:brushNum()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnRightClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("ItemPackageUI:OnRightClick")
        if self.useNum <= 0 then
            return
        end
        if self.itemId == -1 then return end
        local item = DataModeManager:getItemData(self.itemId)
        local iHoldNum = item:GetProperty(Item_Prop_Num)
        if self.useNum == 10 or self.useNum == iHoldNum then
            self.useNum = 1
        else
            self.useNum = self.useNum + 1
        end
        self:brushNum()
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:brushNum()
    if self.itemId == -1 then return end
    local item = DataModeManager:getItemData(self.itemId)
    local iHoldNum = item:GetProperty(Item_Prop_Num)
    if self.useNum <= 1 then
        self.btn_left:getChildByName("tag"):setTexture(self.Res_2)
    else
        self.btn_left:getChildByName("tag"):setTexture(self.Res_1)
    end
    self.lb_usenum:setString(self.useNum.."/"..iHoldNum)
end

function ItemPackageUI:containItem(itemId)
    for _,v in pairs(self.selectItem) do
        if v.v ~= nil and v.v == itemId then
            return true
        end
    end
    return false
end

function ItemPackageUI:showItem()
    local item = DataModeManager:getItemData(self.itemId)
    if self.itemId == -1 or item == nil then 
        self.lb_name:setString("")
        self.lb_usename:setString("")
        self.lb_sellName:setString("")

        self.lb_des:setString("")
        self.lb_usedes:setString("")
        self.box:setTexture("common/label/lb_w104_1.png")
        self.box_pu:setTexture("common/label/lb_w104_1.png")
        self.box_sell:setTexture("common/label/lb_w104_1.png")
        
        self.lb_num:setString("")
        return
    end
    self.useNum = 1
    local str = item:GetStaticProperty(Item_StaticProp_Name)
    self.lb_name:setString(str)
    self.lb_usename:setString(str)
    self.lb_sellName:setString(str)
    str = item:GetStaticProperty(Item_StaticProp_Effectinstruction)
    self.lb_des:setString(str)
    self.lb_usedes:setString(str)
    local iNum = item:GetStaticProperty(Item_StaticProp_Quality)
    self.box:setTexture("common/label/lb_w104_"..iNum..".png")
    self.box_pu:setTexture("common/label/lb_w104_"..iNum..".png")
    self.box_sell:setTexture("common/label/lb_w104_"..iNum..".png")
    iNum = item:GetProperty(Item_Prop_Num)
    self.lb_num:setString(iNum.."")
    self.useNum = 1
    self:brushNum()
end

function ItemPackageUI:countSilver()
    local iCount = 0
    for k,v in pairs(self.selectItem) do
        iCount = iCount + v.s
    end
    return iCount
end

function ItemPackageUI:ShowListView()
    print("ItemPackageUI:ShowListView()")
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
    local panelPos = cc.p(0,0)
    self.myListview = ListView1:create({size = cc.size(469.00,428.00),
                                        pos = panelPos,
                                        spacing = 106,
                                        direction = ListView1.V, 
                                        createItem = createItemFunc, 
                                        udateItem = udateItemFunc, 
                                        clickItem = clickItemFunc,
                                        hightlightItem = hightlightItemFunc,
                                        unhightlightItem = unhightlightItemFunc})
    self.panel:addChild(self.myListview)

    self.myListview:setData(self.dataList)
    self.panel_clickhelper = self:buildClickHelper()
    self.panel:addChild(self.panel_clickhelper)
end

function ItemPackageUI:buildClickHelper()
    local layout = ccui.Layout:create()
    layout:setContentSize(cc.size(469.00,428.00))
    local pos = cc.p(0,0)
    layout:setPosition(pos.x,pos.y)
    layout:setTouchEnabled(true)
    layout:setSwallowTouches(false)
    return layout
end

function ItemPackageUI:OnHightLightItem(item,index)
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
            node = node:getChildByName("bg")
            if node == nil then return end
            local temppoint = node:convertToNodeSpace(point)
            local size = node:getContentSize()
            local cellRect = cc.rect(0,0,size.width,size.height)
            if cc.rectContainsPoint(cellRect,temppoint) then
                self.panel_use:setVisible(false)
                self.panel_sell_1:setVisible(false)
                self.cellClickItem = v
                v:setColor(cc.c3b(166,166,166))
                return
            end
        end
    end
end

function ItemPackageUI:OnUnHightLightItem(item,index)
    if self.cellClickItem ~= nil then
        self.cellClickItem:setColor(cc.c3b(255,255,255))
    end
end

function ItemPackageUI:OnClickItem(item,index)
    if self.isUping == true then
        return
    end
    if self.cellClickItem == nil then
        return
    end
    local point = self.panel_clickhelper:getTouchEndPosition()
    local node = self.cellClickItem:getChildByName("bg")
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
    local itemId = self.dataList[index][itag].v
    if itemId == -1 then return end
    local item = DataModeManager:getItemData(itemId)
    if item == nil then return end
    if self.selling == false then
        self.itemId = itemId
        self:showItem()
    else
        node = self.cellClickItem:getChildByName("tag")
        local iNum = item:GetProperty(Item_Prop_Num)
        local iPrice = item:GetStaticProperty(Item_StaticProp_Saleprice)
        local tlist = {}
        tlist.v = itemId
        tlist.s = iNum*iPrice
        tlist.n = iNum
        if node:isVisible() == false then
            table.insert(self.selectItem,tlist)
        else
            local pos = 0
            for k,v in pairs(self.selectItem) do
                if v.v ~= nil and v.v == itemId then
                    pos = k
                end
            end
            if pos ~= 0 then
                table.remove(self.selectItem,pos)
            end
        end
        node:setVisible(not node:isVisible())
        self.lb_silver:setString(self:countSilver().."")
    end
    print("OnClickItem ItemPackageUI :"..item:GetStaticProperty(Item_StaticProp_Name))
end

function ItemPackageUI:__ValidListData()
    print("_____________________________________________ValidListData")
    local actor = DataModeManager:getActor()
    local part = actor:GetPart(Actor_Part_Item)
    local itemList = part:getAllMode()
    local tlist = {}
    for _,v in pairs(itemList) do
        local item = DataModeManager:getItemData(v)
        local iLen = #tlist
        local sortId = tonumber(item:GetStaticProperty(Item_StaticProp_Order))
        tlist[iLen+1] = {}
        tlist[iLen+1] = {v = v,sortId = sortId}
    end
    table.sort(tlist,handler(self,self.SortFunc))
    local tRetlist={}
    local itag = 1
    local irow = 1
    local iLen = table.getn(tlist)
    local iNum = part:getSize()
    if iLen < iNum then iLen = iNum end
    tRetlist[1] = {}
    local iMaxRow = 4
    for i = 1,iLen do
        if itag > iMaxRow then 
            itag = 1 
            irow = irow + 1
            tRetlist[irow] = {}
        end
        local item = tlist[i]
        tRetlist[irow][itag] = item or {v = -1,sortId = 0}
        itag = itag + 1
    end
    return tRetlist
end

function ItemPackageUI:UpdateCell(cell,index)
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
        node:setPosition(108*(i-1)+70,47.5)
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


function ItemPackageUI:CreateListCell(index)
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
        node:setPosition(108*(i-1)+70,47.5)
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

function ItemPackageUI:__UpdateListItem(node,param)
    local info = node:getChildByName("info")
    local tag = node:getChildByName("tag")
    if param.v == -1 then
        info:setVisible(false)
        tag:setVisible(false)
        return
    end
    info:setVisible(true)
    tag:setVisible(self.selling and self:containItem(param.v))
    local item = DataModeManager:getItemData(param.v)
    local box = info:getChildByName("box")
    local img = info:getChildByName("img")
    local num = info:getChildByName("num")
    
    local iNum = item:GetProperty(Item_Prop_Num)
    num:setString(iNum.."")
    iNum = item:GetStaticProperty(Item_StaticProp_Quality)
    box:setTexture("common/label/lb_w104_"..iNum..".png")
end

function ItemPackageUI:__GetListItem()
    local node = cc.CSLoader:createNode(self.Res_CSB)
    return node
end

function ItemPackageUI:SortFunc(itemA,itemB)
    return itemA.sortId > itemB.sortId
end

function ItemPackageUI:handleNotification(notifyName, body)
end
--------------------------------------------------------------------------------------------------------------------
return ItemPackageUI

