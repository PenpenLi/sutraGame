
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


add("ViewBase", "framework.ViewBase")
add("StaticDataLoader", "src.database.StaticDataLoader")
add("csvParse", "src.database.csvParse")
add("jsonParse", "database.jsonParse")


add("authUser", "src.authUser")
add("mainScene", "game.view.scenes.mainScene")
add("loginLayer", "src.layer.loginLayer")
add("roomLayer", "src.layer.roomLayer")
add("mainLayer", "src.layer.mainLayer")
add("reggetLayer", "src.layer.reggetLayer")
add("tipsView", "src.layer.tipsView")
add("playerControl", "src.control.playerControl")
add("gameControl", "src.control.gameControl")
add("hotRequire", "src.hotRequire")
add("Card", "src.layer.Card")



-- 全局事件
add("EventDefine", "game.define.event_define")

-- 工具类
add("UserData", "src.user_data")
add("SongData", "src.song_data")
add("AdManager", "src.AdManager")

add("NumberHelper", "game.utils.number_helper")
add("GameUtil", "game.utils.game_util")
add("EditBoxHelp", "game.utils.editbox_help")
add("TexasUtil", "game.utils.TexasUtil")
add("Array", "game.utils.array")
add("Base64", "game.utils.base64")
add("CacheUtil", "game.utils.cache_util")
add("AnimationSprite", "game.view.component.animation_sprite")

--状态机
add("StateMgr", "game.state.state_mgr")
add("StateBase", "game.state.state_base")
add("StateHall", "game.state.state_hall")
add("StateGame", "game.state.state_game")


--layer
add("GameLayer", "game.view.layers.game_layer")

-- view层
add("TipView", "game.view.widget.tip_view")
add("TipViewEx", "game.view.widget.tip_view_ex")
add("DialogBase", "game.view.widget.dialog_base")
add("DefaultDialog", "game.view.widget.default_dialog")

add("exitGameBoardView", "game.view.widget.exitGameBoard_view")
add("signBoardView", "game.view.widget.signBoard_view")
add("sutraBoardView", "game.view.widget.sutraBoard_view")
add("sutraOverBoardView", "game.view.widget.sutraOverBoard_view")
add("rankView", "game.view.widget.rank_view")
add("taskView", "game.view.widget.task_view")
add("toolView", "game.view.widget.tool_view")


add("CtrlBase", "game.controller.comm.ctrl_base")
add("GameController", "game.controller.comm.game_controller")
add("audioCtrl", "game.controller.audio_ctrl")
add("gameSoundCtrl", "game.controller.sound_ctrl")
add("loadingTipsCtrl", "game.controller.loadingTips_ctrl")
add("ImageCacheCtrl", "game.controller.image_cache_ctrl")

