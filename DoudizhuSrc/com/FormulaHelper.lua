--公式演算
FormulaHelper = FormulaHelper or {}
FormulaHelper.isInitMag = false


local mag = {}
--mag["magic"] = 14
local _var = nil
local function initMag(var)
    _var = var
    
    if FormulaHelper.isInitMag == false then
        mag["magic"] = function() return 10--[[return _var:get()--从角色object获得相应的属性--]] end
        mag["attack"] = function() return 10 end
    end

    FormulaHelper.isInitMag = true
end

local function parse(str)
    local paraList = {}
    local mulaList = {}
            
            
    --将符号化解为+，-
    local function popUp_para()
        local res = paraList[#paraList]
        paraList[#paraList] = nil
        return res
    end
    local function rePopUp_para()
        local res = paraList[1]
        if res then
            for i=2,#paraList do
                paraList[i-1] = paraList[i]
            end 
            paraList[#paraList] = nil
        end
        return res
    end
    local function popUp_mula()
        local res = mulaList[#mulaList]
        mulaList[#mulaList] = nil
        return res
    end
    local function getTop_mula()
        local res = mulaList[#mulaList]
        return res
    end
    local function popDown_para(para)
        if para then 
            local pa = para
            if mag[pa] then pa = mag[pa]() end
            table.insert(paraList, tonumber(pa))
        end
    end
    local function popDown_mula(mula)
        if mula then 
            table.insert(mulaList, mula) 
        end
    end
    local function think()
        local mulaCnt = #mulaList
        local paraCnt = #paraList
        if mulaCnt <= 0 and paraCnt <= 1 then
            return 
        end

        local mula = getTop_mula()
        if mula == "*" or mula == "/" then
            local p2 = popUp_para()
            local p1 = popUp_para()
            local p3 = nil
            if mula == "*" then
                p3 = p1 * p2
            elseif mula == "/" then
                p3 = p1 / p2
            end
            popDown_para(p3)
            popUp_mula()
        end
    end
            
    local function sweep()
        local result = rePopUp_para()
        for i=1, #mulaList do
            local mula = mulaList[i]
            local p = rePopUp_para()
            if mula == "+" then
                result = result + p
            elseif mula == "-" then
                result = result - p
            end
        end

        return result
    end

    while string.len(str) > 0 do
        local a,b,c,d,e = string.find(str, "([+*-/()])(.*)")
        if c == "." then--分析到.号，string解析不了.号
                local tmp = string.sub(str, a+1, string.len(str))
                local a_,b_,c_,d_,e_ = string.find(tmp, "([+*-/()])(.*)")
                a_ = a_ or 0
                a = a + a_ + 1
        end
        if not a then--分析到最后一个参数
            local subResult = string.sub(str, 1, string.len(str))
            popDown_para(subResult)
            think()
            break

        elseif a ~= 1 then--第一个不是运算符,那么就是参数
            if a == nil or a <= 1 then
                a = 2
            end
            local subResult = string.sub(str, 1, a-1)
            if a == string.len(str) then
                subResult = str
            end
            popDown_para(subResult)
            think()
                    
            if a == string.len(str) then--分析到.号，string解析不了.号
                break
            else
                str = string.sub(str, a, string.len(str))
            end    
        else
            local mula_t = string.sub(str, 1, 1)
                    
            if mula_t == "(" then
                local sstr = string.sub(str, 2, string.len(str))
                local brackIndex = 1
                for i=1, string.len(sstr) do
                    local tmp = string.sub(sstr, i, i)
                    if tmp == "(" then
                        brackIndex = brackIndex + 1

                    elseif tmp == ")" then
                        brackIndex = brackIndex - 1
                        if brackIndex == 0 then
                            sstr = string.sub(sstr, 1, i-1)
                            str = string.sub(str, i+1+1, string.len(str))
                            break
                        end
                    end
                end
                    
                local subResult = parse(sstr)
                popDown_para(subResult)
                        
            else
                popDown_mula(mula_t)
                str = string.sub(str, 2, string.len(str))
            end
        end
    end
    return sweep()
end

--param : 参数
--param.role : 角色
function FormulaHelper.calculate(formula, var)
    initMag(var)
    return parse(formula)
end