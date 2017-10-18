
TipViewEx = class("TipViewEx", ccui.Widget)

-- 提示类型
TipViewEx.tipType = {
	signTip = 1,
	signSuccess = 2,
	songTip = 3,
	getChenghao = 4,
	getTool = 5,
	useTool = 6,
	unuseTool = 7,
}

function TipViewEx:ctor(param)
	local uipath = ""
	if param[1] == TipViewEx.tipType.signTip then uipath = "homeUI/ui_z01.png" end
	if param[1] == TipViewEx.tipType.signSuccess then uipath = "homeUI/ui_z02.png" end
	if param[1] == TipViewEx.tipType.songTip then uipath = "homeUI/ui_z03.png" end
	if param[1] == TipViewEx.tipType.getChenghao then uipath = "songOver/ui_z04.png" end
	if param[1] == TipViewEx.tipType.getTool then uipath = "signBoard/tool/ui_z05.png" end
	if param[1] == TipViewEx.tipType.useTool then uipath = "signBoard/tool/ui_z06.png" end
	if param[1] == TipViewEx.tipType.unuseTool then uipath = "signBoard/tool/ui_z07.png" end
	
	local ui = cocosMake.newSprite(uipath)
	self.ui = ui
	self:addChild(ui)
	
	self.pParent = LayerManager.tipLayer.layer -- 父节点
	
	-- 设置坐标
	self:setPosition(display.center.x, display.center.y+60)
	self.pParent:addChild(self)

	-- 执行动作
	self:executeAction()
end

-- 执行动作
function TipViewEx:executeAction()
	local actionMove = cc.MoveBy:create(3, cc.p(0, 300))
	local actionFade = cc.FadeOut:create(3)
	local actionSpawn = cc.Spawn:create(actionMove, actionFade)
	local function callBackFunc()
		self:removeFromParent()
	end
	
	--local delay = cc.DelayTime:create(self.tipBgSize.width >= display.winSize.width and 1.3 or 0)
	local delay = cc.DelayTime:create(1.3)
	--local actionScale = cc.EaseSineOut:create(cc.ScaleTo:create(0.1, 1.0))
	self.ui:runAction(cc.Sequence:create(delay, actionSpawn, cc.CallFunc:create(callBackFunc)))
end

-- 显示提示信息（相当于静态方法）
function TipViewEx:showTip(pType, pParent)
	TipViewEx:create({pType, pParent})
end
