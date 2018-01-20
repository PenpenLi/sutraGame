--页面控制器(注册通知)
LayerManager = {}



LayerManager.gameScene = nil
LayerManager.rootLayer = {layer=nil, z=0}

LayerManager.gameLayer = {layer=nil, z=0}--游戏页面层
LayerManager.dialogLayer = {layer=nil, z=16}--对话框层
LayerManager.tipsLayer = {layer=nil, z=16}--tips层
LayerManager.touchMaskLayer = {layer=nil, z=1028}--用于屏蔽屏幕触摸事件的层

local ctrlInfo = {layer = nil, moudle = "", name = "", param = {}}
LayerManager.gameLayerControl = DeepCopy(ctrlInfo)--游戏页面层info(当前只能显示一个)



local game_layer
local layer1_bg
local layer2_panel
local layer2_noraml_panel
local layer3_float_panel
local layer4_dialog
local layer4_guide_layer
local layer6_sys_dialog
local layer7_pointer
local layer8_debug
       

--初始化
function LayerManager.init(game_scene)
    LayerManager.gameScene = game_scene
    
    local rootLayer = cocosMake.newLayer()
    rootLayer:setAnchorPoint(cc.p(0,0))
    rootLayer:setPosition(0,0)
    game_scene:addChild(rootLayer, LayerManager.rootLayer.z)
    LayerManager.rootLayer.layer = rootLayer

    local gameLayer = cocosMake.newLayer()
    gameLayer:setAnchorPoint(cc.p(0,0))
    gameLayer:setPosition(0,0)
    rootLayer:addChild(gameLayer, LayerManager.gameLayer.z)
    LayerManager.gameLayer.layer = gameLayer

    
    local dialogLayer = cocosMake.newLayer()
    dialogLayer:setAnchorPoint(cc.p(0,0))
    dialogLayer:setPosition(0,0)
    rootLayer:addChild(dialogLayer, LayerManager.dialogLayer.z)
    LayerManager.dialogLayer.layer = dialogLayer
	
	local tipsLayer = cocosMake.newLayer()
    tipsLayer:setAnchorPoint(cc.p(0,0))
    tipsLayer:setPosition(0,0)
    rootLayer:addChild(tipsLayer, LayerManager.tipsLayer.z)
    LayerManager.tipsLayer.layer = tipsLayer

    --layer1_bg = CCLayer:create()
    --layer2_noraml_panel = CCLayer:create()
    --layer3_float_panel = CCLayer:create()
    --layer4_dialog = CCLayer:create()
    --layer4_guide_layer = CCLayer:create()
    
    --layer6_sys_dialog = CCLayer:create()
    --layer7_pointer = CCLayer:create()
    --layer8_debug = CCLayer:create()
end

function LayerManager.getRootLayer()
    return LayerManager.rootLayer.layer
end

--设置是否屏蔽触摸事件
function LayerManager.setTouchEnable(enable)
    if not enable then
        if not LayerManager.touchMaskLayer.layer then
            local touchMaskLayer = cocosMake.newLayer()
            touchMaskLayer:setAnchorPoint(cc.p(0,0))
            touchMaskLayer:setPosition(0,0)
            rootLayer:addChild(LayerManager.rootLayer, LayerManager.touchMaskLayer.z)
            LayerManager.touchMaskLayer.layer = touchMaskLayer

            local eventDispacher =touchMaskLayer:getEventDispatcher()
            -- var:setTouchEnabled(true)
		    local listener = cc.EventListenerTouchOneByOne:create()
            listener:setSwallowTouches(true)	    
	        eventDispacher:addEventListenerWithSceneGraphPriority(listener,touchMaskLayer)
        end
    else
        if LayerManager.touchMaskLayer.layer then
           LayerManager.touchMaskLayer.layer:removeFromParent(true)
           LayerManager.touchMaskLayer.layer = nil
        end
    end
end

--創建页面（外部調用不受LayerManager管理）
local function createNewPanel(targetName, param, moud)
    local moudle = moud or "layer" 
    local status, view = xpcall(function()
            return require(targetName)
        end, function(msg)
        --if not string.find(msg, string.format("'%s' not found:", packageName)) then
        --    print("load view error: ", msg)
        --end
    end)
    local t = type(view)
    if status and (t == "table" or t == "userdata") then
        view = view:create(param)
        Notifier.addObserver( view )--添加通知
        
        return view
    end
end
LayerManager.createNewPanel = createNewPanel

