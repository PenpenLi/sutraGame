local reggetLayer = class("reggetLayer", cocosMake.viewBase)

reggetLayer.ui_resource_file = {"reggetLayerUI"}
reggetLayer.ui_binding_file = {
register={name="reggetLayerUI.register"},
register_close_btn={name="reggetLayerUI.register.close_btn",event="touch",method="reg_close_btnClick"},
register_zhanghao_edit={name="reggetLayerUI.register.zhanghao_edit"},
register_mima_edit={name="reggetLayerUI.register.mima_edit"},
register_mimaagain_edit={name="reggetLayerUI.register.mimaagain_edit"},
register_email_edit={name="reggetLayerUI.register.email_edit"},
register_phone_edit={name="reggetLayerUI.register.phone_edit"},
register_zhuce_btn={name="reggetLayerUI.register.zhuce_btn",event="touch",method="zhuce_btnClick"},

getpsd={name="reggetLayerUI.getpsd"},
getpsd_zhuce_btn={name="reggetLayerUI.getpsd.close_btn",event="touch",method="psd_close_btnClick"},
getpsd_mima_edit={name="reggetLayerUI.getpsd.mima_edit"},
getpsd_mimaagain_edit={name="reggetLayerUI.getpsd.mimaagain_edit"},
getpsd_wancheng_btn={name="reggetLayerUI.getpsd.wancheng_btn",event="touch",method="psd_wanchengBtnClick"},
}

--reggetLayer.notify = {"openFloatPanel", "closeFloatPanel", "testDataManager"}


function reggetLayer:onCreate(param)
	--[[
	self.reggetLayerUI:setVisible(false)
    local spr2 = cocosMake.newSprite("ui/mainpage/bisai_btn_normal.png", 300, 300)
	self:addChild(spr2)
	spr2:setLocalZOrder(10)
	
	local shader_program = cc.GLProgram:createWithFilenames("src/Shaders/testshader.vsh", "src/Shaders/testshader.fsh")
    shader_program:use()
    shader_program:setUniformsForBuiltins()
    spr2:setGLProgram(shader_program)
	--]]
	
	if param.register then
		self.register:setVisible(true)
		self.getpsd:setVisible(false)
		self.isRegister = true
		
	elseif param.zhaohuimima then
		self.register:setVisible(false)
		self.getpsd:setVisible(true)
		self.isGetPsd = true
	end
	
	self.auser = require(luaFile.authUser)
	
	self.state_tips = {}
	self.state_tips[self.auser.STATE.connecting] = "网络连接中..."
	self.state_tips[self.auser.STATE.connectfail] = "网络连接失败"
	self.state_tips[self.auser.STATE.register_id_repeat] = "注册帐号重复，请换一个帐号"
	self.state_tips[self.auser.STATE.register_id_psd_error] = "注册失败"
	self.state_tips[self.auser.STATE.register_ok] = "注册成功"
end


function reggetLayer:reg_close_btnClick(event)
    if event.state == 2 then
		LayerManager.show(luaFile.loginLayer)
	end
end
function reggetLayer:zhuce_btnClick(event)
    if event.state == 2 then
		local id = self.register_zhanghao_edit:getString()
		local psd = self.register_mima_edit:getString()
		
		self.auser.start_register(id, psd, handler(self, self.registerCallback))
	end
end
function reggetLayer:registerCallback(event)
	print("reggetLayer:registerCallback", event)
	
	if event ~= self.auser.STATE.register_ok then
		LayerManager.showTips(self.state_tips[event] or "未知错误")
		
	else
		LayerManager.showTips(self.state_tips[event] or "未知错误")
		--LayerManager.show(luaFile.roomLayer)		
	end
end

function reggetLayer:psd_close_btnClick(event)
    if event.state == 2 then
	end
end
function reggetLayer:psd_wanchengBtnClick(event)
    if event.state == 2 then
	end
end

function reggetLayer:onClose(str)
end



function reggetLayer:handleNotification(notifyName, body)
    if notifyName == "openFloatPanel" then
     
    end
end



return reggetLayer
