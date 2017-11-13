AdManager = {}
local isLoaded = false

function AdManager:loadAd(extendCallback)
	print("AdManager:loadAd")
	local function callbackLua(res)
		print("AdManager:loadAd callbackLua res ", res)
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
	local ok,ret = luaj.callStaticMethod(className,"luaLoadAd",args,sigs)  
	if not ok then
		--item:setString(ok.."error:"..ret)  
		self:loadAd()
	end
end

function AdManager:showAd()
	print("AdManager:showAd")
	if not isLoaded then
		self:loadAd()
		return
	end
	
	local function callbackLua()
	end
	local className="org/cocos2dx/lua/AppActivity" --包名/类名
	local args = { "", callbackLua }
	local sigs = "(Ljava/lang/String;I)V" --传入string参数，无返回值   
	local ok,ret = luaj.callStaticMethod(className,"luaShowAd",args,sigs)  
	if not ok then
	end
end

function AdManager:hideAd()
	print("AdManager:hideAd")
	if not isLoaded then
		return
	end
	
	local function callbackLua()
		self:loadAd()
		isLoaded = false
	end
	local className="org/cocos2dx/lua/AppActivity" --包名/类名
	local args = { "", callbackLua }
	local sigs = "(Ljava/lang/String;I)V" --传入string参数，无返回值   
	local ok,ret = luaj.callStaticMethod(className,"luaHideAd",args,sigs)  
	if not ok then
	end
	callbackLua()
end

function AdManager:stateAd()
	print("AdManager:stateAd")
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

AdManager:stateAd()


