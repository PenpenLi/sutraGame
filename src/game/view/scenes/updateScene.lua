
local UpdateScene = class("UpdateScene", cocosMake.Scene)

function UpdateScene:ctor(param)
	-- 更新控制器
	self.contrl = param

	self:enableNodeEvents()
end

function UpdateScene:onEnter()
	-- 创建界面
	self:createUI()
	
	self.version:setString(GAME_VERSION)
end

function UpdateScene:onExit()
	if self.scheduleHandler then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleHandler)
		self.scheduleHandler = nil
	end
end

-- 创建界面
function UpdateScene:createUI()
	local node = cc.CSLoader:createNode("UpdateUI.csb")
    self:addChild(node)
	node:setScale(display.relativeScale)
	node:setPosition(display.stageStartPos.x, display.stageStartPos.y)
	
	WidgetHelp:dealChildren(self)
    local loadingNode = cc.CSLoader:createNode("UpdateLoadingUI.csb")
    self.update_panel:addChild(loadingNode)
    loadingNode:setPosition(cc.p(stage_width/2.0, 120.0))
	WidgetHelp:dealChildren(self.update_panel, self)
	
	-- 进度条设置成九宫格形式
	self.loading_bar:setScale9Enabled(true)

	-- 默认不展示更新界面（先要检测更新）
	self.loading_tip_text:setVisible(true)
	self.update_tip_panel:setVisible(false)
	self.update_panel:setVisible(false)

	-- 初始化进度条百分比
    self:setUpdatePercent(0)

    -- 点击取消按钮直接进入游戏
    self.cancel_btn:onTouch(handler(self, self.onCancelBtnTouch))

    -- 点击更新按钮开始更新
    self.confirm_btn:onTouch(handler(self, self.onConfirmBtnTouch))


    self.scheduleHandler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
    	self.loadingTextDotCount = self.loadingTextDotCount or 0
    	self.loadingTextDotCount = self.loadingTextDotCount + 1
    	if self.loadingTextDotCount > 4 then
    		self.loadingTextDotCount = 0
    	end

    	local dotStr = ""
    	for i = 1, self.loadingTextDotCount, 1 do
    		dotStr = dotStr .. "."
    	end
    	self.loading_tip_text:setString(string.format("检测版本更新%s", dotStr))
	end, 0.3, false)
end

-- 取消按钮点击
function UpdateScene:onCancelBtnTouch(event)
	if event.name == "ended" then
		self.contrl:enterGame()
	end
end

-- 确定按钮点击
function UpdateScene:onConfirmBtnTouch(event)
	if event.name == "ended" then
		
		if self.contrl.updateType == UpdateType.SUPER_PACKAGE_UPDATE 
				or self.contrl.updateType == UpdateType.NORMAL_PACKAGE_UPDATE then -- 整包更新
			-- 调用android/ios方法得到当前包的渠道号
			local packgeUrlKey = ""
			if TARGET_PLATFORM == cc.PLATFORM_OS_WINDOWS then
				packgeUrlKey = "packageUrlApk"
			elseif TARGET_PLATFORM == cc.PLATFORM_OS_IPHONE then
				packgeUrlKey = "packageUrlIpa"
        	elseif TARGET_PLATFORM == cc.PLATFORM_OS_ANDROID then
        		-- 调用android方法得到当前包的渠道号
        		local channel = ""
        		packgeUrlKey = "packageUrlApk" .. channel
        	end

			if self.contrl.remoteVersionData and self.contrl.remoteVersionData[packgeUrlKey] then
        		cc.Application:getInstance():openURL(self.contrl.remoteVersionData[packgeUrlKey])
			else
				-- language.package_url_error = "跳转链接出问题，请到应用商店下载最新包"
				TipView:showTip(language.package_url_error, TipView.tipType.ERROR, self)
			end
		elseif self.contrl.updateType == UpdateType.CAN_SKIP_HOT_UPDATE 
				or self.contrl.updateType == UpdateType.UN_SKIP_HOT_UPDATE then -- 热更新
			self.contrl:startUpdate()
		end
	end
end

-- 设置更新loading百分比
function UpdateScene:setUpdatePercent(percent)
	self.loading_txt:setString(string.format("%s%%", percent))
    self.loading_bar:setPercent(percent)
    -- 发光动画位置调整
   	self.loading_light:setPositionX(self.bg_bar_img:getContentSize().width * percent * 0.01)
end

-- 显示更新进度界面
function UpdateScene:showUpdateLoading()
	self.update_panel:setVisible(true)
	self.update_tip_panel:setVisible(false)
	self.loading_tip_text:setVisible(false)
	-- 进度条发光动画
	self.loadingAnimation = new_class(luaFile.AnimationSprite, Resources.animation.loadingLight)
    self.loadingAnimation:playForever()
    self.light_node:addChild(self.loadingAnimation)
end

-- 得到更新size的字符串表示
function UpdateScene:getSizeStr(size)
	size = tonumber(size) or 0

	local strSize = ""
	if size > 1048576 then
		strSize = string.format("%.02fMB", size / 1048576)
	elseif size > 1024 then
		strSize = string.format("%.02fKB", size / 1024)
	else
		strSize = string.format("%sB", size)
	end
	return strSize
end

-- 展示更新提示界面
function UpdateScene:showTipUpdate(updateType, versionData)
	-- 更新提示对话框
	self.loading_tip_text:setVisible(false)
	self.update_tip_panel:setVisible(true)
	self.update_panel:setVisible(false)

	if updateType == UpdateType.SUPER_PACKAGE_UPDATE or updateType == UpdateType.NORMAL_PACKAGE_UPDATE then -- 整包更新
		-- language.found_new_package = "发现整包更新，请前往下载！"
		self.tip_txt:setString(language.found_new_package)
		self.size_txt:setVisible(false)

		-- 隐藏取消按钮强制更新
		self.cancel_btn:setVisible(false)
		self.confirm_btn:setPositionX((self.cancel_btn:getPositionX() + self.confirm_btn:getPositionX()) / 2)
	elseif updateType == UpdateType.CAN_SKIP_HOT_UPDATE or updateType == UpdateType.UN_SKIP_HOT_UPDATE then -- 热更新
		local size = 0
		if versionData and versionData.compSize and versionData.compSize[self.contrl.localVersion] then
			size = versionData.compSize[self.contrl.localVersion]
		end
		self.size_txt:setString(self.size_txt:getString() .. self:getSizeStr(size))

		if updateType == UpdateType.UN_SKIP_HOT_UPDATE then
			-- 隐藏取消按钮强制更新
			self.cancel_btn:setVisible(false)
			self.confirm_btn:setPositionX((self.cancel_btn:getPositionX() + self.confirm_btn:getPositionX()) / 2)
		end
	end
end

return UpdateScene
