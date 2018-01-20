local MainUI = class("MainUI", cocosMake.viewBase)

--规范
MainUI.ui_resource_file = {"mainUI_centerVS","mainUI_leftVS","mainUI_rightVS","mainUI_bottomVS"}--cocos studio生成的csb

MainUI.ui_binding_file = {--控件绑定
    panel_CenterVS = {name="mainUI_centerVS"},
    panel_LeftVS = {name="mainUI_leftVS"},
    panel_RightVS = {name="mainUI_rightVS"},
    panel_BottomVS = {name="mainUI_bottomVS"},
    -----------------------------------------mainUI_centerVS----------------------------------------------------------
    ----------------------------------------------布景层------------------------------------------------
    bg_Back = {name="mainUI_centerVS.bg_byk"},
    bg_Middle = {name="mainUI_centerVS.bg_mid"},
    bg_Forward = {name="mainUI_centerVS.bg_fw"},
    touchMoveNode = {name="mainUI_centerVS.touchMoveNode",event="touch",method="OnMoveBg"},
    --------------------------------------------主城功能按钮--------------------------------------------
    btn_JZ_GC   = {name="mainUI_centerVS.bg_mid.jz.jz_gc",event="touch",method="OnJZClick"},                --攻城
    btn_JZ_LDL  = {name="mainUI_centerVS.bg_mid.jz.jz_ldl",event="touch",method="OnJZClick"},               --炼丹炉
    btn_JZ_SS   = {name="mainUI_centerVS.bg_byk.jz.jz_ss",event="touch",method="OnJZClick"},                --弑神
    btn_JZ_TTT  = {name="mainUI_centerVS.bg_mid.jz.jz_ttt",event="touch",method="OnJZClick"},               --通天塔
    btn_JZ_XM   = {name="mainUI_centerVS.bg_mid.jz.jz_xm",event="touch",method="OnJZClick"},                --仙脉
    btn_JZ_XS   = {name="mainUI_centerVS.bg_mid.jz.jz_xs",event="touch",method="OnJZClick"},                --仙兽
    btn_JZ_XX   = {name="mainUI_centerVS.bg_mid.jz.jz_xx",event="touch",method="OnJZClick"},                --修行
    btn_JZ_ZM   = {name="mainUI_centerVS.bg_mid.jz.jz_zm",event="touch",method="OnJZClick"},                --宗门
    btn_JZ_XBG  = {name="mainUI_centerVS.bg_fw.jz.jz_xbg",event="touch",method="OnJZClick"},                --寻宝阁
    btn_JZ_YWC  = {name="mainUI_centerVS.bg_fw.jz.jz_ywc",event="touch",method="OnJZClick"},                --演武场
    btn_JZ_HS   = {name="mainUI_centerVS.bg_fw.jz.jz_hs",event="touch",method="OnJZClick"},                 --黑市
    --------------------------------------------------------------------------------------------------------------------
    -------------------------------------------mainUI_leftVS------------------------------------------------------------
    ----------------------------------------------头  像------------------------------------------------
    img_tx  = {name="mainUI_leftVS.tx.img"},                                                                --头像图片
    lb_lvl  = {name="mainUI_leftVS.tx.lb_lvl"},                                                             --等级
    lb_zl   = {name="mainUI_leftVS.tx.lb_zl"},                                                              --战力
    lb_name = {name="mainUI_leftVS.tx.lb_name"},                                                            --姓名
    pb_exp  = {name="mainUI_leftVS.tx.pb"},                                                                 --经验条
    btn_vip = {name="mainUI_leftVS.tx.btn_vip",event="touch",method="OnVIPClick"},                          --VIP按钮
    lb_viplvl = {name="mainUI_leftVS.tx.btn_vip.txt"},                                                      --VIP等级
    ---------------------------------------------功能按钮------------------------------------------------
    btn_QD   = {name="mainUI_leftVS.btn.btn_1",event="touch",method="OnLeftClick"},                         --签到
    btn_ZXJL = {name="mainUI_leftVS.btn.btn_2",event="touch",method="OnLeftClick"},                         --在线奖励
    btn_KFKH = {name="mainUI_leftVS.btn.btn_3",event="touch",method="OnLeftClick"},                         --开服狂欢
    btn_CZFL = {name="mainUI_leftVS.btn.btn_4",event="touch",method="OnLeftClick"},                         --充值返利
    btn_XSHD = {name="mainUI_leftVS.btn.btn_5",event="touch",method="OnLeftClick"},                         --限时活动
    ---------------------------------------------聊天窗口------------------------------------------------
    btn_chat = {name="mainUI_leftVS.chatbox.btn_chat",event="touch",method="OnChatClick"},
    tf_cmd  = {name="mainUI_leftVS.chatbox.tf_cmd"},  
    --------------------------------------------------------------------------------------------------------------------
    -------------------------------------------mainUI_rightVS-----------------------------------------------------------
    node_move = {name="mainUI_rightVS.panel.nd_move"},                                                          --移动层
    pn_sw = {name="mainUI_rightVS.panel.nd_move.pn_sw"},                                                        --遮蔽层  
    btn_hideright = {name="mainUI_rightVS.btn_hide",event="touch",method="OnHideRightClick"},                   --隐藏界面按钮
    img_tag = {name="mainUI_rightVS.btn_hide.tag"},
    btn_task = {name="mainUI_rightVS.panel.nd_move.btn_1",event="touch",method="OnTaskClick"},                  --任务
    btn_friend = {name="mainUI_rightVS.panel.nd_move.btn_2",event="touch",method="OnFriendClick"},              --好友
    btn_mail = {name="mainUI_rightVS.panel.nd_move.btn_3",event="touch",method="OnMailClick"},                  --邮箱
    --------------------------------------------------------------------------------------------------------------------
    -------------------------------------------mainUI_bottomVS----------------------------------------------------------
    pn_bottom_btn = {name="mainUI_bottomVS.panel"},
    btn_Camp = {name="mainUI_bottomVS.panel.btn_1",event="touch",method="OnCampClick"},                         --兵营
    btn_Package = {name="mainUI_bottomVS.panel.btn_2",event="touch",method="OnPackageClick"},                   --背包
    btn_Shop = {name="mainUI_bottomVS.panel.btn_3",event="touch",method="OnShopClick"},                         --商店
    btn_hidebootom = {name="mainUI_bottomVS.btn_hide",event="touch",method="OnHideBottomClick"},                --隐藏界面按钮
    img_tag_bottom = {name="mainUI_bottomVS.btn_hide.tag"}
}

