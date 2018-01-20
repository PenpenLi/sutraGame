local fightLogic = class("fightLogic")
fightLogic.notify = {"changeTactics_notify","autoEmbattle_notify", "notify_communicateUI"}

require( luaFile.emBattleData )

function fightLogic:ctor()
    self.battleObjectManager = new_class(luaFile.fightBattleObjectManager)
    self.fightCacheMgr = new_class(luaFile.fightCacheManager) 
end

function fightLogic:init()
    
    --激活技能按钮
   self.skillReadyList = {}

   --双方将领的初始数据
   self.leaders = {}
   self.leaders[ObjectDefine.Camp.own] = {}
   self.leaders[ObjectDefine.Camp.enemy] = {}

   --双方血量
   self.vsHp = {}
   self.vsHp[ObjectDefine.Camp.own] = {max=0, now=0}
   self.vsHp[ObjectDefine.Camp.enemy] = {max=0, now=0}

   --战斗力
   self.fightPower = {owner = 0, enemy = 0}

   --加速
   self.fightSpeed = 1

   --当前战斗状态
   self.fightState = fightState.really

   --正在交互中，交互不允许重叠
   self.communicateUI = false

   --阵型
   emBattleData:init()
   self:setEmBattle(fightEmbattle.em_frontLeader, fightEmbattle.em_frontLeader)

   --开放位置
   self.openSite_own = {1,2,3,4,5,6,7,8,9}

   --没上阵的
   self.unworkLeaders = {}

   --克制关系
   self.kezhiConnect = {}

   self:showEmbattleSiteSign(true)
end

function fightLogic:getEnemyLeaderInfo(heroid, level)
    local property = DataManager.getLeaderStaticDataByID(heroid)
    property.level = level
    local dataT = property

    local function countProp(key,ibase,igresses)
        local function countLvlPropNum(ibase,igress,ilvl)
            return ibase + igress*(ilvl-1)
        end
        local igress = igresses / 10
        local ilvl = property.level
        --local iTalentLvl = self.property.talentLv
        local iNum = countLvlPropNum(ibase,igress,ilvl) -- + self:countTalentPropNum(ibase,igress,iTalentLvl)
        property[key] = iNum
    end

    countProp("physicsAttack",dataT["physicsAttack"],dataT["physicsAttackAgress"])
    countProp("magicAttack",dataT["magicAttack"],dataT["magicAttackAgress"])
    countProp("barmor",dataT["barmor"],dataT["barmorAgress"])
    countProp("bresistance",dataT["bresistance"],dataT["bresistanceAgress"])
    countProp("hp",dataT["hp"],dataT["hpAgress"])
    countProp("hit",dataT["hit"],dataT["hitAgress"])
    countProp("dodge",dataT["dodge"],dataT["dodgeAgress"])
    countProp("crit",dataT["crit"],dataT["critAgress"])
    countProp("opposeCrit",dataT["opposeCrit"],dataT["opposeCritAgress"])
    countProp("endHurt",dataT["endHurt"],dataT["endHurtAgress"])
    countProp("offsetHurt",dataT["offsetHurt"],dataT["offsetHurtAgress"])

    return property
end

