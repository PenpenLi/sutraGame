
HotRequire("database.init")

-- 游戏相关文件
HotRequire(luaFile.NumberHelper)
HotRequire(luaFile.EditBoxHelp)

HotRequire(luaFile.TipView)
HotRequire(luaFile.TipViewEx)

HotRequire(luaFile.EventDefine)
HotRequire(luaFile.Array)
HotRequire(luaFile.Base64)
HotRequire(luaFile.CacheUtil)
HotRequire(luaFile.UserData)
HotRequire(luaFile.SongData)

TARGET_PLATFORM = cc.Application:getInstance():getTargetPlatform()
if TARGET_PLATFORM == cc.PLATFORM_OS_ANDROID then
	luaj = HotRequire("cocos.cocos2d.luaj")
	HotRequire(luaFile.AdManager)
end