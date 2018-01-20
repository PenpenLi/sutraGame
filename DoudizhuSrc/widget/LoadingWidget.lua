LoadingWidget = class("LoadingWidget",function()
	return cc.LayerColor:create(cc.c4b(0,0,0,150))
end)


function LoadingWidget:create()
	self = self.new()
	self.name = "LoadingWidget"

	-- local loading = cc.Sprite:create("res/loading_01.png")
	--local loading = sp.SkeletonAnimation:create("res/ui_animation/loading01.json","res/ui_animation/loading01.atlas",1.0)
	--loading:setPosition(VisibleRect:center())
	--loading:setAnimation(0,"loading01",true)
    local label = cocosMake.newLabel("网络请求中。。。", 0, 0)
    self:addChild(label)
    label:setLocalZOrder(1)
    label:setPosition(cc.p(display.visibleRect.center.x, display.visibleRect.center.y))

	--[[
	local animation = cc.AnimationCache:getInstance():getAnimation("LoadingWidget")
	
	if animation then
		--存在，不创建
--		print("animation exsit")
	else
	    -- cclog("create animation")
		--不存在，创建动画
		animation = cc.Animation:create()
		animation:setDelayPerUnit(0.1)
		animation:setLoops(-1)
		
		for i = 1, 6 do
			local var = string.format("loading_%02d%s",i,".png")
			--print(var)
			local path = "res/"..var
			animation:addSpriteFrameWithFile(path)
		end
		cc.AnimationCache:getInstance():addAnimation(animation,self.name)	
	end

	local animate = cc.Animate:create(animation)
	loading:runAction(animate)
    self:addChild(loading)
	]]

	

    local function onNodeEvent(event)
        if "enter" == event then
            self:onEnter()
        elseif "exit" == event then
            self:onExit()
        end
    end
    
    self:registerScriptHandler(onNodeEvent)

    --测试待超时
    --cc.CallFunc:create()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(Constant.Network.REQUEST_TIMEOUT),cc.CallFunc:create(function ()
    	ShowText:createAndRun("请求超时，请稍候重试")
    	if self.packindex then
	    	networkManager.requestTimeOut(self.packindex)
	    end
    	self:removeFromParent()
    end)))

    local function handler(eventType, x, y)
		if eventType == "began" then
            return true  
        elseif eventType == "moved" then
		elseif eventType == "ended" then
			if self.tap then
				self.tap(x,y)  
			end
        end
	end
	self:registerScriptTouchHandler(handler,false,0,true)
	self:setTouchEnabled(true)

	return self
end

function LoadingWidget:onEnter()
-- 	local function onTouchBegan(touch, event)
--         return true
--     end

--     local listener = cc.EventListenerTouchOneByOne:create()
--     listener:setSwallowTouches(true)
--     listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    
--     local eventDispacher = self:getEventDispatcher()
-- 	eventDispacher:addEventListenerWithFixedPriority(listener,-10)

-- 	self.listener = listener
end

function LoadingWidget:onExit()
	-- local eventDispacher = self:getEventDispatcher()
	-- eventDispacher:removeEventListener(self.listener)

	networkManager.loading = nil
end