MainUI.notify = {"Notifty_Actor_Create","Notifty_Actor_Set_Prop"}--通知

MainUI.movePosVec = { midPos = 0 , backPos = 0 }
MainUI.btnJZClickCallFuc = {}

function MainUI:onCreate()
    print("MainUI:onCreate")
    self.touchMoveNode:setSwallowTouches(false)

    self.btnJZClickCallFuc = {
                                self.OnJZ_GC_Click,
                                self.OnJZ_HS_Click,
                                self.OnJZ_LDL_Click,
                                self.OnJZ_SS_Click,
                                self.OnJZ_TTT_Click,
                                self.OnJZ_XBG_Click,
                                self.OnJZ_XM_Click,
                                self.OnJZ_XS_Click,
                                self.OnJZ_XX_Click,
                                self.OnJZ_YWC_Click,
                                self.OnJZ_ZM_Click
                            }
    self.panel_RightVS:setAnchorPoint(1,0)
    self.panel_RightVS:setPositionX(1280)
    self.panel_BottomVS:setAnchorPoint(1,0)
    self.panel_BottomVS:setPosition(1280,0)
    self.pn_sw:setEnabled(false)
    self:__initShow()
end

function MainUI:onClose()
    print("MainUI:onClose")
end

function MainUI:OnMoveBg(event)
    if event.state and event.state == 0 then
        self.movePosVec.midPos = self.bg_Middle:getPositionX()
        self.movePosVec.backPos = self.bg_Back:getPositionX()
        self.moveEnable = false
    elseif event.state and event.state == 1 then
        local starpos = self.touchMoveNode:getTouchBeganPosition()
        local movepos = self.touchMoveNode:getTouchMovePosition()

        local subX = movepos.x-starpos.x
        if math.abs(subX) > 50 then
            self.moveEnable = true
        end
        if self.moveEnable ~= true then
            return
        end
        local pos = self.movePosVec.backPos + subX
       
        if pos > 0 then
            pos = 0
        elseif pos < -1280 then 
            pos = -1280 
        end
        self.bg_Back:setPositionX(pos)
        self.bg_Forward:setPositionX(pos)

        pos = self.movePosVec.midPos + (pos-self.movePosVec.backPos)*0.9
        self.bg_Middle:setPositionX(pos)
    elseif event.state and event.state == 2 then
    elseif event.state and event.state == 3 then
    end 
end

function MainUI:__initShow()
    self.lb_name:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Name))
    local iLvl = DataModeManager:getActor():GetProperty(Actor_Prop_Lvl)
    self.lb_lvl:setString(iLvl.."")
    self.lb_zl:getVirtualRenderer():setAdditionalKerning(-5.0)
    self.lb_zl:setString(DataModeManager:getActor():GetProperty(Actor_Prop_FC))
    self.lb_viplvl:setString("VIP : "..DataModeManager:getActor():GetProperty(Actor_Prop_VIPLvl))

    local iExp = DataModeManager:getActor():GetProperty(Actor_Prop_Exp)
    local iMaxExp = DataManager.getLevelStaticDataByID(iLvl).exp
    self.pb_exp:setPercent(100*iExp/iMaxExp)
