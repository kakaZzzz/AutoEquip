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

AQSELF.shortKey = function(v)
    
    local t = {strsplit("-", v)}
    local s = ""

    for i=1,#t-1 do
        s = s..strsub(t[i],1,1)
    end

    s = s..t[#t]

    if strlen(s) > 3 then
        s = strsub(s, 1, 3).."..."
    end

    return s
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

AQSELF.chatInfo = function(s)
    print(L["prefix"].." "..s)
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

AQSELF.GetEnchanitID = function(link)
    
    local _, enchantId = link:match("item:(%d+):(%d+)")

    return enchantId
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

AQSELF.AddonEquipItemByName = function( item_id, slot_id )

    EquipItemByName(item_id, slot_id)

    local link = AQSELF.GetItemLink(item_id)
    
    AQSELF.popupInfo(L["Equip "]..link)
end

AQSELF.findCarrot = function( id, slot_id, link )

    if slot_id == 13 then

        if id == 11122 then
            AQSELF.carrot = id
        end

        if not tContains(AQSELF.needSlots, 13) and AQSELF.carrot > 0 then
            table.insert(AQSELF.needSlots, 13)
        end

        return
    end

    local enchantId = AQSELF.GetEnchanitID(link)

    -- 找到带有秘银马刺的鞋子，保存起来
    if enchantId == "464" or enchantId == "930" then
        AQSELF["ride"..slot_id] = id
    end

    if not tContains(AQSELF.needSlots, slot_id) and AQSELF["ride"..slot_id]>0 then
        table.insert(AQSELF.needSlots, slot_id)
    end
end

AQSELF.findSwim = function( id, slot_id )

    -- 找到水藤或者碧蓝腰带，保存起来
    if id == 7052 or id == 9452 then
        AQSELF["swim"..slot_id] = id
    end

    if not tContains(AQSELF.needSlots, slot_id) and AQSELF["swim"..slot_id]>0 then
        table.insert(AQSELF.needSlots, slot_id)
    end
end

AQSELF.equipByID = function(item_id, slot_id, popup)

    if popup == nil then
        popup = true
    end

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

    local rid = AQSELF.reverseId(item_id)

    local link = AQSELF.GetItemLink(rid)

    if popup then
        AQSELF.popupInfo(L["Equip "]..link)
    end

end


AQSELF.infoFrameIndex = 0
AQSELF.infoTexts = {}

AQSELF.popupInfo = function(text)

    if AQSV.hidePopupInfo then
        return
    end

    -- 避免短时的多次显示
    -- print(AQSELF.infoTexts, tostring(text), tContains(AQSELF.infoTexts, text))
    if tContains(AQSELF.infoTexts, text) then
        return
    end
    
    -- 最多显示5条
    if AQSELF.infoFrameIndex >= 5 then
        return
    end
    
    AQSELF.infoFrameIndex = AQSELF.infoFrameIndex + 1

    if _G["AutoEquip_Popup"..AQSELF.infoFrameIndex] == nil then
        CreateFrame( "GameTooltip", "AutoEquip_Popup"..AQSELF.infoFrameIndex, UIParent, "GameTooltipTemplate" )
    end

    local f = _G["AutoEquip_Popup"..AQSELF.infoFrameIndex]

    -- if AQSELF.infoFrame == nil then
    --  AQSELF.infoFrame = CreateFrame( "GameTooltip", "AutoEquip_Popup", UIParent, "GameTooltipTemplate" )
    -- end

    -- local f= AQSELF.infoFrame

    if f.moveOut then
        f.fadeOut:Stop()
        f.moveOut:Stop()
    end
    
    f:Hide()

    f:SetOwner(UIParent, "ANCHOR_NONE")
    f:SetPoint("CENTER", UIParent,  AQSV.popupX, -40*(AQSELF.infoFrameIndex - 1) + AQSV.popupY )

    f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"});
    f:SetBackdropColor(0,0,0,0.8);

    if AQSELF.infoFrameIndex == 5 then
        f:SetText("...")
    else
        f:SetText(text)
        table.insert(AQSELF.infoTexts, text)
    end

    _G["AutoEquip_Popup"..AQSELF.infoFrameIndex.."TextLeft1"]:SetFont(STANDARD_TEXT_FONT, 14)
    _G["AutoEquip_Popup"..AQSELF.infoFrameIndex.."TextLeft1"]:SetTextColor(255,255,255)

    f:Show()

    if not f.moveOut then -- Upgrade to 39
        f.moveOut = f:CreateAnimationGroup()

        local animOut = f.moveOut:CreateAnimation("Translation")
        animOut:SetOrder(1)
        animOut:SetDuration(0.3)
        -- animOut:SetFromAlpha(1)
        -- animOut:SetToAlpha(0)
        animOut:SetOffset(0, 20)
        animOut:SetStartDelay(2)
        f.moveOut:SetScript("OnFinished",function() 
            f:Hide()
            AQSELF.infoFrameIndex = 0
            wipe(AQSELF.infoTexts)
            -- AQSELF.debug(AQSELF.infoFrameIndex)
        end)
    end

    if not f.fadeOut then -- Upgrade to 39
        f.fadeOut = f:CreateAnimationGroup()
        local animOut = f.fadeOut:CreateAnimation("Alpha")
        animOut:SetOrder(1)
        animOut:SetDuration(0.3)
        animOut:SetFromAlpha(1)
        animOut:SetToAlpha(0)
        animOut:SetStartDelay(2)
        f.fadeOut:SetToFinalAlpha(true)
    end

    f.fadeOut:Play()
    f.moveOut:Play()

end