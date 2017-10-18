

function hotRequire(file_name)
    if file_name == nil then
        print(debug.traceback())
    end
    
    local f = require(file_name)
	package.loaded[file_name] = nil
	return f
end

function ReloadAllLuaFile()
    for file_name,_ in ipairs(lua_file_tb) do
        package.loaded[file_name] = nil
    end
    for file_name,_ in ipairs(lua_file_tb) do
        require(file_name)
    end
end

function ReloadSingleLuaFile(file_name)
    package.loaded[file_name] = nil
    return require(file_name)
end