local MapUI = class("MapUI", cocosMake.viewBase)

--规范
MapUI.ui_resource_file = {"mapUI_VS"}--cocos studio生成的csb
MapUI.CopyNodeRes = "csb/mapnode.csb"
MapUI.ui_binding_file = {--控件绑定
    btn_esc = {name="mapUI_VS.btn_esc",event="touch",method="OnEscClick"}
}

MapUI.notify = {}--通知

function MapUI:onCreate()
    print("MapUI:onCreate")
    self.sceneId = 170001
    self:__initShow()
end

function MapUI:onClose()
    print("MapUI:onClose")
end

function MapUI:__initShow()
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(-1)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)

    self.stCopyData = {}
    self.stCopyData = DataManager.getCopyStaticDataBySceneID(self.sceneId)
    for k,v in pairs(self.stCopyData) do
        local node = self:__getCopyNode(v)
        node:setTag(k)
        self:addChild(node)
    end
end

function MapUI:__getCopyNode(data)
    local mgr = DataModeManager:getTollGateDataMgr()
    local copyData = mgr:getData({sceneId = self.sceneId,copyId = data.id})
    local node = cc.CSLoader:createNode(self.CopyNodeRes)
    local pos = string.split(data.mapPlace,"_")
    node:setPosition(cc.p(pos[1],pos[2]))
    if copyData == nil then
        node:getChildByName("lock"):setVisible(true)
        node:getChildByName("info"):setVisible(false)
        node:getChildByName("img"):setEnabled(false)
        node:getChildByName("name_1"):setVisible(true)
        node:getChildByName("name_2"):setVisible(false)
    else
        node:getChildByName("lock"):setVisible(false)
        node:getChildByName("info"):setVisible(true)
        node:getChildByName("img"):onTouch(handler(self,self.OnTollGateClick))
        local copyStarInfo = copyData.star.."/"..data.allStar
        node:getChildByName("info"):getChildByName("txt"):setString(copyStarInfo)
        node:getChildByName("name_1"):setVisible(false)
        node:getChildByName("name_2"):setVisible(true)
    end
    node:getChildByName("name_1"):setTexture(COPY_MAPRES_UIPATH.."/"..data.iconId.."_1.png")
    node:getChildByName("name_2"):setTexture(COPY_MAPRES_UIPATH.."/"..data.iconId.."_2.png")
    node:getChildByName("img"):ignoreContentAdaptWithSize(true)
    node:getChildByName("img"):loadTexture(COPY_MAPRES_UIPATH.."/"..data.iconId.."_3.png")
    return node
end

function MapUI:OnEscClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MapUI:OnEscClick")
        self:getParent():closeFloat({name = luaFile.MapUI})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MapUI:OnTollGateClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MapUI:OnEscClick")
        local iTag = event.target:getParent():getTag()
        local copyId = self.stCopyData[iTag].id
        self:getParent():showFloat(luaFile.TollgateUI,{sceneId = self.sceneId,copyId = copyId})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MapUI:handleNotification(notifyName, body)
end
--------------------------------------------------------------------------------------------------------------------
return MapUI

