------------------------------------

------------------------------------
CacheUtil = CacheUtil or {}
CacheType = {
    signDay = "_signDay_",
	incenseDay = "_incenseDay_",
	songDay = "_songDay_",
	birthday = "_birthday_",
	buddhasLightDay = "_buddhasLightDay_",
	buddhasLightLevel = "_buddhasLightLevel_",--佛光等级
	ImageCacheData = "_ImageCacheData_",
	tools = "_tools_",
	usedTool = "_usedTool_",
	buddhasId = "_buddhasId_",
	selectSongs = "_selectSongs_",
}

	
CacheVal = {
    [CacheType.signDay] =           {default = {}, encrypt = true},
	[CacheType.incenseDay] =           {default = {}, encrypt = true},
	[CacheType.songDay] =           {default = {}, encrypt = true},
	[CacheType.birthday] =           {default = 0, encrypt = true},
	[CacheType.buddhasLightDay] =           {default = 0, encrypt = true},
	[CacheType.buddhasLightLevel] =           {default = 3, encrypt = true},
	[CacheType.tools] =           	{default = "", encrypt = false},
	[CacheType.usedTool] =           {default = "1", encrypt = false},
	[CacheType.buddhasId] =           {default = "nwamtf", encrypt = false},
	[CacheType.selectSongs] =           {default = 1, encrypt = false},
	
	[CacheType.ImageCacheData] =           {default = {}, encrypt = true},
}


toBoolean = function(val)
    if val == "true" then
        return true
    elseif val == "false" then
        return false
    else
        return nil
    end
end

local function valueToString(val)
	local valType = type(val)
	if valType == "string" then
		return val
	elseif valType == "number" then
		return tostring(val)
	elseif valType == "boolean" then
		return val and "true" or "false"
	elseif valType == "table" then
		return table.serialize(val)
	end
end
local function stringToType(val, valType)
	if not val then
		return nil
	elseif valType == "string" then
		return val
	elseif valType == "number" then
		return tonumber(val)
	elseif valType == "boolean" then
		return toBoolean(val)
	elseif valType == "table" then
		return table.unserialize(val)
	end
end

function CacheUtil:getCacheVal(key)
    -- 本地未读取到数据或读取错误，默认返回的串
    local defaultStr = Base64.encode(valueToString(CacheVal[key].default), BASE64_ENCRYPT_KEY)
    -- 读取到的本地数据（加密的数据）
    local encodeCacheStr = cc.UserDefault:getInstance():getStringForKey(key, defaultStr)
    -- 解密读取到的本地数据
    local cacheStr = CacheVal[key].encrypt and Base64.decode(encodeCacheStr, BASE64_ENCRYPT_KEY) or encodeCacheStr

	return stringToType(cacheStr, type(CacheVal[key].default)) or CacheVal[key].default
end

function CacheUtil:setCacheVal(key, val)
    -- value值类型错误
	assert(CacheVal[key], string.format("key is not register!"))
    --assert(type(CacheVal[key].default) == type(val), string.format("value type error!"))
	val = val or CacheVal[key].default

    -- 转换成string类型
    local cacheStr
    if type(CacheVal[key].default) == "boolean" 
            or type(CacheVal[key].default) == "number"
            or type(CacheVal[key].default) == "string" then
        cacheStr = tostring(val)
    elseif type(CacheVal[key].default) == "table" then
        cacheStr = table.serialize(val)
    end

    -- 加密
    local encodeCacheStr = CacheVal[key].encrypt and Base64.encode(cacheStr, BASE64_ENCRYPT_KEY) or cacheStr

    -- 写入已加密串到本地
    cc.UserDefault:getInstance():setStringForKey(key, encodeCacheStr)
    cc.UserDefault:getInstance():flush()
end

--自定义数据（加密）
function CacheUtil:getCustomCacheVal(key, valueType, defaultVal)
	local val = cc.UserDefault:getInstance():getStringForKey(key, tostring(defaultVal or ""))
	val = Base64.decode(val, BASE64_ENCRYPT_KEY)
	if valueType == "number" then return tonumber(val) end
	if valueType == "string" then return tostring(val) end
	if valueType == "boolean" then return toBoolean(val) end
	if valueType == "table" then return table.unserialize(val) or {} end
end
function CacheUtil:setCustomCacheVal(key, val)
	local valType = type(val)
	local cacheVal = DeepCopy(val)
    if valType == "boolean" or valType == "number" or valType == "string" then
        cacheVal = tostring(cacheVal)
    elseif valType == "table" then
        cacheVal = table.serialize(cacheVal)
    end

    -- 加密
    local encodeCacheStr = Base64.encode(cacheVal, BASE64_ENCRYPT_KEY) or cacheVal

    -- 写入已加密串到本地
    cc.UserDefault:getInstance():setStringForKey(key, encodeCacheStr)
    cc.UserDefault:getInstance():flush()
end

