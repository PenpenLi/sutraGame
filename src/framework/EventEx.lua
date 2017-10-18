

local Event = cc.load("event")

local EXPORTED_METHODS = {
    "addEventListener",
    "dispatchEvent",
    "removeEventListener",
    "removeEventListenersByTag",
    "removeEventListenersByEvent",
    "removeAllEventListeners",
    "hasEventListener",
    "dumpAllEventListeners",
    "addEventListenerList",
    "removeEventListenerList",
}

function Event:bind(target)
    self:init_()
    cc.setmethods(target, self, EXPORTED_METHODS)
    self.target_ = target
end

function Event:unbind(target)
    cc.unsetmethods(target, EXPORTED_METHODS)
    self:init_()
end

--event代理
function Event:setEventDispatcher(target, eventDispatcher)
    for i,v in ipairs(EXPORTED_METHODS) do
        if eventDispatcher[v] then
           target[v] = function (_, ...)
                return eventDispatcher[v](eventDispatcher, ...)
            end 
        end
    end
end

function Event:addEventListenerList(listenerList)
    local handlerList = {}
    for i,v in ipairs(listenerList) do
        if v[1] and v[2] then
            local handle, target = self:addEventListener(v[1], v[2])
			handlerList[#handlerList + 1] = handle
        end
    end
    return handlerList
end

function Event:removeEventListenerList(handlerList)
    if handlerList then
        assert(type(handlerList) == "table", "handlerList type is not table")
        for i,v in ipairs(handlerList) do
            self:removeEventListener(v)
        end
    end
end
