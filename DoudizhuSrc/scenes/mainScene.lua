local mainScene = class("mainScene", cocosMake.Scene)
require(luaFile.networkManager)

function mainScene:ctor()
    --local mainlayer = cocosMake.newLayer()
    --mainlayer:setPosition(0, 0)
    --self:addChild(mainlayer, 1)
end

function mainScene:showMainLayer()
    
    LayerManager.show(luaFile.loginLayer)
    --LayerManager.show("layer.scrollviewLayer")
end

return mainScene