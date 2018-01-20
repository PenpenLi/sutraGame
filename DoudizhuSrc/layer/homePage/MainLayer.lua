local MainLayer = class("MainLayer", cocosMake.viewBase)
MainLayer.ui_resource_file = {"MainTestLayer"}
MainLayer.ui_binding_file = {}
MainLayer.notify = {"openFloatPanel", "closeFloatPanel", "testDataManager"}


function MainLayer:onCreate()
    -- add background image
    local testLayer = cocosMake.newlayer
    -- add play button
    
    self.xIndex = 0
    local playButton = cc.MenuItemImage:create("PlayButton.png", "PlayButton.png")
        :onClicked(function()
            
        
            Notifier.postNotifty("openFloatPanel")
            --Notifier.postNotifty("testDataManager")
        end)
         
    self.menu = cc.Menu:create(playButton)
    self.menu:setPosition(display.winSize.width/2, display.winSize.height/2 - 200)
    self:addChild(self.menu, 10)
	
	local spr1 = cocosMake.newSprite("Star.png", display.visibleRect.leftBottom.x, display.visibleRect.leftBottom.y)
	--self:addChild(spr1,100)
	
	local spr2 = cocosMake.newSprite("Star.png", display.visibleRect.rightTop.x, display.visibleRect.rightTop.y)
    --self:addChild(spr2,100)
	
    --添加shader
    printToFile(cc.GLProgram)
    local shader_program = cc.GLProgram:createWithFilenames("src/Shaders/darken.vsh", "src/Shaders/darken.fsh")
    shader_program:use()
    shader_program:setUniformsForBuiltins()
    spr2:setGLProgram(shader_program); 
	

	--cocosMake.newSprite("MainSceneBg.jpg"):move(display.winSize.width/2, display.winSize.height/2):addTo(self)
   
   --[[
    local function UpdateDebugLayer(args)
        local collectgarbageCount = collectgarbage("count")
        label:setString("lua mem: " .. collectgarbageCount)
    end
    UpdateDebugLayer()
	self.aHand = cocosMake.DirectorScheduler:scheduleScriptFunc(UpdateDebugLayer,1.1,false)
    --]]

    local s1Layer = cocosMake.newLayer()
    self:addChild(s1Layer)
    s1Layer:setLocalZOrder(101)
    for i=1,0 do
        local n = math.random(200001, 200005)
        local testSpr = cocosMake.newSprite("res/image/skillIcon/" .. n .. ".png")
        --self:addChild(testSpr)
        testSpr:setPosition(cc.p(math.random(10, 1270), math.random(10, 710)))
        testSpr:setLocalZOrder(math.random(0, 150))
    end
    for i=1,0 do
        local n = math.random(200001, 200005)
        local testSpr = cocosMake.newSprite("res/image/skillIcon/" .. n .. ".png")
        --s1Layer:addChild(testSpr)
        testSpr:setPosition(cc.p(math.random(10, 1270), math.random(10, 710)))
        testSpr:setLocalZOrder(math.random(0, 150))
    end

    self.bullet = "tx_attack_07"
    self.bullet2 = "tx_attack_09"
    for i=1,100 do
        
        local dataFilename = BULLET_FRAMES_UIPATH .. "/" .. self.bullet .. "/" .. "fly" .. ".plist"
        local imageFilename = BULLET_FRAMES_UIPATH .. "/" .. self.bullet .. "/" .. "fly" .. ".png"
        local dataFilename2 = BULLET_FRAMES_UIPATH .. "/" .. self.bullet2 .. "/" .. "fly" .. ".plist"
        local imageFilename2 = BULLET_FRAMES_UIPATH .. "/" .. self.bullet2 .. "/" .. "fly" .. ".png"

        local plistInfo = cc.FileUtils:getInstance():getValueMapFromFile(dataFilename)
        local frame_count = table.nums(plistInfo.frames)
        local plistInfo2 = cc.FileUtils:getInstance():getValueMapFromFile(dataFilename2)
        local frame_count2 = table.nums(plistInfo2.frames)
        local function loadFinishCallback()
            
            local playNode = cocosMake.newSprite()
            playNode:setAnchorPoint(cc.p(0.5,0.5))
            playNode:setPosition(cc.p(100 + i*2, 100 + i*1))
            playNode:setLocalZOrder(100)
            s1Layer:addChild(playNode)
            --transition.moveTo(playNode, {x=math.random(10, 1000), y=math.random(10, 700), time=math.random(1, 10), onComplete=nil})

            local time = 0.1
            local anim = cocosMake.newAnimation(self.bullet .. "/" .. "fly" .. "/", 1, frame_count, false, time)
            
            local time = math.random(1, 10)
            local function delayCallback()
                playNode:removeFromParent(true)
            end
            performWithDelay(playNode, delayCallback, time + i*2)
        
            playNode:playAnimationForever(anim)

            playNode:setVisible(false)
            performWithDelay(playNode, function()  playNode:setVisible(true) end , time)
        end 
        local function loadFinishCallback2()
            
            local playNode = cocosMake.newSprite()
            playNode:setAnchorPoint(cc.p(0.5,0.5))
            playNode:setPosition(cc.p(150 + i*2, 100 + i*1))
            playNode:setLocalZOrder(101)
            s1Layer:addChild(playNode)
            --transition.moveTo(playNode, {x=math.random(10, 1000), y=math.random(10, 700), time=math.random(1, 10), onComplete=nil})

            local time = 0.1
            local anim = cocosMake.newAnimation(self.bullet2 .. "/" .. "fly" .. "/", 1, frame_count2, false, time)
            
            local time = math.random(1, 10)
            local function delayCallback()
                playNode:removeFromParent(true)
            end
            performWithDelay(playNode, delayCallback, time + i*2)
        
            playNode:playAnimationForever(anim)

            playNode:setVisible(false)
            performWithDelay(playNode, function()  playNode:setVisible(true) end , time)
        end

        local function showNumbers()
            local info = {txt=math.random(1, 999999), posx=math.random(1,1100), posy=math.random(1,700),scale=1}
            local bubble = cocosMake.newTextBMFont(info.txt, {font="res/fnt/green_28.fnt"})
            s1Layer:addChild(bubble)
            bubble:setAnchorPoint(cc.p(0.5,0.5))
            bubble:setPosition(cc.p(info.posx, info.posy))
    

            if info.color then
                bubble:setColor(info.color)
            end
    
            local sequence = transition.sequence({
                    CCScaleTo:create(0.2, 1.3 * info.scale),
                    CCScaleTo:create(0.2, 1 * info.scale),
                    CCMoveBy:create(0.5, cc.p(0, 20)),
                    CCFadeOut:create(0.2),
                    cc.RemoveSelf:create()
                })
           --bubble:runAction(sequence)
        end

        local function  stets(args)
            cocosMake.loadSpriteFrames( dataFilename, imageFilename, loadFinishCallback)
            --showNumbers()
        end
        performWithDelay(s1Layer, stets, math.random(1, 10))

        local function  stets2(args)
            cocosMake.loadSpriteFrames( dataFilename2, imageFilename2, loadFinishCallback2)
            --showNumbers()
        end
        performWithDelay(s1Layer, stets2, math.random(1, 10))
    end
    ------------------------------------------------------------------------
    --[[
    local spr = cocosMake.newSprite()
    spr:setPosition(cc.p(100,100))
    self:addChild(spr)

    self.bullet = "tx_attack_002b"
    local POWER = "power"
    local dataFilename = BULLET_FRAMES_UIPATH .. "/" .. self.bullet .. "/" .. POWER .. ".plist"
    local imageFilename = BULLET_FRAMES_UIPATH .. "/" .. self.bullet .. "/" .. POWER .. ".png"


    local plistInfo = cc.FileUtils:getInstance():getValueMapFromFile(dataFilename)
    local frame_count = table.nums(plistInfo.frames)

    local function loadFinishCallback()
        local time = 0.1
        local anim = cocosMake.newAnimation(self.bullet .. "/" .. POWER .. "/", 1, frame_count, false, time)

        local function showCompleteCallback()
            --cocosMake.removeSpriteFrames(dataFilename, imageFilename)
            --if playFinishcallback then playFinishcallback() end
        end
        
        spr:playAnimationOnce(anim, {showDelay=0, delay=0, onComplete=showCompleteCallback})
    end 

    cocosMake.loadSpriteFrames( dataFilename, imageFilename, loadFinishCallback)
    
    for i=1,10 do
    local spineName = "youhun"
    local scale = 1.0
    local path = "avatar"
	local json = SKELETON_AVATAR_UI_PATH .. "/" .. spineName ..".json"
    local atlas = SKELETON_AVATAR_UI_PATH .. "/" .. spineName ..".atlas"
    
 	local skeleton = sp.SkeletonAnimation:create(json, atlas, scale)
 	self.skeleton = skeleton
    skeleton:registerSpineEventHandler(function(event)
        if event.type == 'complete' then
        	if self.actionCallback[event.animation] then
                self.actionCallback[event.animation]()
                self.actionCallback[event.animation] = nil
            end
        elseif event.type == 'event' then
        	if self.eventCallback[event.eventData.name] then
        		self.eventCallback[event.eventData.name](event)
        	end
        end
    end, sp.EventType.ANIMATION_EVENT)
    self:addChild(skeleton)
    self.skeleton:setAnimation(0,"idle",true)
    end
    --]]
