
----------------------------------------------------------
-- author:周旭448
-- email:494084587@qq.com
-- desc:游戏中默认对话框，其他自定义对话框可以参考此对话框
--   继承至DialogBase并重写部分UI逻辑
----------------------------------------------------------

DefaultDialog = class("DefaultDialog", DialogBase)

DefaultDialogType = {
	DefaultNormalDialog = 1, -- 普通对话框
	DefaultComfirmDialog = 2, -- 确认对话框
}

-- @param dialogType
-- @param titleStr
-- @param contentStr
-- @param callback
function DefaultDialog:ctor( param )
	self.dialogType = param[1] or DefaultDialogType.DefaultNormalDialog
	self.titleStr = param[2]
	self.contentStr = param[3]
	self.callback = param[4]
	self.comfirmBtnTxt = param[5]
	self.cancelBtnTxt = param[6]

	self.super.ctor(self, {true, true, true})
end

function DefaultDialog:onEnter()
	-- 创建默认对话框UI
	local node = cc.CSLoader:createNode(Resources.csb.DialogUI .. ".csb")
	self:addChild(node)

	-- 处理node下所有结点，能通过根节点直接访问
	WidgetHelp:dealChildren(node, self)

	-- 播放弹出效果
	self:showEffect(self.dialog_frame)

	-- 按钮点击事件
	-- self.close_btn:onTouch(handler(self, self.onClose))
	self.cancel_btn:onTouch(handler(self, self.onCancel))
	self.comfirm_btn:onTouch(handler(self, self.onComfirm))

	self.title_text:setString(self.titleStr)
	self.content_text:setString(self.contentStr)
	if StringEx:notEmpty(self.comfirmBtnTxt) then
		self.comfirm_btn_txt:setString(self.comfirmBtnTxt)
	end
	if StringEx:notEmpty(self.cancelBtnTxt) then
		self.cancel_btn_txt:setString(self.cancelBtnTxt)
	end

	if StringEx:notEmpty(self.title_text:getString()) then
		self.title_img:setVisible(false)
	else
		self.title_img:setVisible(true)
	end

	if self.dialogType == DefaultDialogType.DefaultNormalDialog then
		self.cancel_btn:setVisible(false)
		self.comfirm_btn:setPositionX((self.cancel_btn:getPositionX() + self.comfirm_btn:getPositionX()) / 2)

		self.comfirm_btn:loadTextureNormal(Resources.image.button_qd1)
		self.comfirm_btn:loadTexturePressed(Resources.image.button_qd2)
	end
end

-- function DefaultDialog:onClose( event )
-- 	if event.name == "ended" then
-- 		self:close()
-- 	end
-- end

function DefaultDialog:onCancel( event )
	if event.name == "ended" then
		self:close(false)
	end
end

function DefaultDialog:onComfirm( event )
	if event.name == "ended" then
		self:close(true)
	end
end
