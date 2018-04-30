local crypts = require("crypt")


local authUser = {}

local auth = {}
auth.STATE = {
connecting = 1,
connectfail = 2,
loginError_id_psd_error = 3,
loginError = 4,
login_ok = 5,
register_id_repeat = 6,
register_id_psd_error = 7,
register_ok = 8
}
authUser.STATE = auth.STATE
local register_info = {
	id = "",
	psd = ""
}
local login_info = {
	id = "",
	psd = ""
}


local function authLogin()
	local challenge
	local clientkey
	local serverkey
	local secret
	
	Constant.UserTokenInfo.secret = ""
	local  function  checkFine(msg)
		local datas = string.split(msg, ",")
		if datas[1] == "200" then
			print("auth error 200")
			authUser.notifyCallback(auth.STATE.loginError)
			
		elseif datas[1] == "300" then
			print("auth error 300")
			authUser.notifyCallback(auth.STATE.loginError_id_psd_error)
			
		else
			Constant.UserTokenInfo.secret = secret
			Constant.UserTokenInfo.uid = tonumber(datas[2])
			
			authUser.notifyCallback(auth.STATE.login_ok)
		end
	end
	
	--3. Server->Client : base64(DH-Exchange(server key))
    local  function  getSecret(msg)
        serverkey = msg
		print("serverkey", serverkey)
		
        secret = crypts.dhsecret(clientkey, serverkey)
        print("secret", crypts.base64encode(secret))
	
			
        --4. Client->Server : base64(HMAC(challenge, secret))
        local hmac = crypts.hmac64(challenge, secret)
		print("hmac", crypts.base64encode(hmac))
		
		local function macCallback(msg)
			if msg == "0" then
				local function encode_token(token)
					return string.format("%s@%s",
						crypts.base64encode(token.user),
						--crypts.base64encode(token.server),
						crypts.base64encode(token.passward))
				end
				local token = {
					--server = Constant.UserTokenInfo.server,
					user = login_info.id,
					passward = login_info.psd,
				}
				
				-- 5. server get token and return response
				log("token:", token)
				print("encode_token(token)", encode_token(token))
				local etoken = crypts.desencode(secret, encode_token(token))
				print("etoken", crypts.base64encode(etoken))
				networkManager.registerMsgCallback(checkFine)
				networkManager.request(etoken)
				
			else
				checkFine(msg)
			end
		end
		networkManager.registerMsgCallback(macCallback)
        networkManager.request(hmac)
    end

	--1. Server->Client : base64(8bytes random challenge)
    local  function  getChallenge(msg)
        networkManager.registerMsgCallback(getSecret)
		
        challenge = msg
		print("challenge", msg)

        --2. Client->Server : base64(8bytes handshake client key)
        clientkey = crypts.randomkey()
        clientkey = crypts.dhexchange(clientkey)
		print("clientkey", crypts.base64encode(clientkey))
        networkManager.request(clientkey)

        
    end

	networkManager.registerMsgCallback(getChallenge)
	networkManager.request("l")	
end

local function connectCallback_register(state)
	--print("connectCallback_register", state)
	if state == "open" then
		networkManager.request("r")
		networkManager.request(register_info.id .. "," .. register_info.psd)
		
		local function register_msg_callback(msg)
			local datas = string.split(msg, ",")
			if datas[1] == "0" then
				authUser.notifyCallback(auth.STATE.register_ok)
				
			elseif datas[1] ==  "200" then
				authUser.notifyCallback(auth.STATE.register_id_psd_error)
			
			elseif datas[1] ==  "300" then
				authUser.notifyCallback(auth.STATE.register_id_repeat)
				
			else
				authUser.notifyCallback(auth.STATE.register_id_psd_error)
			end
			
			networkManager.disconnect()
		end
		networkManager.registerMsgCallback(register_msg_callback)
		
	else
		authUser.notifyCallback(auth.STATE.connectfail)
	end
end

local function connectCallback_login(state)
	--print("connectCallback_login", state)
	if state == "open" then
		authLogin()
		
	else
		authUser.notifyCallback(auth.STATE.connectfail)
	end
end

local function check_illegal_chars(str)
	--if not str or string.len(str) == 0 then return false end
	for i=1, string.len(str) do
		local b = string.byte(str, i)
		if (b > -1 and b < 48) or (b > 57 and b < 65) or (b > 90 and b < 97) or (b  > 122) then
			return false
		end
	end
	return true
end

function authUser.start_register(id, psd, notifyCallback)
	if notifyCallback then authUser.notifyCallback = notifyCallback end
	
	
	--if not check_illegal_chars(id) or not check_illegal_chars(psd) then
	--	authUser.notifyCallback(auth.STATE.register_id_psd_error)
	--	return
	--end
	
	authUser.notifyCallback(auth.STATE.connecting)
	
	register_info.id = id
	register_info.psd = psd
	
	networkManager.logic(networkManager.logicType.userAuth)
	networkManager.connect( GAME_LOGIN_IP_ADDRESS, GAME_LOGIN_IP_PORT, "", connectCallback_register )
end

function authUser.start_login(id, psd, notifyCallback)
	print("authUser.start_login", id, psd)
	if notifyCallback then authUser.notifyCallback = notifyCallback end
	
	
	--if not check_illegal_chars(id) or not check_illegal_chars(psd) then
	--	authUser.notifyCallback(auth.STATE.loginError_id_psd_error)
	--	return
	--end
	
	authUser.notifyCallback(auth.STATE.connecting)
	
	login_info.id = id
	login_info.psd = psd
	
	networkManager.logic(networkManager.logicType.userAuth)
	networkManager.connect( GAME_LOGIN_IP_ADDRESS, GAME_LOGIN_IP_PORT, "", connectCallback_login )
end

return authUser