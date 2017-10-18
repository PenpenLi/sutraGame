------------------------------------
-- desc:调用JAVA和OC方法
------------------------------------
function call_java_oc_func(func_name,class_name)
    
    if TARGET_PLATFORM ==  cc.PLATFORM_OS_ANDROID  then 
        local luaj = require "cocos/cocos2d/luaj"
        local class = class_name or "org/cocos2dx/cpp/AppUtils"
        local func = func_name
        local sig = "()Ljava/lang/String;"
        local args = {}
        --执行
        local ok, ret = luaj.callStaticMethod(class, func, args, sig)
        if not ok then
            print("luaj error:", ret)
        else
            print("luaj ret is:", ret)
        end
        return ret
        
    elseif TARGET_PLATFORM == cc.PLATFORM_OS_IPHONE or TARGET_PLATFORM == cc.PLATFORM_OS_IPAD then
        local luaoc = require "cocos/cocos2d/luaoc"
        local class = class_name or "IOSUtility"
        local func = func_name
        local ok, ret = luaoc.callStaticMethod(class, func)
        if not ok then
            print("luaoc error:", ret)
        else
             print("luaoc ret is:", ret)
        end
        return ret
    end
end
