local SkillObject = class("SkillObject", require(luaFile.SkillBase))


local skill_type = {}
skill_type.all = 0--所有单位
skill_type.difang = 1--敌方单位
skill_type.wofang = 2--我方单位
skill_type.randomLeader = 3--随机敌方英雄目标
skill_type.random = 4--随机敌方目标
skill_type.currentAttackSingle = 5--当前攻击目标
skill_type.currentAttackRange = 6--当前攻击目标及其周围【伤害范围】
skill_type.currentAttackWithLeader = 7--当前攻击目标所属军团的武将
skill_type.myself = 8--施法者自身
skill_type.myselfWithSolders = 9--施法者自身及其带领的士兵。
skill_type.difangAll = 9--敌方全体
skill_type.wofangAll = 10--我方全体


function SkillObject:ctor(param)
end

function SkillObject:getTargetObject()
    local target = {}
   
    local skillType = self.skillInfo.releaseAim
    if skill_type.difangAll == skillType then
        target = self:attack_difangAll_target()

    elseif skill_type.wofangAll == skillType then
        target = self:attack_wofangAll_target()

    elseif skill_type.wofang == skillType then
        target = self:attack_wofang_target()

    elseif skill_type.difang == skillType then
        target = self:attack_difang_target()
    
    elseif skill_type.randomLeader == skillType then
        target = self:attack_randomDifangLeader_target()

    elseif skill_type.random == skillType then
        target = self:attack_randomDifang_target()

    end
    return target
end

function SkillObject:getPowerTargetList(...)
    local targetObjectList = {}
   
    local skillType = self.skillInfo.releaseAim
    if skill_type.difangAll == skillType then
        targetObjectList = self:attack_difangAll(...)

    elseif skill_type.wofangAll == skillType then
        targetObjectList = self:attack_wofangAll(...)

    elseif skill_type.wofang == skillType then
        targetObjectList = self:attack_wofang(...)

    elseif skill_type.difang == skillType then
        targetObjectList = self:attack_difang(...)
    
    elseif skill_type.randomLeader == skillType then
        targetObjectList = self:attack_randomDifangLeader(...)

    elseif skill_type.random == skillType then
        targetObjectList = self:attack_randomDifang(...)

    end
    
    return targetObjectList
end

function SkillObject:attack_difangAll()
    local enemyList = self.camp == ObjectDefine.Camp.own and  self.objectManager_:getEnemyObjectList() or self.objectManager_:getOwnObjectList()
    return enemyList
end
function SkillObject:attack_difangAll_target()
    local enemyList = self.camp == ObjectDefine.Camp.own and  self.objectManager_:getEnemyObjectList() or self.objectManager_:getOwnObjectList()
    local t = nil
    for k,v in pairs(enemyList) do
        t=v
        break
    end
    return t
end

