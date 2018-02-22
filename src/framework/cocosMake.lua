
cocosMake = cocosMake or {}

cocosMake.SCENE_TRANSITIONS = {
    CROSSFADE       = cc.TransitionCrossFade,
    FADE            = {cc.TransitionFade, cc.c3b(0, 0, 0)},
    FADEBL          = cc.TransitionFadeBL,
    FADEDOWN        = cc.TransitionFadeDown,
    FADETR          = cc.TransitionFadeTR,
    FADEUP          = cc.TransitionFadeUp,
    FLIPANGULAR     = {cc.TransitionFlipAngular, cc.TRANSITION_ORIENTATION_LEFT_OVER},
    FLIPX           = {cc.TransitionFlipX, cc.TRANSITION_ORIENTATION_LEFT_OVER},
    FLIPY           = {cc.TransitionFlipY, cc.TRANSITION_ORIENTATION_UP_OVER},
    JUMPZOOM        = cc.TransitionJumpZoom,
    MOVEINB         = cc.TransitionMoveInB,
    MOVEINL         = cc.TransitionMoveInL,
    MOVEINR         = cc.TransitionMoveInR,
    MOVEINT         = cc.TransitionMoveInT,
    PAGETURN        = {cc.TransitionPageTurn, false},
    ROTOZOOM        = cc.TransitionRotoZoom,
    SHRINKGROW      = cc.TransitionShrinkGrow,
    SLIDEINB        = cc.TransitionSlideInB,
    SLIDEINL        = cc.TransitionSlideInL,
    SLIDEINR        = cc.TransitionSlideInR,
    SLIDEINT        = cc.TransitionSlideInT,
    SPLITCOLS       = cc.TransitionSplitCols,
    SPLITROWS       = cc.TransitionSplitRows,
    TURNOFFTILES    = cc.TransitionTurnOffTiles,
    ZOOMFLIPANGULAR = cc.TransitionZoomFlipAngular,
    ZOOMFLIPX       = {cc.TransitionZoomFlipX, cc.TRANSITION_ORIENTATION_LEFT_OVER},
    ZOOMFLIPY       = {cc.TransitionZoomFlipY, cc.TRANSITION_ORIENTATION_UP_OVER},
}
local PARAMS_EMPTY = {}
cocosMake.TEXTURES_PIXEL_FORMAT = {}

local director = cc.Director:getInstance()
local textureCache = director:getTextureCache()
local spriteFrameCache = cc.SpriteFrameCache:getInstance()
local animationCache = cc.AnimationCache:getInstance()
local fileUtils = cc.FileUtils:getInstance()
cocosMake.DirectorScheduler = director:getScheduler()
cocosMake.Director = director
cocosMake.textureCache = textureCache

function cocosMake.init()
    self.sceneIndex = 0
end

cocosMake.Scene = cc.Scene
function cocosMake.newScene(name, params)
    params = params or PARAMS_EMPTY
    self.sceneIndex = self.sceneIndex + 1
    if self.sceneIndex > 99999 then self.sceneIndex = 0 end

    local scene
    if not params.physics then
        scene = cc.Scene:create()
    else
        scene = cc.Scene:createWithPhysics()
    end
    scene.name_ = string.format("%s:%d", name or "<unknown-scene>", self.sceneIndex)

    if params.transition then
        scene = self:wrapSceneWithTransition(scene, params.transition, params.time, params.more)
    end

    return scene
end

function cocosMake.runScene(newScene, transition, time, more)
    if director:getRunningScene() then
        if transition then
            newScene = cocosMake.wrapScene(newScene, transition, time, more)
        end
        director:replaceScene(newScene)
    else
        director:runWithScene(newScene)
    end
end

function cocosMake.getRunningScene()
    return director:getRunningScene()
end


