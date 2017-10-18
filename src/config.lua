
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

virtual_server_open = true

GAME_LOGIN_IP_ADDRESS = "192.168.220.128"
GAME_LOGIN_IP_PORT = 8001

GAME_GAME_IP_ADDRESS = "192.168.220.128"
GAME_GAME_IP_PORT = 7001


--目前支持的分辨率
_SUPPORT_RESOLUTION_ = {
	{9,16},
	{3,4},
}

BASE64_ENCRYPT_KEY = "oUpA4/K01ENnRFSrvTMPD3qQwxBZaklm8VC5WcJXIstu2fgH7deL6GYbyzhij9+O"

stage_width = 720
stage_height = 1280
-- for module display
CC_DESIGN_RESOLUTION = {
    width = stage_width,
    height = stage_height,
    autoscale = "EXACT_FIT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            return {autoscale = "EXACT_FIT"}
        end
    end
}
--打包时打开
--function print()end