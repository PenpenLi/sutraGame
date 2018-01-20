require("cocos.cocos2d.json")
jsonParse = jsonParse or {}
  
--解析csv文件  
function jsonParse.LoadJson(fileName)  
    
    local datapath = "static_client/" .. fileName .. ".json"
    local sourcePath = "res/" .. datapath

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_WINDOWS == targetPlatform) then
        sourcePath = "../../res/" .. datapath
    elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform)  then
        sourcePath = cc.FileUtils:getInstance():getWritablePath() .. "/res/" .. datapath
        Game:initDataBase("res",Constant.DB_NAME)
    end

    local ret = {};  
  
    local file = io.open(sourcePath, "r")  
    assert(file)  

    local data = file:read("*a"); -- 读取所有内容
    file:close() 
    print("jsonParse ------ "..sourcePath)
    return json.decode(data)
 
end