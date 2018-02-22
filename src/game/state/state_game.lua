------------------------------------

------------------------------------
local StateBase = HotRequire(luaFile.StateBase)
local StateGame = class("StateGame", StateBase)

function StateGame:ctor(...)
    StateBase.ctor(self,...)
	
	cc.load("event"):setEventDispatcher(self, GameController)
end

function StateGame:Enter(gameType,...)
    log("进入房间状态",gameType)
    
	
	LayerManager.show(luaFile.GameLayer)
end

function StateGame:Exit(...)
    log("退出游戏状态")
    if self.background_handler then
        GameController:removeEventListener(self.background_handler)
        self.background_handler = nil
    end
end

return StateGame