function SkillObject:attack_difang()
    local objList = self.camp == ObjectDefine.Camp.own and  self.objectManager_:getEnemyObjectList() or self.objectManager_:getOwnObjectList()
    if string.len(self.skillInfo.hurtRange) == 0 then
        return self.objectManager_:objectIsLife(self.selectTargetKey) and {self.selectTarget} or {}
    end
    local enemyList = {}
    local tmp = string.split(self.skillInfo.hurtRange,"_")
    local a,b,r = tonumber(tmp[1]), tonumber(tmp[2]), tonumber(tmp[3])
    local x,y = self.owner:getPosition()
    local selfPos = cc.p(x,y)
    local ex,ey

    if r == 360 then
        for k,v in pairs(objList) do
            ex,ey = v:getPosition()
            local sa = (1 - math.abs(ey - y)/b)*a--x边
            local sb = (1 - math.abs(ex - x)/a)*b--y边
            local sc = math.sqrt( math.pow(sa,2) + math.pow(sb,2) )
            local dis = cc.pGetDistance(selfPos, cc.p(ex,ey))
            if dis < sc then table.insert(enemyList, v) end
        end
    else
        local ownerDir = self.owner:getDirection()--方向
        local rng = r/2/90
        rng = b*rng--Y轴上下允许范围
        local obj2List = {}
        if ownerDir == ObjectDefine.Direction.left then
            for k,v in pairs(objList) do
                ex,ey = v:getPosition()
                if math.abs(ey-y) < rng and ex < x then
                    local sa = (1 - math.abs(ey - y)/b)*a--x边
                    local sb = (1 - math.abs(ex - x)/a)*b--y边
                    local sc = math.sqrt( math.pow(sa,2) + math.pow(sb,2) )
                    local dis = cc.pGetDistance(selfPos, cc.p(ex,ey))
                    if dis < sc then table.insert(enemyList, v) end
                end
            end

        else
            for k,v in pairs(objList) do
                ex,ey = v:getPosition()
                if math.abs(ey-y) < rng and ex > x then
                    local sa = (1 - math.abs(ey - y)/b)*a--x边
                    local sb = (1 - math.abs(ex - x)/a)*b--y边
                    local sc = math.sqrt( math.pow(sa,2) + math.pow(sb,2) )
                    local dis = cc.pGetDistance(selfPos, cc.p(ex,ey))
                    if dis < sc then table.insert(enemyList, v) end
                end
            end
        end
    end
    return enemyList
end
function SkillObject:attack_difang_target()
    return self.owner
end

function SkillObject:attack_randomDifangLeader(x, y)
    if string.len(self.skillInfo.hurtRange) == 0 then 
        return self.objectManager_:objectIsLife(self.selectTargetKey) and {self.selectTarget} or {}
    end
    local enemyList = {}
    local tmp = string.split(self.skillInfo.hurtRange,"_")
    local a,b,r = tonumber(tmp[1]), tonumber(tmp[2]), tonumber(tmp[3])
    local tPos = cc.p(x, y)
    local ex,ey
    local objList = self.camp == ObjectDefine.Camp.own and  self.objectManager_:getEnemyObjectList() or self.objectManager_:getOwnObjectList()
    for k,v in pairs(objList) do
        ex,ey = v:getPosition()
        local sa = (1 - math.abs(ey - y)/b)*a--x边
        local sb = (1 - math.abs(ex - x)/a)*b--y边
        local sc = math.sqrt( math.pow(sa,2) + math.pow(sb,2) )
        local dis = cc.pGetDistance(tPos, cc.p(ex,ey))
        if dis < sc then table.insert(enemyList, v) end
    end
    return enemyList
end
function SkillObject:attack_randomDifangLeader_target()
    local objList = self.camp == ObjectDefine.Camp.own and  self.objectManager_:getEnemyLeaderList() or self.objectManager_:getOwnLeaderList()
    local n = table.nums(objList)
    if n == 0 then return {} end
    n = math.random(1,n)
    local obj = nil
    local ni = 1
    for k,v in pairs(objList) do
        if ni == n then
            obj=v
            break
        end
        ni=ni+1
    end

    return obj
end

function SkillObject:attack_randomDifang(x,y)
    local objList = self.camp == ObjectDefine.Camp.own and  self.objectManager_:getEnemyObjectList() or self.objectManager_:getOwnObjectList()
    if string.len(self.skillInfo.hurtRange) == 0 then 
        return self.objectManager_:objectIsLife(self.selectTargetKey) and {self.selectTarget} or {}
    end
    local enemyList = {}
    local tmp = string.split(self.skillInfo.hurtRange,"_")
    local a,b,r = tonumber(tmp[1]), tonumber(tmp[2]), tonumber(tmp[3])
    local selfPos = cc.p(x,y)
    local ex,ey
    for k,v in pairs(objList) do
        ex,ey = v:getPosition()
        local sa = (1 - math.abs(ey - y)/b)*a--x边
        local sb = (1 - math.abs(ex - x)/a)*b--y边
        local sc = math.sqrt( math.pow(sa,2) + math.pow(sb,2) )
        local dis = cc.pGetDistance(selfPos, cc.p(ex,ey))
        if dis < sc then table.insert(enemyList, v) end
    end

    return enemyList