--初始化战斗数据
function fightLogic:initFightData(param)
    local customsID = param.customsID
    self.customsID = customsID
    print("customsID:" .. customsID)
    local enemyHeroList = {}
    local ownheroList = {}
    local siteIndex = 1
    local maxHeros = 9
    for k,v in pairs(param.heros) do
        local soldierId = v.general:GetProperty(General_Prop_ArmId)
        local soldier = DataModeManager:getSoldierData(soldierId)
        local soldierNum = soldier:GetProperty(Soldier_Prop_Amount)
        local h = DeepCopy(v)
        h.camp = ObjectDefine.Camp.own
        h.site = siteIndex
        h.roleID = h.id
        h.id = nil
        h.soldiersCount = soldierNum
        
        if maxHeros > table.nums(ownheroList) then
            local have = false
            for k,v in pairs(ownheroList) do
                if v.roleID == h.roleID then 
                    have = true
                    table.insert(self.unworkLeaders, h)
                    break 
                end
            end
            if not have then
                siteIndex = siteIndex + 1
                table.insert(ownheroList, h)
            end
        else
            table.insert(self.unworkLeaders, h)
        end
        self.leaders[h.camp][h.roleID] = h
    end

    local function initOwnTeamFinish()
        self:ready()
        if param.finishCallback() then param.finishCallback() end 
    end
    local function initEnemyTeamFinish()
        self:initCustomKezhiConnect()

        local function callback() self:addHeros(ownheroList, initOwnTeamFinish) end
        performWithDelay(self.fightui, callback, 0.0)
    end

    --关卡怪物
    local soldiers = DataManager.getCustomsSoldierInfo(customsID)
    for k,v in pairs(soldiers) do
        if v.ifAttack > 0 and v.leaderId > 0 then
            local h = self:getEnemyLeaderInfo(v.leaderId, v.leaderLevel)
            h.site = v.enemyPosition
            h.camp = ObjectDefine.Camp.enemy
            h.roleID = v.leaderId
            h.soldiersCount = v.soldierNumber
            table.insert(enemyHeroList, h)
        end
    end
    self:addHeros(enemyHeroList, initEnemyTeamFinish)


end

function fightLogic:setEmBattle(own_d, enemy_d)
    --阵型程序
    self.emBattleProgram = {}
    self.emBattleProgram.own = {}
    self.emBattleProgram.own.em = own_d
    self.emBattleProgram.own.getLeader = function()end
    self.emBattleProgram.own.getSoldier = function()end
    self.emBattleProgram.enemy = {}
    self.emBattleProgram.enemy.em = enemy_d
    self.emBattleProgram.enemy.getLeader = function()end
    self.emBattleProgram.enemy.getSoldier = function()end
    self.emBattleProgram.getscale = function()end

    if self.emBattleProgram.own.em == fightEmbattle.em_frontLeader then
        self.emBattleProgram.own.getLeader = function(site) 
            return emBattleData:getfrontLeaderEM_own_leader_withSite(tonumber(site))
        end
        self.emBattleProgram.own.getSoldier = function(site) 
            return emBattleData:getfrontLeaderEM_own_solider_withSite(tonumber(site))
        end
    end
    if self.emBattleProgram.own.em == fightEmbattle.em_backLeader then
        self.emBattleProgram.own.getLeader = function(site)
            return emBattleData:getBackLeaderEM_own_leader_withSite(tonumber(site))
        end
        self.emBattleProgram.own.getSoldier = function(site) 
            return emBattleData:getBackLeaderEM_own_solider_withSite(tonumber(site))
        end
    end

    if self.emBattleProgram.enemy.em == fightEmbattle.em_frontLeader then
        self.emBattleProgram.enemy.getLeader = function(site) 
            return emBattleData:getfrontLeaderEM_enemy_leader_withSite(tonumber(site))
        end
        self.emBattleProgram.enemy.getSoldier = function(site) 
            return emBattleData:getfrontLeaderEM_enemy_solider_withSite(tonumber(site))
        end
    end
    if self.emBattleProgram.enemy.em == fightEmbattle.em_backLeader then
        self.emBattleProgram.enemy.getLeader = function(site) 
            return emBattleData:getBackLeaderEM_enemy_leader_withSite(tonumber(site))
        end
        self.emBattleProgram.enemy.getSoldier = function(site) 
            return emBattleData:getBackLeaderEM_enemy_solider_withSite(tonumber(site))
        end
    end

    self.emBattleProgram.getscale = function(site) 
        return emBattleData:getScaleBySite(tonumber(site))
    end
end

function fightLogic:setFightUILayer(fightUILayer)
    self.fightui = fightUILayer
end
function fightLogic:getCache()
    return self.fightCacheMgr
end

