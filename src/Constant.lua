--定义一些全局常量
Constant = Constant or {}

--网络常量
Constant.Network = {}
Constant.Network.CODE_ONOPEN    = 1
Constant.Network.CODE_ONMESSAGE = 2
Constant.Network.CODE_ONERROR   = 3
Constant.Network.CODE_ONCLOSE   = 4
Constant.Network.CODE_RECONNECT = 6
Constant.Network.CODE_RECONNECTERROR = 7
Constant.Network.NETSTATE_CHANGE = "Event_Netstate_Change"
Constant.Network.CONNECT_EVENT = "Event_MSG_Connect"
--网络请求成功失败响应
Constant.Network.CODE_SUCCESS = 0
Constant.Network.CODE_FAIL = 1
Constant.Network.REQUEST_TIMEOUT = 30

--------------------fight--------------------
Constant.DB_NAME = ""

Constant.gameVersion = "1.0"
Constant.savekey_gameVersion = "DoudizhuClientVersion"
Constant.server_checkVersion_desc = "cv"

Constant.UserTokenInfo = {
    --server = "s1",
    uid = "",
    connectIndex = 1,--连接登录服务器序列号
    messageSession = 0,--消息会话
    secret = "",
    --gameserver = "",
    --username = "",
    --userpassward = ""
}