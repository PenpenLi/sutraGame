
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
	for i=0,2 do
		performWithDelay(cocosMake.getRunningScene(), function()
            ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.win, false), 70)
        end, i*5.0)
	end
	
	
	--胜利
	if result then
		local snum = UserData:getSutraNum() + (UserData:getTodayCanSong() and 1 or 0)
		self.sutraTotalCount:setString(snum)
		--[[local animateNode = new_class(luaFile.AnimationSprite, {
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
		end)--]]
		
		--UserData:setTool_lotus( 1 )
	else
		self.sutraOverBoard:setVisible(false)
		self.shibaiBoard:setVisible(true)
	end
	
	self:jingwenAnim(12)
	
	
	self:dispatchEvent({name = GlobalEvent.SUTRAOVER_VIEW_SHOW, data={view=self}})
	
	UserData:songToday(param.id, param.fojuScore, param.clickCount)
	
	if result then
		UserData:setTodayCanSong(false)
	end
	
	self.scorePanel:setOpacity(0)
	local action_list1 = {}
	action_list1[#action_list1 + 1] = cc.FadeIn:create(1.0)
	action_list1[#action_list1 + 1] = cc.DelayTime:create(11.0)
	action_list1[#action_list1 + 1] = cc.FadeOut:create(1.0)
	local action1 = cc.Sequence:create(unpack(action_list1))
	self.scorePanel:runAction(action1)
	self.score:setString(param.fojuScore)
end


function sutraOverBoardView:jingwenAnim(overTime)
	local txtNum = 8
	local moveX = -10
	local posY = 850
	local degeX = 500/(txtNum)
	local offset = 130
	local movetime = 1.3
	local moveDelayInFront = 0
	if txtNum*movetime <= overTime then
		moveDelayInFront = overTime - (txtNum*movetime)
		moveDelayInFront = moveDelayInFront/txtNum
	else
		movetime = overTime/txtNum
	end
	for i=1, txtNum do
		local sprpath = string.format("res/songOver/%02d.png", i)
		local txt = cocosMake.newSprite(sprpath)
		txt:setPosition(offset+degeX*(txtNum-i)-moveX+degeX/2, posY)
		txt:setOpacity(0)
		self:addChild(txt)
		
		local function callBackFunc()
			local actionMove = cc.MoveBy:create(movetime, cc.p(moveX, 0))
			local actionFade = cc.FadeOut:create(movetime)
			local actionSpawn = cc.Spawn:create(actionMove, actionFade)
			txt:runAction(cc.Sequence:create(actionSpawn, cc.RemoveSelf:create()))
		end
		
		local actionMove = cc.MoveBy:create(movetime, cc.p(moveX, 0))
		local actionFade = cc.FadeIn:create(movetime)
		local actionSpawn = cc.Spawn:create(actionMove, actionFade)
		local delay1 = cc.DelayTime:create((i-1)*movetime + (i-1)*moveDelayInFront)
		txt:runAction(cc.Sequence:create(delay1, actionSpawn))
		
		local delay2 = cc.DelayTime:create(overTime)
		txt:runAction(cc.Sequence:create(delay2, cc.CallFunc:create(callBackFunc)))
	end
	
	if not UserData:getTodayCanSong() then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(overTime + movetime), cc.CallFunc:create(function ()
			LayerManager.closeFloat(self)
		end)))
		
		self.sutraOverBoard:setVisible(false)
		self.shibaiBoard:setVisible(false)
		self.closeBtn:setVisible(false)
		self.touchLayer:setVisible(false)
	end
end

function sutraOverBoardView:onClose( ... )
	self:dispatchEvent({name = GlobalEvent.SUTRAOVER_VIEW_SHOW, data={view=nil}})
end

function sutraOverBoardView:bgTouch()
end

function sutraOverBoardView:closeBtnClick(event)
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	LayerManager.closeFloat(self)
end




return sutraOverBoardView
