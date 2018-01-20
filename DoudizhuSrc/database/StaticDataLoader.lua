require (luaFile.csvParse)


StaticDataLoader = {}

--[[
if _kSystem==kTargetWindows then
	_AbsolutePathWin32=_AbsolutePathWin32 or ""
	DIR=_AbsolutePathWin32.."/"..DIR
	DIR_CLIENT=_AbsolutePathWin32.."/"..DIR_CLIENT
end
--]]

local StaticTableList = {
	leader					= {name = "leaders", cache = nil},
    soldier					= {name = "soldier", cache = nil},
    skill_effect            = {name = "skill_effect", cache = nil},
    skill                   = {name = "skill", cache = nil},
    buff                    = {name = "buff", cache = nil},
    flyprop                 = {name = "flyprop", cache = nil},
    fight_anim_effect       = {name = "fight_anim_effect", cache = nil},--战斗角色特效配置表
    general                 = {name = "general", cache = nil},
    fight_soldier_anim_frame= {name = "fight_soldier_anim_frame", cache = nil},--士兵序列帧配置表
    copy                    = {name = "copy", cache = nil},
    smallGate               = {name = "smallGate", cache = nil},
    bigGate                 = {name = "bigGate", cache = nil},
    level                   = {name = "level", cache = nil},
    advance                 = {name = "advance", cache = nil},
    leadersQuality          = {name = "leadersQuality", cache = nil},
    generalCustomsSoldier   = {name = "gates/gate", cache = {}},--普通关卡怪物信息
    item                    = {name = "item", cache = nil},
}

--读取csv数据，为table
local function ReadCsvFileContentTable(file)
    local ret = csvParse.LoadCsv(file)
    return ret
end

--读取json数据，为table
local function ReadJsonFileContentTable(filePath)	
    require(luaFile.jsonParse)
    local ret = jsonParse.LoadJson(filePath)
    return ret
end

local function DeleteStaticDataLoaderMethod(loadMethodName)
    StaticDataLoader[loadMethodName] = nil
end

--以id为ID的数据表，模板函数
function StaticDataLoader.Template_loadCsvFile(name)
    local staticData = StaticTableList[name]
    if staticData and staticData.cache then
        return staticData.cache
    end

    local data = ReadCsvFileContentTable(staticData.name)
	if not data then 
        return nil 
    end
    
    local tab_data = {}

    for k, v in pairs(data) do
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        local id = v.id
        if id and id ~= "" then
            tab_data[id] = v
        end
    end
    
    staticData.cache = tab_data
    return tab_data
end

--技能特效
function StaticDataLoader.loadSkillEffect()
    if StaticTableList.skill_effect.cache then
        return StaticTableList.skill_effect.cache
    end

    local data = ReadJsonFileContentTable(StaticTableList.skill_effect.name)
	if not data then 
        return nil 
    end
    
    local tab_data = {}
    for k, v in pairs(data) do
        
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        local id = v.effect_id
        if id and id ~= "" then
            tab_data[id] = v
        end
    end
    StaticTableList.skill_effect.cache = tab_data

    return tab_data
end

--技能
function StaticDataLoader.loadSkillData()
    if StaticTableList.skill.cache then
        return StaticTableList.skill.cache
    end

    local data = ReadCsvFileContentTable(StaticTableList.skill.name)
	if not data then 
        return nil 
    end
    
    local tab_data = {}

    for k, v in pairs(data) do
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        local id = v.id
        if id and id ~= "" then
            tab_data[id] = v
        end
    end
    StaticTableList.skill.cache = tab_data
    return tab_data
end

--Buff
function StaticDataLoader.loadBuffData()
    if StaticTableList.buff.cache then
        return StaticTableList.buff.cache
    end

    local data = ReadCsvFileContentTable(StaticTableList.buff.name)
	if not data then 
        return nil 
    end
    
    local tab_data = {}

    for k, v in pairs(data) do
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        local id = v.id
        if id and id ~= "" then
            tab_data[id] = v
        end
    end
    StaticTableList.buff.cache = tab_data
    return tab_data
end

