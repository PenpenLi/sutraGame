
-- 玩家数据
local UserInfo = class("UserInfo")

function UserInfo:ctor( ... )
    
    self:init()

    -- 设置事件派发器
    cc.load("event"):setEventDispatcher(self, GameController)

end

-- 初始化默认数据
function UserInfo:init( ... )
	-- 登录信息
    self.loginData = {}
    
	--第三方登陆信息
	self.kThridPartyInfo = {}
	
	--活动AD
	self.adActivityInfo = {}
end

-- 清除数据
function UserInfo:clear( ... )
    self.loginData = {}
	self.kThridPartyInfo = {}
	self.adActivityInfo = {}
		
end

-- 保存登录服数据
function UserInfo:setData( data )
	assert(type(data) == "table", "UserInfo:setData data is not table")
	for k,v in pairs(data) do
		self.loginData[k] = v
	end

    self:dispatchEvent({name = UserDataEvent.LOGIN_DATA_CHANGE})
end

-- 获取登陸数据
function UserInfo:getData( )
    return self.loginData
end



--第三方登陆信息
function UserInfo:getThirdPartyInfo()
	return self.kThridPartyInfo
end
function UserInfo:setThirdPartyInfo(c)
	self.kThridPartyInfo = c
end


--登陸類型
function UserInfo:getUserLoginType()
    return self.loginData.status
end

--活动类型
function UserInfo:getAdActivityInfo()
	local info = nil
	if #self.adActivityInfo > 0 then
		info = self.adActivityInfo[1]
		table.remove(self.adActivityInfo, 1)
	end
	return info
end
function UserInfo:setAdActivityInfo(data)
	self.adActivityInfo = {}
	for k,v in pairs(data) do
		local subitem = DeepCopy(v)
		table.insert(self.adActivityInfo, subitem)
	end
	
	table.sort(self.adActivityInfo, function(a, b) return a.position > b.position end)
end

function UserInfo:getUserId()
	if self.loginData.user then
		return self.loginData.user.user_id
	end
end

function UserInfo:getUserNickName()
    return self.loginData.user.base.nickname
end

function UserInfo:getUserSecretToken()
	if self.loginData.user then
		return self.loginData.user.base.secret_token
	end
end


function UserInfo:getUserBaseData()
    return self.loginData.user.base
end

--用户第三方登录token
function UserInfo:getLoginToken()
    return self.loginData.token
end

function UserInfo:getUser()
	return self.loginData.user
end

--获取登录时候数据里的seat_id
function UserInfo:getLoginSeatId()
	return self.loginData.user.seat.seat_id or -1
end

--游客登陸
function UserInfo:setGuestLogin(b)
	self.loginData.isGuestID = b
end
function UserInfo:IsGuestLogin()
	return self.loginData.isGuestID and true or false
end




return UserInfo
