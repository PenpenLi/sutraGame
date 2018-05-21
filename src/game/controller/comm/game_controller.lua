
-- 主控制器(单例)
local GameController = class("GameController", {})

function GameController:ctor( ... )
    cc.load("event"):bind(self)
end

-- 进入游戏场景
function GameController:startGame()
	-- 启动管理类（Controller）
	
	AdManager:requestPermission()
	
	if TARGET_PLATFORM == cc.PLATFORM_OS_IPHONE or TARGET_PLATFORM == cc.PLATFORM_OS_IPAD then
		self:initPreInfo()	
		cocosMake.runScene(new_class(luaFile.mainScene))
		
	else
		cocosMake.runScene(new_class(luaFile.splashScene))
	end
	
end

function GameController:initPreInfo()
	require(luaFile.resourceCtrl)
	resourceCtrl:init()
	resourceCtrl:decodeAudio()
	
	self:startManager()
	
	
	
	--缓冲背景图片
	for i=1, 25 do
		cocosMake.loadImage(string.format("bg/gamelayer/BG%02d.jpg",  i))
	end
end

-- 启动管理类
function GameController:startManager( ... )
	
	--cc.Director:getInstance():getTextureCache():pngEncode(true)
    
    -- 网络管理
    --NetworkManager = new_class(luaFile.NetworkManager)
	
	--loading ctrl
	loadingTipsCtrl = new_class(luaFile.loadingTipsCtrl)
	
	UserData = new_class(luaFile.UserData)
	
	-- 图片缓存管理
    ImageCacheCtrl = new_class(luaFile.ImageCacheCtrl)
	
    -- 状态控制器
    StateMgr = new_class(luaFile.StateMgr)
   
    -- 登录控制器
    --LoginCtrl = new_class(luaFile.LoginCtrl)
		
end

function GameController:connectTcp(ip, port, domain, userdata)
    NetworkManager:connect(ip, port, domain, userdata)
end

function GameController:closeConnectedTcp()
    NetworkManager.disconnect()
end



function GameController:SendPack(sockUserdata, pack, packName , showloading, waitTime)
    local commandid = _SendMsgId[packName]
    if not commandid then
        error("GameController:SendPack commandid is nil,packName is",packName)
        return
    end
	
    NetworkManager.sendPack(pack, packName, commandid, 0, showloading, waitTime)
end

function GameController:RecvPack(commandid, msg, sockid, userdata)
	
end

return GameController
