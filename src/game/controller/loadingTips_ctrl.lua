
local loadingTipsCtrl = class("loadingTipsCtrl", HotRequire(luaFile.CtrlBase))

function loadingTipsCtrl:ctor( ... )
	self.super.ctor(self, ... )
end

function loadingTipsCtrl:Init( ... )
	self.super.Init(self)

	self.networkLoadingView = nil
end

function loadingTipsCtrl:networkLoading( b )
	local function destoryview()
		if self.networkLoadingView then
			self.networkLoadingView:removeFromParent()
			self.networkLoadingView = nil
		end
	end
	destoryview()
	LayerManager.setTouchEnable(false)
	
	if b then
		local view = cc.CSLoader:createNode("NetworkLoadingNode.csb")
		self.networkLoadingView = view
		LayerManager.showTipsLayer(view)
		view:setPosition(display.center)
				
		
		
		local loadingIcon = view:getChildByName("loading")		
		local action_list = {}
		action_list[#action_list + 1] = cc.RotateBy:create(0.5, -45)
		local action = cc.RepeatForever:create(cc.Sequence:create(unpack(action_list)))
		loadingIcon:runAction(action)
	end
	
end

return loadingTipsCtrl