local function showNormalPanel(targetPanelName, param, moudle)
    print("targetPanelName: " .. targetPanelName)
    --缓存回收
    local function purgeCache()
    --[[
        --图片缓存回收
        if mem_purge_manual_panels[targetPanelName] then
            cclog("手工收回内存 -> "..targetPanelName)
        else
            --收回所有未使用的图片，明确在配置中申明需要缓存的UI文件，不会被回收
            CacheManager.purge()
        end
        --]]
    end
    
    
       
    --清除原始层
    if LayerManager.gameLayerControl.layer then
        --清除浮层
        if LayerManager.gameLayerControl.layer.floatPanelControl_ then
            for k, v in pairs(LayerManager.gameLayerControl.layer.floatPanelControl_) do
                LayerManager.closeFloat(v, LayerManager.gameLayerControl.layer)
            end
         end

        LayerManager.gameLayerControl.layer:onClose()
        Notifier.removeObserver( LayerManager.gameLayerControl.layer )

        LayerManager.gameLayerControl.layer:removeFromParent(true)
        LayerManager.gameLayerControl.layer = nil
        LayerManager.gameLayerControl.moudle = ""
        LayerManager.gameLayerControl.name = ""
        LayerManager.gameLayerControl.param = {}
    end    

    param = param or {}    
    LayerManager.gameLayerControl.layer = createNewPanel(targetPanelName, param, moudle)
    if LayerManager.gameLayerControl.layer then
        LayerManager.gameLayerControl.moudle = moudle
        LayerManager.gameLayerControl.name = name
        LayerManager.gameLayerControl.param = param
        LayerManager.gameLayerControl.layer.floatPanelControl_ = {}--每个Panel都有浮层
        LayerManager.gameLayer.layer:addChild(LayerManager.gameLayerControl.layer)
        
        local resObj = LayerManager.gameLayerControl.layer:onCreate(param)--OnCreate是完成构造添加通知监听之后的响应函数,ctor一般用于类之间继承中类的构造函数使用
    else
        error( "create panel \"" .. moudle .. "." .. targetPanelName .. "\" error!!!!!" )
    end

    return LayerManager.gameLayerControl.layer
end


local function showFloatPanel(targetPanelName, parentLayer, param, moudle)
    param = param or {}  
    local panelInfo = DeepCopy(ctrlInfo)

    panelInfo.layer = createNewPanel(targetPanelName, param, moudle)
    if panelInfo.layer then
        panelInfo.moudle = moudle
        panelInfo.name = targetPanelName
        panelInfo.param = param

        parentLayer:addChild(panelInfo.layer)
        parentLayer.floatPanelControl_ = parentLayer.floatPanelControl_ or {}
        parentLayer.floatPanelControl_[targetPanelName] = panelInfo
        local resObj = panelInfo.layer:onCreate(param)
        
    else
        error( "create float panel \"" .. moudle .. "." .. targetPanelName .. "\" error!!!!!" )
    end

    return panelInfo.layer
end

local function closeFloatPanel(panelName, parentLayer)
    local panel = parentLayer.floatPanelControl_[panelName.name].layer
    if not panel then
        return
    end

   if panel then
        if panel.floatPanelControl_ then
            for k,v in pairs(panel.floatPanelControl_) do
                LayerManager.closeFloat(v, panel)
            end
        end
        if panel.onClose then panel:onClose() end
        Notifier.removeObserver( panel )--删除通知
        panel:removeFromParent(true)

        parentLayer.floatPanelControl_[panelName.name] = nil
   end
end

--显示panel
function LayerManager.show(panel_name,param)
    return showNormalPanel(panel_name, param, "")
end

--显示浮层panel
function LayerManager.showFloat(panel_name,parentLayer, param)
    return showFloatPanel(panel_name, parentLayer, param, "layer")
end
function LayerManager.closeFloat(floatPanel, parentLayer)
    closeFloatPanel(floatPanel, parentLayer)
end


function LayerManager.showDialog()
	
end

--显示系统级对话框
function LayerManager.showSysDialog(msg)
	
end

--显示退出游戏确认对话框
function LayerManager.showExitDialog()
	
end

function LayerManager.showWaiting(msg,isShowMsgImmediately)
--[[
    if _WaitingUIPanel then
        LayerManager.hideWaiting()
    end

    _WaitingUIPanel = WaitingUIPanel:New()
    _WaitingUIPanel:Create({msg=msg,isShowMsgImmediately=isShowMsgImmediately})
    _WaitingUIPanel:Show()
    _WaitingUIPanel:StartTimer()--取消30秒倒计时
    game_layer:addChild(_WaitingUIPanel.panel.layer,1023)
--]]
end


function LayerManager.hideWaiting()
end

--刷新当前页面
function LayerManager.refreshCurrentPanel()

    cclog("LayerManager.refreshCurrentPanel()")
    
    --更新音乐状态,主要是为了处理ios锁屏导致网络中断，然后重连成功，音乐被恢复的问题
    --if isNotPlaySound() then
    --    StopBGMusic()
    --end
    
    --例外情况
    --1.当前页面是战斗页，不刷新
    
    local moudle = LayerManager.gameLayerControl.moudle
    local name = LayerManager.gameLayerControl.name
    local param = DeepCopy(LayerManager.gameLayerControl.param)
    LayerManager.show(name, moudle, param)
end

function LayerManager.showTips(tipsString)
	local view = new_class(luaFile.tipsView, {text=tipsString})
	LayerManager.tipsLayer.layer:addChild(view)
end