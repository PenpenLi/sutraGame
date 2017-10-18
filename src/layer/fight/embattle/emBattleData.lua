emBattleData = emBattleData or {}
emBattleData.isInit = false

local siteMax = 9
local siteMult = 3
local maxSoldierCharacter = 15

--默认朝向为右
function emBattleData:init()
    if emBattleData.isInit then
         return
    end

    self:initFrontLeaderEM()
    self:initBackLeaderEM()
end

function emBattleData:initFrontLeaderEM()
    self.frontLeaderEM_Info = {}
    for i=1,siteMax do 
        self.frontLeaderEM_Info[i] = {}
        self.frontLeaderEM_Info[i].own = {soldier={},leader={}}
        self.frontLeaderEM_Info[i].enemy = {soldier={},leader={}}
    end

    self:initfrontLeaderEM_own()
    self:initfrontLeaderEM_enemy()
end

function emBattleData:initBackLeaderEM()
    self.backLeaderEM_Info = {}
    for i=1,siteMax do 
        self.backLeaderEM_Info[i] = {}
        self.backLeaderEM_Info[i].own = {soldier={},leader={}}
        self.backLeaderEM_Info[i].enemy = {soldier={},leader={}}
    end

    self:initBackLeaderEM_own()
    self:initBackLeaderEM_enemy()
end

function emBattleData:getScaleBySite(site)
    local v = (site-1)%siteMult
    local res = 1 - v*0.1
    return res
end
function emBattleData:getfrontLeaderEM_own_solider_withSite(site)
    if site > #self.frontLeaderEM_Info or site < 0 then
        return
    end
    return self.frontLeaderEM_Info[site].own.soldier
end
function emBattleData:getfrontLeaderEM_enemy_solider_withSite(site)
    if site > #self.frontLeaderEM_Info or site < 0 then
        return
    end
    return self.frontLeaderEM_Info[site].enemy.soldier
end
function emBattleData:getfrontLeaderEM_own_leader_withSite(site)
    if site > #self.frontLeaderEM_Info or site < 0 then
        return
    end
    return self.frontLeaderEM_Info[site].own.leader
end
function emBattleData:getfrontLeaderEM_enemy_leader_withSite(site)
    if site > #self.frontLeaderEM_Info or site < 0 then
        return
    end
    return self.frontLeaderEM_Info[site].enemy.leader
end



function emBattleData:initfrontLeaderEM_own()
    local bPos_own = {x = 919 - 80, y = 224 + BATTLE_MAP_Y_OFFSET}--第一个site的pos(右下角)
    local cInter = {x=-260, y=0}--武将间隔
    local vInter = {x=-58, y=153}
    
    for li=1,siteMax do
        local cNum = math.floor( (li-1)/siteMult )--一列中的第几个
        local vNum = (li-1)%siteMult--一排中的第几个

        local lx = cInter.x*cNum + vInter.x*vNum + bPos_own.x

        local ly = cInter.y*cNum + vInter.y*vNum + bPos_own.y

        local siteZ = (siteMax/siteMult-cNum)*10--由上往下，层级递+

        self.frontLeaderEM_Info[li].own.leader = {x=lx,y=ly,z=siteZ+2}

        local arr = {}
        local function initSolider(arr)
            local cInter = {x=-35, y=0}--横向
            local vInter = {x=-11, y=24}--纵向
            local mult = 5

            local leaderOffset = {x = -81 - vInter.x*2, y = -vInter.y*2}--武将相对第一个兵的offset

            for i=1,maxSoldierCharacter do
                local cNum = math.floor( (i-1)/mult )
                local vNum = (i-1)%mult

                local x = (self:getScaleBySite(li)*cInter.x)*cNum + vInter.x*vNum + ( (1-self:getScaleBySite(li))*cInter.x )
                local y = cInter.y*cNum + vInter.y*vNum
                local z = maxSoldierCharacter - vNum + siteZ
                table.insert( arr, {x=x,y=y,z=z} )
            end

            for i=1,#arr do
                arr[i].x = arr[i].x + (1+(1-self:getScaleBySite(li)))*leaderOffset.x + lx
                arr[i].y = arr[i].y + leaderOffset.y + ly
            end
        end
        initSolider(arr)
        self.frontLeaderEM_Info[li].own.soldier = arr
    end
end

function emBattleData:initfrontLeaderEM_enemy()

    local bPos_own = {x = 1526 - 80, y = 224 + BATTLE_MAP_Y_OFFSET}--第一个site的pos(左下角)
    local cInter = {x=260, y=0}--武将间隔
    local vInter = {x=-61, y=153}

    for li=1,siteMax do
        local cNum = math.floor( (li-1)/siteMult )
        local vNum = (li-1)%siteMult

        local lx = cInter.x*cNum + vInter.x*vNum + bPos_own.x
        local ly = cInter.y*cNum + vInter.y*vNum + bPos_own.y

        local siteZ = (siteMax/siteMult-cNum)*10--由上往下，层级递+

        self.frontLeaderEM_Info[li].enemy.leader = {x=lx,y=ly,z=siteZ+2}

        local arr = {}
        local function initSolider(arr)
            local cInter = {x=35, y=0}--横向
            local vInter = {x=-11, y=24}--纵向
            local mult = 5

            local leaderOffset = {x = 81 - vInter.x*2, y = -vInter.y*2}--武将相对第一个兵的offset

            for i=1,maxSoldierCharacter do
                local cNum = math.floor( (i-1)/mult )
                local vNum = (i-1)%mult

                local x = (self:getScaleBySite(li)*cInter.x)*cNum + vInter.x*vNum
                local y = cInter.y*cNum + vInter.y*vNum
                local z = maxSoldierCharacter - vNum + siteZ
                table.insert( arr, {x=x,y=y,z=z} )
            end

            for i=1,#arr do
                arr[i].x = arr[i].x + leaderOffset.x + lx
                arr[i].y = arr[i].y + leaderOffset.y + ly
            end
        end
        initSolider(arr)
        self.frontLeaderEM_Info[li].enemy.soldier = arr
    end
