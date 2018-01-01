AdManager = {}
local isLoaded = false
if TARGET_PLATFORM == cc.PLATFORM_OS_ANDROID then
	AdManager.ad = HotRequire("src.androidAd")
end
function AdManager:loadAd(extendCallback)
	if self.ad then
		self.ad:loadAd(extendCallback)
	end
end

function AdManager:showAd()
	if self.ad then
		self.ad:showAd()
	end
end

function AdManager:hideAd()
	if self.ad then
		self.ad:hideAd()
	end
end

function AdManager:stateAd()
	if self.ad then
		self.ad:stateAd()
	end
end

AdManager:stateAd()
