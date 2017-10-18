--²½±øÊ¿±ø
local BubingSoldier = class("BubingSoldier", require(luaFile.RoleInfantry))

function BubingSoldier:ctor(param)
    self:init(param)
end

function BubingSoldier:init(param)
end

function BubingSoldier:starGameWithJob()
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

return BubingSoldier