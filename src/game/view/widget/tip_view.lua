
TipView = class("TipView", ccui.Widget)

-- 提示类型
TipView.tipType = {
	ERROR = -2, -- 错误信息
	WARN = -1, -- 警告信息
	INFO = 0, -- 普通信息
}

function TipView:ctor(param)
	-- 文字信息
	if StringEx:notEmpty(param[1]) then
		self.pText = param[1]
	else
		self.pText = ""
	end
	self.pType = param[2] or TipView.tipType.INFO -- 类型
	self.pParent = param[3] or LayerManager.tipLayer.layer -- 父节点

	-- 创建视图
	local node = cc.CSLoader:createNode("TipLayerUI.csb")
	self:addChild(node)

	-- 处理node下所有结点
	WidgetHelp:dealChildren(self)

	-- 设置文字显示及颜色
	self.tip_text:setString(self.pText)
	if TipView.tipType.ERROR == self.pType then
		self.tip_text:setTextColor(cc.c4b(255, 33, 33, 255))
	elseif TipView.tipType.WARN == self.pType then
		self.tip_text:setTextColor(cc.c4b(209, 90, 31, 255))
	elseif TipView.tipType.INFO == self.pType then
		self.tip_text:setTextColor(cc.c4b(255, 222, 0, 255))
	end

	-- 设置背景尺寸
	--[[
	local tipTextSize = self.tip_text:getContentSize()
	local tipBgSize = cc.size(tipTextSize.width + 80, tipTextSize.height + 10)
	tipBgSize.width = (tipBgSize.width >= 192 and {tipBgSize.width} or {192})[1] -- 最小宽度192
	tipBgSize.height = (tipBgSize.height >= 54 and {tipBgSize.height} or {54})[1] -- 最小高度54
	self.tip_bg:setContentSize(tipBgSize)
	self.tipBgSize = tipBgSize
	self.tip_text:setPosition(cc.p(tipBgSize.width * 0.5, tipBgSize.height * 0.5))
	
	local s = display.winSize.width/tipBgSize.width
	self.tip_text:setScale(math.min(1, s))
	--]]
	
	-- 设置坐标
	self:setPosition(display.center.x, display.center.y+60)
	self.pParent:addChild(self)

	-- 执行动作
	self:executeAction()
end

-- 执行动作
function TipView:executeAction()
	local actionMove = cc.MoveBy:create(3, cc.p(0, 300))
	local actionFade = cc.FadeOut:create(3)
	local actionSpawn = cc.Spawn:create(actionMove, actionFade)
	local function callBackFunc()
		self:removeFromParent()
	end
	
	--local delay = cc.DelayTime:create(self.tipBgSize.width >= display.winSize.width and 1.3 or 0)
	local delay = cc.DelayTime:create(1.3)
	--local actionScale = cc.EaseSineOut:create(cc.ScaleTo:create(0.1, 1.0))
	self.root:runAction(cc.Sequence:create(delay, actionSpawn, cc.CallFunc:create(callBackFunc)))
end

-- 显示提示信息（相当于静态方法）
function TipView:showTip(pText, pType, pParent)
	TipView:create({pText, pType, pParent})
end