end

function MainLayer:onClose(str)
end



function MainLayer:handleNotification(notifyName, body)
    if notifyName == "openFloatPanel" then
        print("MainLayer:handleNotification.openFloatPanel")
        self.xIndex = self.xIndex + 1
        local scheduler = cc.Director:getInstance():getScheduler()
        --scheduler:unscheduleScriptEntry( self.aHand )

        local function testNetwork()
            local pack = networkManager.createPack("login")
                pack.singleGoodsSnap = networkManager.createPack("goodsSnap")
                pack.singleGoodsSnap.name = "names"
                pack.singleGoodsSnap.members = {1,2,3}
                pack.singleGoodsSnap.id = 11
                pack.playerNames = {"2001", "2002"}

                local goodsSnapTmp1 = networkManager.createPack("goodsSnap")
                goodsSnapTmp1.name = "zhangsan"
                goodsSnapTmp1.members = {4,5,6}
                goodsSnapTmp1.id = 22
                local goodsSnapTmp2 = networkManager.createPack("goodsSnap")
                goodsSnapTmp2.name = "lisi"
                goodsSnapTmp2.members = {7,8,9}
                goodsSnapTmp2.id = 33

                pack.playerBags = {}
                table.insert(pack.playerBags, goodsSnapTmp1)
                table.insert(pack.playerBags, goodsSnapTmp2)

                pack.playerIds = {6006,6007,6008}

                networkManager.sendPack(pack,function(obj)
                    print("消息返回 :")
                    print_lua_table(obj)
                end)
        end
        --testNetwork()
        --LayerManager.show(luaFile.fightDirector)

    elseif notifyName == "closeFloatPanel" then
        print("MainLayer:handleNotification.closeFloatPanel")
        self:closeFloat("homePage.MainLayer2")

    elseif notifyName == "testDataManager" then
    end
