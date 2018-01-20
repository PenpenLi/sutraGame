--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
local ModePart = class("ModePart")

function ModePart:ctor(param)
    self.vec = {}
    self.size = 0
    self.partType = param.type
end

function ModePart:pushMode(modeBaseID)
    table.insert(self.vec,modeBaseID)
    Notifier.postNotifty("Notifty_ModePart_ADD_Mode",{partType = self.partType,value = modeBaseID})
end

function ModePart:popMode(modeBaseID)
    for k,v in pairs(self.vec) do
        if modeBaseID == v then
            table.remove(self.vec,k)
            Notifier.postNotifty("Notifty_ModePart_Remove_Mode",{partType = self.partType,value = modeBaseID})
        end
    end
end

function ModePart:contain(modeBaseID)
    for _,v in pairs(self.vec) do
        if v == modeBaseID then return true end
    end
    return false
end

function ModePart:getModeData(modeBaseID)
    return DataModeManager:getModeData(modeBaseID)
end

function ModePart:getModeCount()
    local count = 0  
    for k,v in pairs(self.vec) do  
        count = count + 1  
    end 
    return count
end

function ModePart:getSize()
    return self.size
end

function ModePart:setSize(size)
    self.size = size
end

function ModePart:getAllMode()
    local modeVec = {}
    for _,v in pairs(self.vec) do
        table.insert(modeVec,v)
    end
    return modeVec
end

function ModePart:clear()
    self.vec = {}
end

return ModePart