--界面显示未上阵武将
function fightLogic:showUnworkLeadersUI()
    local tmpIDList = {}
    for k,v in pairs(self.unworkLeaders) do table.insert(tmpIDList, {roleID=v.roleID,baseID=v.baseId}) end 
    self.fightui:showLeaderHeadListview(tmpIDList)
end

--获取未上阵的武将
function fightLogic:getUnworkLeaderByID(roleID)
    for k,v in pairs(self.unworkLeaders) do
        if v.roleID == roleID then
            return v
        end
    end
end

function fightLogic:getWorkLeaderByID(roleID)
    
end

function fightLogic:addUnworkLeader(roleID, camp)
    if self.leaders[camp][roleID] then
        table.insert(self.unworkLeaders, self.leaders[camp][roleID])
        self.fightui:updateLeaderHeadListviewWithAddRole(self.leaders[camp][roleID].roleID, self.leaders[camp][roleID].baseId)
    end
end
function fightLogic:delUnworkLeader(roleID)
    local tmp = {}
    for k,v in pairs(self.unworkLeaders) do
        if v.roleID ~= roleID then table.insert(tmp, v) end
    end
    self.unworkLeaders = tmp

    self.fightui:updateLeaderHeadListviewWithDelRole(roleID)
end



--选中了要上阵的英雄
function fightLogic:setselectHeroToFight(hero, heroID)
    self.selectFightHero = {}
    self.selectFightHero.hero = hero
    self.selectFightHero.id = heroID

    Notifier.postNotifty("notify_showSelectToFightHero", {object=hero})

    --模拟一个role的数据
    local heroAttr = DataManager.getLeaderStaticDataByID(heroID)
    local arm = DataManager.getSoldierStaticDataByID(heroAttr.armId)
    hero.roleProperty = {kezhi={}}
    hero.roleProperty.kezhi[tonumber(arm.restrainId)] = tonumber(arm.restrainHurt)/100
    hero.roleProperty.kezhi[tonumber(arm.restrainIdZ)] = tonumber(arm.restrainHurtZ)/100
    hero.getJob = function() return heroAttr.type end
    hero.getSite = function() return 1 end
    
    self:leaderMoveBegan( hero )
end
function fightLogic:unselectHeroToFight()
    if self.selectFightHero then
        self.fightui:unshowKezhiLayer()
        self.kezhiConnect.showing = false

        self.selectFightHero.hero:removeFromParent(true)
        self.selectFightHero = nil
    end
end
function fightLogic:getselectHeroToFight()
    return self.selectFightHero
end
function fightLogic:selectHeroToFight()
    if self.selectFightHero then
        local herox, heroy = self.selectFightHero.hero:getPosition()
        local selectSite = 0
        for k,v in pairs(self.openSite_own) do
            local pos = self.emBattleProgram.own.getLeader(v)
            local selectRect = cc.rect(pos.x - 50, pos.y - 50, 100, 100)
            if herox > selectRect.x and herox < (selectRect.x+selectRect.width) and heroy > selectRect.y and heroy < (selectRect.y+selectRect.height) then
                selectSite = v
                break
            end  
        end

        --这里是上阵逻辑
        local function upLeader()
            if not self:siteHaveLeader_own(selectSite) then
                local body = self:getUnworkLeaderByID(self.selectFightHero.id)
                body.site=selectSite
                self.leaders[tonumber(body.camp)][tonumber(body.roleID)].site = selectSite
                self:addHero(body)
                self:delUnworkLeader(body.roleID)
            end
        end
        if selectSite ~= 0 then
            if self.battleObjectManager:getOwnObjectByRoleID(self.selectFightHero.id) then
            
                local label = cocosMake.newLabel("不能上阵重复武将", 0, 0)
                label:setColor(cc.c3b(255,0,210))
                self.fightui:addChild(label, 1000, 1000)
                label:setGlobalZOrder(1)
                label:setPosition(cc.p(display.visibleRect.center.x, display.visibleRect.center.y))
                performWithDelay(self.fightui, function(args) label:removeFromParent(true) end, 1.5)

            elseif not self:siteHaveLeader_own(selectSite) then
                upLeader()

            else
                local selectHero = self:getRoleByPositon(cc.p(herox, heroy))
                local roleId = selectHero.roleID
                local roleCamp = selectHero:getCamp()
                self:downerLeader(selectHero, function() upLeader() self:addUnworkLeader(roleId, roleCamp)  end)
            end
        end
    end
