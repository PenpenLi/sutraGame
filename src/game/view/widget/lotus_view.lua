
local lotusView = class("lotusView", cocosMake.DialogBase)

--cocos studio生成的csb
lotusView.ui_resource_file = {"jingtuNode"}


					
lotusView.ui_binding_file = {
	closeBtn        = {event = "click", method = "touchPanelClick"},
}


function lotusView:onCreate(param)
	local openlotusNum = math.random(0, 9)
	log("openlotusNum", openlotusNum)
	
	if openlotusNum > 0 then
		-- 用来回调的方法  
		local function accelerometerListener(event,x,y,z,timestamp)  
			log(x,y,z,timestamp)
			
			
		end 
	
		-- 创建一个重力加速计事件监听器  
		local listerner  = cc.EventListenerAcceleration:create(accelerometerListener)  
		-- 获取事件派发器然后设置触摸绑定到精灵，优先级为默认的0    
		self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listerner,self) 
	end
end


function lotusView:onClose( ... )
	
	self:dispatchEvent({name = GlobalEvent.JINGTU_VIEW_SHOW, data={view=nil}})
end

function lotusView:touchPanelClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	
	LayerManager.closeFloat(self)
end


return lotusView