function cocosMake.wrapScene(scene, transition, time, more)
    local key = string.upper(tostring(transition))

    if key == "RANDOM" then
        local keys = table.keys(cocosMake.SCENE_TRANSITIONS)
        key = keys[math.random(1, #keys)]
    end

    if cocosMake.SCENE_TRANSITIONS[key] then
        local t = cocosMake.SCENE_TRANSITIONS[key]
        time = time or 0.2
        more = more or t[2]
        if type(t) == "table" then
            scene = t[1]:create(time, scene, more)
        else
            scene = t:create(time, scene)
        end
    else
        error(string.format("cocosMake.wrapScene() - invalid transition %s", tostring(transition)))
    end
    return scene
end


cocosMake.Node = cc.Node
function cocosMake.newNode()
    return cc.Node:create()
end

cocosMake.Layer = cc.Layer
cocosMake.LayerColor = cc.LayerColor
function cocosMake.newLayer(...)
    local params = {...}
    local c = #params
    local layer
    if c == 0 then
        -- /** creates a fullscreen black layer */
        -- static Layer *create();
        layer = cc.Layer:create()
    elseif c == 1 then
        -- /** creates a Layer with color. Width and height are the window size. */
        -- static LayerColor * create(const Color4B& color);
        layer = cc.LayerColor:create(cc.convertColor(params[1], "4b"))
    elseif c == 2 then
        -- /** creates a Layer with color, width and height in Points */
        -- static LayerColor * create(const Color4B& color, const Size& size);
        --
        -- /** Creates a full-screen Layer with a gradient between start and end. */
        -- static LayerGradient* create(const Color4B& start, const Color4B& end);
        local color1 = cc.convertColor(params[1], "4b")
        local p2 = params[2]
        assert(type(p2) == "table" and (p2.width or p2.r), "cocosMake.newLayer() - invalid paramerter 2")
        if p2.r then
            layer = cc.LayerGradient:create(color1, cc.convertColor(p2, "4b"))
        else
            layer = cc.LayerColor:create(color1, p2.width, p2.height)
        end
    elseif c == 3 then
        -- /** creates a Layer with color, width and height in Points */
        -- static LayerColor * create(const Color4B& color, GLfloat width, GLfloat height);
        --
        -- /** Creates a full-screen Layer with a gradient between start and end in the direction of v. */
        -- static LayerGradient* create(const Color4B& start, const Color4B& end, const Vec2& v);
        local color1 = cc.convertColor(params[1], "4b")
        local p2 = params[2]
        local p2type = type(p2)
        if p2type == "table" then
            layer = cc.LayerGradient:create(color1, cc.convertColor(p2, "4b"), params[3])
        else
            layer = cc.LayerColor:create(color1, p2, params[3])
        end
    end
    return layer
end

function cocosMake.newLayerColor(clr, posx, posy)
    local l = cc.LayerColor:create(clr or cc.c4b(0,0,0,150))
    l:setPosition(posx or 0, posy or 0)
    return l
end

--默认锚点0.5, 0.5
cocosMake.Sprite = cc.Sprite
function cocosMake.newSprite(source, x, y, params)
    local spriteClass = cc.Sprite
    local scale9 = false

    if type(x) == "table" and not x.x then
        -- x is params
        params = x
        x = nil
        y = nil
    end

    local params = params or PARAMS_EMPTY
    if params.scale9 or params.capInsets then
        spriteClass = ccui.Scale9Sprite
        scale9 = true
        params.capInsets = params.capInsets or RECT_ZERO
        params.rect = params.rect or RECT_ZERO
    end

    local sprite
    while true do
        -- create sprite
        if not source then
            sprite = spriteClass:create()
            break
        end

        local sourceType = type(source)
        if sourceType == "string" then
            if string.byte(source) == 35 then -- first char is #
                -- create sprite from spriteFrame
                if not scale9 then
                    sprite = spriteClass:createWithSpriteFrameName(string.sub(source, 2))
                else
                    sprite = spriteClass:createWithSpriteFrameName(string.sub(source, 2), params.capInsets)
                end
                break
            end

            -- create sprite from image file
            if cocosMake.TEXTURES_PIXEL_FORMAT[source] then
                cc.Texture2D:setDefaultAlphaPixelFormat(cocosMake.TEXTURES_PIXEL_FORMAT[source])
            end
            if not scale9 then
                sprite = spriteClass:create(source)
            else
                sprite = spriteClass:create(source, params.rect, params.capInsets)
            end
            if cocosMake.TEXTURES_PIXEL_FORMAT[source] then
                cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
            end
            break
        elseif sourceType ~= "userdata" then
            error(string.format("cocosMake.newSprite() - invalid source type \"%s\"", sourceType), 0)
        else
            sourceType = tolua.type(source)
            if sourceType == "cc.SpriteFrame" then
                if not scale9 then
                    sprite = spriteClass:createWithSpriteFrame(source)
                else
                    sprite = spriteClass:createWithSpriteFrame(source, params.capInsets)
                end
            elseif sourceType == "cc.Texture2D" then
                sprite = spriteClass:createWithTexture(source)
            else
                error(string.format("cocosMake.newSprite() - invalid source type \"%s\"", sourceType), 0)
            end
        end
        break
    end

    if sprite then
        if x and y then sprite:setPosition(x, y) end
        if params.size then sprite:setContentSize(params.size) end
    else
        print(string.format("cocosMake.newSprite() - create sprite failure, source \"%s\"", tostring(source)), 0)
    end
	
	if params.anchor then
		sprite:setAnchorPoint(params.anchor)
	end
    return sprite
end

function cocosMake.newLabel(text, x, y, params)
    local p = params or {size = 30, font = "Arial"}
    local label = cc.Label:createWithSystemFont(text, p.font, p.size)
    label:setPosition(x or 0, y or 0)
    return label
end

function cocosMake.newTextBMFont(text, params)
    local p = params or {font = ""}
    local label = ccui.TextBMFont:create(text, p.font)
    return label
    --local allTitle = cc.LabelBMFont:create(title,"res/fnt/fnt_title.fnt")
end

function cocosMake.newLabelTTF(text, params)
    local p = params or {font = "res/font/jlx.ttf", size = 30}
    label = cc.LabelTTF:create(text, p.font or "res/font/jlx.ttf", p.size or 30)
    return label
end

--{ttf(字库), fontsize(字体大小), color(字体颜色), outlineColor(描边颜色)}
function cocosMake.newTtfText(str, x, y, params)
	local txt = ccui.Text:create(str, params.ttf or Resources.font.msyh, params.fontsize or 17)
	if params.color then txt:setColor(params.color) end
	txt:setPosition(cc.p(x or 0, y or 0))
	if params.outlineColor then txt:enableOutline(params.outlineColor, 1) end
	return txt
end

cocosMake.ProgressTimer = cc.ProgressTimer
function cocosMake.newProgressTimer(params)
    local image = params.sprite
    local ty = params.type or kCCProgressTimerTypeBar
    local per = params.percent or 100

    local spr = cocosMake.newSprite(image)
    local progress = cc.ProgressTimer:create(spr)
    
    progress:setType(ty)
    progress:setPercentage(per)

    if ty == kCCProgressTimerTypeBar then 
        progress:setBarChangeRate(cc.p(1,0));--kCCProgressTimerTypeBar表示条形模式
    end
    return progress
end

cocosMake.UILoadingBar = ccs.UILoadingBar
function cocosMake.newUILoadingBar(params)
    local image = params.sprite
    local per = params.percent or 100

    local loadingBar = ccui.LoadingBar:create(image)
    
    loadingBar:setPercent(per)

    return loadingBar
end


function cocosMake.newButton(normalImg, pressImg, disableImg, x, y, clickCallback)
    local playButton = cc.MenuItemImage:create(normalImg, pressImg, disableImg)
        :onClicked(function()
            if clickCallback then clickCallback() end
        end)
    local btn = cc.Menu:create(playButton)
        :move(x, y)
    return btn
end

function cocosMake.newSpriteFrame(source, ...)
    local frame
    if type(source) == "string" then
        if string.byte(source) == 35 then -- first char is #
            source = string.sub(source, 2)
        end
        frame = spriteFrameCache:getSpriteFrame(source)
        if not frame then
            error(string.format("cocosMake.newSpriteFrame() - invalid frame name \"%s\"", tostring(source)), 0)
        end
    elseif tolua.type(source) == "cc.Texture2D" then
        frame = cc.SpriteFrame:createWithTexture(source, ...)
    else
        error("cocosMake.newSpriteFrame() - invalid parameters", 0)
    end
    return frame
end

function cocosMake.newFrames(pattern, begin, length, isReversed, indexFormat)
    local frames = {}
    local step = 1
    local last = begin + length - 1
    if isReversed then
        last, begin = begin, last
        step = -1
    end

    indexFormat = indexFormat or 0
    for index = begin, last, step do
        --local nstr = string.format("%03d", index)
        local nstr = string.format("%0"..indexFormat.."d", index)
        local frameName = pattern .. nstr .. ".png"
        local frame = spriteFrameCache:getSpriteFrame(frameName)
        if not frame then
            error(string.format("cocosMake.newFrames() - invalid frame name %s", tostring(frameName)), 0)
        end
        frames[#frames + 1] = frame
    end
    return frames
end

local function newAnimation(frames, time)
    local count = #frames
    assert(count > 0, "cocosMake.newAnimation() - invalid frames")
    time = time or 1.0 / count
    local framesize = frames[1]:getOriginalSizeInPixels()
    return cc.Animation:createWithSpriteFrames(frames, time),framesize
           --cc.Sprite:createWithSpriteFrame(frames[1])
end

function cocosMake.newAnimation(...)
    local params = {...}
    local c = #params
    if c == 2 then
        -- frames, time
        return newAnimation(params[1], params[2])
    elseif c == 4 then
        -- pattern, begin, length, time
        local frames = cocosMake.newFrames(params[1], params[2], params[3])
        return newAnimation(frames, params[4])
    elseif c == 5 or c == 6 then
        -- pattern, begin, length, isReversed, time
        local frames = cocosMake.newFrames(params[1], params[2], params[3], params[4], params[6])
        return newAnimation(frames, params[5])
    else
        error("cocosMake.newAnimation() - invalid parameters")
    end
end

function cocosMake.loadImage(imageFilename, callback)
    if not callback then
        return textureCache:addImage(imageFilename)
    else
        textureCache:addImageAsync(imageFilename, callback)
    end
end


function cocosMake.getImage(imageFilename)
    local fullpath = fileUtils:fullPathForFilename(imageFilename)
    return textureCache:getTextureForKey(fullpath)
end

function cocosMake.removeImage(imageFilename)
    textureCache:removeTextureForKey(imageFilename)
end

function cocosMake.loadSpriteFrames(dataFilename, imageFilename, callback)
    if cocosMake.TEXTURES_PIXEL_FORMAT[imageFilename] then
        cc.Texture2D:setDefaultAlphaPixelFormat(cocosMake.TEXTURES_PIXEL_FORMAT[imageFilename])
    end
    
    spriteFrameCache:addSpriteFrames(dataFilename, imageFilename)
    if callback then callback() end
    --[[
    if not callback then
        spriteFrameCache:addSpriteFrames(dataFilename, imageFilename)
    else
        spriteFrameCache:addSpriteFramesAsync(dataFilename, imageFilename, callback)
    end
    --]]
    if cocosMake.TEXTURES_PIXEL_FORMAT[imageFilename] then
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
    end
end

function cocosMake.removeSpriteFrames(dataFilename, imageFilename)
    spriteFrameCache:removeSpriteFramesFromFile(dataFilename)
    if imageFilename then
        cocosMake.removeImage(imageFilename)
    end
end

function cocosMake.removeSpriteFrame(imageFilename)
    spriteFrameCache:removeSpriteFrameByName(imageFilename)
end

function cocosMake.setTexturePixelFormat(imageFilename, format)
    cocosMake.TEXTURES_PIXEL_FORMAT[imageFilename] = format
end

function cocosMake.setAnimationCache(name, animation)
    animationCache:addAnimation(animation, name)
end

function cocosMake.getAnimationCache(name)
    return animationCache:getAnimation(name)
end

function cocosMake.removeAnimationCache(name)
    animationCache:removeAnimation(name)
end

function cocosMake.removeUnusedSpriteFrames()
    spriteFrameCache:removeUnusedSpriteFrames()
    textureCache:removeUnusedTextures()
end

--1.0为正常速度, 值越小速度越慢
function cocosMake.setGameSpeed(speed)
    cocosMake.gameSpeed = speed
    cocosMake.DirectorScheduler:setTimeScale(speed)
end
function cocosMake.getGameSpeed()
    return cocosMake.gameSpeed
end

function cocosMake.getFullPathForFileName(fileName)
    local fullpath = fileUtils:fullPathForFilename(fileName)
    return fullpath
end

function cocosMake.endToLua()
	if TARGET_PLATFORM == cc.PLATFORM_OS_IPHONE or TARGET_PLATFORM == cc.PLATFORM_OS_IPAD then
		CGame:exitAppForce()
	else
		cocosMake.Director:endToLua()
	end
end


cocosMake.viewBase = require(luaFile.ViewBase)
cocosMake.DialogBase = require(luaFile.DialogBase)
return cocosMake
