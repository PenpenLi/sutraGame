
local splashScene = class("splashScene", cocosMake.Scene)

function splashScene:ctor()
	self:enableNodeEvents()
end


function splashScene:onEnter()
	
	local landscape = cocosMake.newSprite("res/Default-Landscape~ipad.png", display.center.x, display.center.y)
	self:addChild(landscape)
	
	performWithDelayG(function ()
		cocosMake.runScene(new_class(luaFile.mainScene))
	end, 3.0)
	
	GameController:initPreInfo()
	
	
end


function splashScene:onExit()

end

return splashScene
