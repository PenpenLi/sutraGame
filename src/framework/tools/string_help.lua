------------------------------------
-- desc:字符串处理相关工具
------------------------------------
StringEx = StringEx or {}
function StringEx:GetPath(str)
    local pos = 0
	for i=string.len(str),1,-1 do
		local temp_str = string.sub(str,i,i)
		if temp_str == "/" then
			pos = i-1
			break
		end
	end
	if pos==0 then
		return str
	end
	return string.sub(str,1,pos)
end

-- 判断字符串是否为空
function StringEx:notEmpty(str)
	if str and str ~= "" then
		return true;
	else
		return false;
	end
end

-- 字符串中夹杂一个json串，把改字符串转换成table
-- 特殊用途（聊天系统消息中处理消息用）
function StringEx:str2Tab( str )
	str = str or ""
	local retTab = {}

	-- 前缀
	retTab.prefix = string.match(str, "([^{]*){*.*}*")

	-- 数据
	local jsonStr = string.match(str, ".*({.*}).*")
	if StringEx:notEmpty(jsonStr) then
		retTab.data = cjson.decode(jsonStr)
	end

	-- 后缀
	retTab.suffix = string.match(str, ".*{.*}(.*)")

	return retTab
end

-- 截取固定字节长度字符串（从开头开始，截取固定字节长度舍去未满一个字符的字节）
function StringEx:getSubUTF8String(str, len)
	local dropping = string.byte(str, len + 1)
	if not dropping then
		return str
	end
	if dropping >= 128 and dropping < 192 then
		return StringEx:getSubUTF8String(str, len - 1)
	end
	return string.sub(str, 1, len)
end

-- 截取指定字符长度字符串
function StringEx:getSubUTF8StringByCharacter(str, len)
	local count = 0
	local retLen = 0
	
	for i = 1, #str, 1 do
		local dropping = string.byte(str, i)
		if dropping < 128 or dropping >= 192 then
			count = count + 1
		end
		if count > len then
			retLen = i - 1
			break
		else
			retLen = i
		end
	end
	return string.sub(str, 1, retLen)
end

-- 得到UTF8字符串长度
function StringEx:getUTF8StringLength(str)
	local retLen = 0
	local len = string.len(str)
	-- print(len)
	for i = 1, len, 1 do
		local dropping = string.byte(str, i)

		if dropping < 128 or dropping >= 192 then
			retLen = retLen + 1
		end
	end
	return retLen
end