end

--当前站位是否有武将
function fightLogic:siteHaveLeader_own(site)
    local is = false
    local roleList = self.battleObjectManager:getOwnObjectList()
    for k,v in pairs(roleList) do
        if v:isLeader() and site == v:getSite() then
            is = true
            break
        end
    end
    return is
end

function fightLogic:getFightSpeed()
    return self.fightSpeed
end
function fightLogic:setFightSpeed(speed)
    self.fightSpeed = speed
    cocosMake.setGameSpeed(self.fightSpeed)
end



function fightLogic:ready()
    self:setFightSpeed(1)

    self.fightState = fightState.really

    self:showUnworkLeadersUI()
end


function fightLogic:handleNotification(notifyName, body)
    if notifyName == "changeTactics_notify" then--更改阵型
        
        local enmey_em = self.emBattleProgram.enemy.em
        local own_em = self.emBattleProgram.own.em == fightEmbattle.em_frontLeader and  fightEmbattle.em_backLeader or fightEmbattle.em_frontLeader
        self:setEmBattle(own_em, enmey_em)

        local objList = self.battleObjectManager:getOwnObjectList()
        for k,v in pairs(objList) do
            if v:isLeader() then
                v:changeTactics()
            end
        end

    elseif notifyName == "autoEmbattle_notify" then
        local currWorkHeroList = self.battleObjectManager:getOwnLeaderList()

        local allHeroList = DeepCopy(self.leaders[ObjectDefine.Camp.own])

        table.sort(allHeroList, function(a,b) return a:getFightPower()>b:getFightPower() end)

    elseif notifyName == "notify_communicateUI" then
        self.communicateUI = body.ing
    end
end 

function fightLogic:isCommunicateUI()
    return self.communicateUI
end

function fightLogic:starGame()
    if self.fightState ~= fightState.fighting then
        self.battleObjectManager:starGame()
        self:showEmbattleSiteSign(false)

        self.fightState = fightState.fighting
    end
end

function fightLogic:getFightState()
    return self.fightState
end

function fightLogic:initBlueCamp()
end

function fightLogic:initRedCamp()
end

function fightLogic:addFightPower(role)
    local power = role:getFightPower()
    if role:campIsOwn() then
        self.fightPower.owner = self.fightPower.owner + power
        self.fightui:updateLeftPower(self.fightPower.owner)
    else
        self.fightPower.enemy = self.fightPower.enemy + power
        self.fightui:updateRightPower(self.fightPower.enemy)
    end
end
function fightLogic:delFightPower(role)
    local power = role:getFightPower()
    if role:campIsOwn() then
        self.fightPower.owner = self.fightPower.owner - power
        self.fightui:updateLeftPower(self.fightPower.owner)
    else
        self.fightPower.enemy = self.fightPower.enemy - power
        self.fightui:updateRightPower(self.fightPower.enemy)
    end
end

function fightLogic:getOwnerFightPower()
    return self.fightPower.owner
end
function fightLogic:getEnemyFightPower()
    return self.fightPower.enemy
end

function fightLogic:addSolider(body)
    local role = self.battleObjectManager:addObject_infantryPlayer(body)
    self:addFightPower(role)
    return role
end

function fightLogic:deleteSolider(obj, delayTime)
    self:delFightPower(obj)

    local m = obj:getRoleModel()
    if delayTime then
        self.battleObjectManager:removeObject(obj, false)
        performWithDelay(self.fightui, function() 
                self.battleObjectManager:delFromBattle(obj)
                self.fightCacheMgr:delCacheAvatar(m) end, delayTime)
    else
        self.battleObjectManager:removeObject(obj, true)
    end
