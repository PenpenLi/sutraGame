--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

local display = {}
local director = cc.Director:getInstance()
local view = director:getOpenGLView()

if not view then
    local width = stage_width
    local height = stage_height
	
    if CC_DESIGN_RESOLUTION then
        if CC_DESIGN_RESOLUTION.width then
            width = CC_DESIGN_RESOLUTION.width
        end
        if CC_DESIGN_RESOLUTION.height then
            height = CC_DESIGN_RESOLUTION.height
        end
    end
    view = cc.GLViewImpl:createWithRect("Cocos2d-Lua", cc.rect(0, 0, width, height))
    director:setOpenGLView(view)
end

local framesize = view:getFrameSize()
local textureCache = director:getTextureCache()
local spriteFrameCache = cc.SpriteFrameCache:getInstance()
local animationCache = cc.AnimationCache:getInstance()

-- auto scale
local function checkResolution(r)
    r.width = checknumber(r.width)
    r.height = checknumber(r.height)
    r.autoscale = string.upper(r.autoscale)
    assert(r.width > 0 and r.height > 0,
        string.format("display - invalid design resolution size %d, %d", r.width, r.height))
end

local function setDesignResolution(r, framesize)
    if r.autoscale == "SHOW_ALL" then
        view:setDesignResolutionSize(framesize.width, framesize.height, cc.ResolutionPolicy.SHOW_ALL)
    else
        local scaleX, scaleY = framesize.width / r.width, framesize.height / r.height
        local width, height = framesize.width, framesize.height
        if r.autoscale == "FIXED_WIDTH" then
            width = framesize.width / scaleX
            height = framesize.height / scaleX
            view:setDesignResolutionSize(width, height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "FIXED_HEIGHT" then
            width = framesize.width / scaleY
            height = framesize.height / scaleY
            view:setDesignResolutionSize(width, height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "EXACT_FIT" then
            view:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.EXACT_FIT)
        elseif r.autoscale == "NO_BORDER" then
            view:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "SHOW_ALL" then
            view:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.SHOW_ALL)
        else
			view:setDesignResolutionSize(r.width, r.height, 0)
            --printError(string.format("display - invalid r.autoscale \"%s\"", r.autoscale))
        end
    end
end


