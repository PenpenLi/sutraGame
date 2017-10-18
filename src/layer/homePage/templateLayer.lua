local MainLayer2 = class("MainLayer2", cocosMake.viewBase)

--规范
MainLayer2.ui_resource_file = {"Layer4" , "topMenu", "bottomMenu"}--cocos studio生成的csb

MainLayer2.ui_binding_file = {--控件绑定
logout_btn={name="bottomMenu.logout_btn",event="touch",method="OnBtnClick"},
LoadingBar_1={name="bottomMenu.LoadingBar_1"},
ListView_2={name="Layer4.ListView_2"},

}

MainLayer2.notify = {"openFloatPanel1", "closeFloatPanel1"}--通知


--规范
function MainLayer2:onCreate()
    self.topMenu:setPosition(display.visibleRect.leftBottom.x, display.visibleRect.rightTop.y)
    self.bottomMenu:setPosition(display.visibleRect.rightTop.x, display.visibleRect.leftBottom.y)

    self.LoadingBar_1:setPercent(81)
    
    local listview2 = self.ListView_2
    local function listenFunc(p1, p2)
        local n=0
    end
    --self.ListView_2:onEvent(listenFunc)

    local function listenFunc2(p1, p2)
        local n=0
    end
    --self.ListView_2:onScroll(listenFunc2)
    local function numberOfCellsInTableView(p1, p2)
        local n=0
    end
    local function scrollViewDidScroll(p1, p2)
        local n=0
    end
    local function scrollViewDidZoom(p1, p2)
        local n=0
    end
    local function tableCellTouched(p1, p2)
        local n=0
    end
    local function cellSizeForTable(p1, p2)
        local n=0
    end
    local function tableCellAtIndex(p1, p2)
        local n=0
    end
   

   --[[
   --tableView
    listview2:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    listview2:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
    listview2:registerScriptHandler(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
    listview2:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    listview2:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    listview2:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    --]]
end
--规范
function MainLayer2:onClose()
    print("MainLayer2:onClose")
end
--规范
function MainLayer2:handleNotification(notifyName, body)
    if notifyName == "openFloatPanel" then

    elseif notifyName == "closeFloatPanel" then
    end
end

function MainLayer2:OnBtnClick(event)
    if event.state == 2 then
        Notifier.postNotifty("closeFloatPanel")
        print("++++++++++++++++++++++++++++++")
    end
end

return MainLayer2
