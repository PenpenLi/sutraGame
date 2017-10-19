
local sutraOverBoardView = class("sutraOverBoardView", cocosMake.DialogBase)

--cocos studio生成的csb
sutraOverBoardView.ui_resource_file = {"sutraOverBoardNode"}


					
sutraOverBoardView.ui_binding_file = {
	closeBtn        = {event = "click", method = "closeBtnClick"},
}

function sutraOverBoardView:onCreate(param)
	local result = param.result
	self.sutraTotalCount:setString("")
	--[[
	for i=1, 3 do
		self["xx"..i]:setScale(0.2)
		self["xx"..i]:runAction(cc.EaseExponentialInOut:create(cc.ScaleTo:create(0.8, 1.0)))
	end
	
	local animateNode = new_class(luaFile.AnimationSprite, {
		startFrameIndex = 1,                             -- 开始帧索引
		isReversed = false,                              -- 是否反转
		plistFileName = "songOver/songOverXXEffect.plist", -- plist文件
		pngFileName = "songOver/songOverXXEffect.png",     -- png文件
		pattern = "songOverXXEffect/",                      -- 帧名称模式串
		frameNum = 7,                                   -- 帧数
		rate = 0.10,                                     -- 
		stay = true,                                    -- 是否停留（是否从cache中移除纹理）
		indexFormat = 4,                                 -- 整数位数
	})
	animateNode:playOnce(true)
	self.effectNode:addChild(animateNode)
	--]]
	for i=0,1 do
		performWithDelay(cocosMake.getRunningScene(), function() audioCtrl:playSound(audioData.win, false) end, i*5.0)
	end
	
	if result == 0 then
		self.sutraTotalCount:setString(UserData.songCount)
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
			lastspr:runAction(cc.Sequence:create(cc.FadeOut:create(1.0), cc.CallFunc:create(function() lastspr:removeFromParent() end)))
		end)
		
	elseif result == -1 then
		self.sutraOverBoard:loadTexture("songOver/sb_01.png")
		
	elseif result == 1 then
		self.sutraOverBoard:loadTexture("songOver/sb_02.png")
		
	end
	
	
	self:dispatchEvent({name = GlobalEvent.SUTRAOVER_VIEW_SHOW, data={view=self}})
end


function sutraOverBoardView:onClose( ... )
	self:dispatchEvent({name = GlobalEvent.SUTRAOVER_VIEW_SHOW, data={view=nil}})
end

function sutraOverBoardView:bgTouch()
end

function sutraOverBoardView:closeBtnClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	
	LayerManager.closeFloat(self)
end




return sutraOverBoardView
