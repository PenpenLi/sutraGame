--角色
local RoleBase = class("RoleBase", require(luaFile.Avatar))
RoleBase[".isclass"] = true



function RoleBase:ctor(param)
    self:setType(param.objectType)
    self:setCamp(param.camp or ObjectDefine.Camp.none)

    --角色数据
    local roleData = nil
    self.roleID = param.roleID
    if self:isLeader() then
        roleData = DataManager.getLeaderStaticDataByID(param.roleID or 0)
    else
        roleData = DataManager.getSoldierStaticDataByID(param.roleID or 0)
    end
    self.roleData = roleData
    

    self.roleProperty = new_class("layer.fight.object.PropertyRoleControl", {roleData=roleData, property=param, owner=self})
    
    self.roleProperty.vitalValue = self:getVitalMax() * 0.9

    self.roleBuff = new_class("layer.fight.object.buffRoleControl", param)
    self.roleBuff:setOwner(self)
    self.roleBuff:setOwnerPropertyControl(self.roleProperty)

    self.roleSkill = new_class("layer.fight.object.skillRoleControl", {skillID = roleData.skillID})
    self.roleSkill:setOwner(self)

    self.roleAi = new_class("layer.fight.object.AiRole", param)

    --激活技能Index
    self.activeSkillIndex = true

    --站的位置
    self.site = param.site or 1

    --军团内所站的位置
    self.localSite = 1

    --模型
    local modelName = roleData.modelId
    if not self:isLeader() then
        modelName = self:campIsOwn() and (modelName.."_1") or (modelName.."_2")
    end
    self.modelName = modelName
    self:initAvatar({name=modelName, scale=1})
    self:setDirectionWithCamp()

    --spine动画战斗特效
    local spineEffect = DataManager.getFightAnimEffectData(modelName)
    self.attackSpineEvent = spineEffect.attackEff ~= "" and string.split(spineEffect.attackEff, ",") or {}--普通特效名称
    self.skillSpineEvent = spineEffect.skillEff ~= "" and string.split(spineEffect.skillEff, ",") or {}--技能特效名称
    self.bulletSpineEvent = spineEffect.bullet ~= "" and string.split(spineEffect.bullet, ",") or {}--普通攻击的飞行武器（飞行动画：fly, 爆炸动画：power）
    self.PowerPos_attack = spineEffect.PowerPos_attack ~= "" and spineEffect.PowerPos_attack or 0--爆炸位置（普）
    self.flyPos_attack = spineEffect.flyPos_attack ~= "" and string.split(spineEffect.flyPos_attack, ",") or {0,0}  --飞行武器普通攻击的发出点
    self.picPos_attack = spineEffect.picPos_attack ~= "" and string.split(spineEffect.picPos_attack, ",") or {0,0}--power序列图片中心点(飞行普通攻击)
    self.flyPos_skill = spineEffect.flyPos_skill ~= "" and string.split(spineEffect.flyPos_skill, ",") or {}--远程技能的特效在攻击者上的偏移
    self.skillPowerEff = spineEffect.skillPower ~= "" and string.split(spineEffect.skillPower, ",") or {}--技能攻击的飞行武器特效（fly,power）
    self.picPos_skil = spineEffect.picPos_skil ~= "" and string.split(spineEffect.picPos_skil, ",") or {0,0}--序列图片中心点(技)
    self.PowerPos_skil = spineEffect.PowerPos_skil ~= "" and spineEffect.PowerPos_skil or 0--爆炸位置（技）
    self.skillFlySpeed = spineEffect.skillFlySpeed ~= "" and spineEffect.skillFlySpeed or 600--技能移动速度
    self.skillPowerScale = spineEffect.scale ~= "" and spineEffect.scale or 1--技能Power帧动画缩放

    self.jobBuffEff = spineEffect.jobBuffEff ~= "" and string.split(spineEffect.jobBuffEff, ",") or {}--职业BUFF特效
    self.skillBeHitEff = spineEffect.skillBeHitEff ~= "" and string.split(spineEffect.skillBeHitEff, ",") or {}--被技能攻击特效
    self.skillBeHitEffPos = spineEffect.skillBeHitEffPos ~= "" and spineEffect.skillBeHitEffPos or 0--被技能攻击特效位置
    self.attackBuffEff = spineEffect.attack_buff ~= "" and spineEffect.attack_buff or nil--被普通攻击的BUFF特效，播放在被攻击者身上


    table.convertToNumber(self.flyPos_attack)
    table.convertToNumber(self.picPos_attack)
    table.convertToNumber(self.picPos_skil)

    --职业区分普攻类型
    if self:isLRS() then
        self.attackFunction = self.AttackBullet
    else
        self.attackFunction = self.AttackNormal
    end
    
    --local test = cocosMake.newSprite("res/Star.png") self:addChild(test, -100, -100)
    --self.skeleton:setScale(0.9)--test code
