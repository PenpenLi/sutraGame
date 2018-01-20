
local battleObjectManager = class("battleObjectManager")

local enemy = ObjectDefine.Camp.enemy
local own = ObjectDefine.Camp.own
function battleObjectManager:ctor()
    self.serial_ = 0
    self.objectList_enemy = {}
    self.objectList_enemy_site = {}
    self.objectList_own = {}
    self.objectList_own_site = {}
    self.objectList_skill = {}
    self.seekObjectControl = new_class("layer.fight.object.seekObjectControl")
    self.seekObjectControl:setObjectManager(self)

end

function battleObjectManager:getEnemyObjectList()
    return self.objectList_enemy
end
function battleObjectManager:getOwnObjectList()
    return self.objectList_own
end

--这里可以缓存起来，下次不用再算
function battleObjectManager:getOwnLeaderList()
    local leaderList = {}
    for k,v in pairs(self.objectList_own) do
        if v:isLeader() then
            table.insert(leaderList, v)
        end
    end
    return leaderList
end
function battleObjectManager:getEnemyLeaderList()
    local leaderList = {}
    for k,v in pairs(self.objectList_enemy) do
        if v:isLeader() then
            table.insert(leaderList, v)
        end
    end
    return leaderList
end


function battleObjectManager:getEnemyObjectListBySite(s)
    return self.objectList_enemy_site[s] or {}
end
function battleObjectManager:getOwnObjectListBySite(s)
    return self.objectList_own_site[s] or {}
end


function battleObjectManager:getOwnLeaderNum()
    local n = 0
    for k,v in pairs (self.objectList_own) do
        if v:isLeader() then n=n+1 end
    end
    return n
end
function battleObjectManager:getEnemyObjectNum()
   local n = 0
    for k,v in pairs (self.objectList_enemy) do
        if v:isLeader() then n=n+1 end
    end
    return n
end

function battleObjectManager:starGame()
    self.seekObjectControl:initAI()

    for k,v in pairs( self.objectList_own ) do
         v:starGame()
    end

    for k,v in pairs( self.objectList_enemy ) do
         v:starGame()
    end
end

function battleObjectManager:createObject(param)
    local obj = nil
    if param.objectType == ObjectDefine.objectType.infantry then
        obj = self:createInfantry(param)
    elseif param.objectType == ObjectDefine.objectType.leader then
        obj = self:createLeader(param)
    elseif param.objectType == ObjectDefine.objectType.skill then
        obj = self:createSkill(param)
    elseif param.objectType == ObjectDefine.objectType.bullet then
        obj = self:createBullet(param)
    end

    if obj then
        self.serial_ = self.serial_ + 1
        obj:setKey(self.serial_)
    end
    return obj
end

--object加到战场
function battleObjectManager:addToBattle(obj, param)
    local tp = obj:getType()
    if tp == ObjectDefine.objectType.infantry then
        Notifier.postNotifty("addObjectToFightLayer_notify", {object=obj,site=1})
        Notifier.addObserver( obj )
        

    elseif tp == ObjectDefine.objectType.leader then
        Notifier.postNotifty("addObjectToFightLayer_notify", {object=obj,site=1})
        Notifier.addObserver( obj )

    elseif tp == ObjectDefine.objectType.skill then
        if obj:isInAirLayer() then
            Notifier.postNotifty("addObjectToAirLayer_notify", {object=obj})

        elseif obj:isInGroundLayer() then
            Notifier.postNotifty("addObjectToGroundLayer_notify", {object=obj})
        end

    elseif tp == ObjectDefine.objectType.bullet then
        Notifier.postNotifty("addObjectToFightLayer_notify", {object=obj})
    end
end

function battleObjectManager:delFromBattle(obj)

        local tp = obj:getType()
        if tp == ObjectDefine.objectType.infantry then
            Notifier.postNotifty("delObjectToFightLayer_notify",{key = obj:getKey()})
            Notifier.removeObserver(obj)

        elseif tp == ObjectDefine.objectType.leader then
            Notifier.postNotifty("delObjectToFightLayer_notify",{key = obj:getKey()})
            Notifier.removeObserver(obj)

        elseif tp == ObjectDefine.objectType.skill then
            if obj:isInAirLayer() then
                Notifier.postNotifty("delObjectToAirLayer_notify",{key = obj:getKey()})

            elseif obj:isInGroundLayer() then
                Notifier.postNotifty("delObjectToGroundLayer_notify",{key = obj:getKey()})        
            end
    
        elseif tp == ObjectDefine.objectType.bullet then
            Notifier.postNotifty("delObjectToFightLayer_notify",{key = obj:getKey()})
          
        end
