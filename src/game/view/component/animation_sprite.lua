
-- 帧动画类
local AnimationSprite = class("AnimationSprite", cocosMake.Sprite)

-- @param startFrameIndex -- 开始帧索引
-- @param isReversed -- 是否反转
-- @param plistFileName -- plist文件
-- @param pngFileName -- png文件
-- @param pattern -- 帧名称模式串
-- @param frameNum -- 帧数
-- @param rate -- 金币出现
-- @param stay -- 是否停留（是否从cache中移除纹理）
-- @param indexFormat -- 整数位数
function AnimationSprite:ctor(param)
	self:enableNodeEvents()

	-- 参数处理
	self.param = param
	self.param.startFrameIndex = self.param.startFrameIndex or 1
	self.param.isReversed = self.param.isReversed or false
	self.param.rate = self.param.rate or 0.05
	self.param.indexFormat = self.param.indexFormat or 0

	-- 参数检查
    assert(cc.FileUtils:getInstance():isFileExist(self.param.plistFileName), "plist file is not exist !"..self.param.plistFileName)
    assert(cc.FileUtils:getInstance():isFileExist(self.param.pngFileName), "png file is not exist !"..self.param.pngFileName)
    assert(self.param.pattern, "animation config \"pattren\" is nil !")
    assert(self.param.frameNum, "animation config \"frameNum\" is nil !")

    -- 加载纹理
    cocosMake.loadSpriteFrames(self.param.plistFileName, self.param.pngFileName)

    -- 创建动画
    self.framesAnim = cocosMake.newAnimation(
    	self.param.pattern, self.param.startFrameIndex, 
    	self.param.frameNum, self.param.isReversed, 
    	self.param.rate, self.param.indexFormat
    )
    self.animate = cc.Animate:create(self.framesAnim)
    self.frames = self.framesAnim:getFrames()
end

-- 单次播放动画
-- @Access public
-- @param isRemove 播放完毕是否移除
-- @param delay    延迟播放（单位为S）
-- @param callback 播放完毕回调
function AnimationSprite:playOnce(isRemove, delay, callback)
	delay = delay or 0
	assert(self.animate, "AnimationSprite create faild !")

	-- 执行动作
	local delayAction = cc.DelayTime:create(delay)
	local callFunc = cc.CallFunc:create(function ()
		-- 从父节点移除
		if isRemove then
			self:removeFromParent()
		end

		-- 回调
		if callback then
			callback()
		end
	end)
	
	-- 创建动画
    self.framesAnim = cocosMake.newAnimation(
    	self.param.pattern, self.param.startFrameIndex, 
    	self.param.frameNum, self.param.isReversed, 
    	self.param.rate, self.param.indexFormat
    )
    self.animate = cc.Animate:create(self.framesAnim)
	self.frames = self.framesAnim:getFrames()
	self:runAction(cc.Sequence:create(delayAction, self.animate, callFunc))
end

-- 循环播放动画
-- @Access public
function AnimationSprite:playForever()
	assert(self.animate, "AnimationSprite create faild !")

	local repeatForever = cc.RepeatForever:create(self.animate)
	self:runAction(repeatForever)
end

function AnimationSprite:onEnter()

end

function AnimationSprite:onExit()
	
end

function AnimationSprite:onCleanup()
	-- 从缓存移除资源
	if not self.param.stay then
    	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(self.param.plistFileName)
    	for i,v in ipairs(self.frames) do
    		cc.Director:getInstance():getTextureCache():removeTexture(v:getSpriteFrame():getTexture())
    	end

	    self.animate = nil
	    self.framesAnim = nil
	    self.frames = nil
	    collectgarbage("collect")
	end
end

return AnimationSprite
