require "Basepack"
testData_c = class("testData_c",Basepack)
function testData_c:ctor()
    self._packtype = 903    --[int]包标识,0x387
    self._packindex = nil    --[int]标志
    self.testStr = nil    --[string]快捷添加各种资源。数据格式（101_1_100）

    local function appendToTable(t)
        -- print("testData_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendString(t,self.testStr)
        end
    end
    self._appendToTable = appendToTable
end
function testData_c:create()
    local ret = testData_c.new()
    return ret
end
function testData_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end