end

function fightLogic:addLeader(body)
    local role = self.battleObjectManager:addObject_leaderPlayer(body)
    self:addFightPower(role)
    
    if role:campIsOwn() and self:isFightReally() then
        local ci = {}
        local kezhi = self:getKezhiWithRole(role, role:getSite())
        if 1 == kezhi then
            ci[1] = {site=role:getSite(), kezhi=true}
        elseif 2 == kezhi then
            ci[1] = {site=role:getSite(), beikezhi=true}
        end
        Notifier.postNotifty("notify_setEmbattleSiteSignData", {changeInfo = ci})
    end

    return role
end

function fightLogic:deleteLeader(obj, delayTime)
    self:delFightPower(obj)

    if obj:campIsOwn() and self:isFightReally() then
        local ci = {}
        ci[1] = {site=obj:getSite()}
        Notifier.postNotifty("notify_setEmbattleSiteSignData", {changeInfo = ci})
    end

    local m = obj:getRoleModel()
    if delayTime then
        self.battleObjectManager:removeObject(obj, false)
        performWithDelay(self.fightui, function() 
            self.battleObjectManager:delFromBattle(obj) 
            self.fightCacheMgr:delCacheAvatar(m) end, delayTime)
    else
        self.battleObjectManager:removeObject(obj, true)
    end
end

--添加一批英雄
function fightLogic:addHeros(heroList, callback)
    local cacheNum = 0
    local cacheCnt = 0

    local function cacheFinish()
        print("cacheFinish")
        for k,v in pairs(heroList) do
            self:addLeader(v)
        end

        if callback then callback() end
    end

    local function cacheIndex()
        cacheCnt = cacheCnt + 1
        --print("cacheCnt:"..cacheCnt..",cacheNum:"..cacheNum)
        if cacheCnt >= cacheNum then
            cacheFinish()
        end
    end

    for k,v in pairs(heroList) do
        local avatar = DataManager.getLeaderStaticDataByID(v.roleID)
        cacheNum = cacheNum + 1 + v.soldiersCount
        local function cacheHeroCallback()
            cacheIndex()
            local soldiersCount = v.soldiersCount or 0
            print("兵团ID="..avatar.armId)
            local soliderData = DataManager.getSoldierStaticDataByID(avatar.armId)
            local modCamp = v.camp == ObjectDefine.Camp.own and "_1" or "_2"
        
            local ownSoldierCount = 0
            local function cacheSoldiersCallback()
                ownSoldierCount = ownSoldierCount + 1
                if ownSoldierCount <= soldiersCount then
                    self.fightCacheMgr:addCacheAvatar(soliderData.modelId..modCamp, ObjectDefine.objectType.infantry, cacheSoldiersCallback)
                    cacheIndex()
                end
            end
            cacheSoldiersCallback()
        end
        self.fightCacheMgr:addCacheAvatar(avatar.modelId, ObjectDefine.objectType.leader, cacheHeroCallback)
    end
end

--添加单个英雄
function fightLogic:addHero(args)
    self.leaders[args.camp][args.roleID] = args

    local avatar = DataManager.getLeaderStaticDataByID(args.roleID)
    local function cacheFinish()
        self:addLeader(args)
    end

    local function cacheHeroCallback()
        local soldiersCount = args.soldiersCount or 0
        local soliderData = DataManager.getSoldierStaticDataByID(avatar.armId)
        local modCamp = args.camp == ObjectDefine.Camp.own and "_1" or "_2"
        
        local ownSoldierCount = 0
        local function cacheSoldiersCallback()
            
            ownSoldierCount = ownSoldierCount + 1
            if ownSoldierCount <= soldiersCount then
                self.fightCacheMgr:addCacheAvatar(soliderData.modelId..modCamp, ObjectDefine.objectType.infantry, cacheSoldiersCallback)
                
            else
                cacheFinish()
            end
        end
        cacheSoldiersCallback()
    end
    self.fightCacheMgr:addCacheAvatar(avatar.modelId, ObjectDefine.objectType.leader, cacheHeroCallback)
