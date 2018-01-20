local scrollviewLayer = class("scrollviewLayer", cocosMake.viewBase)

scrollviewLayer.ui_resource_file = {}
scrollviewLayer.ui_binding_file = {}
scrollviewLayer.notify = {}

function scrollviewLayer:onCreate()
    --创建容器
    local layerContainer = cocosMake.newLayer(ccc4(10, 20, 30, 10))
    layerContainer:setTouchEnabled(true)
    layerContainer:setPosition(ccp(1, 0))
    --layerContainer:setTouchSwallowEnabled(false)
    layerContainer:registerScriptHandler(function(event)
        return self:onCellCallback(event.name, event.x, event.y)
    end)

    local widgetContainer = cocosMake.newSprite()   
    widgetContainer:setPosition(cc.p(0,0))
    layerContainer:addChild(widgetContainer)


    self.scrollWidth = 300
    self.scrollHeight = 500
    local scrollView = cc.ScrollView:create()
    scrollView:setContentSize(CCSizeMake(0, 0)) -- 設置內容大小
    scrollView:setViewSize(CCSizeMake(self.scrollWidth, self.scrollHeight)) -- 設置可見大小
    scrollView:setPosition(ccp(100, 100)) -- 設置位置
    scrollView:setContainer(layerContainer) -- 設置容器
    scrollView:setDirection(kCCScrollViewDirectionVertical) -- 設置滾動方向
    scrollView:setClippingToBounds(true) -- 設置剪切
    scrollView:setBounceable(true)  -- 設置彈性效果
    scrollView:setDelegate() -- 註冊為自身
    self:addChild(scrollView)
    scrollView:registerScriptHandler(function()self:scrollViewDidScroll()end, cc.SCROLLVIEW_SCRIPT_SCROLL)

    layerContainer:setContentSize(300, 800)

    local i = 1
    local function sf()
        local label = cocosMake.newLabel("测试"..i, 0, i*40)
        label:setAnchorPoint(cc.p(0,0))
        layerContainer:addChild(label)
        i = i + 1
    end
    schedule(self, sf, 1)
end

function scrollviewLayer:onCellCallback(event, x, y)
    if event == "began"then
        print("onCellCallback.event.began")
        self.bolTouchEnd = false
        return true
    
    elseif event == "ended"then
        print("onCellCallback.event.ended")
        self.bolTouchEnd = true
    end
end

function scrollviewLayer:onClose()
end

testIndex = 0
function scrollviewLayer:scrollViewDidScroll()
    print("scrollViewDidScroll_"..testIndex)
    testIndex = testIndex + 1
end


return scrollviewLayer