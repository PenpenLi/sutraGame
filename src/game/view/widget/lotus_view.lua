
local lotusView = class("lotusView", cocosMake.DialogBase)

--cocos studio生成的csb
lotusView.ui_resource_file = {"lotusNode"}


					
lotusView.ui_binding_file = {
	closeBtn        = {event = "click", method = "touchPanelClick"},
}


function lotusView:onCreate(param)
	local openlotusNum = UserData:getLotusNum()
	log("openlotusNum", openlotusNum)

	local xx = cocosMake.newSprite("res/homeUI/xingguang.png")
	
	self:addChild(xx)
	
	local lotusCnt = 0
	local collisionZone
	local accelLayer
	local function updateXX()
		lotusCnt = lotusCnt + 1
		if lotusCnt > openlotusNum then
			if accelLayer then
				accelLayer:removeFromParent()
				accelLayer = nil
			end
			xx:runAction(cc.FadeOut:create(0.6))
			return
		end
		local px,py = self["lotus"..lotusCnt.."Collision"]:getPosition()
		local psize = self["lotus"..lotusCnt.."Collision"]:getContentSize()
		collisionZone = {x=px+stage_width/2, y=py+stage_height/2, w=psize.width, h=psize.height}
		local dropx, dropy = self.dropSite:getPosition()
		xx:setPosition(600, stage_height)
	end
	
	if openlotusNum > 0 then
		updateXX()
		local pxx, pxy = 0,0
		-- 用来回调的方法  
		local function accelerometerListener(event,x,y,z,timestamp)  
			--log(x,y,z,timestamp)
			
			pxx,pxy = xx:getPosition()
			--log(pxx,pxy, collisionZone)
			if pxx >= collisionZone.x and pxx <= (collisionZone.x+collisionZone.w) and
				pxy >= collisionZone.y and pxy <= (collisionZone.y+collisionZone.h) then
				self["lotus"..lotusCnt]:setVisible(true)
				self["lotus"..lotusCnt]:setOpacity(0)
				self["lotus"..lotusCnt]:runAction(cc.FadeIn:create(1))
				updateXX()
			else
				
				xx:setPosition(pxx + x*9,pxy-6)
				if pxy < 0 then
					xx:setPosition(600, 1280)
				end
			end
		end 
		
		accelLayer = cocosMake.newLayer()
		self:addChild(accelLayer)
		accelLayer:setAccelerometerEnabled(true)
		-- 创建一个重力加速计事件监听器  
		local listerner  = cc.EventListenerAcceleration:create(accelerometerListener)  
		-- 获取事件派发器然后设置触摸绑定到精灵，优先级为默认的0    
		accelLayer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listerner,accelLayer)
	end
end


function lotusView:onClose( ... )
	
	self:dispatchEvent({name = GlobalEvent.JINGTU_VIEW_SHOW, data={view=nil}})
end

function lotusView:touchPanelClick(event)
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	
	LayerManager.closeFloat(self)
end


return lotusView
