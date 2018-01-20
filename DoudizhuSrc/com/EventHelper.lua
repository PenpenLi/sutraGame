EventHelper = class("EventHelper")

EventHelper.msgQueue = EventHelper.msgQueue or {}

EventHelper.listeners = {}

function EventHelper:getEventDispatcher()
    if EventHelper.updateFunc == nil then
        EventHelper.updateFunc = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(delta)
            EventHelper.update(delta)
        end,0,false)
    end
	return cocosMake.Director:getEventDispatcher()
end

function EventHelper:addListener(eventname,callback)
	local function eventHandler(event)
        local data = event._userData
        print("eventHandler action")
        if callback then
        	callback(data)
        end
    end

    local listener = cc.EventListenerCustom:create(eventname,eventHandler)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener,1)

    table.insert(EventHelper.listeners,listener)
    return listener
end

function EventHelper:removeListener(listener)
    EventHelper:getEventDispatcher()
	local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:removeEventListener(listener)

    if EventHelper.listeners and listener then
        local index
        for i,v in ipairs(EventHelper.listeners) do
            if v == listener then
                index = i
                break
            end
        end
        if index then
            table.remove(EventHelper.listeners,index)
        end
    end
end

function EventHelper:sendEvent(name,data)
    EventHelper:getEventDispatcher()
    table.insert(EventHelper.msgQueue,{name=name,data=data})    
end

function EventHelper.update(delta)
    if EventHelper:getEventDispatcher():isEnabled() then
        for i,v in ipairs(EventHelper.msgQueue) do
            local event = cc.EventCustom:new(v.name)
            event._userData = v.data
            local eventDispatcher = EventHelper:getEventDispatcher()
            eventDispatcher:dispatchEvent(event)
            table.remove(EventHelper.msgQueue,i)
        end
    else
        -- print("EventHelper正忙",#EventHelper.msgQueue)
    end
end

function EventHelper:removeAllListener()
    local eventDispatcher = self:getEventDispatcher()
    for i,v in ipairs(EventHelper.listeners) do
        eventDispatcher:removeEventListener(v)
    end
    EventHelper.listeners = {}
end