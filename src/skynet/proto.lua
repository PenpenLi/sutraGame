local sprotoparser = require "skynet.sprotoparser"

local proto = {}




proto.c2s = sprotoparser.parse [[

.package {
	type 0 : integer
	session 1 : integer
}

totalPush 1 {
	request {
		uuid 0 : string
	}
	
	response {
		totalRank 0 : integer
		signNum 1 : integer
		signRank 2 : integer
		censerNum 3 : integer
		censerRank 4 : integer
		incenseLastTime 5 : integer
		sutraNum 6 : integer
		sutraRank 7 : integer
		sutraLastTime 8 : integer
		
		jingtuGroup 9 : string
		lotusNum 10 : integer
		
		signLine 11 : integer
		serverTime 12 : integer
		fohaoGroup 13 : string
		
		first 14 : boolean
	}
}

updateUserData 2 {
	request {
		type 0 	: string
		data 1 	: string
		ostime 2	: integer
	}
	response {
		errCode 0 : integer
		desc 1 : string
	}
}
]]

proto.s2c = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

heartbeat 1 {}

pushUserData 2 {
	request {
		type 0 : string
		data 1 : string
	}
}

]]

return proto
