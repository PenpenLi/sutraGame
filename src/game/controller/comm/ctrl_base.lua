------------------------------------
-- desc:控制器基类
------------------------------------
local CtrlBase = class("CtrlBase", {})
function CtrlBase:ctor()
    self.sockUserdata = ""

    cc.load("event"):setEventDispatcher(self, GameController)-- 设置事件派发器（默认事件派发器用全局的GameController）
end

function CtrlBase:Init()
    -- self.msg_handler_map = {}
    -- self.event_handler_map = {}
end

--移除事件和消息监听
function CtrlBase:Clear()
    -- self.msg_handler_map = {}
    -- self.event_handler_map = {}
end

function CtrlBase:SendPack(...)
    GameController:SendPack(self.sockUserdata, ...)
end

function CtrlBase:connectTcp(ip, port, domain)
    GameController:connectTcp(ip, port, domain, self.sockUserdata)
end
function CtrlBase:closeConnectedTcp()
    GameController:closeConnectedTcp()
end

return CtrlBase