end

function MainUI:__BrushPropShow(param)
    if param == nil then return end
    if param.propID == Actor_Prop_Name then
        self.lb_name:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Name))
    elseif param.propID == Actor_Prop_Lvl then
        self.lb_lvl:setString(DataModeManager:getActor():GetProperty(Actor_Prop_Lvl).."")
    elseif param.propID == Actor_Prop_FC then
        self.lb_zl:getVirtualRenderer():setAdditionalKerning(-5.0)
        self.lb_zl:setString(DataModeManager:getActor():GetProperty(Actor_Prop_FC))
    elseif param.propID == Actor_Prop_VIPLvl then
        self.lb_viplvl:setString("VIP : "..DataModeManager:getActor():GetProperty(Actor_Prop_VIPLvl))
    end
end

function MainUI:__regularizeLBWidth(obj,width)
    local size = obj:getContentSize()
    if size.width > width then
        obj:setScaleX(width/size.width)
    end
end

function MainUI:handleNotification(notifyName, body)
    if notifyName == "Notifty_Actor_Create" then
        self:__initShow()
    elseif notifyName == "Notifty_Actor_Set_Prop" then
        self:__BrushPropShow(body)
    end
end

-----------------------------------------------------------------------------------------------
function MainUI:OnJZClick(event)
    if event.state and event.state == 0 then
        event.target:getChildByName("img"):setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:getChildByName("img"):setColor(cc.c3b(255,255,255))
        if self.moveEnable == true then
            return
        end
        local tag = event.target:getTag()
        local func = self.btnJZClickCallFuc[tag]
        func(self,event)
    elseif event.state and event.state == 3 then
        event.target:getChildByName("img"):setColor(cc.c3b(255,255,255))
    end
end


function MainUI:OnJZ_GC_Click(event)
    local starpos = self.btn_JZ_GC:getTouchBeganPosition()
    local endpos = self.btn_JZ_GC:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    self:getParent():showFloat(luaFile.MapUI)
    print("MainUI:OnJZ_GC_Click : 攻城")
    
end

function MainUI:OnJZ_LDL_Click(event)
    local starpos = self.btn_JZ_LDL:getTouchBeganPosition()
    local endpos = self.btn_JZ_LDL:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    print("MainUI:OnJZ_LDL_Click : 炼丹炉")
end

function MainUI:OnJZ_SS_Click(event)
    local starpos = self.btn_JZ_SS:getTouchBeganPosition()
    local endpos = self.btn_JZ_SS:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    print("MainUI:OnJZ_SS_Click : 弑神")
end

function MainUI:OnJZ_TTT_Click(event)
    local starpos = self.btn_JZ_TTT:getTouchBeganPosition()
    local endpos = self.btn_JZ_TTT:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    print("MainUI:OnJZ_TTT_Click : 通天塔")
end

function MainUI:OnJZ_XM_Click(event)
    local starpos = self.btn_JZ_XM:getTouchBeganPosition()
    local endpos = self.btn_JZ_XM:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    print("MainUI:OnJZ_XM_Click : 仙脉")
end

function MainUI:OnJZ_XS_Click(event)
    local starpos = self.btn_JZ_XS:getTouchBeganPosition()
    local endpos = self.btn_JZ_XS:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    print("MainUI:OnJZ_XS_Click : 仙兽")
end

function MainUI:OnJZ_XX_Click(event)
    local starpos = self.btn_JZ_XX:getTouchBeganPosition()
    local endpos = self.btn_JZ_XX:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    print("MainUI:OnJZ_XX_Click : 修行")
end

function MainUI:OnJZ_ZM_Click(event)
    local starpos = self.btn_JZ_ZM:getTouchBeganPosition()
    local endpos = self.btn_JZ_ZM:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    print("MainUI:OnJZ_ZM_Click : 宗门")

end

function MainUI:OnJZ_XBG_Click(event)
    local starpos = self.btn_JZ_XBG:getTouchBeganPosition()
    local endpos = self.btn_JZ_XBG:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    print("MainUI:OnJZ_XBG_Click : 寻宝阁")
end

function MainUI:OnJZ_YWC_Click(event)
    local starpos = self.btn_JZ_YWC:getTouchBeganPosition()
    local endpos = self.btn_JZ_YWC:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    print("MainUI:OnJZ_YWC_Click : 演武场")
end

function MainUI:OnJZ_HS_Click(event)
    local starpos = self.btn_JZ_HS:getTouchBeganPosition()
    local endpos = self.btn_JZ_HS:getTouchEndPosition()
    if cc.pGetDistance(starpos,endpos) > 100 then
        return
    end
    print("MainUI:OnJZ_HS_Click : 黑市")
