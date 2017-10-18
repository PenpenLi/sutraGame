------------------------------------
-- desc:游戏内容显示处理工具
------------------------------------
GameUtil = GameUtil or {}
--筹码显示格式 负数会转换为正数
function GameUtil:GetNumStr(num)
	local unitNum = 0
	local count = math.abs(num)
	while count >= 10000 do
		count = count / 10000
		unitNum = unitNum + 1
	end
	local fixNum = (unitNum == 0 and 0 or 2)
	return GetTranslation("public.moneyUnit" .. unitNum,count == 0 and "0" or string.format("%."..fixNum.."f",count))
end
