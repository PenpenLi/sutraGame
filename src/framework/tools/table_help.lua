------------------------------------
-- desc:表处理相关工具
------------------------------------
local tableEx = table
function tableEx:Concat(dest_tb,src_tb)
    for _,info in ipairs(src_tb) do
        table.insert(dest_tb,info)
    end
    return dest_tb
end

function tableEx:Count(tb)
    if not tb then
        return 0
    end
    local count = 0
    for key,val in pairs(tb) do
        count=count+1
    end
    return count
end

function tableEx:HasLuaKey(msg,key)
    for _key,_val in pairs(msg) do
        if _key == key then
            return true
        end
    end
    return false
end


-- 序列化 table->string
function tableEx.serialize(tab)
    local str = ""
    local t = type(tab)
    if t == "number" then
        str = str .. tab
    elseif t == "boolean" then
        str = str .. tostring(tab)
    elseif t == "string" then
        str = str .. string.format("%q", tab)
    elseif t == "table" then
        str = str .. "{"
        for k, v in pairs(tab) do
            str = str .. "[" .. tableEx.serialize(k) .. "]=" .. tableEx.serialize(v) .. ",\n"
        end
        local metatable = getmetatable(tab)
            if metatable ~= nil and type(metatable.__index) == "table" then
            for k, v in pairs(metatable.__index) do
                str = str .. "[" .. tableEx.serialize(k) .. "]=" .. tableEx.serialize(v) .. ",\n"
            end
        end
        str = str .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not tableEx.serialize a " .. t .. " type.")
    end
    return str
end

-- 反序列化 string->table
function tableEx.unserialize(str)
    local t = type(str)
    if t == "nil" or str == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        str = tostring(str)
    else
        error("can not unserialize a " .. t .. " type.")
    end
    str = "return " .. str
    local func = loadstring(str)
    if func == nil then
        return nil
    end
    return func()
end
