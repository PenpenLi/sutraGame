
----------------------------------------------------------
-- @desc:下载图片的缓存管理器
-- @eg:
-- ImageCacheCtrl:getImage(imageURL, function(fileName)
--     roomImg:loadTexture(fileName)
-- end)
----------------------------------------------------------

local ImageCacheCtrl = class("ImageCacheCtrl", HotRequire(luaFile.CtrlBase))

function ImageCacheCtrl:ctor( ... )
    self.super.ctor(self, ... )

    self:init()
end

function ImageCacheCtrl:init()

    -- 默认的缓存路径，创建路径
    self.cachePath = device.writablePath ..  "cache/"
    if not cc.FileUtils:getInstance():isDirectoryExist(self.cachePath) then
        cc.FileUtils:getInstance():createDirectory(self.cachePath)
    end

    -- 缓存容量
    self.cacheCapacity = 100

    -- 缓存时长（天数）
    self.cacheDay = 7

    -- 加载缓存信息
    self.cacheData = self:loadCacheData() or {}
    --dump(self.cacheData)

    -- 每次启动gc一次，删除七天前的缓存
    self:gcCache()
end

--[[
    加载图片缓存信息
--]]
function ImageCacheCtrl:loadCacheData()
    return CacheUtil:getCacheVal(CacheType.ImageCacheData)
end

--[[
    保存图片缓存信息
--]]
function ImageCacheCtrl:saveCacheData(cacheData)
    CacheUtil:setCacheVal(CacheType.ImageCacheData, cacheData or {})
end

--[[
    根据文件名称判断是否存在缓存表中
    @param 图片名称
    @return 存在：true、位置，不存在：false
--]]
function ImageCacheCtrl:exist(fileName)
    for i = 1, #self.cacheData do
        if self.cacheData[i].fileName == fileName then
            return true, i
        end
    end
    return false
end

--[[  
    向图片缓存表中插入数据  
    @param 图片名称
--]]
function ImageCacheCtrl:insertCache(fileName)
    -- 删除老数据
    for i = #self.cacheData, 1, -1 do
        if self.cacheData[i].fileName == fileName then
            table.remove(self.cacheData, i)
        end
    end

    -- 超过缓存上限，清除第一个元素（通常最久未更新时间戳）
    if #self.cacheData > self.cacheCapacity then
        table.remove(self.cacheData, 1)
        -- 删除本地缓存图片
    end

    table.insert(self.cacheData, {
        time = self:getCurrentMillis(),
        fileName = fileName
    })
    
    self:saveCacheData(self.cacheData)
end

-- 删除缓存
function ImageCacheCtrl:deleteCache(fileName)
    -- 删除缓存表数据
    for i = #self.cacheData, 1, -1 do
        if self.cacheData[i].fileName == fileName then
            table.remove(self.cacheData, i)
        end
    end

    -- 删除对应文件
    if cc.FileUtils:getInstance():isFileExist(fileName) then
        local cmd
        if (device.platform == "windows") then
            cmd = "DEL /Q " .. self.cachePath .. fileName -- "cache\\"
        else
            cmd = "rm -r " .. self.cachePath .. fileName -- "cache/"
        end
        os.execute(cmd)
    end

    self:saveCacheData(self.cacheData)
end

-- 通过url获取图片，通过回调返回图片名称
function ImageCacheCtrl:getImage(url, callback)
    self:downloadImage(url, callback)
end

--[[
    下载缓存图片
    @param url 下载图片的URL地址
           callback 调用下载处的回调函数地址
--]]
function ImageCacheCtrl:downloadImage(url, callback)  
    if not url then
        return
    end

    -- 下载目标文件名（url的md5值 + 扩展名）
    local md5 = cc.CGame:getMD5(url)
    local extension = string.match(url, ".+%.(%w+)$") or "" -- 扩展名
    local fileName = device.writablePath .. "cache/" .. md5 .. "." .. extension

    if cc.FileUtils:getInstance():isFileExist(fileName) and self:exist(fileName) then
        callback(fileName)
    elseif cc.FileUtils:getInstance():isFileExist(fileName) and (not self:exist(fileName)) then
        -- 重新加入缓存表
        self:insertCache(fileName)
        callback(fileName)
    else
        -- 清除对应数据
        self:deleteCache(fileName)
        -- 下载资源
        cc.CGame:HttpDownloadImage(url, fileName, function(code, fileName)
            if code == 200 then
                --print("image download completed")
                self:insertCache(fileName)
                callback(fileName)
            else
                print("image dowmload fail")
            end
        end)
    end
end

function ImageCacheCtrl:downloadFile(url, callback)
    if not url then
        return
    end

    -- 下载目标文件名（url的md5值 + 扩展名）
    local md5 = cc.CGame:getMD5(url)
    local extension = string.match(url, ".+%.(%w+)$") or "" -- 扩展名
    local fileName = device.writablePath .. "cache/" .. md5 .. "." .. extension

    cc.CGame:HttpDownloadFile(url, fileName, function(code, fileName)
		if code == 200 then
			--print("image download completed")
			callback(fileName)
		else
			print("file dowmload fail")
		end
	end)
end

--[[
    根据需要删除缓存图片，释放存储空间
--]]
function ImageCacheCtrl:gcCache()
    for i = #self.cacheData, 1, -1 do
        local recordTime = self.cacheData[i].time  
        local currentTime = self:getCurrentMillis()
        local fileName = self.cacheData[i].fileName

        if currentTime - recordTime > self.cacheDay * 24 * 3600 * 1000
            or (not cc.FileUtils:getInstance():isFileExist(fileName)) then  
            self:deleteCache(fileName)
        end
    end
end

--[[
    得到当前时间戳
--]]
function ImageCacheCtrl:getCurrentMillis( ... )
    return os.time() * 1000
end

return ImageCacheCtrl