end
-----------------------------------------------------------------------------------------------

function MainUI:OnVIPClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnVIPClick")
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
    
end

function MainUI:OnChatClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnChatClick")
        local str = self.tf_cmd:getString()
        local strList = string.split(str," ") or {}
        if strList[2] == nil or strList[2] == "" then
            Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.FloatMsg[26]})
            return
        end
        local pack = networkManager.createPack("gm_command_c")
        pack.cmd = strList[1]
        pack.data = strList[2]
	    networkManager.sendPack(pack,function() end,true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:OnLeftClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnLeftClick")
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end
-------------------------------------------------------------------------------------------------

function MainUI:OnBuySilverClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnBuySilverClick")
        local pack = networkManager.createPack("buyAttr_c")
	    pack.attr = 3
        pack.num = 100
	    networkManager.sendPack(pack,handler(self,self.buySilverCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:buySilverCallBack(obj)
    if obj.retcode == ERR_SUCCESS then 
        print("buySilver------success!")
    else 
        print("buySilver------false!") 
    end
end

function MainUI:OnBuyGoldClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnBuyGoldClick")
        local iValue = DataModeManager:getActor():GetProperty(Actor_Prop_Gold) + 100
        DataModeManager:getActor():SetProperty({propID=Actor_Prop_Gold,value=iValue})
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:OnBuyStrengthClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnBuyStrengthClick")
        local pack = networkManager.createPack("buyAttr_c")
	    pack.attr = 1
        pack.num = 100
	    networkManager.sendPack(pack,handler(self,self.buyVitCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:buyVitCallBack(obj)
    if obj.retcode == ERR_SUCCESS then 
        print("buyVit------success!")
    else 
        print("buyVit------false!") 
    end
end

function MainUI:OnBuyStaminaClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnBuyStaminaClick")
        local pack = networkManager.createPack("buyAttr_c")
	    pack.attr = 2
        pack.num = 100
	    networkManager.sendPack(pack,handler(self,self.buyExpCallBack),true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:buyExpCallBack(obj)
    if obj.retcode == ERR_SUCCESS then 
        print("buyExp------success!")
    else 
        print("buyExp------false!") 
    end
end

-------------------------------------------------------------------------------------------------

function MainUI:OnTaskClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnTaskClick")
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:OnFriendClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnFriendClick")
        local pack = networkManager.createPack("addPlace_c")
	    pack.type = 0
	    networkManager.sendPack(pack,function() end,true,0)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:OnMailClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnMailClick")
        local pack = networkManager.createPack("openPackage_c")
	    pack.type = 1
	    networkManager.sendPack(pack,handler(self,self.openItemPackageCallBack),true,0)

    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:openItemPackageCallBack(obj)
    recvPackageResponse.ItemList(obj)
end

function MainUI:OnHideRightClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnHideRightClick")
        self.img_tag:setScaleY(self.img_tag:getScaleY()*(-1))
        self.node_move:stopAllActions()
        if self.img_tag:getScaleY() > 0 then
            local action1 = cc.MoveTo:create(0.2,cc.vec3(0,0,0))
            local action2 = cc.CallFunc:create(function(sender,param)
                                                   param.sw:setEnabled(false)
                                               end,{sw = self.pn_sw})
            self.node_move:runAction(cc.Sequence:create(action1,action2))
        else
            self.pn_sw:setEnabled(true)
            self.node_move:runAction(cc.MoveTo:create(0.2,cc.vec3(0,300,0)))
        end
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end
-------------------------------------------------------------------------------------------
function MainUI:OnCampClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnCampClick")
        self:getParent():showFloat(luaFile.CampUI)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:OnPackageClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnPackageClick")
        self:getParent():showFloat(luaFile.ItemPackageUI)
        
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:OnShopClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        print("MainUI:OnShopClick")
        self:showFloat(luaFile.RecruitUI)
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end

function MainUI:OnHideBottomClick(event)
    if event.state and event.state == 0 then
        event.target:setColor(cc.c3b(166,166,166))
    elseif event.state and event.state == 2 then
        event.target:setColor(cc.c3b(255,255,255))
        self.pn_bottom_btn:setVisible(not self.pn_bottom_btn:isVisible())
        if self.pn_bottom_btn:isVisible() then
            self.img_tag_bottom:runAction(cc.RotateTo:create(0.1,360))
        else
            self.img_tag_bottom:runAction(cc.RotateTo:create(0.1,270))
        end
        print("MainUI:OnHideBottomClick")
    elseif event.state and event.state == 3 then
        event.target:setColor(cc.c3b(255,255,255))
    end
end
--------------------------------------------------------------------------------------------------------------------
return MainUI

