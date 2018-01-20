local playerCtl = {}
playerCtl.uid = 0
playerCtl.name = ""
playerCtl.site = 0
playerCtl.localSite = 0
playerCtl.gold = 0
playerCtl.state = 0
playerCtl.isMajor = 0

local dizhuIndex = false
local cardsMgr = {cards={}, selects={}}

local ui={}
local ctrl = playerCtl


function playerCtl:setMajor(b)
	ctrl.isMajor = b
end

function playerCtl:init(data, uilist)
	ui={
		readyIcon = uilist.readyIcon,
		jiaodizhuIcon = uilist.jiaodizhuIcon,
		qiangdizhuIcon = uilist.qiangdizhuIcon,
		cd = uilist.cd,
		cardPanel = uilist.cardPanel,
		myCardPanel = uilist.myCardPanel,
		gold = uilist.coin,
		readyBtn = uilist.readyBtn,
		name = uilist.name,
		consolePanel = uilist.consolePanel,
	}
	
	ctrl.uid = data.uid
	ctrl.name = data.name
	ctrl.site = data.site
	ctrl.localSite = data.loc
	ctrl.gold = data.gold
	ctrl.state = data.state
	cardsMgr = {cards={}, selects={}}
	
	ui.readyIcon:setVisible(ctrl.state == 2)
	ui.jiaodizhuIcon:setVisible(false)
	ui.qiangdizhuIcon:setVisible(false)
	ui.cd:setVisible(false)
	ui.cardPanel:setVisible(false)
	if ui.myCardPanel then ui.myCardPanel:setVisible(false) end
	ui.name:setString(ctrl.name)
	ui.gold:setString(ctrl.gold)
	ctrl.state = ctrl.state == 2 and DDZ_Define.player_state.waitStart or DDZ_Define.player_state.waitReady
end


function playerCtl:ready(b)
	if ui.readyBtn then  ui.readyBtn:setVisible(not b) end
	ui.readyIcon:setVisible(b)
	state = b and DDZ_Define.player_state.waitStart or DDZ_Define.player_state.waitReady
	
	local pokesData = "1_3,1_2,2_3,2_1,3_2,3_3,4_2,5_3,5_2,6_3,6_1,7_4,8_2,8_4,9_3,10_1,13_3"
	--self:startGame(pokesData)
end


function playerCtl:startGame(pokesData)
	if ui.readyBtn then ui.readyBtn:setVisible(false) end
	ui.readyIcon:setVisible(false)
	
	ui.myCardPanel:removeAllChildren()
	ui.myCardPanel:setVisible(true)
	
	if pokesData then
		local pokesdatas = string.split(pokesData, ",")
		local px,py = 0,0
		for k,v in pairs(pokesdatas) do
			local str = string.split(v, "_")
			local data = { cardtype = 1, value = tonumber(str[1]), color = tonumber(str[2]) }
			local card = new_class(luaFile.Card, data)
			card:setPosition(px, py)
			card:setClickCallback(handler(self, self.selectCard))
			ui.myCardPanel:addChild(card)
			px = px+50
			cardsMgr.cards[#cardsMgr.cards+1] = card
		end
	
	else
		local px,py = 0,0
		for i=1, DDZ_Define.playerPokeMaxCount do
			local card = new_class(luaFile.Card, {cardtype=0})
			card:setPosition(px, py)
			ui.myCardPanel:addChild(card)
			px = px+50
			cardsMgr.cards[#cardsMgr.cards+1] = card
		end		
	end
end

function playerCtl:selectCard(value, color, beSelect)
end

function playerCtl:jiaodizhu(b)
	ui.jiaodizhuIcon:setVisible(b)
end

function playerCtl:qiangdizhu(b)
	ui.jiaodizhuIcon:setVisible(false)
	ui.qiangdizhuIcon:setVisible(b)
end

function playerCtl:setDizhu(b)
	dizhuIndex = b
	ui.jiaodizhuIcon:setVisible(false)
	ui.qiangdizhuIcon:setVisible(false)
end

function playerCtl:turnPay()
	for k,v in pairs(cardsMgr.cards) do v:setTouchEnable(true) end
	if ui.consolePanel then ui.consolePanel:setVisible(true) end
end
function playerCtl:passPay()
	for k,v in pairs(cardsMgr.cards) do v:setTouchEnable(false) end
	if ui.consolePanel then ui.consolePanel:setVisible(false) end
	ui.cardPanel:setVisible(false)
end
function playerCtl:payPoke(pokesStr)
	ui.cardPanel:removeAllChildren()
	ui.cardPanel:setVisible(true)
	
	local pokesdatas = string.split(pokesStr, ",")
	local px,py = 0,0
	for k,v in pairs(pokesdatas) do
		local str = string.split(v, "_")
		local data = { cardtype = 1, value = tonumber(str[1]), color = tonumber(str[2]) }
		local card = new_class(luaFile.Card, data)
		card:setTouchEnable(false)
		card:setPosition(px, py)
		ui.cardPanel:addChild(card)
		px = px+50
	end
end

return playerCtl