
local ObjectBase = class("ObjectBase", cocosMake.Sprite)
ObjectBase[".isclass"] = true

function ObjectBase:ctor()
    self.objectType_ = ObjectDefine.objectType.none --类型
    self.key_ = 0--唯一ID
    self.objectManager_ = nil
    
    self:setAnchorPoint(cc.p(0.5, 0))--默认锚点

end
function ObjectBase:init()
    local n=0
end
function ObjectBase:setKey(k)
    self.key_ = k
end


function ObjectBase:getKey()
    return self.key_
end
function ObjectBase:setType(tp)
    self.objectType_ = tp
end
function ObjectBase:getType()
    return self.objectType_
end
return ObjectBase