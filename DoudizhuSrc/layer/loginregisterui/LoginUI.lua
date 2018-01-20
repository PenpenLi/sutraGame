--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
local LoginUI = class("LoginUI", cocosMake.viewBase)
LoginUI.uid = 180
--规范
LoginUI.ui_resource_file = {"loginUI_VS"}--cocos studio生成的csb

LoginUI.ui_binding_file = {--控件绑定
    panel_Lgoin = {name="loginUI_VS.Panel_2"},
    panel_CreateActor = {name="loginUI_VS.Panel_3"},
    panel_CNT = {name = "loginUI_VS.Panel_1"},
    tf_post = {name = "loginUI_VS.Panel_1.tf_post"},
    btn_cnt = {name = "loginUI_VS.Panel_1.btn_cnt",event="touch",method="OnCNTClick"},
    tf_username = {name="loginUI_VS.Panel_2.tf_username"},
    tf_password = {name="loginUI_VS.Panel_2.tf_password"},
    btn_login = {name="loginUI_VS.Panel_2.btn_login",event="touch",method="OnLoginClick"},
    btn_register = {name="loginUI_VS.Panel_2.btn_register",event="touch",method="OnRegisterClick"},
    tf_name = {name="loginUI_VS.Panel_3.tf_name"},
    cb_nan = {name="loginUI_VS.Panel_3.cb_nan",event="touch",method="OnCBNANClick"},
    cb_lv = {name="loginUI_VS.Panel_3.cb_lv",event="touch",method="OnCBLVClick"},
    btn_create = {name="loginUI_VS.Panel_3.btn_create",event="touch",method="OnCreateActorClick"}
}

LoginUI.notify = {"Notifty_Connect_State"}

function LoginUI:onCreate()
    print("LoginUI:onCreate")
    local layer = self:showFloat(luaFile.MsgFloatUI)
    self:reorderChild(layer,en_Zorder_MsgFloatUI)
    local default_aid = cc.UserDefault:getInstance():getIntegerForKey("GAME_Default_AId",GAME_Default_AId)
    self.tf_password:setString(default_aid.."")
    local default_post = cc.UserDefault:getInstance():getIntegerForKey("GAME_SERVER_IP_PORT",GAME_SERVER_IP_PORT)
    self.tf_post:setString(default_post.."")
    self.panel_Lgoin:setVisible(false)
    self.panel_CreateActor:setVisible(false)
    self.panel_CNT:setVisible(true)

    Notifier.postNotifty("Notifty_Connect_State", {retcode = Constant.Network.CODE_ONOPEN})
end

function LoginUI:onClose()
    print("LoginUI:onClose")
end

function LoginUI:OnCNTClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        local txt = self.tf_post:getString()
        if txt == "" then
            return
        end
        local default_post = tonumber(txt)
        networkManager.connect(GAME_SERVER_IP_ADDRESS, default_post)--初始化socket
        cc.UserDefault:getInstance():setIntegerForKey("GAME_SERVER_IP_PORT",default_post)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function LoginUI:OnLoginClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))

        
        local txt = self.tf_password:getString()
        if not txt or txt == "" then
            txt = "169"
        end
        
        
        local pack = networkManager.createPack("selectChar_c")
	    pack.aid = tonumber(txt)
	    networkManager.sendPack(pack,handler(self,self.loginCallBack),true,0)
        self.uid = tonumber(txt)
        local default_aid  = self.uid
        print(default_aid) 
        cc.UserDefault:getInstance():setIntegerForKey("GAME_Default_AId",default_aid)
        
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function LoginUI:loginCallBack(obj)
    print("LoginUI:loginCallBack \n ----charid = "..obj.charid)
    if obj.charid and obj.charid == 0 then
        self.panel_Lgoin:setVisible(false)
        self.panel_CreateActor:setVisible(true)
        return
	end
    local pack = networkManager.createPack("enterGame_c")
	pack.charid = obj.charid
	networkManager.sendPack(pack,handler(self,self.enterGameCallBack),true,0)
end

function LoginUI:createRoleCallBack(obj)
    print("LoginUI:createRoleCallBack : \n -----retcode="..obj.retcode)
    if obj.retcode == ERR_SUCCESS then
        local pack = networkManager.createPack("selectChar_c")
	    pack.aid = self.uid
	    networkManager.sendPack(pack,handler(self,self.loginCallBack),true,0)
    end
end

function LoginUI:enterGameCallBack(obj)
    local colorLayer = cocosMake.newLayerColor()
    self:addChild(colorLayer)
    colorLayer:setLocalZOrder(100)
    colorLayer:registerScriptTouchHandler(function() return true end,false,0,true)
    colorLayer:setTouchEnabled(true)

    print("LoginUI:enterGameCallBack")
    if tostring(obj._packtype) == "900" then
        Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[22]})
        return
    end
    local tAct = {
        uid = obj.baseData.charid,
        name = obj.baseData.name,
        body=obj.baseData.body,
        level = obj.baseData.level,
        exp = obj.baseData.exp,
        endurance = obj.baseData.endurance,
        silver = obj.baseData.money[1],
        gold = obj.baseData.money[2],
        lowRecruitFreeNum = obj.baseData.lowRecruitFreeNum,
        highRecruitNum = obj.baseData.highRecruitNum,
        leaderSoul = obj.baseData.leaderSoul}
    DataModeManager:CreateActor(tAct)
    local pack = networkManager.createPack("leaderPacket_c")
    networkManager.sendPack(pack,handler(self,self.leaderListCallBack),true,0)
    
