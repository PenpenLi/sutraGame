------------------------------------
-- desc:UI控件处理相关工具
------------------------------------
WidgetHelp = WidgetHelp or {
    frame_animation_list = {}
}
WidgetHelp.framesAnimationCache = {}
function WidgetHelp:RegWidgetAndEvent(class_obj,root,widget_list)
    class_obj._widget_name_tb = class_obj._widget_name_tb or {}

    for nodeName, nodeBinding in pairs(widget_list) do
        if nodeBinding.name then
            local nodepath = string.split(nodeBinding.name, ".")
            local cur_widget = root
            for _,widget_name in ipairs(nodepath) do
                cur_widget = cur_widget:getChildByName(widget_name)
            end
            if cur_widget then
                class_obj[nodeName] = cur_widget
                class_obj._widget_name_tb[nodeName] = cur_widget
                if nodeBinding.event and nodeBinding.method then
					if nodeBinding.event == "touch" then
						cur_widget:onTouch(handler(class_obj, class_obj[nodeBinding.method]))
						
					elseif nodeBinding.event == "click" then--button clicked
						local func = handler(class_obj, class_obj[nodeBinding.method])
                        cur_widget:onClicked(function(...)  ccexp.AudioEngine:play2d(nodeBinding.sound)  func(...) end)
					end
                end
            end
        end
    end
end

function WidgetHelp:UnRegWidget(class_obj)
    if not class_obj._widget_name_tb then
        return
    end
    for nodeName,_ in pairs(class_obj._widget_name_tb) do
        class_obj[nodeName] = nil
    end
    class_obj._widget_name_tb = nil
end

function WidgetHelp:PlayFrameAnimation(img,interval,res_path,res_num,res_type,play_time,callback)
    if res_type == nil then
        res_type = ccui.TextureResType.localType
    end

    local cur_time = -interval
    local res_index = 0
    local timer_handler = nil
    local play_next = function()
        res_index = res_index + 1
        if res_index > res_num then
            res_index = 1
        end
		
        img:setTexture(res_path..res_index..".png")
        --img:setContentSize(img:getVirtualRendererSize())

        cur_time = cur_time + interval
        if play_time and cur_time>play_time then
            if callback then
                RealTimer:UnRegTimer(timer_handler)
                callback(img,timer_handler)
            else
                self:RemoveFrameAnimation(timer_handler)
            end
        end
    end
    timer_handler = RealTimer:RegTimerLoop(interval,play_next)
    self.frame_animation_list[timer_handler] = img
    play_next()
    return timer_handler
end

--播放序列帧animation，每帧以单位数字为名
function WidgetHelp:PlayFramesAnimation(animPath, animName, frameCount, startFrameIndex, isReversed)
	if not WidgetHelp.framesAnimationCache[animPath] then
        local dataFilename = animPath .. ".plist"
		local dataImagename = animPath .. ".png"

        -- 判断文件是否存在
        if not (cc.FileUtils:getInstance():isFileExist(dataFilename)
            and cc.FileUtils:getInstance():isFileExist(dataImagename)) then
            return
        end
		
		local plistInfo = cc.FileUtils:getInstance():getValueMapFromFile(dataFilename)
		local frame_count = table.nums(plistInfo.frames)
        WidgetHelp.framesAnimationCache[animPath] = frame_count
		
		cocosMake.loadSpriteFrames(dataFilename, dataImagename)
    end

    local frame_count = WidgetHelp.framesAnimationCache[animPath]
	local frameInterval = 0.05
    local anim,frameSize = cocosMake.newAnimation(animName .. "/", startFrameIndex or 1, frameCount or frame_count, isReversed or false, frameInterval, 0)
    return anim, frameSize, frameInterval*frame_count
end

function WidgetHelp:RemoveFrameAnimation(handler)
    if not handler then
        return
    end
    RealTimer:UnRegTimer(handler)
    local img = self.frame_animation_list[handler]
    if img then
        img:removeFromParent()
        img = nil
    end
end

