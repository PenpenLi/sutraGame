--步兵将领
local BubingLeader = class("BubingLeader", require(luaFile.RoleLeader))

function BubingLeader:ctor(param)
    self:init(param)
end

function BubingLeader:init(param)
end

function BubingLeader:starGameWithJob()
    local function restore()
        for i=1,#self.jobBuffEff do
            self:clearEffectSkeleton(self.jobBuffEff[i])
        end
    end
    performWithDelay(self, function() restore() end, 4)


    for i=1,#self.jobBuffEff do
        self:PlayEffectSkeleton(self.jobBuffEff[i], nil, true)
    end
end


return BubingLeader