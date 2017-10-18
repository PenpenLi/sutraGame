local roomLayer = class("roomLayer", cocosMake.viewBase)

roomLayer.ui_resource_file = {"roomLayerUI"}
roomLayer.ui_binding_file = {
rt_panel={name="roomLayerUI.rt_panel"},
exitBtn={name="roomLayerUI.rt_panel.exitBtn",event="touch",method="exitBtnClick"},
setBtn={name="roomLayerUI.rt_panel.setBtn",event="touch",method="setBtnClick"},
tuoguanBtn={name="roomLayerUI.rt_panel.tuoguanBtn",event="touch",method="tuoguanBtnClick"},

t_panel={name="roomLayerUI.t_panel"},
t_card_panel={name="roomLayerUI.t_panel.card_panel"},

r_panel={name="roomLayerUI.r_panel"},
tishiBtn={name="roomLayerUI.r_panel.tishiBtn",event="touch",method="tishiBtnBtnClick"},
chupaiBtn={name="roomLayerUI.r_panel.chupaiBtn",event="touch",method="chupaiBtnClick"},
buchuBtn={name="roomLayerUI.r_panel.buchuBtn",event="touch",method="buchuBtnBtnClick"},

leftman_panel={name="roomLayerUI.leftman_panel"},
leftman_head={name="roomLayerUI.leftman_panel.head"},
leftman_name={name="roomLayerUI.leftman_panel.head.name"},
leftman_coinnum={name="roomLayerUI.leftman_panel.coinnum"},
leftman_cardpanel={name="roomLayerUI.leftman_panel.card_panel"},
leftman_rm={name="roomLayerUI.leftman_panel.rm"},
leftman_cd={name="roomLayerUI.leftman_panel.cd"},
leftman_readyIcon={name="roomLayerUI.leftman_panel.readyIcon"},
leftman_jiaodizhuIcon={name="roomLayerUI.leftman_panel.jiaodizhuIcon"},
leftman_qiangdizhuIcon={name="roomLayerUI.leftman_panel.qiangdizhuIcon"},

rightman_panel={name="roomLayerUI.rightman_panel"},
rightman_head={name="roomLayerUI.rightman_panel.head"},
rightman_name={name="roomLayerUI.rightman_panel.head.name"},
rightman_coinnum={name="roomLayerUI.rightman_panel.coinnum"},
rightman_cardpanel={name="roomLayerUI.rightman_panel.card_panel"},
rightman_rm={name="roomLayerUI.rightman_panel.rm"},
rightman_cd={name="roomLayerUI.rightman_panel.cd"},
rightman_readyIcon={name="roomLayerUI.rightman_panel.readyIcon"},
rightman_jiaodizhuIcon={name="roomLayerUI.rightman_panel.jiaodizhuIcon"},
rightman_qiangdizhuIcon={name="roomLayerUI.rightman_panel.qiangdizhuIcon"},

selfman_panel={name="roomLayerUI.selfman_panel"},
selfman_head={name="roomLayerUI.selfman_panel.head"},
selfman_name={name="roomLayerUI.selfman_panel.head.name"},
selfman_coinnum={name="roomLayerUI.selfman_panel.coinnum"},
selfman_addcoinBtn={name="roomLayerUI.selfman_panel.coinadd_btn",event="touch",method="coinaddBtnBtnClick"},
selfman_mycard_panel={name="roomLayerUI.selfman_panel.mycard_panel"},
selfman_card_panel={name="roomLayerUI.selfman_panel.card_panel"},
selfman_cd={name="roomLayerUI.selfman_panel.cd"},
selfman_jiaodizhuIcon={name="roomLayerUI.selfman_panel.jiaodizhuIcon"},
selfman_qiangdizhuIcon={name="roomLayerUI.selfman_panel.qiangdizhuIcon"},
selfman_readyIcon={name="roomLayerUI.selfman_panel.readyIcon"},
selfman_readyBtn={name="roomLayerUI.selfman_panel.ready_btn",event="touch",method="readyBtnClick"},
selfman_jiaodizhuBtn={name="roomLayerUI.selfman_panel.jiaodizhu_btn",event="touch",method="jiaodizhuBtnClick"},
selfman_jiaodizhuBtnTitle={name="roomLayerUI.selfman_panel.jiaodizhu_btn.title"},

}

--roomLayer.notify = {"openFloatPanel", "closeFloatPanel", "testDataManager"}
local gameControl = hotRequire(luaFile.gameControl)
local max_players = DDZ_Define.play_MaxCount

