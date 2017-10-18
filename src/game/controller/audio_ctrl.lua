------------------------------------
-- desc:效果控制器
------------------------------------

local audioCtrl = class("audioCtrl", HotRequire(luaFile.CtrlBase))

local soundpath = "res/audio/"
local audioEnable = true
local musicEnable = true




function audioCtrl:ctor(...)
    
end

function audioCtrl:Init()
   
	--预加载
end


function audioCtrl:Clear()
   
end

--播放音乐
function audioCtrl:playMusic(filename, isLoop)
	if musicEnable then
		audio.playMusic(filename, isLoop)
	end
end

--停止音乐
function audioCtrl:stopMusic()
	audio.stopMusic()
end

--播放音效
function audioCtrl:playSound(eff, isLoop)
	if audioEnable then
		return audio.playSound(eff, isLoop)
	end
end

--停止音效
function audioCtrl:stopSound(handle)
	audio.stopSound(handle)
end
function audioCtrl:stopAllSounds()
	audio.stopAllSounds()
end

--是否允许播放
function audioCtrl:enableMusic(b)
	musicEnable = b and true or false
end
function audioCtrl:enableSound(b)
	audioEnable = b and true or false
end

--设置音量
function audioCtrl:setVolumn(volume)
	audio.setSoundsVolume(volume/100.0)
end

--设置背景音量
function audioCtrl:setMusicVolume(volume)
	audio.setMusicVolume(volume/100.0)
end 
return audioCtrl