end

function battleObjectManager:createSkill(param)
    local obj = new_class(luaFile.SkillObject, param)
    obj.objectManager_ = self
    return obj
end

function battleObjectManager:createBullet(param)
    local obj = new_class(luaFile.BulletBase, param)
    obj.objectManager_ = self
    return obj
end

function battleObjectManager:createLeader(param)
    local l = DataManager.getLeaderStaticDataByID( param.roleID )
    local obj = nil
    if l.type == ObjectDefine.jobType.bubing then
        obj = new_class(luaFile.BubingLeader, param)

    elseif l.type == ObjectDefine.jobType.cike then
        obj = new_class(luaFile.CikeLeader, param)

    elseif l.type == ObjectDefine.jobType.fashi then
        obj = new_class(luaFile.FashuLeader, param)

    elseif l.type == ObjectDefine.jobType.gongbing then
        obj = new_class(luaFile.GongbingLeader, param)

    elseif l.type == ObjectDefine.jobType.qibing then
        obj = new_class(luaFile.QibingLeader, param)
    else
        error(false, "未知职业被创建leader")
    end
    obj.objectManager_ = self
    return obj
end

function battleObjectManager:createInfantry(param)
    local l = DataManager.getSoldierStaticDataByID( param.roleID )
    local obj = nil
    
    if l.type == ObjectDefine.jobType.bubing then
        obj = new_class(luaFile.BubingSoldier, param)

    elseif l.type == ObjectDefine.jobType.cike then
        obj = new_class(luaFile.CikeSoldier, param)

    elseif l.type == ObjectDefine.jobType.fashi then
        obj = new_class(luaFile.FashuSoldier, param)

    elseif l.type == ObjectDefine.jobType.gongbing then
        obj = new_class(luaFile.GongbingSoldier, param)

    elseif l.type == ObjectDefine.jobType.qibing then
        obj = new_class(luaFile.QibingSoldier, param)
    else
        error(false, "未知职业被创建soldier")
    end
    obj.objectManager_ = self
    return obj
end

--[[
--body={type(单位职业), camp(阵营)，leader（所属）,site(leader位置)，name(spineName)}
function battleObjectManager:addObject(body)
    local obj = self:createObject(body)
    if obj then
        if obj:getCamp() == enemy then
            self.objectList_enemy[obj:getKey()] = obj
            if not self.objectList_enemy_site[obj:getSite()] then
                self.objectList_enemy_site[obj:getSite()] = {}
            end
            self.objectList_enemy_site[obj:getSite()][obj:getKey()] = obj

        elseif obj:getCamp() == own then
            self.objectList_own[obj:getKey()] = obj
            if not self.objectList_own_site[obj:getSite()] then
                self.objectList_own_site[obj:getSite()] = {}
            end
            self.objectList_own_site[obj:getSite()][obj:getKey()] = obj
        end

        self:addToBattle(obj, body)
        return obj
    end
end
--]]

function battleObjectManager:addObject_infantryPlayer(body)
    body.objectType = ObjectDefine.objectType.infantry
    local obj = self:createObject(body)
    if obj then
        if obj:getCamp() == enemy then
            self.objectList_enemy[obj:getKey()] = obj
            if not self.objectList_enemy_site[obj:getSite()] then
                self.objectList_enemy_site[obj:getSite()] = {}
            end
            self.objectList_enemy_site[obj:getSite()][obj:getKey()] = obj
        elseif obj:getCamp() == own then
            self.objectList_own[obj:getKey()] = obj
            if not self.objectList_own_site[obj:getSite()] then
                self.objectList_own_site[obj:getSite()] = {}
            end
            self.objectList_own_site[obj:getSite()][obj:getKey()] = obj
        end

        self:addToBattle(obj, body)
        return obj
    end
