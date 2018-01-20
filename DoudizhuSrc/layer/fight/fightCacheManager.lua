local fightCacheManager = class("fightCacheManager")
local FLY = "fly"
local BUFFFLY = "buff_fly"
local POWER = "power"
local BUFFPOWER = "buff_power"
local NAME = "name"

function fightCacheManager:ctor()
    self.bulletCache = {}
    self.bulletCacheCount = {}
    self.SkillEffCache = {}
    self.SkillEffCacheCount = {}
    self.buffFrameAnimCache = {}
    self.buffFrameAnimCacheCount = {}

    self.avatarSkeletonCache = {}

    --------------------
    self.avatarCache = {}
    self.textureCacheTotal = {}
    self.framesAnimTotal = {}

    self:initCache()
end

function fightCacheManager:cacheSpriteFrames(dataFileName, imageFilename, completeCallback)
    --print("缓存序列帧："..dataFileName)
    local function framesCacheCompleteCallback(res)
        --print("异步序列帧" .. dataFileName .. "完成。")
        if completeCallback then completeCallback(res == 0 and 0 or 1, 1, dataFileName) end
    end
    local function imageCompleteCallback(args)
        --print("异步缓存图片" .. imageFilename .. "完成。")
        cocosMake.loadSpriteFrames(dataFileName, imageFilename, framesCacheCompleteCallback)
        return true
    end
    if cc.FileUtils:getInstance():isFileExist(dataFileName) then
        cocosMake.loadImage(imageFilename, imageCompleteCallback)
    else
        framesCacheCompleteCallback(0)
    end
end

function fightCacheManager:cacheImage(imageFilename, completeCallback)
    if string.sub(imageFilename, -5) == "/.png" then
        local test = 0
    end
    --print("缓存图片："..imageFilename)
    local function imageCompleteCallback(res)
        --print("异步缓存图片" .. imageFilename .. "完成。")
        if completeCallback then completeCallback(res == 0 and 0 or 1, 0, imageFilename) end
    end
    if cc.FileUtils:getInstance():isFileExist(imageFilename) then
        cocosMake.loadImage(imageFilename, imageCompleteCallback)
    else
        imageCompleteCallback(0)
    end
end


function fightCacheManager:isCacheTexture(img)
    return self.textureCacheTotal[img] and self.textureCacheTotal[img] > 0
end
function fightCacheManager:isCacheFrames(img)
    return self.framesAnimTotal[img] and self.framesAnimTotal[img] > 0
end

