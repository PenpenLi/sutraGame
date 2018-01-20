
require(luaFile.ObjectDefine)
require(luaFile.fightCommon)
require(luaFile.roleHelper)

--战斗导演，负责战场当前状态的管理
local fightDirector = class("fightDirector", cocosMake.viewBase)
fightDirector.ui_resource_file = {}
fightDirector.ui_binding_file = {}

fightDirector.notify = {
"addSoliderObject_notify", 
"update_hp_vs", 
"startFight_notify", 
"addSkillObject_notify",
"addSkillReally_notify",
"addBulletObject_notify",
"playFightAgain_notify",
"exitFight_notify"
}

--游戏逻辑类，全局单例
g_fightLogic = nil


local z_UILayer = 1024
local z_ComboSkillLayer = 2048

function fightDirector:onCreate(param)
    print("fightDirector:onCreate")
     self:createAnyLayer()

     self.completeCallback = param.completeCallback
     
     g_fightLogic = new_class("layer.fight.fightLogic")
     g_fightLogic:init()
     
     Notifier.addObserver(g_fightLogic)
     self.fightUILayer:initUI()
     g_fightLogic:setFightUILayer(self.fightUILayer)
    

    local function callback (args)
        
        --[[
        local testModID = 100021
        --test code
        require("testModle")
         
        if testModle ~= "" then
            local leaders = DataManager.getLeaderStaticData()
            for k,v in pairs(leaders) do
                if v.modelId == testModle then
                    testModID = k
                    break
                end
            end
        end
        
        --100004
        local soldierSomebody = 15
        local heroList = {}
        table.insert(heroList, {camp=ObjectDefine.Camp.own, site=1, roleID=100021, soldiersCount=soldierSomebody})
        table.insert(heroList, {camp=ObjectDefine.Camp.enemy, site=1, roleID=100021, soldiersCount=soldierSomebody})

        table.insert(heroList, {camp=ObjectDefine.Camp.own, site=2, roleID=100001, soldiersCount=soldierSomebody})
        table.insert(heroList, {camp=ObjectDefine.Camp.enemy, site=2, roleID=100001, soldiersCount=soldierSomebody})

        table.insert(heroList, {camp=ObjectDefine.Camp.own, site=3, roleID=100007, soldiersCount=soldierSomebody})
        table.insert(heroList, {camp=ObjectDefine.Camp.enemy, site=3, roleID=100007, soldiersCount=soldierSomebody})

        table.insert(heroList, {camp=ObjectDefine.Camp.own, site=4, roleID=100013, soldiersCount=soldierSomebody})
        table.insert(heroList, {camp=ObjectDefine.Camp.enemy, site=4, roleID=100013, soldiersCount=soldierSomebody})

        table.insert(heroList, {camp=ObjectDefine.Camp.own, site=5, roleID=100015, soldiersCount=soldierSomebody})
        table.insert(heroList, {camp=ObjectDefine.Camp.enemy, site=5, roleID=100015, soldiersCount=soldierSomebody})

        table.insert(heroList, {camp=ObjectDefine.Camp.own, site=6, roleID=100016, soldiersCount=soldierSomebody})
        table.insert(heroList, {camp=ObjectDefine.Camp.enemy, site=6, roleID=100016, soldiersCount=soldierSomebody})

        table.insert(heroList, {camp=ObjectDefine.Camp.own, site=7, roleID=100020, soldiersCount=soldierSomebody})
        table.insert(heroList, {camp=ObjectDefine.Camp.enemy, site=7, roleID=100020, soldiersCount=soldierSomebody})

        table.insert(heroList, {camp=ObjectDefine.Camp.own, site=8, roleID=100021, soldiersCount=soldierSomebody})
        table.insert(heroList, {camp=ObjectDefine.Camp.enemy, site=8, roleID=100021, soldiersCount=soldierSomebody})

        table.insert(heroList, {camp=ObjectDefine.Camp.own, site=9, roleID=100036, soldiersCount=soldierSomebody})
        table.insert(heroList, {camp=ObjectDefine.Camp.enemy, site=9, roleID=100036, soldiersCount=soldierSomebody})
        --]]
        

        if self.completeCallback then  self.completeCallback() end
    end


    self.fightUILayer:showLoadingFightSceneLayer()
    performWithDelay(self, callback, 0.1)
