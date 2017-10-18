------------------------------------
-- author:蓝宛君445
-- email:1053210246@qq.com
-- desc:加注处理工具
------------------------------------
RaiseBetUtil = {
-- 【2倍盲注】，即加注额 = 2倍盲注；
DOUBLE_BLIAND = 1,
-- 【3倍盲注】，即加注额 = 3倍盲注；	
THREE_BLIAND = 2,
--【5倍盲注】，即加注额 = 5倍盲注； 	
FIVE_BLIAND = 3,
-- 【1/2池底】，即加注额 = 1/2池底；	
HALF_POOL_BOTTOM = 4,
-- 【1倍池底】，即加注额 = 1倍池底；	
ONE_POOL_BOTTOM = 5,
}

function RaiseBetUtil:GetRaiseList()
    local model = GameLogicCtrl:GetModel()
	local min = model:GetMinRaise()
	local max = model:GetSelfChip() + model:GetSelfNowTurnChip()
    local room_bet_limit = model:GetRoomBetLimit()
    local bottom_pool = model:GetBottomPool()
	if min >= max then
		return {}
	end

	local addList = 
       {{num=room_bet_limit * 2,type=self.DOUBLE_BLIAND},
		{num=room_bet_limit * 3,type=self.THREE_BLIAND},
		{num=room_bet_limit * 5,type=self.FIVE_BLIAND},
		{num=bottom_pool / 2,   type=self.HALF_POOL_BOTTOM},
		{num=bottom_pool,       type=self.ONE_POOL_BOTTOM}}
    table.sort(addList,function(a,b)
        return a.num<b.num
    end)

	local tempList = {}
	for i=1,#addList do
		local obj = addList[i]
		local add = model:GetRaiseBet(obj.num)
		if self:IsIn(add,min,max) then
            table.insert(tempList,obj)
		end
	end
	if #tempList <= 2 then
		return tempList
	end

	local oneThird = (max - min) / 3 + min
	local twoThird = (max - min) * 2 / 3 + min
	local temp1 = tempList[1]
	local temp2 = tempList[#tempList]
	for i = 2,#tempList - 1 do
		local obj = tempList[i]
		if math.abs(temp1.num - oneThird) > math.abs(obj.num - oneThird) then
			temp1 = obj
		end
		if math.abs(temp2.num - twoThird) > math.abs(obj.num - twoThird) then
			temp2 = obj
		end
	end
	return {temp1,temp2}
end
	
function RaiseBetUtil:IsIn(num,min,max)
	return num > min and num < max
end