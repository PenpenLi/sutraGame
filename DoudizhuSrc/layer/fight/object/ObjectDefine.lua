
if not ObjectDefine then ObjectDefine = {} end

--单位类型
ObjectDefine.objectType = {
    none            = 1,--null
    infantry        = 2,--步兵
    leader          = 3,--将领
    skill            = 4,--技能
    bullet           = 5--飞行武器
}

--职业
ObjectDefine.jobType = {
    none            = 0,--null
    bubing          = 1,
    qibing          = 2,
    gongbing        = 3,--弓兵
    cike            = 4,
    fashi           = 5
    
}

--单位朝向
ObjectDefine.Direction = {
    none            = 1,--null
    right           = 2,
    left            = 3
}

--AI状态
ObjectDefine.Ai = {
    none            = 1,--null
    idle           = 2,--等待
    attack          = 3,--普攻
    dead            = 4,--死亡
    run            = 5,--跑动
    seekFoe        = 6,--寻找敌人
    runToFoe       = 7,--跑向敌人
    charge         = 8,--冲锋
    fightWin         = 9,--胜利
    freeze          = 10,--冰冻
    skillAttack     = 11--技能攻击
}
ObjectDefine.Ai_Event = {
    enter            = 1,
    execute          = 2,
    exit             = 3
}

--阵营
ObjectDefine.Camp = {
    none            = 0,
    own             = 1,
    enemy           = 2
}


--攻击属性
ObjectDefine.hurtType = {
    none            = 0,
    hp_att           = 1,--物理
    mp_att             = 2,--魔法
    hp_res             = 3--回血
}

--更新VS HP 类型
updateHP_Type = {
    upLimit = 1,
    downLimit = 2,
    upLimit_addHp = 3,
    downLimit_loseHp = 4,
    loseHp = 5,
    addHp = 6
}

--战斗状态
fightState = {
    none = 0,
    really = 1,
    fighting = 2,
    over = 3,
    finish = 4
}
fightResult = {
    none = 0,
    win_own = 1,
    win_enemy = 2
}

--属性名称
properties = {
    level           = 1,
    attackRange     = 2, --攻击距离
    attackSpeed     = 3,----攻击频率
    speed           = 4,--移动速度
    physicsAttack   = 5,--物攻
    magicAttack     = 6,--魔伤
    barmor          = 7,--物防
    bresistance     = 8,--魔防
    hp              = 9,--生命
    hit             = 10,--命中
    dodge           = 11,--闪避
    crit            = 12,--暴击
    opposeCrit      = 13,--抗暴
    god             = 14,--无敌
    corbet          = 15--隐形
}

--怒气
VitalDefine = {
    skillLeader = 720,
    skillSolider = 115,
    attack = 160,
    max = 1000,
    job_bubing = 5,
    job_qibing = 8,
    job_gongbing = 10,
    job_fashi = 10,
    job_cike = 12,
    empty = 0
}

--阵形
fightEmbattle = {
    em_frontLeader = 0,
    em_backLeader = 1,
}

--战斗序列帧播放速率
fight_soldier_frames_play_rate = 0.03
fight_skill_frames_play_rate = 0.05