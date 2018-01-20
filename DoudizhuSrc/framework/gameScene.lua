--region *.lua
--Date
local gameScene = class("gameScene")

function gameScene:onCreate()
    self.mainScene = nil
    self:createMainScene()
end


function gameScene:createMainScene()
    if self.mainScene == nil then
        local mainscene = new_scene("mainScene")
        cocosMake.runScene(mainscene)
    end
end

return gameScene
--endregion
