local mainLayer = class("mainLayer", cocosMake.viewBase)
mainLayer.ui_resource_file = {"mainLayerUI"}
mainLayer.ui_binding_file = {
bg={name="mainLayerUI.bg"},
paihangbang_btn={name="mainLayerUI.bg.paihangbang_btn",event="touch",method="paihangbang_btnClick"},
shangdian_btn={name="mainLayerUI.bg.shangdian_btn",event="touch",method="shangdian_btnClick"},
tuichu_btn={name="mainLayerUI.bg.tuichu_btn",event="touch",method="tuichu_btnClick"},
huodong_btn={name="mainLayerUI.bg.huodong_btn",event="touch",method="huodong_btnClick"},
youxichang_btn={name="mainLayerUI.bg.youxichang_btn",event="touch",method="youxichang_btnClick"},
bisai_btn={name="mainLayerUI.bg.bisai_btn",event="touch",method="bisai_btnClick"},
shezhi_btn={name="mainLayerUI.bg.shezhi_btn",event="touch",method="shezhi_btnClick"},
}
--mainLayer.notify = {"openFloatPanel", "closeFloatPanel", "testDataManager"}

function mainLayer:onCreate()
	self.paihangbang_btn:getRendererClicked():setLocalZOrder(1)
	self.shangdian_btn:getRendererClicked():setLocalZOrder(2)
	self.tuichu_btn:getRendererClicked():setLocalZOrder(3)
	self.huodong_btn:getRendererClicked():setLocalZOrder(0)
	self.youxichang_btn:getRendererClicked():setLocalZOrder(1)
	self.bisai_btn:getRendererClicked():setLocalZOrder(2)
	self.shezhi_btn:getRendererClicked():setLocalZOrder(3)
end


function mainLayer:paihangbang_btnClick(event)
    if event.state == 2 then
		
	end
end
function mainLayer:shangdian_btnClick(event)
    if event.state == 2 then
		
	end
end
function mainLayer:tuichu_btnClick(event)
    if event.state == 2 then
		
	end
end
function mainLayer:huodong_btnClick(event)
    if event.state == 2 then
		LayerManager.show(luaFile.roomLayer)
	end
end
function mainLayer:youxichang_btnClick(event)
    if event.state == 2 then
		LayerManager.show(luaFile.roomLayer)
	end
end
function mainLayer:bisai_btnClick(event)
    if event.state == 2 then
		
	end
end
function mainLayer:shezhi_btnClick(event)
    if event.state == 2 then
		
	end
end

function mainLayer:onClose(str)
end

return mainLayer
