
luaFile = {}


local function add(name, def)
    if luaFile[name] and luaFile[name] == def then
        error("存在相同LuaName：" .. name)
        return
    end
    luaFile[name] = def
end


add("networkManager", "src.NetWork.networkManager")
add("networkAuthUser", "src.NetWork.networkHandle_authUser")
add("networkGame", "src.NetWork.networkHandle_game")


add("ViewBase", "src.com.ViewBase")
add("StaticDataLoader", "src.database.StaticDataLoader")
add("csvParse", "src.database.csvParse")


add("authUser", "src.authUser")
add("mainScene", "src.scenes.mainScene")
add("loginLayer", "src.layer.loginLayer")
add("roomLayer", "src.layer.roomLayer")
add("mainLayer", "src.layer.mainLayer")
add("reggetLayer", "src.layer.reggetLayer")
add("tipsView", "src.layer.tipsView")
add("playerControl", "src.control.playerControl")
add("gameControl", "src.control.gameControl")
add("hotRequire", "src.hotRequire")
add("Card", "src.layer.Card")

