--页面控制器(注册通知)
LayerManager = {}


LayerManager.gameScene = nil
LayerManager.rootLayer = {layer=nil, z=0}

LayerManager.gameLayer = {layer=nil, z=0}--游戏页面层
LayerManager.dialogLayer = {layer=nil, z=16}--对话框层
LayerManager.tipLayer = {layer=nil, z=32}--游戏提示层
LayerManager.networkTLayer = {layer=nil, z=64}--网络提示层
LayerManager.touchMaskLayer = {layer=nil, z=1028}--用于屏蔽屏幕触摸事件的层
LayerManager.debugLayer = {layer=nil, z=1029}

local ctrlInfo = {layer = nil, moudle = "", name = "", param = {}}
LayerManager.gameLayerControl = DeepCopy(ctrlInfo)--游戏页面层info(当前只能显示一个)

local layerIds = 0

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
       
	   

function LayerManager.getRootLayer()
    return LayerManager.rootLayer.layer
end

--设置是否屏蔽触摸事件
function LayerManager.setTouchEnable(enable)
	
	if not LayerManager.touchMaskLayer.layer then
		local touchMaskLayer = cocosMake.newLayer()
		touchMaskLayer:setAnchorPoint(cc.p(0,0))
		touchMaskLayer:setPosition(0,0)
		LayerManager.rootLayer.layer:addChild(touchMaskLayer, LayerManager.touchMaskLayer.z)
		LayerManager.touchMaskLayer.layer = touchMaskLayer
	end
	
	if not enable then
		if LayerManager.touchMaskLayer.listener then
			local eventDispacher = LayerManager.touchMaskLayer.layer:getEventDispatcher()
			eventDispacher:removeEventListener(LayerManager.touchMaskLayer.listener)
			LayerManager.touchMaskLayer.listener = nil
		end
	else
		if LayerManager.touchMaskLayer.listener then
			return true
		end
		local function onTouchBegan(touch, event)
			return true
		end
		local listener = cc.EventListenerTouchOneByOne:create()
		listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
		listener:setSwallowTouches(true)
		LayerManager.touchMaskLayer.listener = listener
		local eventDispacher = LayerManager.touchMaskLayer.layer:getEventDispatcher()
		eventDispacher:addEventListenerWithSceneGraphPriority(listener,LayerManager.touchMaskLayer.layer)
	end
	
end

--創建页面（外部調用不受LayerManager管理）
local function createNewPanel(targetName, param, moud)
	
	local panel = new_class(targetName, param)
	layerIds = layerIds + 1
	panel._serialID = layerIds
	
	return panel
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
                LayerManager.closeFloat(v.layer, LayerManager.gameLayerControl.layer)
            end
         end

        if LayerManager.gameLayerControl.layer.onClose then LayerManager.gameLayerControl.layer:onClose() end
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
        
		Notifier.addObserver( LayerManager.gameLayerControl.layer )--添加通知
		if LayerManager.gameLayerControl.layer.onCreate then LayerManager.gameLayerControl.layer:onCreate(param) end--OnCreate是完成构造添加通知监听之后的响应函数,ctor一般用于类之间继承中类的构造函数使用
    else
        error( "create panel \"" .. targetPanelName .. "\" error!!!!!" )
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
        table.insert(parentLayer.floatPanelControl_, panelInfo)
        local resObj = panelInfo.layer:onCreate(param)
        
    else
        error( "create float panel \"" .. moudle .. "." .. targetPanelName .. "\" error!!!!!" )
    end

    return panelInfo.layer
end

local function closeFloatPanel(layer, parent)
	local panel = nil
	local removeKey = nil
	for k,v in pairs(parent.floatPanelControl_) do
		if v.layer._serialID == layer._serialID then
			panel = v.layer
			removeKey = k
			break
		end
	end
    
	if not panel then
		return 
	end

	if panel.floatPanelControl_ then
		for k,v in pairs(panel.floatPanelControl_) do
			LayerManager.closeFloat(v, panel)
		end
	end
	if panel.onClose then panel:onClose() end
	Notifier.removeObserver( panel )--删除通知
	panel:removeFromParent(true)

	parent.floatPanelControl_[removeKey] = nil
end

--显示panel
function LayerManager.show(panel_name,param)
    return showNormalPanel(panel_name, param, "")
end

--获取当前显示panel
function LayerManager.getActivePanel()
	return LayerManager.gameLayerControl.layer
end

--显示浮层panel
function LayerManager.showFloat(panel_name,param)
	local parentLayer = LayerManager.getActivePanel()
    return showFloatPanel(panel_name, parentLayer, param, "")
end

--關閉浮層
function LayerManager.closeFloat(floatPanel, parentLayer)
    local p = parentLayer or LayerManager.getActivePanel()
    closeFloatPanel(floatPanel, p)
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

