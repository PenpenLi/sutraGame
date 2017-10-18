Basepack = class("Basepack")

kNetpack_Type	= "type"
kNetpack_Value	= "value"

-- function Basepack:appendValue(t,v)
-- 	print("append:Value")
-- 	if type(v) == "table" and v._appendToTable ~= nil then
-- 		v:_appendToTable(t)
-- 	else
-- 		table.insert(t,v)
-- 	end
-- end

function Basepack:appendInt(t,v)
	local value = {}
	value[kNetpack_Type]	= "int"
	value[kNetpack_Value] 	= v
	table.insert(t,value)
end

function Basepack:appendString(t,v)
	local value = {}
	value[kNetpack_Type]	= "string"
	value[kNetpack_Value] 	= v
	table.insert(t,value)
end

function Basepack:appendLong(t,v)
	local value = {}
	value[kNetpack_Type]	= "long"
	value[kNetpack_Value] 	= v
	table.insert(t,value)
end

function Basepack:appendBool(t,v)
	local value = {}
	value[kNetpack_Type]	= "bool"
	value[kNetpack_Value] 	= v
	table.insert(t,value)
end

function Basepack:appendByte(t,v)
	local value = {}
	value[kNetpack_Type]	= "byte"
	value[kNetpack_Value] 	= v
	table.insert(t,value)
end

function Basepack:appendShort(t,v)
	local value = {}
	value[kNetpack_Type]	= "short"
	value[kNetpack_Value] 	= v
	table.insert(t,value)
end

function Basepack:appendDouble(t,v)
	local value = {}
	value[kNetpack_Type]	= "double"
	value[kNetpack_Value] 	= v
	table.insert(t,value)
end

function Basepack:appendFloat(t,v)
	local value = {}
	value[kNetpack_Type]	= "float"
	value[kNetpack_Value] 	= v
	table.insert(t,value)
end

function Basepack:appendObject(t,v)
	-- self.appendValue(t,v)
	if v == nil then
		self:appendByte(t,0)
	else
		self:appendByte(t,1)
		v._appendToTable(t)
	end
end

-- function Basepack:appendArray(t,v)
-- 	for i,value in ipairs(v) do
-- 		self.appendValue(t,value)
-- 	end
-- end

function Basepack:appendIntArray(t,v)
    self:appendShort(t,#v)
	for i,value in ipairs(v) do
		self:appendInt(t,value)
	end
end

function Basepack:appendStringArray(t,v)
    self:appendShort(t,#v)
	for i,value in ipairs(v) do
		self:appendString(t,value)
	end
end

function Basepack:appendLongArray(t,v)
    self:appendShort(t,#v)
	for i,value in ipairs(v) do
		self:appendLong(t,value)
	end
end

function Basepack:appendBoolArray(t,v)
    self:appendShort(t,#v)
	for i,value in ipairs(v) do
		self:appendBool(t,value)
	end
end

function Basepack:appendByteArray(t,v)
    self:appendShort(t,#v)
	for i,value in ipairs(v) do
		self:appendByte(t,value)
	end
end

function Basepack:appendShortArray(t,v)
    self:appendShort(t,#v)
	for i,value in ipairs(v) do
		self:appendShort(t,value)
	end
end

function Basepack:appendDoubleArray(t,v)
    self:appendShort(t,#v)
	for i,value in ipairs(v) do
		self:appendDouble(t,value)
	end
end

function Basepack:appendFloatArray(t,v)
    self:appendShort(t,#v)
	for i,value in ipairs(v) do
		self:appendFloat(t,value)
	end
end

function Basepack:appendObjectArray(t,v)
    self:appendShort(t,#v)
	for i,value in ipairs(v) do
		self:appendObject(t,value)
	end
end




-- function Basepack:ctor()
-- 	print("Basepack:ctor")
-- 	-- self._packhead 	= nil --包头
-- 	self._packtype 	= nil --包类型
-- 	self._packindex = nil --包号
-- end

-- function Basepack:getPack(t)
-- 	print("Basepack:getPack")
-- 	-- local pack = t or {}

-- 	assert(type(t)=="table","para must be a table!")
	
	
	
-- 	print(table.concat(t," "))
-- 	-- for i,v in ipairs(table) do
-- 	-- 	table.insert(pack,v)
-- 	-- end
-- end

-- function Basepack:putValue(t,v)
-- 	if type(v) == "table" then
-- 		if v._getpack ~= nil and type(v._getpack) == "function" then
-- 			--对象
-- 			v._getpack(t)
-- 		else
-- 			--普通的table
-- 			for i,value in ipairs(t) do
				
-- 			end
-- 		end
-- 	end
-- end