local gameCtl = {}


local ui={
	publicCard_panel,
	
}

local gameState = DDZ_Define.play_state.playWaitStart
local players = {}
local dizhuSite = 0
local ctrl = gameCtl

local jiaodizhuCnt = 0
local qiangdizhuCnt = 0

function gameCtl:setMajor(b)
	ctrl.isMajor = b
end

function gameCtl:init(uilist)
	ui.publicCard_panel = uilist.publicCard
	
	gameState = DDZ_Define.play_state.playWaitStart
	
	jiaodizhuCnt = 0
	qiangdizhuCnt = 0
end



function gameCtl:startGame(publicCardData)
	local pokesdatas = string.split(publicCardData, ",")
	local px,py = 0,0
	for k,v in pairs(pokesdatas) do
		local str = string.split(v, "_")
		local data = { cardtype = 1, value = tonumber(str[1]), color = tonumber(str[2]) }
		local card = new_class(luaFile.Card, data)
		card:setPosition(px, py)
		card:setTouchEnable(false)
		ui.publicCard_panel:addChild(card)
		px = px+50
	end
	ui.publicCard_panel:setScale(0.5)
	
	gameState = DDZ_Define.play_state.playing_dealDZ
end

function gameCtl:jiaodizhu()
	jiaodizhuCnt = jiaodizhuCnt + 1
	
	if jiaodizhuCnt == DDZ_Define.play_MaxCount then
		gameState = DDZ_Define.play_state.playing_robDZ
	end
end
function gameCtl:jiaodizhuIng()
	return gameState == DDZ_Define.play_state.playing_dealDZ
end
function gameCtl:qiangdizhu()
	qiangdizhuCnt = qiangdizhuCnt + 1
	
	if qiangdizhuCnt == DDZ_Define.play_MaxCount then
		gameState = DDZ_Define.play_state.playing_play
	end
end
function gameCtl:qiangdizhuIng()
	return gameState == DDZ_Define.play_state.playing_robDZ
end
function gameCtl:setDizhuSite(s)
	dizhuSite = s
end

	
return gameCtl