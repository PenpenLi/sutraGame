
NumberHelper = {}

--亿
local billion = 100000000
-- 万
local ten_thousand = 10000

-- 数字转换成缩写
-- @param num 数字
-- @param perc 精度（保留几位小数）
-- @param flag 是否四舍五入  true:四舍五入 false:直接舍弃
function NumberHelper:num2Abbr(num, prec, flag)
	num = tonumber(num or 0) or 0
	if num >= billion or num <= -billion then -- "亿"
		if prec then
			local formatStr = "%." .. prec .. "f%s"
			return string.format(formatStr, 
				(flag and (num / billion) or (math.floor(num / (billion / math.pow(10, prec))) / math.pow(10, prec))), 
				language.billion)
		else
			return (num / billion) .. language.billion
		end
	elseif num >= ten_thousand or num <= -ten_thousand then -- "万"
		if prec then
			local formatStr = "%." .. prec .. "f%s"
			return string.format(formatStr, 
				(flag and (num / ten_thousand) or (math.floor(num / (ten_thousand / math.pow(10, prec))) / math.pow(10, prec))), 
				language.ten_thousand)
		else
			return (num / ten_thousand) .. language.ten_thousand
		end
	else
		return num
	end
end

-- 缩写还原成数字
function NumberHelper:abbr2Num(abbr)
	abbr = abbr or 0
	local num , unit = string.match(abbr, "([0-9]+)(.*)")

	if unit == language.billion then -- 如果有单位“亿”
		return num * billion
	elseif unit == language.ten_thousand then -- 如果有单位“万”
		return num * ten_thousand
	else
		return num
	end
end
