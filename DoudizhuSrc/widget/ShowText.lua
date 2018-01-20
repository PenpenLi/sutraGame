
--通知显示，文本显示
ShowText = class("ShowText",function()
	-- return cc.LayerColor:create(cc.c4b(0,0,0,150))
	return cc.Layer:create()
end)

function ShowText:createAndRun(txt,time)
	self = self.new()
	self:init(txt,time)
	return self
end

function ShowText:init(txt,time)
	time = time or 1.0
    --开启屏蔽层
    -- local function handler()
    --     return true
    -- end
    -- self:registerScriptTouchHandler(handler,false,0,true)
    -- self:setTouchEnabled(true)
	
	self:addToTop(txt,time)
end

--创建ui
function ShowText:initData(txt,time)
	--创建
	local lab = cc.Label:create({text = txt})
	local size = lab:getContentSize()

	local bg_sprite = cc.Sprite:create({sc9 = true,pos =VisibleRect:center(),img = "res/not_package/public/tishikuang.png",testImg = true,
							size = cc.size(size.width + 80, size.height + 35),cap = cc.rect(24,30,2,2)})
	-- local bg_sprite = Sprite:create({sc9 = true,pos =VisibleRect:center(),img = "res/ccsui/budui/black_02.png",size = cc.size(350,46),cap = cc.rect(19,19,1,1),testImg=true})
	self:addChild(bg_sprite,0,10)

	--local sp = Sprite:create({img = "",cap = cc.rect(),sc9 = true,pos = VisibleRect:center(),size })
	size = bg_sprite:getContentSize()
	lab:setPosition(cc.p(size.width/2, size.height/2))

	bg_sprite:addChild(lab,0,10)
	
	self:resetData(txt,time)
end

--重设数据
function ShowText:resetData(txt,time)
	local bg_sprite = self:getChildByTag(10)
	local lab = bg_sprite:getChildByTag(10)
	
	local action0 = cc.DelayTime:create(time)
	local action1 = cc.MoveTo:create(0.8,cc.pAdd(VisibleRect:center(),cc.p(0,30)))
	local action2 = cc.CallFunc:create(function()
		self:removeFromParent(true)
	end)
	bg_sprite:runAction(cc.Sequence:create(cc.Sequence:create(action0,action1),action2))
end

--将window添加到最上层
function ShowText:addToTop(txt,time)
    --cclog("aaaa")
	if not self.layer then
		self.layer = 20001
	end
    local scene = cc.Director:getInstance():getRunningScene()
	local textView = scene:getChildByTag(99995)
	if textView then
		textView:removeFromParent(true)
	end
	self:initData(txt,time)
	scene:addChild(self,self.layer,99995)
end



return ShowText