end

function LoginUI:leaderListCallBack(obj)
    recvGeneralPropResponse.leaderPacket(obj)
    local pack = networkManager.createPack("openPackage_c")
	pack.type = 1
	networkManager.sendPack(pack,handler(self,self.openItemPackageCallBack),true,0)
end

function LoginUI:openItemPackageCallBack(obj)
    recvPackageResponse.ItemList(obj)
    
    --test code
    recvFubenDataResponse.InitfubenData()

    LayerManager.show(luaFile.UILayer)
end

function LoginUI:test()
    cocosMake.loadSpriteFrames("pic/xiaobing.plist", "pic/xiaobing.png")

    cocosMake.loadSpriteFrames("pic/bubing.plist", "pic/bubing.png")
    for i=1, 600 do
   --[[
        local spr = cc.CSLoader:createNode("cocoscsb/run.csb")
        self:addChild(spr)
        spr:setPosition(100+i*1, 100)
        spr:setAnchorPoint(cc.p(0,0))
        local action = cc.CSLoader:createTimeline("cocoscsb/run.csb");   
        spr:runAction(action)
        action:gotoFrameAndPlay(1, 30, true)
     --]]
     --[[
        local scale = 1.0
        local path = "avatar"
	    local json = "res/pic/bubing_1.json"
        local atlas = "res/pic/bubing_1.atlas"
   
 	    local skeleton = sp.SkeletonAnimation:create(json, atlas, scale)
 	    self.skeleton = skeleton
        skeleton:setPosition(100+i*1, 100)
        skeleton:setAnchorPoint(cc.p(0.5, 0))--默认锚点
        skeleton:registerSpineEventHandler(function(event)
            --if event.type == 'event' then
        	    if self.eventCallback[event.eventData.name] then
        		    self.eventCallback[event.eventData.name](event)
        	    end
            --end
        end, sp.EventType.ANIMATION_EVENT)
        self:addChild(skeleton)
        self.skeleton:setAnimation(0,"idle",true)
         --]]
         
         local spr = cocosMake.newSprite()
         self:addChild(spr)
         spr:setPosition(100+i*1, 100)
        spr:setAnchorPoint(cc.p(0,0))
        if i%3 == 0 then
             local anim,frameSize = cocosMake.newAnimation("bubing/bubing_1-attack", 0, 30, false, 0.06)
             spr:playAnimationForever(anim)
        elseif i%3 == 1 then
            local anim,frameSize = cocosMake.newAnimation("bubing/bubing_1-idle", 0, 40, false, 0.06)
             spr:playAnimationForever(anim)
        elseif i%3 == 2 then
            local anim,frameSize = cocosMake.newAnimation("bubing/bubing_1-die", 0, 31, false, 0.06)
             spr:playAnimationForever(anim)
        end

    end
end

function LoginUI:OnRegisterClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        --self:test()
        --LayerManager.show(luaFile.fightDirector)
        --[[
        local c = 5
        local a = 4
        local sin = a/c
        local asin = math.asin(sin)
        local ar = math.deg(asin)
        print(sin)
        print(asin)
        print(ar)
        --]]
        
        local t = os.clock()
        for i=1,9999999 do
            local a = 12312312
            local b = 12312312
            local r = rawequal(a,b)
            --local r = a == b
        end
        print(os.clock() - t)

        --[[
        local pack = networkManager.createPack("yuqiang_c")
        pack.num = 1000000000000000

        local function packCallback(obj)
            print_lua_table(obj)
        end
        networkManager.sendPack(pack, packCallback, true)
        --]]

    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function LoginUI:OnCreateActorClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("LoginUI:OnCreateActorClick")
        local pack = networkManager.createPack("createRole_c")
	    pack.job = 0
        pack.name = self.tf_name:getString()
        pack.aid = self.uid
	    networkManager.sendPack(pack,handler(self,self.createRoleCallBack),true,0)
        print("createRole_c : "..pack.name.." "..pack.aid)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function LoginUI:OnCBNANClick(event)
    if event.state and event.state == 0 then
    elseif event.state and event.state == 2 then
        if self.cb_lv:isSelected() == false then 
            if not self.cb_nan:isSelected() then  self.cb_nan:setSelected(true) end
            return
        end
        self.cb_lv:setSelected(false)
        print("LoginUI:OnCBNANClick")
    elseif event.state and event.state == 3 then
    end
end

function LoginUI:OnCBLVClick(event)
    if event.state and event.state == 0 then
    elseif event.state and event.state == 2 then
        if self.cb_nan:isSelected() == false then 
            if not self.cb_lv:isSelected() then  self.cb_lv:setSelected(true) end
            return
        end
        self.cb_nan:setSelected(false)
        print("LoginUI:OnCBLVClick")
    elseif event.state and event.state == 3 then
    end
end


function LoginUI:handleNotification(notifyName, data)
    if notifyName == "Notifty_Connect_State" then
        if data.retcode == Constant.Network.CODE_ONOPEN then
            if self.panel_CreateActor:isVisible() == false then
                self.panel_Lgoin:setVisible(true)
                self.panel_CreateActor:setVisible(false)
                self.panel_CNT:setVisible(false)
            end
	    elseif data.retcode == Constant.Network.CODE_ONERROR then

	    elseif data.retcode == Constant.Network.CODE_ONCLOSE then

	    elseif data.retcode == Constant.Network.CODE_RECONNECT then

	    elseif data.retcode == Constant.Network.CODE_RECONNECTERROR then

	    end
    end
end

return LoginUI