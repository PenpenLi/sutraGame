
-- 主控制器(单例)
local GameController = class("GameController", {})

function GameController:ctor( ... )
    cc.load("event"):bind(self)
end

-- 进入游戏场景
function GameController:startGame()
	-- 启动管理类（Controller）
	
	require(luaFile.resourceCtrl)
	resourceCtrl:init()
	resourceCtrl:decodeAudio()
	
	self:startManager()
	
    self.gamescene = new_class(luaFile.mainScene)
    cocosMake.runScene(self.gamescene)
	
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
