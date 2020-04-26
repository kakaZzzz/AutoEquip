

-- 复制table的数据，而不是引用
function clone(org)
    local function copy(org, res)
        for k,v in pairs(org) do
            if type(v) ~= "table" then
                res[k] = v;
            else
                res[k] = {};
                copy(v, res[k])
            end
        end
    end
 
    local res = {}
    copy(org, res)
    return res
end

-- 去掉重复的值
function diff( t1, t2 )
    local new = {}

    for i,v in ipairs(t1) do
        if not tContains(t2, v) then
            table.insert(new, v)
        end
    end

    return new
end

-- 调试函数
function debug( t )
    if not enableDebug then
        return
    end

    if type(t) == "table" then
        for k,v in pairs(t) do
            print("@DEBUG: ",k.." =>"..v)
        end
    else
        print("@DEBUG: ",t)
    end
end

function GetItemLink( id )
    local _, link = GetItemInfo(id)
    return link
end