
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


stage_width = 1280
stage_height = 720
-- for module display
CC_DESIGN_RESOLUTION = {
    width = stage_width,
    height = stage_height,
    autoscale = "NO_BORDER",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            return {autoscale = "NO_BORDER"}
        end
    end
}
--打包时打开
--function print()end