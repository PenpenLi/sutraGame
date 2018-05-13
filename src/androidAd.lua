local androidAD = {}
local isLoaded = false
luaj = HotRequire("cocos.cocos2d.luaj")

function androidAD:loadAd(extendCallback)
	print("androidAD:loadAd")
	local function callbackLua(res)
		print("androidAD:loadAd callbackLua res ", res)
		if res == "success" then
			isLoaded = true
			if extendCallback then extendCallback() end
		else
			self:loadAd()
		end
	end
	local className="org/cocos2dx/lua/AppActivity" --包名/类名
	local args = { "", callbackLua }
	local sigs = "(Ljava/lang/String;I)V" --传入string参数，无返回值   
	--local ok,ret = luaj.callStaticMethod(className,"luaLoadAd",args,sigs)  
	--if not ok then
		--item:setString(ok.."error:"..ret)  
		--self:loadAd()
	--end
end

function androidAD:showAd()
	print("androidAD:showAd")
	
	
	local function callbackLua()
	end
	local className="org/cocos2dx/lua/AppActivity" --包名/类名
	local args = { "", callbackLua }
	local sigs = "(Ljava/lang/String;I)V" --传入string参数，无返回值   
	local ok,ret = luaj.callStaticMethod(className,"luaShowAd",args,sigs)  
	if not ok then
	end
end

function androidAD:hideAd()
	print("androidAD:hideAd")
	
	local function callbackLua()
		
	end
	local className="org/cocos2dx/lua/AppActivity" --包名/类名
	local args = { "", callbackLua }
	local sigs = "(Ljava/lang/String;I)V" --传入string参数，无返回值   
	local ok,ret = luaj.callStaticMethod(className,"luaHideAd",args,sigs)  
	if not ok then
	end
end

function androidAD:stateAd()
	print("androidAD:stateAd")
	local function callbackLua(res)
		self:stateAd()
	end
	local className="org/cocos2dx/lua/AppActivity" --包名/类名
	local args = { "", callbackLua }
	local sigs = "(Ljava/lang/String;I)V" --传入string参数，无返回值   
	local ok,ret = luaj.callStaticMethod(className,"luaStateAd",args,sigs)  
	if not ok then
	end
end

function androidAD:getUUID()
	print("getUUID")
	local className="org/cocos2dx/lua/AppUtils" --包名/类名
	local args = {  }
	local sigs = "()Ljava/lang/String;"
	local ok,ret = luaj.callStaticMethod(className,"getDeviceClientId",args,sigs)  
	log("callcall", ok, ret)
	if not ok then
		return ""
	end
	
	return ret
end

function androidAD:setSysClipboardText(text)
	print("getUUID")
	local className="org/cocos2dx/lua/AppActivity" --包名/类名
	local args = { text }
	local sigs = "(Ljava/lang/String)V" --传入string参数，无返回值   
	local ok,ret = luaj.callStaticMethod(className,"setSysClipboardText",args,sigs)  
	log("callcall", ok, ret)
	if not ok then
		return ""
	end
	
	return ret
end

androidAD:stateAd()
return androidAD