--本套适配适用于无边框模式
local function setConstants()
    local sizeInPixels = view:getFrameSize()
	local viewsize = director:getWinSize()

    --适配缩放值
    display._scaleX = view:getScaleX()
    display._scaleY = view:getScaleY()

	local visibleOrigin = view:getVisibleOrigin()--可显示区域的原点
    display.frameSize = {width = sizeInPixels.width/display._scaleX, height = sizeInPixels.height/display._scaleY}--实际可视屏幕分辨率大小（无边框适配模式为可视窗口大小）
    display.contentScaleFactor = director:getContentScaleFactor()
    display.winSize = {width = viewsize.width, height = viewsize.height}--实际使用分辨率大小，即可用大小
	
    display.visibleRect = { 
    leftBottom={x=visibleOrigin.x, y=visibleOrigin.y}, 
    leftTop={x=visibleOrigin.x, y=display.winSize.height-visibleOrigin.y},
    rightTop={x=display.winSize.width-visibleOrigin.x, y=display.winSize.height-visibleOrigin.y},
    rightBottom={x=display.winSize.width-visibleOrigin.x, y=visibleOrigin.y},
	center={x=visibleOrigin.x+display.winSize.width/2.0, y=visibleOrigin.y+display.winSize.height/2.0},
    }

    display.visibleRect.leftCenter={}
    display.visibleRect.leftCenter.x = display.visibleRect.leftBottom.x
    display.visibleRect.leftCenter.y = display.visibleRect.leftBottom.y + (display.visibleRect.leftTop.y-display.visibleRect.leftBottom.y)/2

    display.visibleRect.rightCenter={}
    display.visibleRect.rightCenter.x = display.visibleRect.rightBottom.x
    display.visibleRect.rightCenter.y = display.visibleRect.rightBottom.y + (display.visibleRect.rightTop.y-display.visibleRect.rightBottom.y)/2

    display.visibleRect.center={}
    display.visibleRect.center.x = display.visibleRect.leftBottom.x + (display.visibleRect.rightBottom.x-display.visibleRect.leftBottom.x)/2
    display.visibleRect.center.y = display.visibleRect.leftBottom.y + (display.visibleRect.leftTop.y-display.visibleRect.leftBottom.y)/2
    
    display.visibleRect.bottomCenter={}
    display.visibleRect.bottomCenter.x = display.visibleRect.leftBottom.x + (display.visibleRect.rightBottom.x-display.visibleRect.leftBottom.x)/2
    display.visibleRect.bottomCenter.y = display.visibleRect.leftBottom.y

    display.visibleRect.topCenter={}
    display.visibleRect.topCenter.x = display.visibleRect.leftTop.x + (display.visibleRect.rightTop.x-display.visibleRect.leftTop.x)/2
    display.visibleRect.topCenter.y = display.visibleRect.leftTop.y

    --实际可视屏幕显示Rect(即适配后，中间可以显示到屏幕的区域)

	
    local sizeInPixels = view:getFrameSize()
    display.sizeInPixels = {width = sizeInPixels.width, height = sizeInPixels.height}

    local viewsize = director:getWinSize()
	display.viewsize = viewsize
    display.contentScaleFactor = director:getContentScaleFactor()
    display.size               = {width = viewsize.width, height = viewsize.height}
    display.width              = display.size.width
    display.height             = display.size.height
    display.cx                 = display.width / 2
    display.cy                 = display.height / 2
    display.c_left             = -display.width / 2
    display.c_right            = display.width / 2
    display.c_top              = display.height / 2
    display.c_bottom           = -display.height / 2
    display.left               = 0
    display.right              = display.width
    display.top                = display.height
    display.bottom             = 0
    
    display.left_top           = cc.p(display.left, display.top)
    display.left_bottom        = cc.p(display.left, display.bottom)
    display.left_center        = cc.p(display.left, display.cy)
    display.right_top          = cc.p(display.right, display.top)
    display.right_bottom       = cc.p(display.right, display.bottom)
    display.right_center       = cc.p(display.right, display.cy)
    display.top_center         = cc.p(display.cx, display.top)
    display.bottom_center      = cc.p(display.cx, display.bottom)
	display.center     		   = cc.p(display.cx, display.cy)
	
    printInfo(string.format("# display.sizeInPixels         = {width = %0.2f, height = %0.2f}", display.sizeInPixels.width, display.sizeInPixels.height))
    printInfo(string.format("# display.size                 = {width = %0.2f, height = %0.2f}", display.size.width, display.size.height))
    printInfo(string.format("# display.contentScaleFactor   = %0.2f", display.contentScaleFactor))
    printInfo(string.format("# display.width                = %0.2f", display.width))
    printInfo(string.format("# display.height               = %0.2f", display.height))
    printInfo(string.format("# display.cx                   = %0.2f", display.cx))
    printInfo(string.format("# display.cy                   = %0.2f", display.cy))
    printInfo(string.format("# display.left                 = %0.2f", display.left))
    printInfo(string.format("# display.right                = %0.2f", display.right))
    printInfo(string.format("# display.top                  = %0.2f", display.top))
    printInfo(string.format("# display.bottom               = %0.2f", display.bottom))
    printInfo(string.format("# display.c_left               = %0.2f", display.c_left))
    printInfo(string.format("# display.c_right              = %0.2f", display.c_right))
    printInfo(string.format("# display.c_top                = %0.2f", display.c_top))
    printInfo(string.format("# display.c_bottom             = %0.2f", display.c_bottom))
    printInfo(string.format("# display.center               = {x = %0.2f, y = %0.2f}", display.center.x, display.center.y))
    printInfo(string.format("# display.left_top             = {x = %0.2f, y = %0.2f}", display.left_top.x, display.left_top.y))
    printInfo(string.format("# display.left_bottom          = {x = %0.2f, y = %0.2f}", display.left_bottom.x, display.left_bottom.y))
    printInfo(string.format("# display.left_center          = {x = %0.2f, y = %0.2f}", display.left_center.x, display.left_center.y))
    printInfo(string.format("# display.right_top            = {x = %0.2f, y = %0.2f}", display.right_top.x, display.right_top.y))
    printInfo(string.format("# display.right_bottom         = {x = %0.2f, y = %0.2f}", display.right_bottom.x, display.right_bottom.y))
    printInfo(string.format("# display.right_center         = {x = %0.2f, y = %0.2f}", display.right_center.x, display.right_center.y))
    printInfo(string.format("# display.top_center           = {x = %0.2f, y = %0.2f}", display.top_center.x, display.top_center.y))
    printInfo(string.format("# display.top_bottom           = {x = %0.2f, y = %0.2f}", display.bottom_center.x, display.bottom_center.y))
    printInfo("#")
	
end