end

--param={}
--heros = {}
--customsID = 0
--设置战斗参数
local lastFightArgs
function fightDirector:setFightArgs(param)
    lastFightArgs = DeepCopy(param)
    local function callback()
        param.finishCallback = function(args)
            self.fightUILayer:hideLoadingFightSceneLayer()
        end
        self.customsID = param.customsID
        g_fightLogic:initFightData(param)
    end
    performWithDelay(self, callback, 0.0)
    
end

--播放战斗
function fightDirector:play()  
end

function fightDirector:onClose()
    Notifier.removeObserver(g_fightLogic)
    g_fightLogic:exitFight()

    g_fightLogic = nil
end

function fightDirector:createAnyLayer()
    --UI
   self.fightUILayer = self:showFloat(luaFile.fightUILayer, {director = self})
   self.fightUILayer:setLocalZOrder(z_UILayer)

   --combo skill
   self.comboSkillLayer = self:showFloat(luaFile.comboSkillLayer, {director = self})
   self.comboSkillLayer:setLocalZOrder(z_ComboSkillLayer)

   --对话层
   self.speakLayer = self:showFloat(luaFile.speakLayer, {director = self})

   --战场层
   self.battleScene = self:showFloat(luaFile.battleScene, {director = self}) 

end

function fightDirector:onClose()
end

function fightDirector:handleNotification(notifyName, body)
    if notifyName == "update_hp_vs" then--更新双方总血量

    elseif notifyName == "addSoliderObject_notify" then--增加士兵（{士兵参数}）
        return g_fightLogic:addSolider(body)

    elseif notifyName == "startFight_notify" then
        local function  startGameCallback(args)
            print("startGameCallback")
            g_fightLogic:starGame()
            

        end
        self.fightUILayer:showStartGameLayer(startGameCallback)
        

    elseif notifyName == "addSkillObject_notify" then
        return g_fightLogic:addSkillObject(body)
    
    elseif notifyName == "addBulletObject_notify" then
        return g_fightLogic:addBulletlObject(body)
        
    elseif notifyName == "addSkillReally_notify" then
        local skillID = body.skillID
        local player = body.player
        g_fightLogic:addSkillReady(player, skillID, self.fightUILayer)

    elseif notifyName == "exitFight_notify" then
        cocosMake.setGameSpeed(1)
        g_fightLogic:cleanAllObject()
        LayerManager.show(luaFile.UILayer)

    elseif notifyName == "playFightAgain_notify" then
        --[[
        cocosMake.setGameSpeed(1)
        g_fightLogic:cleanAllObject()

        local cid = self.customsID
        cocosMake.DirectorScheduler:scheduleScriptFunc(function()
            local pack = networkManager.createPack("enterBattle_c")
	        pack.gateId = cid

            local function requestCallback()
                local actor = DataModeManager:getActor()
                local part = actor:GetPart(Actor_Part_General)
                local tGeneralList = part:getAllMode()

                local heroList = {}
                for _,v in pairs(tGeneralList) do
	                local general = DataModeManager:getGeneralData(v)
	                local fightData = general:GetFightData()
                    fightData.baseId = v
                    fightData.general = general
                    table.insert(heroList, fightData)
                end

                local fightDirector = LayerManager.show(luaFile.fightDirector)
                self.fightDirector = fightDirector
                fightDirector:setFightArgs({heros=heroList, customsID=cid})
            end
	        networkManager.sendPack(pack, requestCallback, true, 0)
        end,1.15,false)
        --]]
        

        --[[
        g_fightLogic:cleanAllObject()

        local function schfunc()
            local fightDirector = LayerManager.show(luaFile.fightDirector)
            fightDirector:setFightArgs(lastFightArgs)
        end
        performWithDelay(self, schfunc, 0.1)
        --]]
    end
end 

return fightDirector
