
local mainScene = class("mainScene", cocosMake.Scene)

function mainScene:ctor()
    self:enableNodeEvents()

end


function mainScene:onEnter()

	LayerManager.init(self)
	
	--test code
	--local ss = cocosMake.getRunningScene()
	--ss:addChild(cocosMake.newSprite("res/off.png", 123, 234))
	
	
	networkManager = new_class(luaFile.networkManager)	
	networkControl = new_class(luaFile.networkControl)
	networkControl:init()
	networkControl:authUser()
	
	if TARGET_PLATFORM ~= cc.PLATFORM_OS_WINDOWS then
		local action_list = {}
		action_list[#action_list+1] = cc.DelayTime:create(0.0)
		action_list[#action_list+1] = cc.CallFunc:create(function()		
			AdManager:loadAd()
		end)
		self:runAction(cc.Sequence:create(unpack(action_list)))
		
	end
	
	StateMgr:ChangeState(StateType.Game)
end

function mainScene:onExit()

end

return mainScene
