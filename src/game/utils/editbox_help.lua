
----------------------------------------------------------
-- author:周旭448
-- email:494084587@qq.com
-- desc:由于cocostudio中无法直接使用EditBox，此类中定义了
-- 方法，通过传入TextField根据TextField的各种属性创建一个
-- EditBox，并覆盖原来的TextField
----------------------------------------------------------

EditBoxHelp = {}

function EditBoxHelp:createEditBoxWithTextField(textField)
	if not textField then
		return
	end

	-- 创建editbox
	local editBox = ccui.EditBox:create(textField:getContentSize(), Resources.image.touming_img)
	
	-- 设置基本属性
	editBox:setVisible(textField:isVisible())
	editBox:setPosition(cc.p(textField:getPosition()))
	editBox:setAnchorPoint(textField:getAnchorPoint())

	-- 设置输入框内容 默认的“微软雅黑”
	--editBox:setText(textField:getString())
	editBox:setFont(Resources.font.msyh, textField:getFontSize())
	editBox:setFontSize(textField:getFontSize())
	editBox:setFontName(textField:getFontName())
	editBox:setFontColor(textField:getTextColor())

	-- 占位字
	editBox:setPlaceHolder(textField:getPlaceHolder())
	editBox:setPlaceholderFont(Resources.font.msyh, textField:getFontSize())
	editBox:setPlaceholderFontSize(textField:getFontSize())
	editBox:setPlaceholderFontName(textField:getFontName())
	editBox:setPlaceholderFontColor(textField:getPlaceHolderColor())

	-- 最大输入长度
	if textField:getMaxLength() > 0 then
		editBox:setMaxLength(textField:getMaxLength())
	end

	-- ANY 用户可以输入任何文本,包括换行符。
	-- EMAIL_ADDRESS 允许用户输入一个电子邮件地址。
	-- NUMERIC 允许用户输入一个整数值。
	-- PHONE_NUMBER 允许用户输入一个电话号码。
	-- URL 允许用户输入一个URL。
	-- DECIMAL 允许用户输入一个实数 通过允许一个小数点扩展了kEditBoxInputModeNumeric模式
	-- SINGLE_LINE 除了换行符以外，用户可以输入任何文本,
	editBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)

	-- cc.KEYBOARD_RETURNTYPE_DEFAULT = 0
	-- cc.KEYBOARD_RETURNTYPE_DONE = 1
	-- cc.KEYBOARD_RETURNTYPE_SEND = 2
	-- cc.KEYBOARD_RETURNTYPE_SEARCH = 3
	-- cc.KEYBOARD_RETURNTYPE_GO = 4
	editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DEFAULT)
	
	-- PASSWORD 表明输入的文本是保密的数据，任何时候都应该隐藏起来 它隐含了EDIT_BOX_INPUT_FLAG_SENSITIVE
	-- SENSITIVE 表明输入的文本是敏感数据， 它禁止存储到字典或表里面，也不能用来自动补全和提示用户输入。 一个信用卡号码就是一个敏感数据的例子。
	-- INITIAL_CAPS_WORD 这个标志的作用是设置一个提示,在文本编辑的时候，是否把每一个单词的首字母大写。
	-- INITIAL_CAPS_SENTENCE 这个标志的作用是设置一个提示,在文本编辑，是否每个句子的首字母大写。
	-- INITIAL_CAPS_ALL_CHARACTERS 自动把输入的所有字符大写。
	if textField:isPasswordEnabled() then -- 如果类型是密码
		editBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	else
		editBox:setInputFlag(-1)
	end

	editBox:setText(textField:getString())

	-- 移除textField并用editbox代替
	local zOrder = textField:getLocalZOrder()
	local parent = textField:getParent()
	textField:setTouchEnabled(false)
	textField:removeFromParent(true)
	parent:addChild(editBox, zOrder)

	-- setString方法适配
	editBox.setString = editBox.setText
	editBox.getString = editBox.getText

	return editBox
end

return EditBoxHelp
