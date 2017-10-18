------------------------------------
-- author:蓝宛君445
-- email:1053210246@qq.com
-- desc:数组，下标从0开始
------------------------------------
Array = Array or {}
function Array:Create()
    local obj = {}
    setmetatable(obj,self)
    self.__index = self
    
    obj.array = {}
    obj.count = 0
    return obj
end

function Array:CreatByNum(val,count)
    local obj = Array:Create()
    obj:InitByVal(val,count)
    return obj
end

function Array:CreateByTb(tb)
    local obj = Array:Create()
    obj:T2A(tb)
    return obj
end

function Array:GetLen()
    return self.count
end

function Array:ForArray(each_func)
    for i=0,self.count-1 do
        local val = each_func(i,self.array[i])
        if val == false then
            return
        end
    end
end

function Array:ForMap(each_func)
    for key,val in pairs(self.array) do
        local val = each_func(key,val)
        if val == false then
            return
        end
    end
end

function Array:GetVal(idx)
    return self.array[idx]
end

function Array:SetVal(idx,val)
    self.array[idx] = val
end

function Array:GetLast()
    if self.count == 0 then
        return nil
    end
    return self.array[self.count-1]
end

function Array:Push(val)
    self.array[self.count] = val
    self.count = self.count + 1
end

function Array:Pop()
    if self.count==0 then
        return nil
    end
    local top_val = self.array[self.count-1]
    self.count = self.count - 1
    return top_val
end

function Array:InitByVal(val,count)
    for i=0,count-1 do
        self.array[i] = val
    end
	self.count = count
end

function Array:A2T()
    local tb = {}
    self:ForArray(function(key,val)
        table.insert(tb,val)
    end)
    return tb
end

function Array:Clear()
    self.array = {}
    self.count = 0
end

function Array:T2A(tb)
    self:Clear()
    for _,val in ipairs(tb) do
        self:Push(val)
    end
end

function Array:Sort(sort_func)
    local tb = self:A2T()
    table.sort(tb,sort_func)
    self:T2A(tb)
end