end

--是否是远程攻击
function RoleBase:isLRS()
    local job = self:getJob()
    return job == ObjectDefine.jobType.fashi or job == ObjectDefine.jobType.gongbing
end

function RoleBase:getRoleModel()
    return self.modelName
end

--调整景深
function RoleBase:updateZOrder()
    local posY = self:getPositionY()
    self:setLocalZOrder(2048-posY)
end
function RoleBase:updateNuqi()
    self:updateVital(20)
end

function RoleBase:startRoleSchedule()
    local updateSchedule = schedule(self, function() 
    self:updateZOrder() 
    self:updateNuqi()
        end, 1)

    updateSchedule:setTag(123456)
end
function RoleBase:stopRoleSchedule()
    self:stopActionByTag(123456)
end

function RoleBase:setCamp(camp)
    self.camp = camp
end

function RoleBase:getCamp()
    return self.camp
end

function RoleBase:campIsOwn()
    return self.camp == ObjectDefine.Camp.own
end

function RoleBase:setDirectionWithCamp()
    
    if self.camp == ObjectDefine.Camp.own then
        self:setDirection(ObjectDefine.Direction.right)
    elseif self.camp == ObjectDefine.Camp.enemy then
        self:setDirection(ObjectDefine.Direction.left)
    end
end

function RoleBase:init(param)
    
    self.roleBuff:init()
    self.roleAi:setOwner(self)
    --self.roleAi:registerAI(ObjectDefine.Ai.run, "AI_run")
end

function RoleBase:isDead()
    return 0 >= self.roleProperty:getHP()
end


--返回克制的伤害加成信息
function RoleBase:kezhiAddition(targetObject)
    local targetJob = targetObject:getJob()
    return self.roleProperty.kezhi[targetJob] and self.roleProperty.kezhi[targetJob] or 1
end

--计算普通攻击伤害
function RoleBase:calcAttackDamage(attackObj)
    local myAttr = self.roleProperty
    local attAttr = attackObj.roleProperty
    
    local critPower = 1.0

    local function getHit()
        local tmp = ( 10000 - myAttr.hit - (attAttr.dodge - 20000 * myAttr.hit / 10000) ) / 10000
        tmp = math.max( 5, math.min(tmp*100, 100) )
        return tmp
    end

    local function getCrit()
        local tmp = (myAttr.crit - attAttr.opposeCrit) / (myAttr.crit - attAttr.opposeCrit + 1.05 * attAttr.level * 200) * 10000
        tmp = math.max( 5, math.min(tmp, 100) )
        return tmp
    end

    --随机数大失败
    local hit = getHit()
    local rand = math.random(1, 100)
    if hit < rand then
        print("未命中")
        return 0
    end

    local myAttack = myAttr.physicsAttack
    local bar = attAttr.barmor
    local myJob = self:getJob()
    if myJob == ObjectDefine.jobType.cike or myJob == ObjectDefine.jobType.cike then
        myAttack = myAttr.magicAttack
        bar = attAttr.bresistance
    end 

    --随机数大失败
    local crit = getCrit()
    rand = math.random(1, 100)
    if crit >= rand then
        myAttack = myAttack * myAttr.bcritDamage/100
    end

    local damage = math.max(1, (myAttack - bar) + (myAttr.endHurt - attAttr.offsetHurt))
    --print("伤害: " .. damage)
    
    return damage
end

function RoleBase:getJob()
    return self.roleProperty:getJob()
end
--普通攻击
function RoleBase:AttackNormal(objKey, obj, extendPower)
    if self.objectManager_:objectIsLife(objKey) and obj:canBeSeek() then
        local xp = extendPower or 0

        --增加克制
        local power = (self:calcAttackDamage(obj) + xp) * self:kezhiAddition(obj)
        obj:beAttack(power, self)

        --更新怒气
        local vv = VitalDefine.attack
        if obj:isDead() then
            if obj:isLeader() then
                vv = vv + VitalDefine.skillLeader
            else
                vv = vv + VitalDefine.skillSolider
            end
        end
        self:updateVital(vv)
        return true
    else
        return false
    end
