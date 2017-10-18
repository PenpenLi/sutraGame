--公式演算
roleHelper = roleHelper or {}

function roleHelper.getCacheFrameAvatar(frameName, action, isReversed)
    local actionData = DataManager.getFightSoldierFramesData(frameName)
    local actionName = frameName .. "/" .. frameName .. "-" .. action
	local anim,framesize = cocosMake.newAnimation(actionName, 0, actionData[action], isReversed or false, fight_soldier_frames_play_rate)
    return anim,framesize
end

function roleHelper.getCacheSkeletonAvatar(skeletonName, scale)
    local json = SKELETON_AVATAR_UI_PATH .. "/" .. skeletonName ..".json"
    local atlas = SKELETON_AVATAR_UI_PATH .. "/" .. skeletonName ..".atlas"
    local skeleton = sp.SkeletonAnimation:create(json, atlas, scale or 1)
    return skeleton
end

local bulletCache_frameCountCache = {}
function roleHelper.getCacheBulletSpriteFrames(bulletName, framesType, isReversed)
    if not g_fightLogic:getCache():isCacheFrames(BULLET_FRAMES_UIPATH .. "/" .. bulletName .. "/" .. framesType) then
        --print("未缓存getCacheBulletSpriteFrames.bulletName:"..bulletName..",framesType:"..framesType)
        return nil
    end

    if not bulletCache_frameCountCache[bulletName..framesType] then
        local dataFilename = BULLET_FRAMES_UIPATH .. "/" .. bulletName .. "/" .. framesType .. ".plist"
        local plistInfo = cc.FileUtils:getInstance():getValueMapFromFile(dataFilename)
        local frame_count = table.nums(plistInfo.frames)
        bulletCache_frameCountCache[bulletName..framesType] = frame_count
    end

    local frame_count = bulletCache_frameCountCache[bulletName..framesType]
    local anim,frameSize = cocosMake.newAnimation(bulletName .. "/" .. framesType .. "/", 1, frame_count, isReversed or false, fight_skill_frames_play_rate, 3)
    return anim, frameSize
end

local SkillEffCache_frameCountCache = {}
function roleHelper.getCacheSkillEffectSpriteFrames(skillEff, framesType, isReversed)
    if not g_fightLogic:getCache():isCacheFrames(SKILLEFFECT_FRAMES_UIPATH .. "/" .. skillEff .. "/" .. framesType) then
        --print("未缓存getCacheSkillEffectSpriteFrames.skillEff:"..skillEff..",framesType:"..framesType)
        return nil
    end

    if not SkillEffCache_frameCountCache[skillEff..framesType] then
        local dataFilename = SKILLEFFECT_FRAMES_UIPATH .. "/" .. skillEff .. "/" .. framesType .. ".plist"
        local plistInfo = cc.FileUtils:getInstance():getValueMapFromFile(dataFilename)
        local frame_count = table.nums(plistInfo.frames)
        SkillEffCache_frameCountCache[skillEff..framesType] = frame_count
    end

    local frame_count = SkillEffCache_frameCountCache[skillEff..framesType]
    local anim,frameSize = cocosMake.newAnimation(skillEff .. "/" .. framesType .. "/", 1, frame_count, isReversed or false, fight_skill_frames_play_rate, 3)
    return anim, frameSize
end

local buffFrameAnimCache_frameCountCache = {}
function roleHelper.getCacheBuffEffectSpriteFrames(buffEff, isReversed)
    if not g_fightLogic:getCache():isCacheFrames(FRAMES_EFFECT_ANIMATION_PATH .. "/" .. buffEff) then
        --print("未缓存getCacheBuffEffectSpriteFrames.buffEff:"..buffEff)
        return nil
    end

    if not buffFrameAnimCache_frameCountCache[buffEff] then
        local dataFilename = FRAMES_EFFECT_ANIMATION_PATH .. "/" .. buffEff .. ".plist"
        local plistInfo = cc.FileUtils:getInstance():getValueMapFromFile(dataFilename)
        local frame_count = table.nums(plistInfo.frames)
        buffFrameAnimCache_frameCountCache[buffEff] = frame_count
    end

    local frame_count = buffFrameAnimCache_frameCountCache[buffEff]
    local anim,frameSize = cocosMake.newAnimation(buffEff .. "/", 1, frame_count, isReversed or false, fight_skill_frames_play_rate, 3)
    return anim, frameSize
end

function roleHelper.getCacheSkillComboEffectSpriteFrames(tp, scaleTime)
    local eff = ""
    if tp == 1 then
        eff = "skill_jiaodiguang"
    elseif tp == 2 then
        eff = "skill_beiguang"
    end
    if not buffFrameAnimCache_frameCountCache[eff] then
        local dataFilename = SKILLEFFECT_FRAMES_UIPATH .. "/combo/" .. eff .. ".plist"
        local plistInfo = cc.FileUtils:getInstance():getValueMapFromFile(dataFilename)
        local frame_count = table.nums(plistInfo.frames)
        buffFrameAnimCache_frameCountCache[eff] = frame_count
    end

    local frame_count = buffFrameAnimCache_frameCountCache[eff]
    local r = fight_skill_frames_play_rate*(scaleTime or 1)
    print(r, fight_skill_frames_play_rate, scaleTime)
    local anim,frameSize = cocosMake.newAnimation(eff .. "/", 1, frame_count, isReversed or false, r, 3)
    return anim, frameSize
end