end



--下阵
function fightLogic:downerLeader(role, downerCallback)
    role:downer(downerCallback)
end

function fightLogic:addSkillObject(body)
    return self.battleObjectManager:addObject_skill(body)
end

function fightLogic:addBulletlObject(body)
    return self.battleObjectManager:addObject_bullet(body)
end

function fightLogic:cleanAllObject()
    self.battleObjectManager:deleteAll()
    self.fightCacheMgr:cleanAll()
end


function fightLogic:playSkill(playerKey, skillID)
    if self.battleObjectManager:objectIsLife(playerKey) then
        local object = self.battleObjectManager:getObject(playerKey)
        object:playSkill(skillID)

    end

    if self.skillReadyList[playerKey] and self.skillReadyList[playerKey].skillID then
        self.skillReadyList[playerKey].skillID.removeCallback()
        self.skillReadyList[playerKey].skillID = nil
    end
end

function fightLogic:addSkillReady(player, skillID, uiLayer)
    local playerKey = player:getKey()
    local function removeSkillReally()
        uiLayer:removeActiveSkillButton(skillID)
    end
    local function clickCallback()
        self:playSkill(playerKey, skillID)
        removeSkillReally()
    end
    uiLayer:activeSkill(skillID, player, clickCallback)
    
    if not self.skillReadyList[playerKey] then
        self.skillReadyList[playerKey] = {}
    end

    self.skillReadyList[playerKey].skillID = {removeCallback=removeSkillReally}
end



function fightLogic:fightGameOver(isWin)
    self.fightState = fightState.over
    Notifier.postNotifty("fightWin_role_notify")

    local pack = networkManager.createPack("battleEnd_c")
    pack.gateId = self.customsID
    pack.grade = isWin and 5 or 0

    local function packCallback(obj)
        obj = obj or {isWin=true}--test code
        obj.isWin = isWin
        Notifier.postNotifty("showFightAccountsUI_notify", obj)
    end

    networkManager.sendPack(pack, packCallback, true)
    --Notifier.postNotifty("showFightAccountsUI_notify", {tools=tools})
end

function fightLogic:checkFightResult()
    if self.fightState == fightState.fighting then
        if self.vsHp[ObjectDefine.Camp.own].now <= 0 or self.vsHp[ObjectDefine.Camp.enemy].now <= 0 then
            self:fightGameOver(self.vsHp[ObjectDefine.Camp.own].now > 0)
        end
    end
end

--更新VS HP
function fightLogic:updateVSHP(body)
    if body.type == updateHP_Type.upLimit_addHp then
        self.vsHp[body.camp].max = self.vsHp[body.camp].max + body.hp
        self.vsHp[body.camp].now = self.vsHp[body.camp].now + body.hp

    elseif body.type == updateHP_Type.downLimit_loseHp then
        self.vsHp[body.camp].max = self.vsHp[body.camp].max - body.hp
        self.vsHp[body.camp].now = self.vsHp[body.camp].now - body.hp

    elseif body.type == updateHP_Type.upLimit then
        self.vsHp[body.camp].max = self.vsHp[body.camp].max + body.hp

    elseif body.type == updateHP_Type.downLimit then
        self.vsHp[body.camp].max = self.vsHp[body.camp].max - body.hp

    elseif body.type == updateHP_Type.loseHp then
        self.vsHp[body.camp].now = self.vsHp[body.camp].now - body.hp

    elseif body.type == updateHP_Type.addHp then
        self.vsHp[body.camp].now = self.vsHp[body.camp].now + body.hp
    end

    local function printLog()
        print("body.hp="..body.hp)
        print("own.maxhp="..self.vsHp[ObjectDefine.Camp.own].max..",own.hp="..self.vsHp[ObjectDefine.Camp.own].now)
        print("enemy.maxhp="..self.vsHp[ObjectDefine.Camp.enemy].max..",enemy.hp="..self.vsHp[ObjectDefine.Camp.enemy].now)
    end
    --printLog()
    self.fightui:updateVSHPUI(body)
    self:checkFightResult()
