
local toolView = class("toolView", cocosMake.DialogBase)

--cocos studio生成的csb
toolView.ui_resource_file = {"toolNode"}


					
toolView.ui_binding_file = {
	closeBtn        = {event = "click", method = "closeBtnClick"},
	useBtn        = {event = "click", method = "useBtnClick"},
	unuseBtn        = {event = "click", method = "unuseBtnClick"},
	
}

function toolView:onCreate(param)
	self.sel = 0
	local toollist = {}
	local function updateTool(tid)
		self.sel=tid
		for k,v in pairs(toollist) do
			local sname = "darken"
			if v.tid == self.sel then
				sname = "light"
				self.useBtn:setVisible(UserData.usedTool ~= tostring(self.sel))
				self.unuseBtn:setVisible(UserData.usedTool == tostring(self.sel))
			end
			v.gou:setVisible(v.tid == self.sel)
			--WidgetHelp:setShader(v, "Shaders/light.vsh", "Shaders/light.fsh")
		end
	end
	
	local toolPos = {}
	toolPos[1] = {offsetPos=cc.p(0, 10),cnt=-1}
	toolPos[2] = {offsetPos=cc.p(1, 10),cnt=-1}
	toolPos[3] = {offsetPos=cc.p(-9, 10),cnt=UserData:getTool_lotus(  )}
	for idx=1, 3 do
		--if UserData.toolList[tostring(idx)] then
		if true then
			local tool = ccui.ImageView:create("signBoard/tool/".."t"..idx..".png")
			self["Node_"..idx]:addChild(tool)
			WidgetHelp:setShader(tool, "Shaders/light.vsh", "Shaders/light.fsh")
			
			tool:setPosition(toolPos[idx].offsetPos)
			tool.tid=idx
			toollist[idx] = tool
			local tid = idx
			tool:setTouchEnabled(true)
			tool:onClicked(function() 
				print("XXX", tid)
				updateTool(tid)
			end)
			
			local gou = cocosMake.newSprite("signBoard/q_on.png", 45, -45 )
			--gou:setScale(0.7)
			self["Node_"..idx]:addChild(gou)
			gou:setVisible(false)
			tool.gou = gou
			
			if toolPos[idx].cnt >= 0 then
				local lbl = cocosMake.newLabel(toolPos[idx].cnt, -55, -45)
				lbl:setColor(cc.c3b(150, 150, 150))
				self["Node_"..idx]:addChild(lbl)
			end
		end
	end
	
	
	self:dispatchEvent({name = GlobalEvent.TOOL_VIEW_SHOW, data={view=self}})
end


function toolView:onClose( ... )
	self:dispatchEvent({name = GlobalEvent.TOOL_VIEW_SHOW, data={view=nil}})
end

function toolView:bgTouch()
end

function toolView:closeBtnClick(event)
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	
	LayerManager.closeFloat(self)
end
function toolView:useBtnClick(event)
	if self.sel == 3 then--观赏莲花
		local animateNode = new_class(luaFile.AnimationSprite, {
			startFrameIndex = 1,                             -- 开始帧索引
			isReversed = false,                              -- 是否反转
			plistFileName = "signBoard/tool/lianhua.plist", -- plist文件
			pngFileName = "signBoard/tool/lianhua.png",     -- png文件
			pattern = "lianhua/",                      -- 帧名称模式串
			frameNum = 18,                                   -- 帧数
			rate = 0.10,                                     -- 
			stay = true,                                    -- 是否停留（是否从cache中移除纹理）
			indexFormat = 2,                                 -- 整数位数
		})
		animateNode:setScale(2.5)
		animateNode:setPosition(720/2, 1280/2+270)
		self:addChild(animateNode)
		animateNode:playOnce(true, 0, function() 
			local lastspr = cocosMake.newSprite("signBoard/tool/lianhua_last.png")
			lastspr:setScale(2.5)
			lastspr:setPosition(720/2, 1280/2+270)
			self:addChild(lastspr)
			lastspr:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.FadeOut:create(1.0), cc.CallFunc:create(function() lastspr:removeFromParent() end)))
		end)
		
	else
		UserData:saveUseTool( self.sel )
		self.useBtn:setVisible(false)
		self.unuseBtn:setVisible(true)
		TipViewEx:showTip(TipViewEx.tipType.useTool)
	end
end
function toolView:unuseBtnClick(event)
	UserData:saveUseTool( "" )
	self.useBtn:setVisible(true)
	self.unuseBtn:setVisible(false)
	TipViewEx:showTip(TipViewEx.tipType.unuseTool)
end

return toolView
