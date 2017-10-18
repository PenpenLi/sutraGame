
local seekObjectControl = class("seekObjectControl")

local enemy = ObjectDefine.Camp.enemy
local own = ObjectDefine.Camp.own
function seekObjectControl:ctor()
    self.objMgr_ = {}

    self.policy_1v1 = {}
    self.policy_leaderProir_1v1 = {}
end

function seekObjectControl:setObjectManager(objMgr)
    self.objMgr_ = objMgr
end

function seekObjectControl:removeObject1(key, camp)
    self.policy_1v1[key] = nil

    self.policy_leaderProir_1v1[key] = nil
    for k,v in pairs(self.policy_leaderProir_1v1) do
        if v == key then self.policy_leaderProir_1v1[k] = 0 end
    end
end


--寻找敌方目标(最短距离寻找)
function seekObjectControl:seekObject1(obj, seekCamp)
    local enemyList = {}
    if seekCamp == ObjectDefine.Camp.enemy then
        enemyList = self.objMgr_:getEnemyObjectList()
    elseif seekCamp == ObjectDefine.Camp.own then
        enemyList = self.objMgr_:getOwnObjectList()
    end
    local selfPosX,selfPosY = obj:getPosition()
    local minDistance = 99999
    local seekObjectKey = 0

    for k,v in pairs(enemyList) do
        local vTp = v:getType()
        if vTp == ObjectDefine.objectType.infantry or 
        vTp == ObjectDefine.objectType.leader then
            local vPosX,vPosY = v:getPosition()
            local dis = cc.pGetDistance(cc.p(selfPosX, selfPosY), cc.p(vPosX,vPosY))
            if dis < minDistance then
                seekObjectKey = v:getKey()
                minDistance = dis
            end
        end
    end
    
    return enemyList[seekObjectKey]
end

