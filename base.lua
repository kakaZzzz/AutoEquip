local _, SELFAQ = ...

local L = SELFAQ.L

-- 复制table的数据，而不是引用
SELFAQ.clone =  function(org)
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

SELFAQ.tableInsert = function(t,v)
    if t == nil then
        t = {}
    end

    if v then
        table.insert(t,v)
    end
    return t
end

-- 合并两个数组
SELFAQ.merge = function(...)
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
SELFAQ.diff =  function( t1, t2 )
    wipe(SELFAQ.empty3)
    local new = SELFAQ.empty3

    for i,v in ipairs(t1) do
        if not tContains(t2, v) then
            table.insert(new, v)
        end
    end

    return new
end

SELFAQ.diff2 =  function( t1, t2 )
    wipe(SELFAQ.empty4)
    local new = SELFAQ.empty4

    for i,v in ipairs(t1) do
        if not tContains(t2, v) then
            table.insert(new, v)
        end
    end

    return new
end

SELFAQ.empty = function( t )
    
    if t == nil then
        t = {}
    end
    
    wipe(t)

end

SELFAQ.findItemsOrder = function( id )
    
    local count = GetItemCount(id)
    local order = 1
    local find = false

    if count == 1 then

    elseif count > 1 then

        for index=1,count do

            if not find then
                local fid = (index-1)*100000 + id
                -- print(SELFAQ.itemInBags[fid])

                if SELFAQ.itemInBags[fid] == nil then
                    order = index
                    find = true
                end
            end

        end

    end

    return 100000*(order-1) + id

end

SELFAQ.reverseId = function( id )

    if id == nil then
        return 0,0
    end
    
    local order = math.floor(id/100000)
    local rid = id%100000

    return rid, order

end

SELFAQ.reverseBagSlot = function( id )

    local num = SELFAQ.itemInBags[id]

    if num == nil then
        return -1
    end
    
    local bag = math.floor(num/100)
    local slot = num%100

    return bag, slot

end

SELFAQ.otherSlot = function(slot_id)
    
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

SELFAQ.loopSlots = function( func )
    for k,v in pairs(SELFAQ.needSlots) do
        func(v)
    end
end

SELFAQ.shortKey = function(v)
    
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
SELFAQ.debug = function( t )
    if not SELFAQ.enableDebug then
        return
    end

    if type(t) == "table" then
        for k,v in pairs(t) do
            
            if type(v) == "table" then
                print("@DEBUG: ",k)
                SELFAQ.debug(v)
            else
                print("@KV: ",k.." =>"..tostring(v))
            end
        end
    else
        print("@DEBUG: ",t)
    end
end

SELFAQ.getCooldownText = function(rest)
    local text = math.floor(rest)
    
    if rest > 3600 then
        text = "|cFFFFFFFF"..math.ceil(rest/3600).."|rh"
    elseif rest > 60 then
        text = "|cFFFFFFFF"..math.ceil(rest/60).."|rm"
    end
    
    return text
end

SELFAQ.chatInfo = function(s)
    print(L["prefix"].." "..s)
end

SELFAQ.initSV = function( v, init )
    if v == nil then

        if type(init) == "table" then
            local t = SELFAQ.clone(init)
            return t
        end

        v = init
    end
    return v
end

SELFAQ.GetItemLink = function( id )

    local id, order = SELFAQ.reverseId(id)

    if id == 0 then
        return L["[Empty]"]
    end
    local _, link = GetItemInfo(id)

    if order >0 then
        link = link.."#"..order
    end

    return link
end

SELFAQ.GetEnchanitID = function(link)
    
    if link then
        local _, enchantId = link:match("item:(%d+):(%d+)")
        return enchantId
    else
        return 0
    end
end

SELFAQ.GetItemEquipLoc = function( id )
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)
    return itemEquipLoc
end

SELFAQ.GetItemSlot = function( id )
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

SELFAQ.GetItemTexture = function( id )
    id = SELFAQ.reverseId(id)

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)
    return itemTexture
end

SELFAQ.GetSlotID = function(slot_id)
    local id = GetInventoryItemID("player", slot_id)

    if id == nil then
        id = 0
    end

    return id
end

SELFAQ.AddonEquipItemByName = function( item_id, slot_id )

    EquipItemByName(item_id, slot_id)

    local link = SELFAQ.GetItemLink(item_id)
    
    SELFAQ.popupInfo(L["Equip "]..link)
end

