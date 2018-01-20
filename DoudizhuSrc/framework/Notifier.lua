--通知者
Notifier = {}
Notifier.container = {}

function Notifier.init()
    
end

-- 添加一个观察者(观察者需要有handleNotification函数和notify属性)
function Notifier.addObserver( mediator )
    local array = mediator.notify or {}
    for key, var in ipairs(array) do
        if var ~= "" then
            if Notifier.container[var] == nil then  
               Notifier.container[var] = {}  
            end  
            table.insert(Notifier.container[var],mediator)  
        end
    end
end

-- 删除一个观察者  
function Notifier.removeObserver(mediator)  
    local array = mediator.notify or {}
    for key, var in ipairs(array) do  
        if Notifier.container[var] ~= nil then  
            local j = 1  
            local len = #Notifier.container[var]  
            for i=1,len do  
                local observer = Notifier.container[var][j]  
                if observer == mediator then  
                   table.remove(Notifier.container[var],j)  
                else  
                   j = j + 1  
                end  
            end  
        end  
    end  
end  
  
-- 发布消息  , 在接收体内使用body的数据应先缓存起来，body可能提前被释放
function Notifier.postNotifty(notifierName,body)  
    local observers = Notifier.container[notifierName]  
    if observers == nil then  
        return  
    end  

    for key, var in ipairs(observers) do  
        var:handleNotification(notifierName, body or {})
    end  
end

-- 得到消息
function Notifier.getNotifty(notifierName,body)  
    local observers = Notifier.container[notifierName]  
    if observers == nil then  
        return  
    end  
      
    for key, var in ipairs(observers) do  
        return var:handleNotification(notifierName, body or {})  
    end  
end