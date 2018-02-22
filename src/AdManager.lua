AdManager = {}
local isLoaded = false
local ad

if TARGET_PLATFORM == cc.PLATFORM_OS_ANDROID then
	ad = HotRequire("src.androidAd")
elseif TARGET_PLATFORM == cc.PLATFORM_OS_IPHONE or TARGET_PLATFORM == cc.PLATFORM_OS_IPAD then
    ad = HotRequire("src.iosAd")
end
function AdManager:loadAd(extendCallback)
	if ad then
		ad:loadAd(extendCallback)
	end
end

function AdManager:showAd()
	if ad then
		ad:showAd()
	end
end

function AdManager:hideAd()
	if ad then
		ad:hideAd()
	end
end

function AdManager:stateAd()
	if ad then
		ad:stateAd()
	end
end

function AdManager:getUUID()
	if ad then
		return ad:getUUID()
	end
	return "ABCDEFG1234567891"
end

AdManager:stateAd()
