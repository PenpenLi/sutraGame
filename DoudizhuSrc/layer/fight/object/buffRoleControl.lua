
local buffRoleControl = class("buffRoleControl")

function buffRoleControl:ctor(param)
    self.buffList = {}
    self.buffEffectManager = {}
    
end

function buffRoleControl:setOwner(obj)
    self.owner = obj
end

function buffRoleControl:setOwnerPropertyControl(obj)
    self.owner_properties = obj
end


function buffRoleControl:addBuff(id)
    
    local buff = new_class(luaFile.buffNode,{id=id})
    buff:setOwner(self.owner)
    buff:setBuffControl(self)

    local repeatIndex = false
    if self.buffList[id] then
        self.buffList[id]:remove()
        self.buffList[id] = nil
        repeatIndex = true
    end

    local function createBuff()
        local function removeBuff(id)
            self.buffList[id] = nil
        end
        buff:setRmoveCallback(removeBuff)
        buff:show()

        buff:setVisible(false)
        buff:setPosition(100, 100)--test code
        self.buffList[id] = buff
    end
    
    if false == repeatIndex then
        createBuff()
    else
        performWithDelay(self.owner, createBuff, 0)
    end
end




--BUFF作用
function buffRoleControl:buffEffect(iaAdd, key, property, v, percent)
    local value = tonumber(v)
    local isPercent = percent == 1
    if property == properties.speed then
        if iaAdd then
            self:moveSpeed_addBuff(key, v, isPercent)
        else
            self:moveSpeed_delBuff(key, v, isPercent)
        end

    elseif property == properties.god then
        if iaAdd then
            self:god_addBuff(key, v, isPercent)
        else
            self:god_delBuff(key, v, isPercent)
        end

    elseif property == properties.corbet then
        if iaAdd then
            self:corbet_addBuff(key, v, isPercent)
        else
            self:corbet_delBuff(key, v, isPercent)
        end
    end
end

function buffRoleControl:define_add_buff_function(pro, buff_pro, k, v, isPercent)
    local effect = 0
    if isPercent then effect = pro * (v/100) else effect = v end
    pro = pro + effect
    buff_pro[k] = effect
end
function buffRoleControl:define_del_buff_function(pro, buff_pro, k)
    pro = pro - (buff_pro[k] or 0)
    buff_pro[k] = nil
end

--BUFF--BUFF--BUFF--BUFF--BUFF--BUFF--BUFF--BUFF--BUFF--BUFF

function buffRoleControl:physicsAttack_addBuff(k, v, isPercent)
    self:define_add_buff_function(self.owner_properties.physicsAttack, self.buffEffectManager, k, v, isPercent)
end
function buffRoleControl:physicsAttack_delBuff(k)
    self:define_del_buff_function(self.owner_properties.physicsAttack, self.buffEffectManager, k)
end

function buffRoleControl:moveSpeed_addBuff(k, v, isPercent)
    self:define_add_buff_function(self.owner_properties.moveSpeed, self.buffEffectManager, k, v, isPercent)
end
function buffRoleControl:moveSpeed_delBuff(k)
    self:define_del_buff_function(self.owner_properties.moveSpeed, self.buffEffectManager, k)
end

function buffRoleControl:god_addBuff(k, v, isPercent)
    self:define_add_buff_function(self.owner_properties.god, self.buffEffectManager, k, v, isPercent)
end
function buffRoleControl:god_delBuff(k)
    self:define_del_buff_function(self.owner_properties.god, self.buffEffectManager, k)
end

function buffRoleControl:corbet_addBuff(k, v, isPercent)
    self:define_add_buff_function(self.owner_properties.corbet, self.buffEffectManager, k, v, isPercent)
end
function buffRoleControl:corbet_delBuff(k)
    self:define_del_buff_function(self.owner_properties.corbet, self.buffEffectManager, k)
end

--BUFF--BUFF--BUFF--BUFF--BUFF--BUFF--BUFF--BUFF--BUFF--BUFF


return buffRoleControl