--初始化
function LayerManager.init(game_scene)
    LayerManager.gameScene = game_scene
    
    local rootLayer = cocosMake.newLayer()
    rootLayer:setAnchorPoint(cc.p(0,0))
    rootLayer:setPosition(0,0)
    game_scene:addChild(rootLayer, LayerManager.rootLayer.z)
    LayerManager.rootLayer.layer = rootLayer
	
	--rootLayer:setScale(display.relativeScale)
	--rootLayer:setPosition(cc.p(display.stageStartPos.x, display.stageStartPos.y))
	

	--游戏页面层
    local gameLayer = cocosMake.newLayer()
    gameLayer:setAnchorPoint(cc.p(0,0))
    gameLayer:setPosition(0,0)
    LayerManager.rootLayer.layer:addChild(gameLayer, LayerManager.gameLayer.z)
    LayerManager.gameLayer.layer = gameLayer

    --对话框层
    local dialogLayer = cocosMake.newLayer()
    dialogLayer:setAnchorPoint(cc.p(0,0))
    dialogLayer:setPosition(0,0)
    LayerManager.gameLayer.layer:addChild(dialogLayer, LayerManager.dialogLayer.z)
    LayerManager.dialogLayer.layer = dialogLayer

    --游戏提示层
    local tipLayer = cocosMake.newLayer()
    tipLayer:setAnchorPoint(cc.p(0,0))
    tipLayer:setPosition(0,0)
    LayerManager.gameLayer.layer:addChild(tipLayer, LayerManager.tipLayer.z)
    LayerManager.tipLayer.layer = tipLayer

	--网络提示层
	local networkTLayer = cocosMake.newLayer()
	networkTLayer:setAnchorPoint(cc.p(0,0))
    networkTLayer:setPosition(0,0)
    LayerManager.gameLayer.layer:addChild(networkTLayer, LayerManager.networkTLayer.z)
    LayerManager.networkTLayer.layer = networkTLayer
	
	--debug layer
	local debugLayer = cocosMake.newLayer()
	debugLayer:setAnchorPoint(cc.p(0,0))
    debugLayer:setPosition(0,0)
    LayerManager.gameLayer.layer:addChild(debugLayer, LayerManager.debugLayer.z)
    LayerManager.debugLayer.layer = debugLayer
	
end


function LayerManager.showDefaultNormalDialog(title, content, callback, comfirmBtnTxt)
    local defaultDialog = DefaultDialog:create({DefaultDialogType.DefaultNormalDialog, title, content, callback, comfirmBtnTxt})
    -- 默认加入到dialogLayer层
    LayerManager.showDialogLayer(defaultDialog)
    return defaultDialog
end


function LayerManager.showDefaultComfirmDialog(title, content, callback, comfirmBtnTxt, cancelBtnTxt)
    local defaultDialog = DefaultDialog:create({DefaultDialogType.DefaultComfirmDialog, title, content, callback, comfirmBtnTxt, cancelBtnTxt})
    -- 默认加入到dialogLayer层
    LayerManager.showDialogLayer(defaultDialog)
    return defaultDialog
end


function LayerManager.showDialogLayer(l)
	LayerManager.dialogLayer.layer:addChild(l)
end

function LayerManager.showTipsLayer(l)
	LayerManager.tipLayer.layer:addChild(l)
end

function LayerManager.debugError(str)
	if not LayerManager.debugLayer.layer.showlayer then
		LayerManager.debugLayer.layer.showlayer = cocosMake.newLayer()
		local showlayer = LayerManager.debugLayer.layer.showlayer
		LayerManager.debugLayer.layer:addChild(showlayer)
		showlayer.errNum = 0
		showlayer:setPosition(0, 0)
		
		local function clickCallback()
			LayerManager.debugLayer.layer:removeFromParent()
			LayerManager.debugLayer.layer.showlayer = nil
		end
		local btn = cocosMake.newButton("comm/button_gb1.png", "comm/button_gb1.png", "comm/button_gb1.png", display.right_top.x-50, display.right_top.y-50, clickCallback)
		LayerManager.debugLayer.layer:addChild(btn)
		
		local locationInNode
		local function onTouchBegan(touch, event)
			local target = event:getCurrentTarget()
			locationInNode = target:convertToNodeSpace(touch:getLocation())
			return true
		end
		
		local function onTouchMoved(touch, event)
			local target = event:getCurrentTarget()
			local moveNode = target:convertToNodeSpace(touch:getLocation())
			
			local y = showlayer:getPositionY() + (moveNode.y - locationInNode.y)
			showlayer:setPositionY(y)
			locationInNode = moveNode
		end	
		
		--注册触摸事件
		local listener = cc.EventListenerTouchOneByOne:create()
		listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
		listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )		
		local eventDispacher = showlayer:getEventDispatcher()
		eventDispacher:addEventListenerWithSceneGraphPriority(listener,showlayer)
	end
	
	local showlayer = LayerManager.debugLayer.layer.showlayer
	if showlayer.errLabel then			
		showlayer.errLabel:removeFromParent()
		showlayer.errLabel = nil
	end
	showlayer.errNum = showlayer.errNum + 1
	
	local errLabel = cocosMake.newLabel(str, 0, display.left_top.y/2)
	errLabel:setAnchorPoint(cc.p(0, 0))
	showlayer:addChild(errLabel)
	LayerManager.debugLayer.layer.showlayer.errLabel = errLabel
end