SELFAQ.findCarrot = function( id, slot_id, link )

    if slot_id == 13 then

        if id == 11122 then
            SELFAQ.carrot = id
        end

        if not tContains(SELFAQ.needSlots, 13) and SELFAQ.carrot > 0 then
            table.insert(SELFAQ.needSlots, 13)
        end

        return
    end

    local enchantId = SELFAQ.GetEnchanitID(link)

    -- 找到带有秘银马刺的鞋子，保存起来
    if enchantId == "464" or enchantId == "930" then
        SELFAQ["ride"..slot_id] = id
    end

    if not tContains(SELFAQ.needSlots, slot_id) and SELFAQ["ride"..slot_id]>0 then
        table.insert(SELFAQ.needSlots, slot_id)
    end
end

SELFAQ.findSwim = function( id, slot_id )

    -- 找到水藤或者碧蓝腰带，保存起来
    if id == 7052 or id == 9452 or id == 10506 then
        SELFAQ["swim"..slot_id] = id
    end

    if not tContains(SELFAQ.needSlots, slot_id) and SELFAQ["swim"..slot_id]>0 then
        table.insert(SELFAQ.needSlots, slot_id)
    end
end

SELFAQ.equipByID = function(item_id, slot_id, popup)

    if popup == nil then
        popup = true
    end

    if item_id > 100000 then
        local bag,slot = SELFAQ.reverseBagSlot(item_id)

        if bag == -1 then
            return false
        end

        ClearCursor()
        PickupContainerItem(bag,slot)

        if CursorHasItem() then
            EquipCursorItem(slot_id)
        end
    else
        EquipItemByName(item_id, slot_id)
    end

    local rid = SELFAQ.reverseId(item_id)

    local link = SELFAQ.GetItemLink(rid)

    if popup then
        SELFAQ.popupInfo(L["Equip "]..link)
    end

end


SELFAQ.infoFrameIndex = 0
SELFAQ.infoTexts = {}

SELFAQ.popupInfo = function(text)

    if AQSV.hidePopupInfo then
        return
    end

    -- 避免短时的多次显示
    -- print(SELFAQ.infoTexts, tostring(text), tContains(SELFAQ.infoTexts, text))
    if tContains(SELFAQ.infoTexts, text) then
        return
    end
    
    -- 最多显示5条
    if SELFAQ.infoFrameIndex >= 5 then
        return
    end
    
    SELFAQ.infoFrameIndex = SELFAQ.infoFrameIndex + 1

    if _G["AutoEquip_Popup"..SELFAQ.infoFrameIndex] == nil then
        CreateFrame( "GameTooltip", "AutoEquip_Popup"..SELFAQ.infoFrameIndex, UIParent, "GameTooltipTemplate" )
    end

    local f = _G["AutoEquip_Popup"..SELFAQ.infoFrameIndex]

    -- if SELFAQ.infoFrame == nil then
    --  SELFAQ.infoFrame = CreateFrame( "GameTooltip", "AutoEquip_Popup", UIParent, "GameTooltipTemplate" )
    -- end

    -- local f= SELFAQ.infoFrame

    if f.moveOut then
        f.fadeOut:Stop()
        f.moveOut:Stop()
    end
    
    f:Hide()

    f:SetOwner(UIParent, "ANCHOR_NONE")
    f:SetPoint("CENTER", UIParent,  AQSV.popupX, -40*(SELFAQ.infoFrameIndex - 1) + AQSV.popupY )

    f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"});
    f:SetBackdropColor(0,0,0,0.8);

    if SELFAQ.infoFrameIndex == 5 then
        f:SetText("...")
    else
        f:SetText(text)
        table.insert(SELFAQ.infoTexts, text)
    end

    _G["AutoEquip_Popup"..SELFAQ.infoFrameIndex.."TextLeft1"]:SetFont(STANDARD_TEXT_FONT, 14)
    _G["AutoEquip_Popup"..SELFAQ.infoFrameIndex.."TextLeft1"]:SetTextColor(255,255,255)

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
            SELFAQ.infoFrameIndex = 0
            wipe(SELFAQ.infoTexts)
            -- SELFAQ.debug(SELFAQ.infoFrameIndex)
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

SELFAQ.isNefNest = function()
    local zonetext = GetSubZoneText() == "" and GetZoneText() or GetSubZoneText()

    if zonetext == "奈法利安的巢穴" or zonetext ==  "Nefarian's Lair" then
    -- if zonetext == "艾尔文森林" then
        return true
    else
        return false
    end
end