function WidgetHelp:FadeOut(obj,time,callback)
    time = time or 0.2
    local action_list = {}
    action_list[#action_list + 1] = cc.FadeOut:create(time)
    action_list[#action_list + 1] = cc.CallFunc:create(function()
        if callback then
            callback()
        end
    end)
    local action = cc.Sequence:create(unpack(action_list))
    obj:runAction(action)
end

function WidgetHelp:FadeIn(obj,time)
    time = time or 0.2
    local action_list = {}
    action_list[#action_list + 1] = cc.FadeIn:create(time)
    local action = cc.Sequence:create(unpack(action_list))
    obj:runAction(action)
    obj:setOpacity(0)
end

function WidgetHelp:MoveTo(obj,pos,time,callback)
    local action_list = {}
    action_list[#action_list + 1] = cc.MoveTo:create(time, pos)
    action_list[#action_list + 1] = cc.CallFunc:create(function()
        if callback then
            callback()
        end
    end)
    local action = cc.Sequence:create(unpack(action_list))
    obj:runAction(action)
end

--循環移動action
function WidgetHelp:RepeatFloat(obj,p1,p2,callback,time)
    time = time or 0.7
    obj:stopAllActions()
    obj:setPosition(p1)
    local action_list = {}
    action_list[#action_list + 1] = cc.MoveTo:create(time, p1)
    action_list[#action_list + 1] = cc.MoveTo:create(time, p2)
	action_list[#action_list + 1] = cc.CallFunc:create(function() if callback then callback(obj) end end)
    local action = cc.RepeatForever:create(cc.Sequence:create(unpack(action_list)))
    obj:runAction(action)
end

function WidgetHelp:RepeatFloatEx1(obj,movePos,callback,time)
    time = time or 0.7
    obj:stopAllActions()
    local action_list = {}
    action_list[#action_list + 1] = cc.MoveBy:create(time, movePos)
	if callback then 
		action_list[#action_list + 1] = cc.CallFunc:create(function() if callback then callback(obj) end end)
	end
    local action = cc.RepeatForever:create(cc.Sequence:create(unpack(action_list)))
    obj:runAction(action)
end

function WidgetHelp:InitSwitchBtn(
    switch_bg,
    switch_btn,
    open_pos,
    close_pos,
    open_skin,
    close_skin,
    init_state,
    callback,time)
    time = time or 0.1
    local switch_state = init_state
    local function click_switch(node, event)
        if event ~= ccui.TouchEventType.ended then
           return 
        end
        switch_state = not switch_state
        if switch_state then
            WidgetHelp:MoveTo(switch_btn,open_pos,time)
            switch_btn:loadTextures(open_skin.up,open_skin.down)
        else
            WidgetHelp:MoveTo(switch_btn,close_pos,time)
            switch_btn:loadTextures(close_skin.up,close_skin.down)
        end
        if callback then
            callback(switch_state)
        end
    end
    switch_bg:addTouchEventListener(click_switch)
    switch_btn:addTouchEventListener(click_switch)
    if init_state then
        switch_btn:loadTextures(open_skin.up,open_skin.down)
        switch_btn:setPosition(open_pos)
    else
        switch_btn:loadTextures(close_skin.up,close_skin.down)
        switch_btn:setPosition(close_pos)
    end
end

function WidgetHelp:InitSwitchBtn2(
    switch_on,
    switch_off,
    init_state,
    callback)
    time = time or 0.1
    local switch_state = init_state
    local function click_switch(node, event)
        if event ~= ccui.TouchEventType.ended then
           return 
        end
		
		switch_state = not switch_state
		switch_on:setTouchEnabled(switch_state)
		switch_on:setVisible(switch_state)
		switch_off:setTouchEnabled(not switch_state)
		switch_off:setVisible(not switch_state)
		
        if callback then
            callback(switch_state)
        end
    end
    switch_on:addTouchEventListener(click_switch)
	switch_on:setTouchEnabled(init_state)
	switch_on:setVisible(init_state)
    switch_off:addTouchEventListener(click_switch)
	switch_off:setTouchEnabled(not init_state)
	switch_off:setVisible(not init_state)
end

function WidgetHelp:CenterX(obj,inner_width,out_width)
    if not out_width then
        out_width = cc.Director:getInstance():getVisibleSize().width
    end
    local x = out_width*0.5-inner_width*0.5
    obj:setPositionX(x)
end

function WidgetHelp:ZhuAlign(zhu_panel,align_type)
    local zhu_val = zhu_panel:getChildByName("zhu_val")
    local zhu_val_bg = zhu_panel:getChildByName("zhu_val_bg")
    local zhu = zhu_panel:getChildByName("zhu")
	
	local zhu_panel_pos = cc.p(zhu_panel:getPosition())
    local zhu_val_bg_pos = cc.p(zhu_val_bg:getPosition())
    local zhu_pos = cc.p(zhu:getPosition())
	
	
    local txt_size = zhu_val:getContentSize()
    local bg_size = zhu_val_bg:getContentSize()
	
    local bg_new_width = txt_size.width+42
	local bg_old_width = bg_size.width
	local offset_x = bg_new_width - bg_old_width
	
    zhu_val_bg:setContentSize(cc.size(bg_new_width,bg_size.height))
	
	
    if align_type == "left" then
    else
		local curWidth = zhu_val_bg:getContentSize().width
		local offset = 59.0
		if curWidth > offset then
			zhu_panel:setPositionX(zhu_panel_pos.x-(curWidth-offset))
			--zhu_val_bg:setPosition(cc.p(zhu_val_bg_pos.x+offset_x,zhu_val_bg_pos.y))
			--zhu:setPosition(cc.p(zhu_pos.x+offset_x,zhu_pos.y))
		end
    end 
end

--創建裁剪節點，stencilNode為裁剪圖層，透明區域被裁剪
function WidgetHelp:createClippingNode(stencilNode)
    local stencilNodeSize = stencilNode:getContentSize()
	local ggclipper = cc.ClippingNode:create()
    ggclipper:setPosition(stencilNode:getPosition())
	--stencilNode:setPosition(cc.p(0,0))
    ggclipper:setAlphaThreshold(0.0)--设置alpha透明度闸值
	ggclipper:setContentSize(stencilNodeSize)
	ggclipper:setStencil(stencilNode)--设置遮罩模板
	return ggclipper
end

-- 处理parent下所有结点可以直接通过“root.”访问
-- 注：节点重名导致的未正确访问节点可通过全路径访问
-- 如: root.node1.node1_1.leaf_node
--     root.node2.node2_1.leaf_node

function WidgetHelp:dealChildren(parent, root)
    root = root or parent
    local children = parent:getChildren()
    for i,v in ipairs(children) do
        parent[v:getName()] = v
        root[v:getName()] = v
		self:dealChildren(v, root)
    end
end

-- 设置成灰色
function WidgetHelp:setGray(node)
    local program = cc.GLProgram:create("Shaders/gray.vsh", "Shaders/gray.fsh")
    program:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION) 
    program:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORD)
    program:link()
    program:updateUniforms()
    node:setGLProgram(program)
end

-- 使用shader
function WidgetHelp:setShader(node, vshfile, fshfile)
    local program = cc.GLProgram:create(vshfile, fshfile)
    program:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION) 
    program:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORD)
	
    program:link()
	
    program:updateUniforms()
    node:setGLProgram(program)
	program:use()
end
