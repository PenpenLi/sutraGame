require "Basepack"
leaderDataSnap = class("leaderDataSnap",Basepack)
function leaderDataSnap:ctor()
    self.playerId = nil    --[double]玩家Id,0x0
    self.baseId = nil    --[double]服务器基础ID
    self.leaderId = nil    --[int]将领id
    self.level = nil    --[int]等级
    self.grade = nil    --[int]品阶
    self.talentLv = nil    --[int]天赋等级
    self.seat = nil    --[int]将领上阵位置
    self.state = nil    --[int]将领状态
    self.exp = nil    --[int]经验
    self.soldiers = {}    --[soldierDataSnap]小兵数据
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
        -- print("leaderDataSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendDouble(t,self.playerId)
            self:appendDouble(t,self.baseId)
            self:appendInt(t,self.leaderId)
            self:appendInt(t,self.level)
            self:appendInt(t,self.grade)
            self:appendInt(t,self.talentLv)
            self:appendInt(t,self.seat)
            self:appendInt(t,self.state)
            self:appendInt(t,self.exp)
            self:appendObject(t,self.soldiers)
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
function leaderDataSnap:create()
    local ret = leaderDataSnap.new()
    return ret
end
function leaderDataSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end