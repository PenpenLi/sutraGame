require "Basepack"
soldierDataSnap = class("soldierDataSnap",Basepack)
function soldierDataSnap:ctor()
    self.baseId = nil    --[double]服务器唯一标示ID,0x0
    self.soldierId = nil    --[int]士兵id
    self.level = nil    --[int]等级
    self.quality = nil    --[int]品质
    self.exp = nil    --[int]经验
    self.amount = nil    --[int]小兵数量
    self.physicsAttack = nil    --[int]物攻
    self.magicAttack = nil    --[int]魔伤
    self.barmor = nil    --[int]物防
    self.bresistance = nil    --[int]魔防
    self.hp = nil    --[int]生命
    self.hit = nil    --[int]命中
    self.dodge = nil    --[int]闪避
    self.crit = nil    --[int]暴击
    self.opposeCrit = nil    --[int]抗暴
    self.endHurt = nil    --[int]最终伤害
    self.offsetHurt = nil    --[int]最终免伤

    local function appendToTable(t)
        -- print("soldierDataSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendDouble(t,self.baseId)
            self:appendInt(t,self.soldierId)
            self:appendInt(t,self.level)
            self:appendInt(t,self.quality)
            self:appendInt(t,self.exp)
            self:appendInt(t,self.amount)
            self:appendInt(t,self.physicsAttack)
            self:appendInt(t,self.magicAttack)
            self:appendInt(t,self.barmor)
            self:appendInt(t,self.bresistance)
            self:appendInt(t,self.hp)
            self:appendInt(t,self.hit)
            self:appendInt(t,self.dodge)
            self:appendInt(t,self.crit)
            self:appendInt(t,self.opposeCrit)
            self:appendInt(t,self.endHurt)
            self:appendInt(t,self.offsetHurt)
        end
    end
    self._appendToTable = appendToTable
end
function soldierDataSnap:create()
    local ret = soldierDataSnap.new()
    return ret
end
function soldierDataSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end