function StaticDataLoader.loadleadersQuality()
    local staticData = StaticTableList["leadersQuality"]
    if staticData and staticData.cache then
        return staticData.cache
    end
    local data = ReadCsvFileContentTable(staticData.name)
	if not data then 
        return nil 
    end
    
    local tab_data = {}

    for k, v in pairs(data) do
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        local id = v.quality
        if id and id ~= "" then
            tab_data[id] = v
        end
    end
    staticData.cache = tab_data
    return tab_data
end

function StaticDataLoader.loadLevel()
    local staticData = StaticTableList["level"]
    if staticData and staticData.cache then
        return staticData.cache
    end
    local data = ReadCsvFileContentTable(staticData.name)
	if not data then 
        return nil 
    end
    
    local tab_data = {}

    for k, v in pairs(data) do
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        local id = v.grade
        if id and id ~= "" then
            tab_data[id] = v
        end
    end
    staticData.cache = tab_data
    return tab_data
end

function StaticDataLoader.loadAdvance()
    local staticData = StaticTableList["advance"]
    if staticData and staticData.cache then
        return staticData.cache
    end
    local data = ReadCsvFileContentTable(staticData.name)
	if not data then 
        return nil 
    end
    
    local tab_data = {}

    for k, v in pairs(data) do
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        local id = v.leaderQuality
        local iNextId = v.advanceLevel
        if id and id ~= "" and iNextId and iNextId ~= "" then
            tab_data[id] = tab_data[id] or {}
            tab_data[id][iNextId] = v
        end
    end
    staticData.cache = tab_data
    return tab_data
end

function StaticDataLoader.loadItem()
    return StaticDataLoader.Template_loadCsvFile("item")
end

function StaticDataLoader.loadCopy()
    return StaticDataLoader.Template_loadCsvFile("copy")
end

function StaticDataLoader.loadSmallGate()
    return StaticDataLoader.Template_loadCsvFile("smallGate")
end

function StaticDataLoader.loadBigGate()
    return StaticDataLoader.Template_loadCsvFile("bigGate")
end

function StaticDataLoader.loadSoldiers()
    return StaticDataLoader.Template_loadCsvFile("soldier")
end

function StaticDataLoader.loadLeaders()
    return StaticDataLoader.Template_loadCsvFile("leader")
end

--飞行武器
function StaticDataLoader.loadFlyprop()
    return StaticDataLoader.Template_loadCsvFile("flyprop")
end

function StaticDataLoader.loadGeneral()
    return StaticDataLoader.Template_loadCsvFile("general")
end


function StaticDataLoader.loadFightAnimEffectData()
    if StaticTableList.fight_anim_effect.cache then
        return StaticTableList.fight_anim_effect.cache
    end

    local data = ReadCsvFileContentTable(StaticTableList.fight_anim_effect.name)
	if not data then 
        return nil 
    end
    
    local tab_data = {}

    for k, v in pairs(data) do
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        if v and v.role ~= "" then
            tab_data[v.role] = v
        end
        
    end
    StaticTableList.fight_anim_effect.cache = tab_data
    return tab_data
end

function StaticDataLoader.loadFightSoldierFramesData()
    if StaticTableList.fight_soldier_anim_frame.cache then
        return StaticTableList.fight_soldier_anim_frame.cache
    end

    local data = ReadCsvFileContentTable(StaticTableList.fight_soldier_anim_frame.name)
	if not data then 
        return nil 
    end
    
    local tab_data = {}

    for k, v in pairs(data) do
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        if v and v.name ~= "" then
            tab_data[v.name] = v
        end
    end

    StaticTableList.fight_soldier_anim_frame.cache = tab_data
    return tab_data
end

--获取普通关卡怪物信息
function StaticDataLoader.getcustomsSoldierInfo(id)
    if StaticTableList.generalCustomsSoldier.cache[id] then
        return StaticTableList.generalCustomsSoldier.cache[id]
    end

    local data = ReadCsvFileContentTable(StaticTableList.generalCustomsSoldier.name .. id)
	if not data then 
        return nil 
    end
    
    local tab_data = {}

    for k, v in pairs(data) do
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        if v ~= "" then
            table.insert(tab_data, v)
        end
    end
    StaticTableList.generalCustomsSoldier.cache[id] = tab_data
    return tab_data
end