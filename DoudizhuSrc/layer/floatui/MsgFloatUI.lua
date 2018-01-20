local MsgFloatUI = class("MsgFloatUI", cocosMake.viewBase)

--规范
MsgFloatUI.ui_resource_file = {}--cocos studio生成的csb
MsgFloatUI.FloatInfoNodeRes = "csb/floatInfoNode.csb"
MsgFloatUI.ui_binding_file = {--控件绑定
    
}

MsgFloatUI.notify = {"Notifty_MsgFloatUI_floatErrorCmd","Notifty_MsgFloatUI_floatMsg"}--通知

function MsgFloatUI:onCreate()
    print("MsgFloatUI:onCreate")
    self.vec = {}
    self.container = cc.Node:create()
    self.container:setPosition(640,360)
    self:addChild(self.container)
    self:__initShow()
end

function MsgFloatUI:onClose()
    print("MsgFloatUI:onClose")
    if self.entryID ~= nil then
        local schedule = self:getScheduler()
        schedule:unscheduleScriptEntry(self.entryID)
    end
end

function MsgFloatUI:__initShow()
    local schedule = self:getScheduler()
    self.entryID = schedule:scheduleScriptFunc(handler(self,self.deltaMsg),0.2,false)
end

function MsgFloatUI:PopMsg()
    if next(self.vec) == nil then
        return nil
    end
    local msg = self.vec[1]
    for i=1,#(self.vec)-1,1 do
        self.vec[i] = self.vec[i+1]
    end
    self.vec[#(self.vec)] = nil
    return msg
end

function MsgFloatUI:deltaMsg(dt)
    if next(self.vec) == nil then
        return
    end
    if self.container:getChildrenCount() >= 3 then
        return
    end
    local msg = self:PopMsg()
    if msg ~= nil then
        self:FloatMsg(msg)
        self:updatePosition()
    end
end

function MsgFloatUI:updatePosition()
    local children = self.container:getChildren()
    for k,v in ipairs(children) do
        local posY = 80*(#children - k)
        local moveto = cc.MoveTo:create(0.1,cc.p(0,posY))
        v:runAction(moveto)
    end
end

function MsgFloatUI:FloatMsg(msg)
    if msg == nil or msg == "" then
        return
    end

    local node = cc.CSLoader:createNode(self.FloatInfoNodeRes)
    local txt = node:getChildByName("txt")
    txt:setString(msg)
    self.curNode = node
    node:runAction(self:getBrushAction())
    node:runAction(self:getLifeAction(node))
    self.container:addChild(node)
end

function MsgFloatUI:pushMsg(msg)
    if self.curNode ~= nil then
        if self.curNode:getChildByName("txt"):getString() == msg then
            self.curNode:stopAllActions()
            self.curNode:setOpacity(255)
            self.curNode:runAction(self:getBrushAction())
            self.curNode:runAction(self:getLifeAction(self.curNode))
            return
        end 
    end
    if next(self.vec) ~= nil then
        if msg == self.vec[#(self.vec)] then
            return
        end
    end
    if msg ~= nil then
        self.vec[#(self.vec)+1] = msg
    end
end

function MsgFloatUI:getBrushAction()
    local scale1 = cc.ScaleTo:create(0.1,0.8)
    local scale2 = cc.ScaleTo:create(0.1,1.2)
    local scale3 = cc.ScaleTo:create(0.1,1.0)
    local tAc = {scale1,scale2,scale3}
    local action = cc.Sequence:create(tAc)
    return action
end

function MsgFloatUI:getLifeAction(node)
    local delay = cc.DelayTime:create(1.8)
    local fadeout = cc.FadeOut:create(0.2)
    local function funcb(target,sender)
        if target.curNode == sender then
            target.curNode = nil
        end
        sender:removeFromParentAndCleanup(true)
    end
    local function funca()
        funcb(self,node)
    end
    local func = cc.CallFunc:create(funca)
    local tAc = {delay,fadeout,func}
    local action = cc.Sequence:create(tAc)
    return action
end

function MsgFloatUI:floatErrorCmd(cmd)
    local msg = TxtCache.ErrorMsg[cmd]
    if msg == nil then
        self:pushMsg("unknown ErrorCode "..cmd)
        return
    end
    self:pushMsg(msg)
end

function MsgFloatUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_MsgFloatUI_floatErrorCmd" then
        self:floatErrorCmd(body.cmd)
    elseif notifyName == "Notifty_MsgFloatUI_floatMsg" then
        self:pushMsg(body.msg)
    end
end
--------------------------------------------------------------------------------------------------------------------
return MsgFloatUI