end



function MainLayer:hideMenu()
    self.menu:setVisible(false)
end

function MainLayer:createTestLayer(index)
    if index == 1 then
       local view = new_view("MainLayer2")
       self:addChild(view, 1)
       view:setAnchorPoint(cc.p(0,0))
       view:setPosition(100, 100)
       self.layer1 = view
    end
    if index == 2 then
       local view = new_view("MainLayer2")
       self:addChild(view, 1)
       view:setAnchorPoint(cc.p(0,0))
       view:setPosition(50, 60)
       self.layer2 = view
    end
    if index == 3 then
       local view = new_view("MainLayer2")
       self.layer1:addChild(view, 1)
       view:setAnchorPoint(cc.p(0,0))
       view:setPosition(5, 5)
       self.layer3 = view
    end
    if index == 4 then
        local myX, myY = self:getPosition()
        local l1X, l1Y = self.layer1:getPosition()
        local l2X, l2Y = self.layer2:getPosition()
        local l3X, l3Y = self.layer3:getPosition()

        local p1 = self.layer1:convertToNodeSpace(cc.p(myX, myY))
        local p2 = self.layer1:convertToWorldSpace(cc.p(l1X, l1Y))

        local p3 = self:convertToNodeSpace(cc.p(myX, myY))
        local p4 = self:convertToWorldSpace(cc.p(l1X, l1Y))

        local p5 = self.layer1:convertToNodeSpace(cc.p(l2X, l2Y))
        local p6 = self.layer1:convertToWorldSpace(cc.p(0, 0))

        local p7 = self.layer2:convertToNodeSpace(cc.p(l1X, l1Y))
        local p8 = self.layer1:convertToWorldSpace(cc.p(l1X, l1X))

        local p9 = self.layer3:convertToNodeSpace(cc.p(myX, myY))
        local p10 = self:convertToNodeSpace(cc.p(l3X, l3Y))
        local p11 = self.layer3:convertToWorldSpace(cc.p(0, 0))

        local p12 = self.layer2:convertToNodeSpace(cc.p(p11.x, p11.y))

        printToFile("myX:" .. myX .. ",myY:" .. myY .. ",l1X:" .. l1X .. ",l1Y:" .. l1X .. ",l2X:" .. l2X .. ",l2Y:" .. l2Y .. ",l3X:" .. l3X .. ",l3Y:" .. l3Y)
        printToFile(p1)
        printToFile(p2)
        printToFile(p3)
        printToFile(p4)
        printToFile(p5)
        printToFile(p6)
        printToFile(p7)
        printToFile(p8)
        printToFile("--------------------")
        printToFile(p9)
        printToFile(p10)
        printToFile(p11)
        printToFile(p12)
        printToFile("--------------------")
    end
end
local tt = MainLayer.notify
return MainLayer
