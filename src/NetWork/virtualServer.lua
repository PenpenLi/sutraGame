require "json"
require(luaFile.RequestPackpath)
require(luaFile.EventHelper)


virtualServer = {}

function virtualServer.request(pack)
    print("S")
    if virtualServer["c_"..pack._packtype] then
        return virtualServer["c_"..pack._packtype](pack)
    end
end

--selectChar_c
charid = nil
function virtualServer.c_10006(pack)
    local path = "login/selectChar_s"
    local packid = "selectChar_s"
    require ("src.NetWork.Response." .. path)
	local resPack = loadstring("return " .. packid .. ":create()")()
    resPack.charid = math.random(100000, 999999)
    if not charid then charid = resPack.charid end
    resPack.name = "测试账号"
    return resPack
end

--selectChar_c
function virtualServer.c_10022(pack)
    local path = "player/enterGame_s"
    local packid = "enterGame_s"
    require ("src.NetWork.Response." .. path)
	local resPack = loadstring("return " .. packid .. ":create()")()
    
    local playerData = {}
    playerData.name = "测试账号"
    playerData.charid = charid
    playerData.body = 1
    playerData.exp = 10000
    playerData.level = 10
    playerData.endurance = 100
    playerData.money = {1000,2000}
    playerData.lowRecruitFreeNum = 0
    playerData.highRecruitNum = 0
    playerData.leaderSoul = 0
    resPack.baseData = playerData

    return resPack
end

--leaderPacket_c
function virtualServer.c_10102(pack)
    local path = "player/leaderPacket_s"
    local packid = "leaderPacket_s"
    require ("src.NetWork.Response." .. path)
	local resPack = loadstring("return " .. packid .. ":create()")()

    resPack.result = 0
    resPack.leaderPacket = {}

    local leaderNum = math.random(1, 20)
    local basepool = {} basepool[0] = true
    local function getbaseID()
        local r = 0
        while basepool[r] do r = math.random(1000000, 9999999) end
        basepool[r] = true
        return r
    end

    local datas = DataManager.getLeaderStaticData()
    local datasNum = table.nums(datas)
    local datasBegin = math.random(1,datasNum)
    local function getLeader()
        datasBegin = datasBegin%datasNum + 1
        print("datasBegin",datasBegin)
        local index = 0
        local l = nil
        for k,v in pairs(datas) do index=index+1 if index == datasBegin then l = v break end end
        --print_lua_table(l)
        return l
    end

    local soldiers = DataManager.getSoldierStaticData()
    local soldierAmount = math.random(1,3)*5
    local function getSoldier(l)
        local soldier = {}
        local stype = l.type
        local ts = {}
        for k,v in pairs (soldiers) do if v.type == stype then table.insert(ts, v) end end
        ts = ts[math.random(1, #ts)]
        soldier.baseId = getbaseID()
        soldier.soldierId = ts.id
        soldier.level = math.random(1,5)
        soldier.quality = math.random(1,5)
        soldier.exp = 1
        soldier.amount = soldierAmount
        soldier.physicsAttack = ts.physicsAttack
        soldier.magicAttack = ts.magicAttack
        soldier.barmor = ts.barmor
        soldier.bresistance = ts.bresistance
        soldier.hp = ts.hp
        soldier.hit = ts.hit
        soldier.dodge = ts.dodge
        soldier.crit = ts.crit
        soldier.opposeCrit = ts.opposeCrit
        soldier.endHurt = ts.endHurt
        soldier.offsetHurt = ts.offsetHurt
        return soldier
    end
    for ln=1,leaderNum do
        local leaderData = {}
        local l = getLeader()
        leaderData.playerId = charid
        leaderData.baseId = getbaseID()
        leaderData.leaderId = l.id
        leaderData.level = math.random(1,20)
        leaderData.grade = math.random(1,5)
        leaderData.talentLv = math.random(1,2)
        leaderData.seat = math.random(1,9)
        leaderData.state = 1
        leaderData.exp = 1
        leaderData.soldiers = getSoldier(l)
        leaderData.physicsAttack = l.physicsAttack
        leaderData.magicAttack = l.magicAttack
        leaderData.barmor = l.barmor
        leaderData.bresistance = l.bresistance
        leaderData.hp = l.hp
        leaderData.hit = l.hit
        leaderData.dodge = l.dodge
        leaderData.crit = l.crit
        leaderData.opposeCrit = l.opposeCrit
        leaderData.endHurt = l.endHurt
        leaderData.offsetHurt = l.offsetHurt
        table.insert(resPack.leaderPacket, leaderData)
    end

    return resPack
end

--openPackage_c
function virtualServer.c_10041(pack)
   local path = "package/packageList_s"
    local packid = "packageList_s"
    require ("src.NetWork.Response." .. path)
	local resPack = loadstring("return " .. packid .. ":create()")() 
    resPack.item_list = {}
    resPack.valid_gird = {}
    return resPack
end