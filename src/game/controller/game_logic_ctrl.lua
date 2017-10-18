
local GameLogicCtrl = class("GameLogicCtrl", HotRequire(luaFile.CtrlBase))
GameLogicCtrl.players = {}
GameLogicCtrl.playerCount = 0
GameLogicCtrl.roomID = 0
GameLogicCtrl.gameid = 0
GameLogicCtrl.areaid = 0
GameLogicCtrl.master_seat_id = 0
GameLogicCtrl.currentGameCount = 0
local isInRoom = false

local _delegate = nil

local this


-- 游戏规则配置
GameLogicCtrl.tagGameRuleConfig =
{
	game_round 				= 8,			-- 游戏局数
	need_card			 	= 1,			-- 需要的房卡数量
	master_seat 			= 0,			-- 房主座位
	area_id 				= 0, 			-- 区域ID
}

function GameLogicCtrl:ctor( ... )
	self.super.ctor(self, ... )
	this = self
	self:init()
end



--玩家状态改变
local function OnProGameRoomUserStateResponse(event)
	logc("OnProGameRoomUserStateResponse")
	local msg = event.data.msg
	if msg.user_id == UserManager:getUserInfo():getUserId() then
		UserManager:getUserData():setUserState(msg.state)
	end
	if _delegate then _delegate:OnProGameRoomUserStateResponse(event) end 
end

--player进入桌子
function GameLogicCtrl:OnGameDeskUserEnter(msg)
	if _delegate then _delegate:OnGameDeskUserEnter(msg) end 
end
function GameLogicCtrl:OnGameDeskUserExit(msg)
	if _delegate then _delegate:OnGameDeskUserExit(msg) end 
end



-- 文本表情聊天消息
function GameLogicCtrl:OnProGameUserChatRequest(msg)
	if _delegate then _delegate:OnProGameUserChatRequest(msg) end 
end 


-- 语音聊天
function GameLogicCtrl:OnProGameUserVoiceRequest(msg)
	if _delegate then _delegate:OnProGameUserVoiceRequest(msg) end 
end 


-- 定位信息
function GameLogicCtrl:OnProGameUserLocationRequest(msg)
	if _delegate then _delegate:OnProGameUserLocationRequest(msg) end 
end 

-- 普通用户离开
function GameLogicCtrl:OnProGameUserLeaveDeskResponse(msg)
	if _delegate then _delegate:OnProGameUserLeaveDeskResponse(msg) end 
end 
--进入房间
function GameLogicCtrl:joinGame(gameID,nRoomNumber)
	RoomConnectCtrl:enterGame(gameID, nRoomNumber)
end
function GameLogicCtrl:createGame(gameID)
	RoomConnectCtrl:enterGame(gameID, -1)
end

function GameLogicCtrl:setDelegate(del)
	if _delegate then 
		_delegate:clear()
		_delegate = nil
	end
	_delegate = del 
end

function GameLogicCtrl:getPlayers()			return self.players end
function GameLogicCtrl:getPlayerNum()		return self.playerCount end
function GameLogicCtrl:setPlayerNum(num)	self.playerCount = num end

function GameLogicCtrl:initPlayersUI(ui)
	_delegate:initPlayersUI(ui)
end

function GameLogicCtrl:onConnectRoomSucess()
	isInRoom = true
	StateMgr:ChangeState(StateType.Game)
	
	_delegate:onConnectRoomSucess()
end

function GameLogicCtrl:onMajorLocationUpdate()
	if isInRoom and _delegate then
		_delegate:SendMajorLocation()
	end
end


function GameLogicCtrl:isInRoom()
	return isInRoom
end
function GameLogicCtrl:exitRoom(...)
	if _delegate then _delegate:exitRoom(...) end 
end

	
function GameLogicCtrl:getGameRuleConfig()
	return self.tagGameRuleConfig
end
function GameLogicCtrl:getPlayGameCount()
	return self.currentGameCount
end

function GameLogicCtrl:getRoomID()
	return roomID
end

function GameLogicCtrl:majorIsMaster()
	return self.players[1]:getMaster()
end


function GameLogicCtrl:ClearData()
	GameLogicCtrl.players = {}
	GameLogicCtrl.playersCount = 0
	_delegate:clear()
	RoomConnectCtrl:ClearData()
	_delegate = nil
	gameFactoryCtrl.currRoomLayer = nil
	GameLogicCtrl.master_seat_id = 0
end




function GameLogicCtrl:init()
	self.players = {}
	
	
	self.handlerList = self:addEventListenerList({
        {RoomEvent.CONNECT_ROOM_SUCCESS, handler(self, self.onConnectRoomSucess)},
		{RoomEvent.GAME_MAJOR_LOCATION_UPDATE, handler(self, self.onMajorLocationUpdate)},
		--{"ProGameRoomUserStateResponse",         OnProGameRoomUserStateResponse},
		--{"ProGameDeskUserEnterResponse",         OnProGameDeskUserEnterResponse},
    })
end

function GameLogicCtrl:playerEnter(msg)
	_delegate:playerEnter(msg)
end

function GameLogicCtrl:sendGameRuleConfigRequest(...)
	_delegate:sendGameRuleConfigRequest(...)
end


local mt = {__index = function (existTab, val)
			if _delegate and _delegate[val]  then 
				return _delegate[val]
			end
		end}
setmetatable(GameLogicCtrl, mt)

return GameLogicCtrl
