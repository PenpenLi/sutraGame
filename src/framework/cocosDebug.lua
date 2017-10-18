
cocosDebug = {}


local function  getLuaMemory (args)
    local collectgarbageCount = collectgarbage("count")
    return collectgarbageCount
end

local function  getTextureCacheMemory (args)
    local textureInfo = cocosMake.textureCache:getCachedTextureInfo()
    return textureInfo
end

local function numberFormat(num)
        num = math.ceil(num)
        if num > 1024 then
            return num.."k("..string.format("%2.2f",num/1024).."M)"
        else
            return num.."k"
        end
    end

local function UpdateDebugLayer(duration)
    if not cocosDebug.degbugInfoLabel then
        cocosDebug.degbugInfoLabel = cocosMake.newLabel("", display.visibleRect.leftBottom.x, display.visibleRect.leftBottom.y)
        cocosDebug.degbugInfoLabel:setAnchorPoint(cc.p(0,0))
        cocosDebug.degbugInfoLabel:setScale(0.7)
        cocosMake.getRunningScene():addChild(cocosDebug.degbugInfoLabel, 99999)
    end

    local luaMem = getLuaMemory()
    local textureMem = getTextureCacheMemory()
    local memInfo = string.split(textureMem , "_" )
    local str = "lua memory:" .. numberFormat(tonumber(luaMem)) .. ", image count:" .. memInfo[1] .. ",image memory:" .. numberFormat(tonumber(memInfo[2]/1024))
    cocosDebug.degbugInfoLabel:setString(str)
end

function startCocosDegbugTicker()
    if not cocosDebug.aHand then
        cocosDebug.aHand = cocosMake.DirectorScheduler:scheduleScriptFunc(UpdateDebugLayer,0.5,false)
    end
end

function stopCocosDegbugTicker()
    if cocosDebug.aHand then
        scheduler:unscheduleScriptEntry( cocosDebug.aHand )
        cocosDebug.aHand = nil
    end

    if cocosDebug.degbugInfoLabel then
        cocosDebug.degbugInfoLabel:removeFromParent(true)
        cocosDebug.degbugInfoLabel = nil
    end
end