--开始先寻找最近的敌将，再寻找敌方目标(1V1)优先同一排作为攻击目标，然后再选其它角色
function seekObjectControl:seekObject2(obj, seekCamp)
    local enemyList = {}
    if seekCamp == ObjectDefine.Camp.enemy then
        enemyList = self.objMgr_:getEnemyObjectList()
    elseif seekCamp == ObjectDefine.Camp.own then
        enemyList = self.objMgr_:getOwnObjectList()
    end

    
    --寻找距离最近的敌将
    local targetOkey = self.policy_leaderProir_1v1[obj:getKey()]
    if not targetOkey then
        local selectRole = nil
        local selectDistance = 999999
        for k,v in pairs(enemyList) do
            if v:isLeader() then
                local dis = cc.pGetDistance(cc.p(obj:getPositionX(), obj:getPositionY()), cc.p(v:getPositionX(), v:getPositionY()))
                if dis < selectDistance then
                    selectDistance = dis 
                    selectRole = v
                end
            end
        end
        if selectRole then
            self.policy_leaderProir_1v1[obj:getKey()] = selectRole:getKey()
            return selectRole
        else
            self.policy_leaderProir_1v1[obj:getKey()] = 0
        end

    else
        
        if targetOkey ~= 0 and self.objMgr_:objectIsLife(targetOkey) then
            return enemyList[targetOkey]
        end
    end

    local function selectObjBySite(sSite)
        local function getRandomObjWithList(list)
            if #list > 0 then
                local randomKey = math.random(1, #list)
                local selectObj = list[randomKey]
                self.policy_1v1[selectObj:getKey()] = true
                return selectObj
            end
        end

        local objListTmp = {}
        for k,v in pairs(enemyList) do
            if not v:isDead() and v:canBeSeek() and v.site == sSite and not self.policy_1v1[v:getKey()] then--v没有在 攻击对象列表中
               table.insert(objListTmp, v)
            end
        end

        local target = getRandomObjWithList(objListTmp)
        if target then return target end

        objListTmp = {}
        for k,v in pairs(enemyList) do
            if not v:isDead() and v.site == sSite then--v没有在 攻击对象列表中
               table.insert(objListTmp, v)
            end
        end
        target = getRandomObjWithList(objListTmp)
        if target then return target end
    end

    local mySite = obj.site
    local selectObj = nil
    selectObj = selectObjBySite(mySite)
    if selectObj then
        return selectObj
    end
    

    local sSite = mySite + 3
    while(sSite <= 9)
    do
        selectObj = selectObjBySite(sSite)
        if selectObj then
            return selectObj
        end
        sSite = sSite + 3
    end

    sSite = mySite + 1
    while(sSite <= 9)
    do
        selectObj = selectObjBySite(sSite)
        if selectObj then
            return selectObj
        end
        sSite = sSite + 1
    end

    --这一排都没有目标了，随机选其它的
    objListTmp = {}
    for k,v in pairs(enemyList) do
        if not v:isDead() then
            table.insert(objListTmp, v)
        end
    end
    if #objListTmp > 0 then
        local randomKey = math.random(1, #objListTmp)
        local selectObj = objListTmp[randomKey]
        return selectObj
    end
end


local seekState_1 = 1
local seekState_2 = 2
local seekState_3 = 3
local max_site = 9


--先干掉同排的最近的第一个兵团，再干掉同排其它兵团，目标随机选一个，同排干掉再选择最近的目标
--期间如果角色被除当前攻击的兵团之外的角色攻击，且距离离自己比当前攻击的目标还近，则攻击目标改为这个角色，切换目标的机会只有一次，下次不再切换
function seekObjectControl:seekObject3(obj, seekCamp)

    local myCamp = obj:getCamp()
    obj.seekstate = obj.seekstate or seekState_1
    

    if seekState_1 == obj.seekstate then--干掉同排最近的第一个兵团
        local siteTeam = {}
        local site = obj:getSite() - math.floor((obj:getSite()-1)/3) * 3
        local getFunc = self.objMgr_.getEnemyObjectListBySite
        if seekCamp == ObjectDefine.Camp.own then getFunc = self.objMgr_.getOwnObjectListBySite end
        
        local teamNum = 0
        while( teamNum == 0 and site < 10 )
        do
            siteTeam = DeepCopy( getFunc(self.objMgr_, site) )
            teamNum = table.nums(siteTeam)
            site = site + 3 
        end

        if teamNum == 0 then
            obj.seekstate = seekState_2

        else
            local function randomTarget()
                local r = math.random(1, teamNum)
                local index = 0
                for k,v in pairs(siteTeam) do
                    index=index+1
                    if r == index then
                        return k,v,table.nums(siteTeam)
                    end
                end
            end
            local k,v,m = randomTarget()
            while( v and v:isDead() and m > 1 )
            do
                siteTeam[k] = nil
                k,v,m = randomTarget()
            end
            if v and not v:isDead() then
                return v
            else
                obj.seekstate = seekState_2
            end
        end
    end

    if seekState_2 == obj.seekstate then--干掉同一排最近的
        local siteTeam = {}
        local site = obj:getSite() - math.floor((obj:getSite()-1)/3) * 3
        local getFunc = self.objMgr_.getEnemyObjectListBySite
        if seekCamp == ObjectDefine.Camp.own then getFunc = self.objMgr_.getOwnObjectListBySite end

        local function addTargetList(list)
            if list then
                for k,v in pairs(list) do
                    table.insert(siteTeam, v)
                end
            end
        end
        addTargetList(getFunc(self.objMgr_, site))
        addTargetList(getFunc(self.objMgr_, site+3))
        addTargetList(getFunc(self.objMgr_, site+6))
        local teamNum = table.nums(siteTeam)
        
        if teamNum == 0 then
            obj.seekstate = seekState_3
        else
            local target = nil
            for i=1,#siteTeam do
                if not siteTeam[i]:isDead() then
                    target = siteTeam[i]
                    break
                end
            end

            if target == nil then
                obj.seekstate = seekState_3
            else
                local x,y = obj:getPosition()
                local objPos = cc.p(x, y)
                local dis = cc.pGetDistance(objPos, cc.p(target:getPosition()))
                for i=1,#siteTeam do
                    local s = cc.pGetDistance(objPos, cc.p(siteTeam[i]:getPosition()))
                    if s < dis and not siteTeam[i]:isDead() then
                        dis = s
                        target = siteTeam[i]
                    end
                end
                return target
            end
        end
    end

    if seekState_3 == obj.seekstate then--干掉其它最近的
        local findTeam = {}
        if seekCamp == ObjectDefine.Camp.enemy then
            findTeam = self.objMgr_:getEnemyObjectList()
        elseif seekCamp == ObjectDefine.Camp.own then
            findTeam = self.objMgr_:getOwnObjectList()
        end
        if 0 == table.nums(findTeam) then
            return nil
        end

        local target = nil
        for k,v in pairs(findTeam) do
            if not v:isDead() then
                target = v
                break
            end
        end
        if not target then
            return nil
        end
        local x,y = obj:getPosition()
        local objPos = cc.p(x, y)
        local ox,oy = target:getPosition()
        local dis = cc.pGetDistance(objPos, cc.p(ox,oy))
        for k,v in pairs(findTeam) do
            ox,oy = v:getPosition()
            local s = cc.pGetDistance(objPos, cc.p(ox,oy))
            if s < dis and not v:isDead() then
                dis = s
                target = v
            end
        end
        return target
    end
end


function seekObjectControl:initAI()
    --角色受击对象列表{foe存放自己的攻击目标}
    self.attackPassive_own = {}
    self.attackPassive_enemy = {}
    
    local ownList = self.objMgr_:getOwnObjectList()
    for k,v in pairs(ownList) do
        if not self.attackPassive_own[v:getSite()] then self.attackPassive_own[v:getSite()] = {} end
        self.attackPassive_own[v:getSite()][v:getKey()] = {}
    end
    local enemyList = self.objMgr_:getEnemyObjectList()
    for k,v in pairs(enemyList) do
        if not self.attackPassive_enemy[v:getSite()] then self.attackPassive_enemy[v:getSite()] = {} end
        self.attackPassive_enemy[v:getSite()][v:getKey()] = {}
    end
    self.isInitAI = true
end
function seekObjectControl:removeObject(obj, camp)
    if not self.isInitAI then return false end
    local list = camp == ObjectDefine.Camp.own and self.attackPassive_own or self.attackPassive_enemy
    local passivelist = camp == ObjectDefine.Camp.own and self.attackPassive_enemy or self.attackPassive_own

    if list[obj.site] and list[obj.site][obj.key_] and table.nums(list[obj.site][obj.key_].foe) > 0 then
        for k,v in pairs(list[obj.site][obj.key_].foe) do
            local targetSite,targetKey = v.site, v.key_
            passivelist[targetSite][targetKey][obj.key_] = nil
        end
        list[obj.site][obj.key_] = nil
    end
    
end
function seekObjectControl:seekObject(obj, seekCamp)
    local myCamp = obj:getCamp()
    obj.seekstate = obj.seekstate or seekState_1
    

    if seekState_1 == obj.seekstate then--干掉同排最近的第一个兵团
        local siteTeam = {}
        local site = obj:getSite() - math.floor((obj:getSite()-1)/3) * 3
        local getFunc = self.objMgr_.getEnemyObjectListBySite
        if seekCamp == ObjectDefine.Camp.own then getFunc = self.objMgr_.getOwnObjectListBySite end
        
        local teamNum = 0
        while( site < 10 and teamNum == 0 )
        do
            siteTeam = DeepCopy( getFunc(self.objMgr_, site) )
            teamNum = table.nums(siteTeam)
            if teamNum > 0 then
                for k,v in pairs(siteTeam) do
                    if not v:canBeSeek() then  teamNum = 0  end break
                end
                if teamNum > 0 then break end
            end
            site = site + 3
        end

        if teamNum == 0 then
            obj.seekstate = seekState_2

        else
            local palist = seekCamp == ObjectDefine.Camp.own and self.attackPassive_own or self.attackPassive_enemy
            for k,v in pairs (palist[site]) do
                if table.nums( v ) <= 0  then
                    local t = self.objMgr_:getObject(k)
                    if t and not t:isDead() and t:canBeSeek() then
                        palist[site][k][obj.key_] = true
                        return t
                    end
                end
            end

            local min = 9999
            local target = nil
            local targetk = 0
            for k,v in pairs (palist[site]) do
                local cn = table.nums(v)
                if min > cn then
                    local tt = self.objMgr_:getObject(k)
                    if tt and not tt:isDead() and tt:canBeSeek() then
                        target = tt
                        targetk = k
                        min = cn
                    end
                end
            end
            if targetk == 0 then
                obj.seekstate = seekState_2
            else
                palist[site][targetk][obj.key_] = true
                return target
            end
        end
    end

    if seekState_2 == obj.seekstate then--干掉其它最近的，找最近的
        local findTeam = {}
        if seekCamp == ObjectDefine.Camp.enemy then
            findTeam = self.objMgr_:getEnemyObjectList()
        elseif seekCamp == ObjectDefine.Camp.own then
            findTeam = self.objMgr_:getOwnObjectList()
        end
        if 0 == table.nums(findTeam) then
            return nil
        end

        local target = nil
        for k,v in pairs(findTeam) do
            if not v:isDead() and v:canBeSeek() then
                target = v
                break
            end
        end
        if not target then
            return nil
        end
        local x,y = obj:getPosition()
        local objPos = cc.p(x, y)
        local ox,oy = target:getPosition()
        local dis = cc.pGetDistance(objPos, cc.p(ox,oy))
        for k,v in pairs(findTeam) do
            ox,oy = v:getPosition()
            local s = cc.pGetDistance(objPos, cc.p(ox,oy))
            if s < dis and not v:isDead() and v:canBeSeek() then
                dis = s
                target = v
            end
        end
        return target
    end
end


return seekObjectControl