require "Basepack"
packageList_s = class("packageList_s",Basepack)
function packageList_s:ctor()
    self._packtype = 10042    --[int]包标识,0x273a
    self._packindex = nil    --[int]标志
    self.item_list = nil    --[array]
    self.valid_gird = nil    --[int]

    local function appendToTable(t)
        -- print("packageList_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendObjectArray(t,self.item_list)
            self:appendInt(t,self.valid_gird)
        end
    end
    self._appendToTable = appendToTable
end
function packageList_s:create()
    local ret = packageList_s.new()
    return ret
end
function packageList_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end