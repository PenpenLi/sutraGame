songData = {}
--频名字后面没有标记敲击量的，就按时间秒最低三秒一下，最高一秒两下频率计算
--type=1是自由发挥，2是木鱼引导
songData[#songData+1] = {id=1, name="觀音菩薩", file="s1.mp3", time=15, count=1, B=true, type=1, touchMax=30, touchMin=5}
songData[#songData+1] = {id=2, name="觀音菩薩", file="s1.mp3", time=15, count=100, B=true, type=2, touchMax=1440, touchMin=960}
songData[#songData+1] = {id=3, name="南無本師釋迦牟尼佛", file="s2.mp3", time=37, count=50, B=true, type=1, touchMax=3700, touchMin=616}
songData[#songData+1] = {id=4, name="南無本師釋迦牟尼佛", file="s2.mp3", time=37, count=50, B=true, type=2, touchMax=900, touchMin=600}
songData[#songData+1] = {id=5, name="觀音靈感真言", file="s3.mp3", time=93, count=110, type=2, touchMax=132, touchMin=88}
songData[#songData+1] = {id=6, name="準提神咒", file="s4.mp3", time=63, count=124, type=2, touchMax=148, touchMin=99}
songData[#songData+1] = {id=7, name="大悲咒", file="s5.mp3", time=315, count=1, type=1, touchMax=630, touchMin=105}
songData[#songData+1] = {id=8, name="觀音靈感真言", file="s6.mp3", time=237, count=1, type=1, touchMax=474, touchMin=79}
songData[#songData+1] = {id=9, name="廣大靈感觀世音", file="s7.mp3", time=304, count=1, type=1, touchMax=608, touchMin=101}
songData[#songData+1] = {id=10, name="心經", file="s8.mp3", time=255, count=1, type=1, touchMax=510, touchMin=85}
songData[#songData+1] = {id=11, name="準提神咒", file="s9.mp3", time=372, count=1, type=1, touchMax=744, touchMin=124}




local songpath = "audio/song/"
for k,v in pairs(songData) do
	v.file = songpath .. v.file
end




local audiopath = "audio/"
audioData = {
buttonClick = "buttonClick.mp3",
background = "background.mp3",
censer = "censer.mp3",--上香
error = "error.mp3",
win = "win.mp3",
woodenFish = "woodenFish.mp3",
woodenFishB = "woodenFishB.mp3",--当播放到B开头的经文，就用这个木鱼音效
startSong = "startSong.mp3",--开始诵经
signDay = "signDay.mp3",--签到

}
for k,v in pairs(audioData) do
	audioData[k] = audiopath .. audioData[k]
end

