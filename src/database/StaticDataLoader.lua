


StaticDataLoader = {}

--[[
if _kSystem==kTargetWindows then
	_AbsolutePathWin32=_AbsolutePathWin32 or ""
	DIR=_AbsolutePathWin32.."/"..DIR
	DIR_CLIENT=_AbsolutePathWin32.."/"..DIR_CLIENT
end
--]]

local StaticTableList = { 
giftTool = {path="res/static_data/T_VG_GIFT.csv", cache = nil},
shopItem = {path="res/static_data/shopItem.csv", cache = nil},
}

--读取csv数据，为table
local function ReadCsvFileContentTable(file)
    local ret = csvParse.LoadCsv(file)
    return ret
end

--读取json数据，为table
local function ReadJsonFileContentTable(filePath)
    local ret = jsonParse.LoadJson(filePath)
    return ret
end

local function DeleteStaticDataLoaderMethod(loadMethodName)
    StaticDataLoader[loadMethodName] = nil
end

--以id为ID的数据表，模板函数
function StaticDataLoader.Template_loadCsvFile(name)
    local staticData = StaticTableList[name]
    

    local data = ReadCsvFileContentTable(staticData.path)
	if not data then 
        return nil 
    end
	
    
    local tab_data = {}

    for k, v in pairs(data) do
        for kk,vv in pairs(v) do
            if type(vv) ~= "number" and tonumber(vv) then
                v[kk] = tonumber(vv)
            end
        end
        local id = v.ID or v.id--默认是ID为Key
		
		if id and id ~= "" then
			tab_data[id] = v
		end
    end
    
    return tab_data
end


function StaticDataLoader.loadGiftTool()
	local dataname = "giftTool"
	local path = "res/" .. dataname .. "/"
	local staticData = StaticTableList[dataname]
    if not staticData.cache then
        local tab_data = StaticDataLoader.Template_loadCsvFile(dataname)
		local data = {}
		for k,v in pairs(tab_data) do
			v.SMALLICONURL = path .. v.ID .. "/SMALLICONURL/"..v.ID..".png"
			v.ICONURL = path .. v.ID .. "/ICONURL/"..v.ID..".png"
			v.GIFURL = path .. v.ID .. "/GIFURL"
			if v.FULLSCREENURL ~= "" then v.FULLSCREENURL = path .. v.ID .. "/FULLSCREENURL" end
			if tonumber(v.COMPANY_ID) == COMPANYID then
				data[tonumber(v.ID)] = SimpleCopy(v)
			end
		end
		staticData.cache = data
    end
    return staticData.cache
end
function StaticDataLoader.loadShopItem()
	local dataname = "shopItem"
	local staticData = StaticTableList[dataname]
	if not staticData.cache then
		staticData.cache = StaticDataLoader.Template_loadCsvFile(dataname)
		
	end
	return staticData.cache
end
function StaticDataLoader.loadShopItemSerial()
	local data = StaticDataLoader.loadShopItem()
	local res = {}
	for k,v in pairs(data) do res[#res+1]=v end
	return res
end