end

--飞行器攻击
function RoleBase:AttackBullet(objKey, obj, extendPower)
    if self.objectManager_:objectIsExist(objKey) then
        local xp = extendPower or 0
        local power = (self:calcAttackDamage(obj) + xp) * self:kezhiAddition(obj)
        if power < 0 then
            assert(false, "打出的power为负数， id=" .. self.roleData.id .. ", 目标：" .. obj.roleData.id)
        end


        self.roleSkill:playBullet(self.bulletSpineEvent, self.roleData.bulletSpeed, power, obj)
        
        --更新怒气
        local vv = VitalDefine.attack
        if obj:isDead() then
            if obj:isLeader() then
                vv = vv + VitalDefine.skillLeader
            else
                vv = vv + VitalDefine.skillSolider
            end
        end
        self:updateVital(vv)
        return true
    else
        return false
    end
end

function RoleBase:isLeader()
    return self:getType() == ObjectDefine.objectType.leader
end

--敌方被远程普通攻击的偏移
function RoleBase:getBeBulletAttackOffset()
    if self.PowerPos_attack == 0 then
        return cc.p(0,0)
    elseif self:isLeader() then
        return cc.p(0, 37)
    else    
        return cc.p(0, 16)
    end
end
--远程攻击的偏移
function RoleBase:getBulletAttackOffset()
    return cc.p(self.flyPos_attack[1], self.flyPos_attack[2])
end

--敌方被远程技能的偏移
function RoleBase:getBeSkillAttackOffset()
    if self.PowerPos_skil == 0 then
        return cc.p(0,0)
    elseif self:isLeader() then
        return cc.p(0, 37)
    else    
        return cc.p(0, 16)
    end
end

function RoleBase:updateVitalWithBeAttack(dabv)
    if dabv > 0 then
        local job = self:getJob()
        local vv = 0
        if job == ObjectDefine.jobType.bubing then
            vv = dabv * VitalDefine.job_bubing
        elseif job == ObjectDefine.jobType.qibing then
            vv = dabv * VitalDefine.job_qibing
        elseif job == ObjectDefine.jobType.gongbing then
            vv = dabv * VitalDefine.job_gongbing
        elseif job == ObjectDefine.jobType.fashi then
            vv = dabv * VitalDefine.job_fashi
        elseif job == ObjectDefine.jobType.cike then
            vv = dabv * VitalDefine.job_cike
        end
        self:updateVital(vv)
    end
end

function RoleBase:powerFire(power)
    local p = math.floor(power)
    return self:addHp(-p)
end
--呗普通攻击
function RoleBase:beAttack(power, attackRole, attackType)
    local loseHP = self:powerFire(power)

    --if  not tolua.isnull(attackRole) then
    --    assert(false, "target为空空空空空空空空空空空")
    --end
    if attackRole.isLeader and attackRole:isLeader() then
        self:bubbleWithHp(loseHP)
    end
    
    if attackRole.attackBuffEff then self:PlayBuffEffectFrameAnimation(attackRole.attackBuffEff) end

    self:updateVitalWithBeAttack( math.floor( loseHP  / self.roleProperty.dabHp ) )
end


--呗技能攻击
function RoleBase:beAttackSkill(power, attackRole, attackType)
    local loseHP = self:powerFire(power)

    if attackRole:isLeader() then
        self:bubbleWithHp(loseHP)
    end

    self:updateVitalWithBeAttack( math.floor( loseHP  / self.roleProperty.dabHp ) )
end

--掉血数字冒泡
function RoleBase:bubbleWithHp(hp)
    if hp ~= 0 then
        local hh = math.floor(hp)
        local txt = hh > 0 and "+"..hh or hh
        local x = -20
        local y = 150
        local s = 1.0
        if self:getType() ~= ObjectDefine.objectType.leader then
            y = 80
            s = 0.5
        end

       self.parentLayer:addBubbleHp(txt, self:getPositionX()+x, self:getPositionY()+y, s)
    end
end

function RoleBase:addHp_callback()   
end

--加血
function RoleBase:addHp(value)
    local updateHP = self.roleProperty:addHP(value)
    if updateHP ~= 0 then
        g_fightLogic:updateVSHP({type=updateHP_Type.loseHp, hp=updateHP > 0 and updateHP or -updateHP, camp=self:getCamp()})
        self:addHp_callback()
    
        if 0 >= self.roleProperty:getHP() then
            self.roleAi:setAi(ObjectDefine.Ai.dead)
        end
    end
    
    return updateHP
