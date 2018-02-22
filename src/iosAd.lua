local IOSAD = {}
local isLoaded = false
luaoc = HotRequire("cocos.cocos2d.luaoc")
local className="IOSUtility" --包名/类名

function IOSAD:loadAd(extendCallback)
	print("IOSAD:loadAd")
	local function callbackLua(res)
		print("IOSAD:loadAd callbackLua res ", res)
		if res == "success" then
			isLoaded = true
			if extendCallback then extendCallback() end
		else
			self:loadAd()
		end
	end

	local args = { callback = callbackLua }
	local ok,ret = luaoc.callStaticMethod(className,"luaLoadAd",args)
	if not ok then
		--item:setString(ok.."error:"..ret)  
		--self:loadAd()
	end
end

function IOSAD:showAd()
	print("IOSAD:showAd")
	
	
	local function callbackLua()
	end
	local args = { callback = callbackLua }
	local sigs = "(Ljava/lang/String;I)V" --传入string参数，无返回值   
	local ok,ret = luaoc.callStaticMethod(className,"luaShowAd",args,sigs)  
	if not ok then
	end
end

function IOSAD:hideAd()
	print("IOSAD:hideAd")
	
	local function callbackLua()
		
	end
	local args = { callback = callbackLua }
	local sigs = "(Ljava/lang/String;I)V" --传入string参数，无返回值   
	local ok,ret = luaoc.callStaticMethod(className,"luaHideAd",args,sigs)  
	if not ok then
	end
end

function IOSAD:stateAd()
	print("IOSAD:stateAd")
	local function callbackLua(res)
		self:stateAd()
	end
	local args = { callback = callbackLua }
	local sigs = "(Ljava/lang/String;I)V" --传入string参数，无返回值   
	local ok,ret = luaoc.callStaticMethod(className,"luaStateAd",args,sigs)  
	if not ok then
	end
end

function IOSAD:getUUID()
	print("getUUID")
	local args = {  }
	local sigs = "()Ljava/lang/String;" --传入string参数，无返回值   
	local ok,ret = luaoc.callStaticMethod(className,"getDeviceClientId",args,sigs)  
	log("callcall", ok, ret)
	if not ok then
		return ""
	end
	
	return ret
end

IOSAD:stateAd()
return IOSAD