--jobbuffeff序列帧特例
local jobBuffEff_frame_exceptive = {}
jobBuffEff_frame_exceptive["tx_attack_004b"] = true
----------------------------
--增加对角色骨骼动画的文理缓存
function fightCacheManager:addCacheAvatar(roleName, avatarType, completeCallback, param)
    local countIndex = 0
    local cacheCount = 0
    local function cachefinish(res, type, img)
        
        --print("完成资源缓存："..img.."，类型："..(res == 0 and "纹理" or "序列帧"))
        --清除没有被加载的资源列表
        if res == 0 and type == 0 then--img
            --print("资源未被缓存："..img.."，类型：纹理")
            self.avatarCache[roleName].texture[img] = math.max(0, self.avatarCache[roleName].texture[img] - 1)
            self.textureCacheTotal[img] = math.max(0, self.textureCacheTotal[img] - 1)
        end
        if res == 0 and type == 1 then--frames
            --print("资源未被缓存："..img.."，类型：序列帧")
            local imgtmp = string.sub(img, 1, string.len(img)-6)
            self.avatarCache[roleName].framesAnim[imgtmp] = math.max(0, self.avatarCache[roleName].framesAnim[imgtmp] - 1)
            self.framesAnimTotal[imgtmp] = math.max(0, self.framesAnimTotal[imgtmp] - 1)
        end

        countIndex = countIndex + 1
        if countIndex >= cacheCount then
            --这里可能会加载太快导致重复调用completeCallback
            if completeCallback then completeCallback() end
        end
    end

    if not self.avatarCache[roleName] then
        self.avatarCache[roleName] = {}
        self.avatarCache[roleName].count = 0
        self.avatarCache[roleName].type = avatarType
        self.avatarCache[roleName].texture = {}
        self.avatarCache[roleName].framesAnim = {}
    end

    --纹理缓存
    if self.avatarCache[roleName].count == 0 then
        local eff_db = DataManager.getFightAnimEffectData(roleName)
        local function cacheImageLocal(img)
            if not self.avatarCache[roleName].texture[img] then self.avatarCache[roleName].texture[img]=0 end 
            self.avatarCache[roleName].texture[img] = self.avatarCache[roleName].texture[img] + 1

            if not self.textureCacheTotal[img] then self.textureCacheTotal[img]=0 end 
            self.textureCacheTotal[img] = self.textureCacheTotal[img] + 1

            self:cacheImage(img, cachefinish)
            
        end
        local function cacheSpriteFramesLocal(img)
            if not self.avatarCache[roleName].framesAnim[img] then self.avatarCache[roleName].framesAnim[img]=0 end 
            self.avatarCache[roleName].framesAnim[img] = self.avatarCache[roleName].framesAnim[img] + 1

            if not self.framesAnimTotal[img] then self.framesAnimTotal[img]=0 end 
            self.framesAnimTotal[img] = self.framesAnimTotal[img] + 1

            self:cacheSpriteFrames(img .. ".plist", img .. ".png", cachefinish)
        end

        local needCacheTextures = {}
        local needCacheFramesAnim = {}
        local function addCacheTexture(img)
            cacheCount = cacheCount + 1
            table.insert(needCacheTextures, img)
        end
        local function addCacheFramesAnim(frames)
            cacheCount = cacheCount + 1
            table.insert(needCacheFramesAnim, frames)
        end
        if avatarType == ObjectDefine.objectType.leader then
            print("加载将领角色骨骼："..roleName)
            
            if roleName ~= "" then addCacheTexture(SKELETON_AVATAR_UI_PATH .. "/" .. roleName ..".png") end

            local tmp = string.split( eff_db.attackEff, "," )
            for k,v in pairs(tmp) do
                addCacheTexture(SKELETON_EFFECT_ANIMATION_PATH .. "/" .. v .. ".png") 
            end
            
            if eff_db.skillEff ~= "" then addCacheTexture(SKELETON_EFFECT_ANIMATION_PATH .. "/" .. eff_db.skillEff .. ".png") end

            if eff_db.bullet ~= "" then 
                addCacheFramesAnim(BULLET_FRAMES_UIPATH .. "/" .. eff_db.bullet .. "/" .. POWER)
                addCacheFramesAnim(BULLET_FRAMES_UIPATH .. "/" .. eff_db.bullet .. "/" .. FLY)
            end

            if eff_db.skillPower ~= "" then 
                addCacheFramesAnim(SKILLEFFECT_FRAMES_UIPATH .. "/" .. eff_db.skillPower .. "/" .. POWER)
                addCacheFramesAnim(SKILLEFFECT_FRAMES_UIPATH .. "/" .. eff_db.skillPower .. "/" .. FLY)
            end

            if eff_db.jobBuffEff ~= "" then
                if jobBuffEff_frame_exceptive[eff_db.jobBuffEff] then
                    addCacheFramesAnim(BULLET_FRAMES_UIPATH .. "/" .. eff_db.jobBuffEff .. "/" .. POWER)
                    addCacheFramesAnim(BULLET_FRAMES_UIPATH .. "/" .. eff_db.jobBuffEff .. "/" .. FLY)
                else
                    local tmpList = string.split( eff_db.jobBuffEff , "," )
                    for k,v in pairs(tmpList) do
                        addCacheTexture(SKELETON_EFFECT_ANIMATION_PATH .. "/" .. v .. ".png")
                    end
                end
            end

            if eff_db.attack_buff ~= "" then  addCacheFramesAnim(FRAMES_EFFECT_ANIMATION_PATH .. "/" .. eff_db.attack_buff) end

        elseif avatarType == ObjectDefine.objectType.infantry then
            print("加载士兵角色序列帧："..roleName)
            if roleName ~= "" then addCacheFramesAnim(FRAME_AVATAR_UI_PATH .. "/" .. roleName) end

            if "tx_attack_07" == eff_db.bullet then
                local test = 0
            end
            if eff_db.bullet ~= "" then 
                addCacheFramesAnim(BULLET_FRAMES_UIPATH .. "/" .. eff_db.bullet .. "/" .. POWER)
                addCacheFramesAnim(BULLET_FRAMES_UIPATH .. "/" .. eff_db.bullet .. "/" .. FLY)
            end
            
            if eff_db.jobBuffEff ~= "" then
                if jobBuffEff_frame_exceptive[eff_db.jobBuffEff] then
                    addCacheFramesAnim(BULLET_FRAMES_UIPATH .. "/" .. eff_db.jobBuffEff .. "/" .. POWER)
                    addCacheFramesAnim(BULLET_FRAMES_UIPATH .. "/" .. eff_db.jobBuffEff .. "/" .. FLY)
                else
                    local tmpList = string.split( eff_db.jobBuffEff , "," )
                    for k,v in pairs(tmpList) do
                        addCacheTexture(SKELETON_EFFECT_ANIMATION_PATH .. "/" .. v .. ".png")
                    end
                end
            end

            if eff_db.attack_buff ~= "" then addCacheFramesAnim(FRAMES_EFFECT_ANIMATION_PATH .. "/" .. eff_db.attack_buff) end
        end

        for i=1,#needCacheTextures do
            cacheImageLocal(needCacheTextures[i])
        end
        for i=1,#needCacheFramesAnim do
            cacheSpriteFramesLocal(needCacheFramesAnim[i])
        end
        self.avatarCache[roleName].count = 1
    else
        self.avatarCache[roleName].count = self.avatarCache[roleName].count + 1
        if completeCallback then completeCallback() end
    end
