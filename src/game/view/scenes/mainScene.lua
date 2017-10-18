
local mainScene = class("mainScene", cocosMake.Scene)

function mainScene:ctor()
    self:enableNodeEvents()

end


function mainScene:onEnter()

	LayerManager.init(self)
	
	--test code
	--local ss = cocosMake.getRunningScene()
	--ss:addChild(cocosMake.newSprite("res/off.png", 123, 234))
	
	StateMgr:ChangeState(StateType.Game)
end

function mainScene:onExit()

end

return mainScene