end
function SkillObject:attack_randomDifang_target()
    local objList = self.camp == ObjectDefine.Camp.own and  self.objectManager_:getEnemyObjectList() or self.objectManager_:getOwnObjectList()
    local n = table.nums(objList)
    if n == 0 then return {} end
    n = math.random(1,n)
    local obj = nil
    local ni = 1
    for k,v in pairs(objList) do
        if ni == n then
            obj=v
            break
        end
        ni=ni+1
    end

    return obj
end

function SkillObject:attack_wofangAll()
    local enemyList = self.camp == ObjectDefine.Camp.own and self.objectManager_:getOwnObjectList() or self.objectManager_:getEnemyObjectList()
    return enemyList
end
function SkillObject:attack_wofangAll_target()
    local enemyList = self.camp == ObjectDefine.Camp.own and self.objectManager_:getOwnObjectList() or self.objectManager_:getEnemyObjectList()
    local t = nil
    for k,v in pairs(enemyList) do
        t=v
        break
    end
    return t
end

function SkillObject:attack_wofang()
    local objList = self.camp == ObjectDefine.Camp.own and self.objectManager_:getOwnObjectList() or self.objectManager_:getEnemyObjectList()
    if string.len(self.skillInfo.hurtRange) == 0 then
        return self.objectManager_:objectIsLife(self.selectTargetKey) and {self.selectTarget} or {}
    end

    local enemyList = {}
    local tmp = string.split(self.skillInfo.hurtRange,"_")
    local a,b,r = tonumber(tmp[1]), tonumber(tmp[2]), tonumber(tmp[3])
    local x,y = self.owner:getPosition()
    local selfPos = cc.p(x,y)
    local ex,ey
    for k,v in pairs(objList) do
        ex,ey = v:getPosition()
        local sa = (1 - math.abs(ey - y)/b)*a--x边
        local sb = (1 - math.abs(ex - x)/a)*b--y边
        local sc = math.sqrt( math.pow(sa,2) + math.pow(sb,2) )
        local dis = cc.pGetDistance(selfPos, cc.p(ex,ey))
        if dis < sc then table.insert(enemyList, v) end
    end
    return enemyList
end
function SkillObject:attack_wofang_target()
    return self.owner
end



function SkillObject:power()
    local targetObjectList = self:getPowerTargetList(self.targetPosX, self.targetPosY)

    local power = 100
     power = FormulaHelper.calculate(self.skillInfo.hurtFormula, self.owner)--计算伤害公式

     if not self.objectManager_:objectIsLife(self.ownerKey) then
        self:removeSelf()
        return false
    end
    --self.skillInfo.hurtType = 1--伤害类型
    --self.skillInfo.hurtRange = 100--伤害范围
    local hurtTypes = transHurtType(self.skillInfo.hurtType)
    if not targetObjectList then
        return false
    end
    for k,v in pairs(targetObjectList) do
        v:beAttackSkill(power, self.owner, hurtTypes)
    end

    --BUFF
    for i=1, #self.targetBuffList do
        for k,v in pairs(targetObjectList) do
            v:addBuff(self.targetBuffList[i])
        end
    end
    for i=1, #self.selfBuffList do
        self.owner:addBuff(self.selfBuffList[i])
    end
    self.selfBuffList = {}
    self.targetBuffList = {} --只第一次作用BUFF



    --在目标身上播放power序列帧
    if self.skillPowerEff ~= "" then
        local function finishCallback()
            self:removeSelf()
        end
        if self.camp == ObjectDefine.Camp.own then Notifier.postNotifty("notify_shakeBattleScene") end
        self:playSpriteFrames(self.skillPowerEff, "power", finishCallback)
    end
end

function SkillObject:finishCallback()
end

return SkillObject