DrawRunner = class("DrawRunner",function () 
    return cc.Sprite:create()
end)

function DrawRunner:create(parameters) 
    self = self.new(parameters)
    self:init(parameters)
    return self
end

function DrawRunner:init(parameters)
    local size = parameters.size
    local drawRunnerPos = parameters.pos or cc.p(475,390)

    -- self.backSprite = Sprite:create({img = "tongyong/huakuai_black.png",pos = drawRunnerPos,sc9 = true ,cap = cc.rect(0,0,2,17),size =cc.size(2,size.height)})
    self.backSprite = cc.Scale9Sprite:create("res/not_package/huatiao/latiao_di.png",cc.rect(0,0,5,53),cc.rect(0,0,0,0))
    self.backSprite:setContentSize(5,size.height)
    self.backSprite:setPosition(drawRunnerPos)
    self.backSprite:setAnchorPoint(cc.p(0.5,0.0))
    self:addChild(self.backSprite)

    -- self.frontSprite = cc.Sprite:createWithSpriteFrameName("tongyong/huakuai_black.png")
    -- self.frontSprite = Sprite:create({img = "tongyong/huakuai_grey.png",pos = drawRunnerPos,sc9 = true ,cap = cc.rect(0,0,2,17),size =cc.size(2,40)})
    self.frontSprite = cc.Scale9Sprite:create("res/not_package/huatiao/latiao.png",cc.rect(0,0,9,17),cc.rect(0,0,0,0))
    self.frontSprite:setContentSize(9,17)
    self.frontSprite:setPosition(cc.p(self.backSprite:getContentSize().width * 0.5,self.backSprite:getContentSize().height - self.frontSprite:getContentSize().height))
    self.frontSprite:setAnchorPoint(cc.p(0.5,0.0))
    self.backSprite:addChild(self.frontSprite)
end
 