end

function fightLogic:getVSHP()
    return self.vsHp[ObjectDefine.Camp.own].max, self.vsHp[ObjectDefine.Camp.own].now, self.vsHp[ObjectDefine.Camp.enemy].max, self.vsHp[ObjectDefine.Camp.enemy].now
end

function fightLogic:isFighting()
    return self.fightState == fightState.fighting
end

function fightLogic:isFightReally()
    return self.fightState == fightState.really
end

--是否能开始战斗
function fightLogic:canStartFight()
    return self.fightState == fightState.really and self.communicateUI == false
end

--获取武将位置
function fightLogic:getRoleByPositon(pos, except)
    if not self:isFightReally() then
        return
    end

    local roleList = self.battleObjectManager:getOwnObjectList()
    for k,v in pairs(roleList) do
        if v:isLeader() then
            local box = v:getRoleBoundBox()
            if pos.x > box.x and pos.y > box.y and pos.x < (box.x+box.width) and pos.y < (box.y+box.height) and v ~= except then
                return v
            end
        end
    end
end

function fightLogic:initCustomKezhiConnect()
    if not self.kezhiConnect.init then
        self.kezhiConnect.init = true
        local es1 = {}
        local es2 = {}
        local es3 = {}
        es1 = self.battleObjectManager:getEnemyObjectListBySite(1)
        if 0 == table.nums(es1) then es1 = self.battleObjectManager:getEnemyObjectListBySite(4) end
        if 0 == table.nums(es1) then es1 = self.battleObjectManager:getEnemyObjectListBySite(7) end
        es2 = self.battleObjectManager:getEnemyObjectListBySite(2)
        if 0 == table.nums(es2) then es2 = self.battleObjectManager:getEnemyObjectListBySite(5) end
        if 0 == table.nums(es2) then es2 = self.battleObjectManager:getEnemyObjectListBySite(8) end
        es3 = self.battleObjectManager:getEnemyObjectListBySite(3)
        if 0 == table.nums(es3) then es3 = self.battleObjectManager:getEnemyObjectListBySite(6) end
        if 0 == table.nums(es3) then es3 = self.battleObjectManager:getEnemyObjectListBySite(9) end

        for k,v in pairs(es1) do
            if v:isLeader() then
                local pos = v:getPosition()
                self.kezhiConnect[1] = {leader=v, pos=pos, job=v:getJob()}
                break
            end
        end
        for k,v in pairs(es2) do
            if v:isLeader() then
                local pos = v:getPosition()
                self.kezhiConnect[2] = {leader=v, pos=pos, job=v:getJob()}
                break
            end
        end
        for k,v in pairs(es3) do
            if v:isLeader() then
                local pos = v:getPosition()
                self.kezhiConnect[3] = {leader=v, pos=pos, job=v:getJob()}
                break
            end
        end
    end
end

function fightLogic:leaderMoveBegan( followLeader )
    if not followLeader then
        return false
    end

    local kezhiSite = {}
    local beikezhiSite = {}
    
    for i=1,3 do
        if self.kezhiConnect[i] then
            local kz = self:getKezhiWithRole(followLeader, i)
            if 1 == kz then
                table.insert(kezhiSite, {site=i, pos=cc.p(self.kezhiConnect[i].leader:getPosition())})
            elseif 2 == kz then
                table.insert(beikezhiSite, {site=i, pos=cc.p(self.kezhiConnect[i].leader:getPosition())})
            end
        end
    end
    local sitePoslist = {}
    for k,v in pairs(self.openSite_own) do
        local pos = self.emBattleProgram.own.getLeader(v)
        sitePoslist[v] = pos
    end

    self.fightui:showKezhiLayer(followLeader, sitePoslist, kezhiSite, beikezhiSite)
    self.kezhiConnect.showing = true

    Notifier.postNotifty("notify_communicateUI", {ing=true})