end
function battleObjectManager:addObject_leaderPlayer(body)
    body.objectType = ObjectDefine.objectType.leader
    local obj = self:createObject(body)
    if obj then
        if obj:getCamp() == enemy then
            self.objectList_enemy[obj:getKey()] = obj
            if not self.objectList_enemy_site[obj:getSite()] then
                self.objectList_enemy_site[obj:getSite()] = {}
            end
            self.objectList_enemy_site[obj:getSite()][obj:getKey()] = obj
        elseif obj:getCamp() == own then
            self.objectList_own[obj:getKey()] = obj
            if not self.objectList_own_site[obj:getSite()] then
                self.objectList_own_site[obj:getSite()] = {}
            end
            self.objectList_own_site[obj:getSite()][obj:getKey()] = obj
        end

        self:addToBattle(obj, body)
        return obj
    end
end
function battleObjectManager:addObject_skill(body)
    body.objectType = ObjectDefine.objectType.skill
    local obj = self:createObject(body)
    if obj then
        self.objectList_skill[obj:getKey()] = obj

        self:addToBattle(obj, body)
        return obj
    end
end
function battleObjectManager:addObject_bullet(body)
    body.objectType = ObjectDefine.objectType.bullet
    local obj = self:createObject(body)
    if obj then
        self.objectList_skill[obj:getKey()] = obj

        self:addToBattle(obj, body)
        return obj
    end
end


--更换角色位置
function battleObjectManager:exchangeRoleSite(orgSiteA, orgSiteB)
    local A = DeepCopy(self.objectList_own_site[orgSiteB] or {})
    local B = DeepCopy(self.objectList_own_site[orgSiteA] or {})
    self.objectList_own_site[orgSiteA] = {}
    self.objectList_own_site[orgSiteB] = {}
    
    for k,v in pairs(B) do
        self.objectList_own_site[orgSiteB][v:getKey()] = v
    end
    for k,v in pairs(A) do
        self.objectList_own_site[orgSiteA][v:getKey()] = v
    end
end

function battleObjectManager:removeObject(obj, isdelete)
    local key = obj:getKey()
    local objectType = obj:getType()
    if objectType == ObjectDefine.objectType.bullet or objectType == ObjectDefine.objectType.skill then
        self.objectList_skill[key] = nil
    
    else
        self.seekObjectControl:removeObject(obj, camp)
        local camp = obj:getCamp()
        if camp == ObjectDefine.Camp.enemy then
            if self.objectList_enemy[key] then
                self.objectList_enemy[key] = nil
                self.objectList_enemy_site[obj:getSite()][obj:getKey()] = nil
            end
        elseif camp == ObjectDefine.Camp.own then
            if self.objectList_own[key] then
                self.objectList_own[key] = nil
                self.objectList_own_site[obj:getSite()][obj:getKey()] = nil
            end
        end
    end

    if isdelete then self:delFromBattle(obj) end
end



--单位是否存在
function battleObjectManager:objectIsExist(key)
    return self.objectList_enemy[key] or self.objectList_own[key]
end

--单位是否生存
function battleObjectManager:objectIsLife(key)
    if self.objectList_enemy[key] then
        if self.objectList_enemy[key]:isDead() then
            return false
        else
            return true
        end
    end
    if self.objectList_own[key] then
        if self.objectList_own[key]:isDead() then
            return false
        else
            return true
        end
    end
    return false
end

function battleObjectManager:getObject(key)
    if self.objectList_enemy[key] then return self.objectList_enemy[key] end
    if self.objectList_own[key] then return self.objectList_own[key] end
end

--获得我方武将
function battleObjectManager:getOwnObjectByRoleID(roleid)
    for k,v in pairs(self.objectList_own) do
        if v.roleID == roleid then
            return v
        end
    end
end

--寻找攻击对象
function battleObjectManager:seekObject(selfObject, seekObjectCamp)
    return self.seekObjectControl:seekObject(selfObject, seekObjectCamp)
end

function battleObjectManager:deleteAll()
    for k,v in pairs(self.objectList_own) do
        local delTarget = v
        self:removeObject(delTarget,true)
    end
    for k,v in pairs(self.objectList_enemy) do
        local delTarget = v
        self:removeObject(delTarget, true)
    end
end

return battleObjectManager