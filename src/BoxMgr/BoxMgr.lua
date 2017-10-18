BoxMgr = {}

function BoxMgr.GetGeneralInfoBox(baseId,args)
    local general = DataModeManager:getGeneralData(baseId)
    local node = cc.Node:create()
    local iNum = general:GetStaticProperty(General_StaticProp_Beginquelity)
    local btn = ccui.ImageView:create("common/label/lb_w104_"..iNum..".png")
    btn:setTag(1)
    btn:setAnchorPoint(cc.p(0,0))
    node:addChild(btn)
    if args and args.callBack ~= nil then
        btn:setTouchEnabled(true)
        btn:onTouch(args.callBack)
    end

    local str = general:GetStaticProperty(General_StaticProp_Iconid)
    sprite = cc.Sprite:create(ICON_LEADER_HEAD_UIPATH .. "/"..str..".png")--头像
    sprite:setAnchorPoint(cc.p(0,0))
    sprite:setPosition(cc.p(7,8))
    node:addChild(sprite)
    sprite:setTag(2)

    iNum = general:GetStaticProperty(General_StaticProp_Type)
    sprite = cc.Sprite:create("common/label/lb_w38_"..iNum..".png")--职业
    sprite:setPosition(cc.p(95.00,95.00))
    node:addChild(sprite)
    sprite:setTag(3)

    sprite = cc.Sprite:create("common/label/lb_w38_6.png")--等级背景
    sprite:setAnchorPoint(cc.p(0,0))
    sprite:setPosition(cc.p(4,6))
    node:addChild(sprite)
    sprite:setTag(4)

    local label = ccui.Text:create("","font/fzy4jw.ttf",18)--等级
    label:setAnchorPoint(0,0)
    label:setPosition(13,3)
    label:setTextColor(cc.c4b(255,240,200,255))
    label:enableOutline(cc.c4b(73,38,1,255),3)
    iNum = general:GetProperty(General_Prop_Level)
    label:setString(iNum)
    node:addChild(label)
    label:setTag(5)

    if args and args.nametype == 1 then
        sprite = cocosMake.newSprite(FIGTHUI_UIPATH.."headName_bg.png")
        sprite:setAnchorPoint(00,00)
        sprite:setPosition(5, -13)
        node:addChild(sprite)

        local nm = general:GetStaticProperty(General_StaticProp_Name)
        local name = ccui.Text:create(nm,"font/fzy4jw.ttf",18)--等级
        name:setAnchorPoint(0.5,0.5)
        name:setPosition(45, 13)
        name:setTextColor(cc.c4b(255,240,200,255))
        name:enableOutline(cc.c4b(73,38,1,255),3)
        sprite:addChild(name)
    end
    return node
end