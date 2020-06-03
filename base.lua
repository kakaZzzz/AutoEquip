local _, AQSELF = ...

local L = AQSELF.L

-- 复制table的数据，而不是引用
AQSELF.clone =  function(org)
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

AQSELF.tableInsert = function(t,v)
    if t == nil then
        t = {}
    end

    if v then
        table.insert(t,v)
    end
    return t
end

-- 合并两个数组
AQSELF.merge = function(...)
    local tabs = {...}
    if not tabs then
        return {}
    end
    local origin = tabs[1]
    for i = 2,#tabs do
        if origin then
            if tabs[i] then
                for k,v in pairs(tabs[i]) do
                    table.insert(origin,v)
                end
            end
        else
            origin = tabs[i]
        end
    end
    return origin
end

-- 去掉重复的值
AQSELF.diff =  function( t1, t2 )
    wipe(AQSELF.empty3)
    local new = AQSELF.empty3

    for i,v in ipairs(t1) do
        if not tContains(t2, v) then
            table.insert(new, v)
        end
    end

    return new
end

AQSELF.diff2 =  function( t1, t2 )
    wipe(AQSELF.empty4)
    local new = AQSELF.empty4

    for i,v in ipairs(t1) do
        if not tContains(t2, v) then
            table.insert(new, v)
        end
    end

    return new
end

AQSELF.empty = function( t )
    
    if t == nil then
        t = {}
    end
    
    wipe(t)

end

AQSELF.findItemsOrder = function( id )
    
    local count = GetItemCount(id)
    local order = 1
    local find = false

    if count == 1 then

    elseif count > 1 then

        for index=1,count do

            if not find then
                local fid = (index-1)*100000 + id
                -- print(AQSELF.itemInBags[fid])

                if AQSELF.itemInBags[fid] == nil then
                    order = index
                    find = true
                end
            end

        end

    end

    return 100000*(order-1) + id

end

AQSELF.reverseId = function( id )
    
    local order = math.floor(id/100000)
    local rid = id%100000

    return rid, order

end

AQSELF.reverseBagSlot = function( id )

    local num = AQSELF.itemInBags[id]
    
    local bag = math.floor(num/100)
    local slot = num%100

    return bag, slot

end

AQSELF.otherSlot = function(slot_id)
    
    local other = 0

    if slot_id == 11 or slot_id == 12 then
        other = 23 - slot_id
    elseif slot_id == 13 or slot_id == 14 then
        other = 27 -slot_id
    elseif slot_id == 16 or slot_id == 17 then
        other = 33 -slot_id
    end

    return other
end

AQSELF.loopSlots = function( func )
    for k,v in pairs(AQSELF.needSlots) do
        func(v)
    end
end

-- 调试函数
AQSELF.debug = function( t )
    if not AQSELF.enableDebug then
        return
    end

    if type(t) == "table" then
        for k,v in pairs(t) do
            
            if type(v) == "table" then
                print("@DEBUG: ",k)
                AQSELF.debug(v)
            else
                print("@KV: ",k.." =>"..tostring(v))
            end
        end
    else
        print("@DEBUG: ",t)
    end
end

AQSELF.getCooldownText = function(rest)
    local text = math.floor(rest)
    
    if rest > 3600 then
        text = "|cFFFFFFFF"..math.ceil(rest/3600).."|rh"
    elseif rest > 60 then
        text = "|cFFFFFFFF"..math.ceil(rest/60).."|rm"
    end
    
    return text
end

AQSELF.addonInfo = function(s)
    print(L["prefix"]..s)
end

AQSELF.initSV = function( v, init )
    if v == nil then

        if type(init) == "table" then
            local t = AQSELF.clone(init)
            return t
        end

        v = init
    end
    return v
end

AQSELF.GetItemLink = function( id )

    local id, order = AQSELF.reverseId(id)

    if id == 0 then
        return L["[Empty]"]
    end
    local _, link = GetItemInfo(id)

    if order >0 then
        link = link.." - "..order
    end

    return link
end

AQSELF.GetItemEquipLoc = function( id )
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)
    return itemEquipLoc
end

AQSELF.GetItemSlot = function( id )
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)
    local slot = 0

    if itemEquipLoc == "INVTYPE_TRINKET" then
        slot = 13
    elseif itemEquipLoc == "INVTYPE_CHEST" or itemEquipLoc == "INVTYPE_ROBE" then
        slot = 5
    elseif itemEquipLoc == "INVTYPE_HEAD" then
        slot = 1
    elseif itemEquipLoc == "INVTYPE_NECK" then
        slot = 2
    elseif itemEquipLoc == "INVTYPE_SHOULDER" then
        slot = 3
    elseif itemEquipLoc == "INVTYPE_WAIST" then
        slot = 6
    elseif itemEquipLoc == "INVTYPE_LEGS" then
        slot = 7
    elseif itemEquipLoc == "INVTYPE_FEET" then
        slot = 8
    elseif itemEquipLoc == "INVTYPE_WRIST" then
        slot = 9
    elseif itemEquipLoc == "INVTYPE_HAND" then
        slot = 10
    elseif itemEquipLoc == "INVTYPE_FINGER" then
        slot = 11
    elseif itemEquipLoc == "INVTYPE_CLOAK" then
        slot = 15
    elseif itemEquipLoc == "INVTYPE_WEAPON" then
        slot = 16
    elseif itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND" or itemEquipLoc == "INVTYPE_HOLDABLE" then
        slot = 17
    elseif itemEquipLoc == "INVTYPE_2HWEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND" then
        slot = 16
    elseif itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_THROWN" or itemEquipLoc == "INVTYPE_RANGEDRIGHT" or itemEquipLoc == "INVTYPE_RELIC" then
        slot = 18
    end

    return slot
end

AQSELF.GetItemTexture = function( id )
    id = AQSELF.reverseId(id)

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)
    return itemTexture
end

AQSELF.GetSlotID = function(slot_id)
    local id = GetInventoryItemID("player", slot_id)

    if id == nil then
        id = 0
    end

    return id
end

AQSELF.equipByID = function(item_id, slot_id)

    if item_id > 100000 then
        local bag,slot = AQSELF.reverseBagSlot(item_id)

        ClearCursor()
        PickupContainerItem(bag,slot)

        if CursorHasItem() then
            EquipCursorItem(slot_id)
        end
    else
        EquipItemByName(item_id, slot_id)
    end

end    