function display.setAutoScale(configs)
    if type(configs) ~= "table" then return end

    checkResolution(configs)
    if type(configs.callback) == "function" then
        local c = configs.callback(framesize)
        for k, v in pairs(c or {}) do
            configs[k] = v
        end
        checkResolution(configs)
    end

    setDesignResolution(configs, framesize)

    printInfo(string.format("# design resolution size       = {width = %0.2f, height = %0.2f}", configs.width, configs.height))
    printInfo(string.format("# design resolution autoscale  = %s", configs.autoscale))
    setConstants()
end

if type(CC_DESIGN_RESOLUTION) == "table" then
    display.setAutoScale(CC_DESIGN_RESOLUTION)
end

display.COLOR_WHITE = cc.c3b(255, 255, 255)
display.COLOR_BLACK = cc.c3b(0, 0, 0)
display.COLOR_RED   = cc.c3b(255, 0, 0)
display.COLOR_GREEN = cc.c3b(0, 255, 0)
display.COLOR_BLUE  = cc.c3b(0, 0, 255)

display.AUTO_SIZE      = 0
display.FIXED_SIZE     = 1
display.LEFT_TO_RIGHT  = 0
display.RIGHT_TO_LEFT  = 1
display.TOP_TO_BOTTOM  = 2
display.BOTTOM_TO_TOP  = 3

display.CENTER        = cc.p(0.5, 0.5)
display.LEFT_TOP      = cc.p(0, 1)
display.LEFT_BOTTOM   = cc.p(0, 0)
display.LEFT_CENTER   = cc.p(0, 0.5)
display.RIGHT_TOP     = cc.p(1, 1)
display.RIGHT_BOTTOM  = cc.p(1, 0)
display.RIGHT_CENTER  = cc.p(1, 0.5)
display.CENTER_TOP    = cc.p(0.5, 1)
display.CENTER_BOTTOM = cc.p(0.5, 0)

display.DEFAULT_TTF_FONT        = "Arial"
display.DEFAULT_TTF_FONT_SIZE   = 32

local RECT_ZERO = cc.rect(0, 0, 0, 0)



function display.resetRelativePosition()
	local sizeInPixels = view:getFrameSize()
    display.sizeInPixels = {width = sizeInPixels.width, height = sizeInPixels.height}
	--display.sizeInPixels = {width = 1920, height =1080}
	local viewsize = director:getWinSize()
	display.winSize = {width = viewsize.width, height = viewsize.height}
	display.stageSize = {width=CC_DESIGN_RESOLUTION.width, height=CC_DESIGN_RESOLUTION.height}
	
	local sx = display.sizeInPixels.width/display.stageSize.width
	local sy = display.sizeInPixels.height/display.stageSize.height
	
		
	local s = math.min(sx, sy)
	
	
	local lb = {x=0, y=0}
	local rt = {x=display.stageSize.width, y=display.stageSize.height}
	local bx,by = 0, 0
	if sx < sy then
		by = display.sizeInPixels.height - s*display.stageSize.height
		by = by/2.0
		lb.y = lb.y - by/s
		rt.y = rt.y + by/s 
	else
		bx = display.sizeInPixels.width - s*display.stageSize.width
		bx = bx/2.0
		lb.x = lb.x - bx/s
		rt.x = rt.x + bx/s 
	end
	
	display.viewSize = {width = rt.x - lb.x , height = rt.y - lb.y}
	display.left_bottom = cc.p(lb.x, lb.y)
	display.left_center = cc.p(lb.x, lb.y+display.viewSize.height/2.0)
	display.left_top = cc.p(lb.x, lb.y+display.viewSize.height)
	display.bottom_center = cc.p(lb.x+display.viewSize.width/2.0, lb.y)
	display.center = cc.p(lb.x+display.viewSize.width/2.0, lb.y+display.viewSize.height/2.0)
	display.top_center = cc.p(lb.x+display.viewSize.width/2.0, rt.y)
	display.right_bottom = cc.p(rt.x, lb.y)
	display.right_center = cc.p(rt.x, lb.y+display.viewSize.height/2.0)
	display.right_top = cc.p(rt.x, rt.y)
	
	
	local screen_resolution = display.sizeInPixels.width/display.sizeInPixels.height
	local min_res = 99.99
	for k,v in pairs(_SUPPORT_RESOLUTION_) do
		local plot = v[1]/v[2]
		local off = math.abs(screen_resolution - plot)
		if min_res > off then
			display.perfect_resolution = v
			min_res = off
		end
	end
	
	
	log("display.resetRelativePosition",sx,sy,s,bx,by)
	log("sizeInPixels", display.sizeInPixels)
	log("winSize", display.winSize)
	log("stageSize", display.stageSize)
	log("viewSize", display.viewSize)
	
	display.relativeScale = s
	display.stageStartPos = {x=bx, y=by}
	
end
--display.resetRelativePosition()



return display
