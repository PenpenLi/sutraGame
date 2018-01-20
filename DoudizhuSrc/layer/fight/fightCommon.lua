
function transHurtType(value)
    local hurtTypes = ObjectDefine.hurtType.none
    if value == 1 then hurtTypes = ObjectDefine.hurtType.hp_att end
    if value == 2 then hurtTypes = ObjectDefine.hurtType.mp_att end
    if value == 3 then hurtTypes = ObjectDefine.hurtType.hp_res end
    return hurtTypes
end