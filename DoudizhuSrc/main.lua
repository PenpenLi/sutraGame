
__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    print(msg)
    --cocosMake.setGameSpeed(0)
    return msg
end

cc.FileUtils:getInstance():setPopupNotify(false)

cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

collectgarbage("setpause", 100)
collectgarbage("setstepmul", 5000)

--就是把 time返回的数值字串倒过来（低位变高位）， 再取高位6位
math.randomseed(tostring(os.time()):reverse():sub(1, 6))

--require "pb"
require "config"
require "cocos.init"
require "framework.init"
require "DDZ_Define"

local gamescene = nil
local function main()
    
	--require "checkversion"
	
    cocosMake.Director:setDisplayStats(false)
    gamescene = new_class(luaFile.mainScene)
    LayerManager.init(gamescene)
	require(luaFile.hotRequire)
	
    cocosMake.runScene(gamescene)
    gamescene:showMainLayer()

    --startCocosDegbugTicker()
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