end

function fightLogic:leaderMoving()
    if self.kezhiConnect.showing then
        self.fightui:kezhiMovingLayer()
    end
end

local deling = 0
--武将移动响应
function fightLogic:leaderMoveEnd(role)
    local herox, heroy = role:getPosition()
    local selectSite = 0

    for k,v in pairs(self.openSite_own) do
        local pos = self.emBattleProgram.own.getLeader(v)
        local selectRect = cc.rect(pos.x - 50, pos.y - 50, 100, 100)
        if herox > selectRect.x and herox < (selectRect.x+selectRect.width) and heroy > selectRect.y and heroy < (selectRect.y+selectRect.height) then
            selectSite = v
            break
        end
    end
    
    if selectSite == 0 then
        if 1 >= (self.battleObjectManager:getOwnLeaderNum()-deling) then
            role:setSite(role:getSite())
        else
            --移除武将
            role:setGlobalZOrder_(10)
            deling = deling + 1
            self.fightui:downerLeaderFromBattle(role, function() 
                self:downerLeader(role)
                self:addUnworkLeader(role.roleID, role:getCamp()) 
                deling = deling - 1
                Notifier.postNotifty("notify_communicateUI", {ing=false})
            end)
            
        end

    elseif selectSite == role:getSite() then
        role:setSite(role:getSite())
        Notifier.postNotifty("notify_communicateUI", {ing=false})

    else
        local exchangeRole = self:getRoleByPositon({x=herox,y=heroy}, role)

        local changeInfo ={}
        changeInfo[1] = {}
        changeInfo[2] = {}
        
        changeInfo[1].site = role:getSite()
        changeInfo[2].site = selectSite
        local kz = self:getKezhiWithRole(role, selectSite)
        if kz == 1 then changeInfo[2].kezhi = true elseif kz==2 then changeInfo[2].beikezhi = true end
        --先更新布阵界面
        if exchangeRole then
           
            kz = self:getKezhiWithRole(exchangeRole, role:getSite())
            if kz == 1 then changeInfo[1].kezhi = true elseif kz==2 then changeInfo[1].beikezhi = true end

            self.battleObjectManager:exchangeRoleSite(role:getSite(), exchangeRole:getSite())
            role:exchangeRoleSite(exchangeRole)
        else
            self.battleObjectManager:exchangeRoleSite(role:getSite(), selectSite)
            role:setSite(selectSite)
        end
        Notifier.postNotifty("notify_setEmbattleSiteSignData", {changeInfo = changeInfo})
        Notifier.postNotifty("notify_communicateUI", {ing=false})
    end

    self.fightui:unshowKezhiLayer()
    self.kezhiConnect.showing = false
end

--获取角色的克制关系(0无，1克制，2被克制)
function fightLogic:getKezhiWithRole(role, mysite)
    if not role then return 0 end

    local site = mysite - math.floor((mysite-1)/3) * 3
    if not self.kezhiConnect[site] then return 0 end

    if role.roleProperty.kezhi[self.kezhiConnect[site].job] then
        return 1

    elseif self.kezhiConnect[site].leader.roleProperty.kezhi[role:getJob()] then
        return 2
    end
    return 0
end

--显示位置标示
function fightLogic:showEmbattleSiteSign(isShow)
    if isShow then
        local poslist = {}
        for k,v in pairs(self.openSite_own) do
            local pos = self.emBattleProgram.own.getLeader(v)
            poslist[v] = {pos=pos}
        end
        Notifier.postNotifty("notify_initEmbattleSiteSign", {data=poslist})

    else
        Notifier.postNotifty("notify_clearEmbattleSiteSign")
    end
end

return fightLogic