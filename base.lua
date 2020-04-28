local _, AQ_SELF = ...

-- 复制table的数据，而不是引用
AQ_SELF.clone =  function(org)
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
AQ_SELF.diff =  function( t1, t2 )
    local new = {}

    for i,v in ipairs(t1) do
        if not tContains(t2, v) then
            table.insert(new, v)
        end
    end

    return new
end

-- 调试函数
AQ_SELF.debug = function( t )
    if not AQ_SELF.enableDebug then
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

AQ_SELF.GetItemLink = function( id )
    local _, link = GetItemInfo(id)
    return link
end

AQ_SELF.GetItemTpye = function( id )
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)
    return itemEquipLoc
end