function roomLayer:onCreate()
    self.r_panel:setVisible(false)
	self.leftman_panel:setVisible(false)
	self.rightman_panel:setVisible(false)
	self.selfman_jiaodizhuBtn:setVisible(false)
	
	self.players = {}
	
	networkManager.logic(networkManager.logicType.game)
	
	networkManager.registerMsgCallback(handler(self, self.serverMessageCallback), "roomLayer")
	
	networkManager.connect(GAME_GAME_IP_ADDRESS,
	GAME_GAME_IP_PORT,
	"",
	handler(self, self.connectServerCallback))
	
	local uilist = {
	publicCard=self.t_card_panel,
	}
	gameControl:init(uilist)
end

function roomLayer:serverMessageCallback(name, data)
	print("*******roomLayer:serverMessageCallback", name)
	
	
	if name == "playerEnterRoom" then
		local playerdata = {
				uid = data["p_uid"],
				state = data["p_state"],
				site = data["p_site"],
				icon = data["p_icon"],
				gold = data["p_gold"],
				name = data["p_name"]
			}
		
		local site = self.players[1].site
		for i=2, max_players do
			site = self:turnNext(site)
			if site == playerdata.site then
				self:playerEnterRoom(playerdata, i)
				break
			end
		end
		
	elseif name == "playerExitRoom" then
		for k,v in pairs(self.players) do
			if v.site == data.site then
				self:playerEnterRoom(nil, k)
				break
			end
		end
		
	elseif name == "playerReady" then
		for k,v in pairs(self.players) do
			if v.uid == data.uid then
				v:ready(true)
				break
			end
		end
		
	elseif name == "startGame" then
		self:startGame(data)
		
	elseif name == "jiaodizhu" then
		local player = self:getPlayerWithSite(data.site)
		player:jiaodizhu(tonumber(data.isjiaodizhu) == 0)
		
		gameControl:jiaodizhu()
		
		if not gameControl:jiaodizhuIng() then self.selfman_jiaodizhuBtnTitle:setString("抢地主") end
		player = self:getPlayerWithSite(self:turnNext(data.site))
		self.selfman_jiaodizhuBtn:setVisible(player.localSite == 1)
		
	elseif name == "qiangdizhu" then
		local player = self:getPlayerWithSite(data.site)
		player:qiangdizhu(tonumber(data.isqiangdizhu) == 0)
		
		gameControl:qiangdizhu()
		
		player = self:getPlayerWithSite(self:turnNext(data.site))
		self.selfman_jiaodizhuBtn:setVisible(player.localSite == 1)
		
	elseif name == "startPayPoke" then
		gameControl:setDizhuSite(data.dizhuSite)
		
		for k,v in pairs(self.players) do v:setDizhu(data.dizhuSite == v.site) end
		self:playerTurnToPay(data.dizhuSite)
		
	elseif name == "payPoke" then
		local player = self:getPlayerWithSite(self:turnNext(data.site))
		player:payPoke(data.pokes)
		if data.roundWinSite ~= 0 then
			
		end
	end
end

function roomLayer:playerTurnToPay(site)
	for k,v in pairs(self.players) do
		if v.site == s then
			return v
		end
	end
	
	local player = self:getPlayerWithSite(site)
	player:turnPay()
end

function roomLayer:getPlayerWithSite(s)
	for k,v in pairs(self.players) do
		if v.site == s then
			return v
		end
	end
end

function roomLayer:startGame(data)
	self.players[1]:startGame(data.pokes)
	self.players[2]:startGame()
	self.players[3]:startGame()
	
	
	if self.players[1].site == data.jiaodizhuSite then
		self.selfman_jiaodizhuBtn:setVisible(true)
	end
	
	gameControl:startGame(data.secretpokes)
end

function roomLayer:connectServerCallback(data)
	if data == "open" then
		LayerManager.showTips("服务器连接成功")
		
		performWithDelay(self, function()		
			networkManager.request("totalPush",
			{uid=Constant.UserTokenInfo.uid}, 
			handler(self, self.totalPushCallback))
				end, 0)
	else
		LayerManager.showTips("服务器连接失败")
	end
end

function roomLayer:enterRoomCallback(data)
	
	local function translatePlayerData(arr, site, loc)
		local playerdata = {
				uid = arr["p_uid_"..site],
				state = arr["p_state_"..site],
				site = arr["p_site_"..site],
				icon = arr["p_icon_"..site],
				gold = arr["p_gold_"..site],
				name = arr["p_name_"..site]
			}
		self:playerEnterRoom(playerdata, loc)
	end
	
	local l = 0
	for i=1, max_players do
		if data["p_uid_"..i] == Constant.UserTokenInfo.uid then
			translatePlayerData(data, i, 1)
			l = i
			break
		end
	end
	
	
	for i=2, max_players do
		l = self:turnNext(l)
		translatePlayerData(data, l, i)
	end
