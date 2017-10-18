local loginLayer = class("loginLayer", cocosMake.viewBase)

loginLayer.ui_resource_file = {"loginLayerUI"}
loginLayer.ui_binding_file = {
mainBg={name="loginLayerUI.mainBg"},
edit_panel={name="loginLayerUI.edit_panel"},
zhanghao_edit={name="loginLayerUI.edit_panel.zhanghao_edit"},
mima_edit={name="loginLayerUI.edit_panel.mima_edit"},
sure_btn={name="loginLayerUI.edit_panel.sure_btn",event="touch",method="sureBtnClick"},
register_btn={name="loginLayerUI.edit_panel.register_btn",event="touch",method="registerBtnClick"},

process_panel={name="loginLayerUI.process_panel"},
process={name="loginLayerUI.process_panel.process"},
}

--loginLayer.notify = {"openFloatPanel", "closeFloatPanel", "testDataManager"}


function loginLayer:onCreate()
	--[[
	self.loginLayerUI:setVisible(false)
    local spr2 = cocosMake.newSprite("ui/mainpage/bisai_btn_normal.png", 300, 300)
	self:addChild(spr2)
	spr2:setLocalZOrder(10)
	
	local shader_program = cc.GLProgram:createWithFilenames("src/Shaders/testshader.vsh", "src/Shaders/testshader.fsh")
    shader_program:use()
    shader_program:setUniformsForBuiltins()
    spr2:setGLProgram(shader_program)
	--]]
	self.auser = require(luaFile.authUser)
	
	self.state_tips = {}
	self.state_tips[self.auser.STATE.connecting] = "网络连接中..."
	self.state_tips[self.auser.STATE.connectfail] = "网络连接失败"
	self.state_tips[self.auser.STATE.loginError_id_psd_error] = "帐号或密码错误"
	self.state_tips[self.auser.STATE.loginError] = "登录失败"
	self.state_tips[self.auser.STATE.login_ok] = "登录成功"
	
end

function loginLayer:loginCallback(event)
	print("loginLayer:loginCallback", event)
	LayerManager.showTips(self.state_tips[event] or "未知错误")
	
	if event == self.auser.STATE.login_ok then
		--LayerManager.show(luaFile.roomLayer)
		LayerManager.show(luaFile.mainLayer)
	end
end

function loginLayer:sureBtnClick(event)
    if event.state == 2 then
		--local id = self.zhanghao_edit:getString()
		--local psd = self.mima_edit:getString()
		--self.auser.start_login(id, psd, handler(self, self.loginCallback))
		 self:loginCallback(self.auser.STATE.login_ok)
	end
end
function loginLayer:registerBtnClick(event)
    if event.state == 2 then
		LayerManager.show(luaFile.reggetLayer, {register=true})		
	end
end

function loginLayer:onClose(str)
end



function loginLayer:handleNotification(notifyName, body)
    if notifyName == "openFloatPanel" then
        

    elseif notifyName == "closeFloatPanel" then
        print("loginLayer:handleNotification.closeFloatPanel")
        self:closeFloat("homePage.MainLayer2")

    elseif notifyName == "testDataManager" then
    end
end



return loginLayer
