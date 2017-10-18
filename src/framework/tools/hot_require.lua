------------------------------------
-- desc:热刷新处理
------------------------------------
local lua_file_tb = {}

function HotRequire(file_name)
    if file_name == nil then
        print(debug.traceback())
    end
    package.loaded[file_name] = nil
    lua_file_tb[file_name] = true
    return require(file_name)
end

function ReloadAllLuaFile()
    for file_name,_ in pairs(lua_file_tb) do
        package.loaded[file_name] = nil
        lua_file_tb[file_name] = true
        require(file_name)
    end
end

function UnloadAllLuaFile()
    for file_name,_ in pairs(lua_file_tb) do
        package.loaded[file_name] = nil
        table.remove(lua_file_tb, file_name)
    end
end

function ReloadSingleLuaFile(file_name)
    package.loaded[file_name] = nil
    return require(file_name)
end
