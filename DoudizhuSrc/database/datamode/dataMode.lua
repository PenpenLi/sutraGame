
local DataMode = class("DataMode")

DataMode.property = {}

DataMode[".isclass"] = true

function DataMode:ctor()

end

function DataMode:postNotifty(name,param)
    Notifier.postNotifty(name,param)
end

return DataMode