end

function fightCacheManager:clearAllCacheAvatar()
    for k,v in pairs(self.avatarCache) do
        self:delCacheAvatar(k)
    end
end

function fightCacheManager:delCacheAvatar(roleName)
    if not self.avatarCache[roleName] then return nil end

    self.avatarCache[roleName].count = self.avatarCache[roleName].count - 1
    if self.avatarCache[roleName].count <= 0 then
        for k,v in pairs(self.avatarCache[roleName].texture) do
            if self.textureCacheTotal[k] then
                --print("缓存准备清除纹理："..k..",v:"..v..",total:"..self.textureCacheTotal[k])
                self.textureCacheTotal[k] = self.textureCacheTotal[k] - v
                if self.textureCacheTotal[k] <= 0 then
                    cocosMake.removeImage(k)
                    --print("移除缓存纹理："..k)
                    self.textureCacheTotal[k] = nil
                end
            end
        end
        for k,v in pairs(self.avatarCache[roleName].framesAnim) do
            if self.framesAnimTotal[k] then
                --print("缓存准备清除序列帧："..k..",v:"..v..",total:"..self.framesAnimTotal[k])
                self.framesAnimTotal[k] = self.framesAnimTotal[k] - v
                if self.framesAnimTotal[k] <= 0 then
                    cocosMake.removeImage(k .. ".png")
                    cocosMake.removeSpriteFrames(k .. ".png", k .. ".plist")
                    --print("移除缓存序列帧："..k)
                    self.framesAnimTotal[k] = nil
                end
            end
        end
        self.avatarCache[roleName] = nil
    end
end

function fightCacheManager:initCache()
    local img = SKILLEFFECT_FRAMES_UIPATH .. "/combo/"

    local function cachefinish()
        self:cacheSpriteFrames(img .. "skill_jiaodiguang.plist", img .. "skill_jiaodiguang.png")
    end
    self:cacheSpriteFrames(img .. "skill_beiguang.plist", img .. "skill_beiguang.png", cachefinish)
end

function fightCacheManager:cleanAll()
    self:clearAllCacheAvatar()
    cocosMake.removeAllCacheFramesSprite()
    cocosMake.removeAllCacheTextures()
end
return fightCacheManager