end

--移动
function RoleBase:moveBy(pos, completeCallback,speedMult)
    local sMult = speedMult or 1

    local function moveComplete()
        self.moveAction = nil
        if completeCallback then completeCallback() end
    end

    local t = 0
    local myPosX, myPosY = 0,0
    local mvPosX, mvPosY = pos.x or 0, pos.y or 0
    local x_dis = math.abs(mvPosX - myPosX)
    local y_dis = math.abs(mvPosY - myPosY)
    local dis = math.sqrt(math.pow(x_dis,2) + math.pow(y_dis,2))
    t = dis/(self.roleProperty.moveSpeed*sMult)

    self.moveAction = transition.moveBy(self, {x=mvPosX,y=mvPosY,time=t,onComplete=moveComplete})
end
function RoleBase:moveTo(pos, completeCallback,speedMult)
    local function moveComplete()
        self.moveAction = nil
        if completeCallback then completeCallback() end
    end
    local sMult = speedMult or 1
    local t = 0
    local myPosX, myPosY = self:getPosition()
    local mvPosX, mvPosY = pos.x or 0, pos.y or 0
    local x_dis = math.abs(mvPosX - myPosX)
    local y_dis = math.abs(mvPosY - myPosY)
    local dis = math.sqrt(math.pow(x_dis,2) + math.pow(y_dis,2))
    t = dis/(self.roleProperty.moveSpeed*sMult)

    self.moveAction = transition.moveTo(self, {x=mvPosX,y=mvPosY,time=t,onComplete=moveComplete})
end

function RoleBase:stopMove()
    if self.moveAction then
        self:stopAction(self.moveAction)
    end
    self.moveAction = nil
end

function RoleBase:emptyVital()
    self.roleProperty.vitalValue = VitalDefine.empty
    self:updateVital(0)
end

--激活技能准备
function RoleBase:activieSkillReally(v)
    if v then
        self.activeSkillIndex = false
        Notifier.postNotifty("addSkillReally_notify", {player=self, skillID=v})
    end
end

function RoleBase:getVitalMax()
    return VitalDefine.max
end

function RoleBase:canPlaySkill()
    if self.roleProperty.vitalValue == self:getVitalMax() then
        return true
    end
    return false
end

--是否可以被发现
function RoleBase:canBeSeek()
    return true
end

function RoleBase:updateVital_callback() 
end

function RoleBase:updateVital(value)
    if not self:isLeader() or self.roleAi:getAi() == ObjectDefine.Ai.skillAttack then
        return 
    end

    self.roleProperty.vitalValue = math.min(self:getVitalMax(), self.roleProperty.vitalValue + value or 0)
    if self:canPlaySkill() and self:campIsOwn() and self.activeSkillIndex then
        local skillid = self.roleSkill:getActiveSkill()
        if skillid then
            self:activieSkillReally(skillid)
        end
    end
    self:updateVital_callback()
end

function RoleBase:addBuff(id)
    self.roleBuff:addBuff(id)
end

function RoleBase:setAi(ai, param)
    self.roleAi:setAi(ai, param)
end

--获取战斗力
--角色战斗力=生命战力值*生命+命中战力值*命中+闪避战力值*闪避+暴击战力值*暴击+抗暴战力值*抗暴+魔伤战力值*魔伤+
--物攻战力值*物攻+物防战力值*物防+魔抗战力值*魔抗+最终伤害*最终伤害战力值+最终免伤*最终免伤战力值
function RoleBase:getFightPower()
    if not self.fightPower_ then
        local generalData = DataManager.getGeneralStaticData()
        local power = generalData[220007].value * self.roleProperty.org.hp
        power = power + generalData[220008].value * self.roleProperty.org.hit
        power = power + generalData[220009].value * self.roleProperty.org.dodge
        power = power + generalData[220010].value * self.roleProperty.org.crit
        power = power + generalData[220011].value * self.roleProperty.org.opposeCrit
        power = power + generalData[220012].value * self.roleProperty.org.magicAttack
        power = power + generalData[220013].value * self.roleProperty.org.physicsAttack
        power = power + generalData[220014].value * self.roleProperty.org.barmor
        power = power + generalData[220015].value * self.roleProperty.org.bresistance
        power = power + generalData[220016].value * self.roleProperty.org.endHurt
        power = power + generalData[220017].value * self.roleProperty.org.offsetHurt
        self.fightPower_ = power
    end
    return self.fightPower_
end

return RoleBase