end

function emBattleData:getBackLeaderEM_own_solider_withSite(site)
    if site > #self.backLeaderEM_Info or site < 0 then
        return
    end
    return self.backLeaderEM_Info[site].own.soldier
end
function emBattleData:getBackLeaderEM_enemy_solider_withSite(site)
    if site > #self.backLeaderEM_Info or site < 0 then
        return
    end
    return self.backLeaderEM_Info[site].enemy.soldier
end
function emBattleData:getBackLeaderEM_own_leader_withSite(site)
    if site > #self.backLeaderEM_Info or site < 0 then
        return
    end
    return self.backLeaderEM_Info[site].own.leader
end
function emBattleData:getBackLeaderEM_enemy_leader_withSite(site)
    if site > #self.backLeaderEM_Info or site < 0 then
        return
    end
    return self.backLeaderEM_Info[site].enemy.leader
end

function emBattleData:initBackLeaderEM_own()
    local bPos_own = {x = 919 - 80, y = 224 + BATTLE_MAP_Y_OFFSET}--第一个site的pos(右下角)
    local cInter = {x=-260, y=0}--武将间隔
    local vInter = {x=-58, y=153}
    
    for li=1,siteMax do
        local cNum = math.floor( (li-1)/siteMult )--一列中的第几个
        local vNum = (li-1)%siteMult--一排中的第几个

        local lx = cInter.x*cNum + vInter.x*vNum + bPos_own.x

        local ly = cInter.y*cNum + vInter.y*vNum + bPos_own.y

        local siteZ = (siteMax/siteMult-cNum)*10--由上往下，层级递+

        self.backLeaderEM_Info[li].own.leader = {x=lx,y=ly,z=siteZ+2}

        local arr = {}
        local function initSolider(arr)
            local cInter = {x=-35, y=0}--横向
            local vInter = {x=-11, y=24}--纵向
            local mult = 5

            local leaderOffset = {x = 131 - vInter.x*2, y = -vInter.y*2}--武将相对第一个兵的offset

            for i=1,maxSoldierCharacter do
                local cNum = math.floor( (i-1)/mult )
                local vNum = (i-1)%mult

                local x = (self:getScaleBySite(li)*cInter.x)*cNum + vInter.x*vNum
                local y = cInter.y*cNum + vInter.y*vNum
                local z = maxSoldierCharacter - vNum + siteZ
                table.insert( arr, {x=x,y=y,z=z} )
            end

            for i=1,#arr do
                arr[i].x = arr[i].x + self:getScaleBySite(li)*leaderOffset.x + lx
                arr[i].y = arr[i].y + leaderOffset.y + ly
            end
        end
        initSolider(arr)
        self.backLeaderEM_Info[li].own.soldier = arr
    end
end

function emBattleData:initBackLeaderEM_enemy()

    local bPos_own = {x = 1526 - 80, y = 224 + BATTLE_MAP_Y_OFFSET}--第一个site的pos(左下角)
    local cInter = {x=260, y=0}--武将间隔
    local vInter = {x=-61, y=153}

    for li=1,siteMax do
        local cNum = math.floor( (li-1)/siteMult )
        local vNum = (li-1)%siteMult

        local lx = cInter.x*cNum + vInter.x*vNum + bPos_own.x
        local ly = cInter.y*cNum + vInter.y*vNum + bPos_own.y

        local siteZ = (siteMax/siteMult-cNum)*10--由上往下，层级递+

        self.backLeaderEM_Info[li].enemy.leader = {x=lx,y=ly,z=siteZ+2}

        local arr = {}
        local function initSolider(arr)
            local cInter = {x=35, y=0}--横向
            local vInter = {x=-11, y=24}--纵向
            local mult = 5

            local leaderOffset = {x = -101 - vInter.x*2, y = -vInter.y*2}--武将相对第一个兵的offset

            for i=1,maxSoldierCharacter do
                local cNum = math.floor( (i-1)/mult )
                local vNum = (i-1)%mult
                
                local x = (self:getScaleBySite(li)*cInter.x)*cNum + vInter.x*vNum
                local y = cInter.y*cNum + vInter.y*vNum
                local z = maxSoldierCharacter - vNum + siteZ
                table.insert( arr, {x=x,y=y,z=z} )
            end

            for i=1,#arr do
                arr[i].x = arr[i].x + self:getScaleBySite(li)*leaderOffset.x + lx
                arr[i].y = arr[i].y + leaderOffset.y + ly
            end
        end
        initSolider(arr)
        self.backLeaderEM_Info[li].enemy.soldier = arr
    end
end
