--角色数据表读取类
roleDataManager = roleDataManager or {}

roleDataManager.cacheData = {}

--获取武将信息
function roleDataManager.getLeaderData(roleID)
    local data = csvParse.LoadCsv("active_csv")
end 