end

function roomLayer:turnNext(loc)
	local l = loc
	l = (l+1)%(max_players+1)
	l= l == 0 and 1 or l
	return l
end

function roomLayer:totalPushCallback(data)
	networkManager.request("enterRoom", {level=1}, handler(self, self.enterRoomCallback))
end



--loc = 2 left 
function roomLayer:playerEnterRoom(data, loc)
	self.players[loc] = nil
	
	if not data or data.uid == 0 then
		if loc == 1 then return end
		if loc == 2 then self.leftman_panel:setVisible(false) end
		if loc == 3 then self.rightman_panel:setVisible(false) end
		return
	end
	data.loc = loc
	
	if loc == 1 then
		self.selfman_panel:setVisible(true)
		local playerctrl = hotRequire(luaFile.playerControl)
		local uilist = {
		readyIcon = self.selfman_readyIcon,
		jiaodizhuIcon = self.selfman_jiaodizhuIcon,
		qiangdizhuIcon = self.selfman_qiangdizhuIcon,
		cd = self.selfman_cd,
		cardPanel = self.selfman_card_panel,
		myCardPanel = self.selfman_mycard_panel,
		coin = self.selfman_coinnum,
		readyBtn = self.selfman_readyBtn,
		name = self.selfman_name
		}
		playerctrl:init(data, uilist)
		playerctrl:setMajor(true)
		self.players[loc] = playerctrl
		
		
	elseif loc == 2 then
		self.leftman_panel:setVisible(true)
		local playerctrl = hotRequire(luaFile.playerControl)
		local uilist = {
		readyIcon = self.leftman_readyIcon,
		jiaodizhuIcon = self.leftman_jiaodizhuIcon,
		qiangdizhuIcon = self.leftman_qiangdizhuIcon,
		cd = self.leftman_cd,
		cardPanel = self.leftman_cardpanel,
		myCardPanel = self.leftman_rm,
		coin = self.leftman_coinnum,
		name = self.leftman_name,
		consolePanel = self.r_panel,
		}
		playerctrl:init(data, uilist)
		self.players[loc] = playerctrl
		
		
	elseif loc == 3 then
		self.rightman_panel:setVisible(true)
		local playerctrl = hotRequire(luaFile.playerControl)
		local uilist = {
		readyIcon = self.rightman_readyIcon,
		jiaodizhuIcon = self.rightman_jiaodizhuIcon,
		qiangdizhuIcon = self.rightman_qiangdizhuIcon,
		cd = self.rightman_cd,
		cardPanel = self.rightman_cardpanel,
		myCardPanel = self.rightman_rm,
		coin = self.rightman_coinnum,
		name = self.rightman_name
		}
		playerctrl:init(data, uilist)
		self.players[loc] = playerctrl
	end
end

function roomLayer:onClose(str)
	networkManager.unRegisterMsgCallback("roomLayer")
end

function roomLayer:exitBtnClick(event)
    if event.state == 2 then
		LayerManager.show(luaFile.loginLayer)
	end
end
function roomLayer:setBtnClick(event)
    if event.state == 2 then
	end
end
function roomLayer:tuoguanBtnClick(event)
    if event.state == 2 then
	end
end

function roomLayer:tishiBtnBtnClick(event)
    if event.state == 2 then
	end
end
function roomLayer:chupaiBtnClick(event)
    if event.state == 2 then
	end
end
function roomLayer:buchuBtnBtnClick(event)
    if event.state == 2 then
	end
end
function roomLayer:coinaddBtnBtnClick(event)
    if event.state == 2 then
	end
end
function roomLayer:readyBtnClick(event)
    if event.state == 2 then
		self.selfman_readyBtn:setVisible(false)
		
		networkManager.request("ready",
			{uid=self.players[1].uid, ready=true}, 
			function() self.players[1]:ready(true) end, 0)
	end
end
function roomLayer:jiaodizhuBtnClick(event)
    if event.state == 2 then
		self.selfman_jiaodizhuBtn:setVisible(false)
		
		local msgName = "selfJiaodizhu"
		if not gameControl:jiaodizhuIng() then msgName = "selfQiangdizhu" end
		networkManager.request(msgName, {value=0})
	end
end

return roomLayer
