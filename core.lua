local _, AQSELF = ...

local debug = AQSELF.debug
local clone = AQSELF.clone
local diff = AQSELF.diff
local diff2 = AQSELF.diff2
local L = AQSELF.L
local player = AQSELF.player
local initSV = AQSELF.initSV
local GetItemTexture = AQSELF.GetItemTexture
local GetItemEquipLoc = AQSELF.GetItemEquipLoc
local tableInsert = AQSELF.tableInsert
local loopSlots = AQSELF.loopSlots


-- 初始化插件
function AQSELF.addonInit()

        AQSELF.addItems()

        for k,v in pairs(AQSELF.pvpSet) do
            if GetItemCount(v) > 0 then
                table.insert(AQSELF.pvp, v)
            end
        end
        
        AQSELF.checkUsable()

        loopSlots(AQSELF.initGroupCheckbox)

        AQSELF.checkTrinket()

        AQSELF.settingInit()
        AQSELF.suitInit()

end

function aq_test( )
    print("test test")
    local bag = AQSELF.itemInBags[18392]
    PickupContainerItem(bag[1], bag[2])
    EquipCursorItem(17)
end

AQSELF.addItems = function()
    -- 兼容全角逗号
    AQSV.additionItems = string.gsub(AQSV.additionItems,"，", ",")
    local t = { strsplit(",", AQSV.additionItems) }

    for k,v in pairs(t) do
        -- 去掉两端空格
        v= strtrim(v)
        local id, time = strsplit("/", v)
        -- 避免非数字的情况
        id = tonumber(id)
        time = tonumber(time)

        -- 避免nil的情况
        if id then

            local slot_id = AQSELF.GetItemSlot(id)

            if slot_id > 0 then

                if AQSELF.usable[slot_id] == nil then
                    AQSELF.usable[slot_id] = {}
                end

                if not tContains(AQSELF.usable[slot_id], id) and id and time then
                    table.insert(AQSELF.usable[slot_id], id)
                    AQSELF.buffTime[id] = time

                    if AQSV.pvpTrinkets[id] == nil then
                        AQSV.pvpTrinkets[id] = false
                    end
                    if AQSV.pveTrinkets[id] == nil then
                        AQSV.pveTrinkets[id] = false
                    end
                end

                -- 手动修改buff持续时间
                if id and time then
                    AQSELF.buffTime[id] = time
                end

            end

        end

    end
end

AQSELF.initGroupCheckbox = function(slot_id)
    for k,v in pairs(AQSELF.pvp) do
        if AQSV.pveTrinkets[v] == nil then
            AQSV.pveTrinkets[v] = false
        end
    end

    for k,v in pairs(AQSV.usableItems[slot_id]) do
        if AQSV.pvpTrinkets[v] == nil then
            AQSV.pvpTrinkets[v] = true
        end
        if AQSV.pveTrinkets[v] == nil then
            AQSV.pveTrinkets[v] = true
        end
        if AQSV.queue13[v] == nil then
            AQSV.queue13[v] = true
        end
        if AQSV.queue14[v] == nil then
            AQSV.queue14[v] = true
        end
    end
end

-- 检查主动饰品
AQSELF.checkUsable = function()
    -- 删除没有或者放在银行里的主动饰品，并保持优先级不变

    AQSELF.needSlots = {}

    for sid,items in pairs(AQSELF.usable) do
        
        local new = {}

        if not AQSV.usableItems[sid] then
            AQSV.usableItems[sid] = {}
        end

        for i,v in pairs(AQSV.usableItems[sid]) do

            if GetItemCount(v) > 0 and not tContains(new, v) and tContains(AQSELF.usable[sid], v) then
                table.insert(new, v)
            end
            -- debug(new)
        end
        AQSV.usableItems[sid] = new

        -- 获得新饰品，或者从银行取出，保持优先级不变，追加到最后
        for i,v in ipairs(AQSELF.usable[sid]) do
            if GetItemCount(v) > 0 and not tContains(AQSV.usableItems[sid], v) then
                table.insert(AQSV.usableItems[sid], v)
            end
        end

        if #AQSV.usableItems[sid] > 0 then
            table.insert(AQSELF.needSlots, sid)
        end

    end

    table.sort(AQSELF.needSlots)

    local new = {}

    for k,v in pairs(AQSELF.needSlots) do
        if v == 13 then
            table.insert(new, 1, v)
        else
            table.insert(new, v)
        end
    end

    AQSELF.needSlots = new

end

-- 检查角色身上所有的饰品
AQSELF.checkTrinket = function( )

    AQSELF.items = {}
    AQSELF.multiItems = {}

    for i=1,18 do
        if i ~= 4 then
            AQSELF.items[i] = tableInsert(AQSELF.items[i], 0)

            local id = GetInventoryItemID("player", i)

            if id then
                tableInsert(AQSELF.items[i], id)
                if i == 11 or i == 13 then
                    AQSELF.items[i+1] = tableInsert(AQSELF.items[i+1], id)
                elseif i == 12 or i == 14 then
                    AQSELF.items[i-1] = tableInsert(AQSELF.items[i-1], id)
                elseif i == 16 or i == 17 then
                    if(GetItemEquipLoc(id) == "INVTYPE_WEAPON") then
                        AQSELF.items[33-i] = tableInsert(AQSELF.items[33-i], id)
                    end
                end
            end
        end
    end

    -- 保存饰品在背包中的位置
    AQSELF.itemInBags = {}

    for i=0,NUM_BAG_SLOTS do
        local count = GetContainerNumSlots(i)

        for s=1,count do
            if GetContainerItemInfo(i,s) then

                -- fix：背包槽位是空的时候，会中断循环
                local id = GetContainerItemID(i,s)

                -- if id ~= "" then
                     local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)

                     -- debug(itemEquipLoc)

                     -- if id == 7961 then
                     --    print(itemEquipLoc)
                     -- end

                    if itemEquipLoc ~= "" then
                        AQSELF.itemInBags[id] = {i,s}
                    end

                    if itemEquipLoc == "INVTYPE_TRINKET" then
                        table.insert(AQSELF.items[13], id)
                        table.insert(AQSELF.items[14], id)
                    elseif itemEquipLoc == "INVTYPE_CHEST" or itemEquipLoc == "INVTYPE_ROBE" then
                        table.insert(AQSELF.items[5], id)
                    elseif itemEquipLoc == "INVTYPE_HEAD" then
                        table.insert(AQSELF.items[1], id)
                    elseif itemEquipLoc == "INVTYPE_NECK" then
                        table.insert(AQSELF.items[2], id)
                    elseif itemEquipLoc == "INVTYPE_SHOULDER" then
                        table.insert(AQSELF.items[3], id)
                    elseif itemEquipLoc == "INVTYPE_WAIST" then
                        table.insert(AQSELF.items[6], id)
                    elseif itemEquipLoc == "INVTYPE_LEGS" then
                        table.insert(AQSELF.items[7], id)
                    elseif itemEquipLoc == "INVTYPE_FEET" then
                        table.insert(AQSELF.items[8], id)
                    elseif itemEquipLoc == "INVTYPE_WRIST" then
                        table.insert(AQSELF.items[9], id)
                    elseif itemEquipLoc == "INVTYPE_HAND" then
                        table.insert(AQSELF.items[10], id)
                    elseif itemEquipLoc == "INVTYPE_FINGER" then
                        table.insert(AQSELF.items[11], id)
                        table.insert(AQSELF.items[12], id)
                    elseif itemEquipLoc == "INVTYPE_CLOAK" then
                        table.insert(AQSELF.items[15], id)
                    elseif itemEquipLoc == "INVTYPE_WEAPON" then
                        table.insert(AQSELF.items[16], id)
                        table.insert(AQSELF.items[17], id)
                    elseif itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND" or itemEquipLoc == "INVTYPE_HOLDABLE" then
                        table.insert(AQSELF.items[17], id)
                    elseif itemEquipLoc == "INVTYPE_2HWEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND" then
                        table.insert(AQSELF.items[16], id)
                    elseif itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_THROWN" or itemEquipLoc == "INVTYPE_RANGEDRIGHT" or itemEquipLoc == "INVTYPE_RELIC" then
                        table.insert(AQSELF.items[18], id)
                    end
                    
                -- end
            end  
        end
    end

    loopSlots(function(slot_id)

        -- 去掉主动饰品
        -- AQSELF.items[slot_id] = diff2(AQSELF.items[slot_id], AQSV.usableItems[slot_id])

        -- 降幂排序，序号大的正常来看是等级高的饰品
        table.sort(AQSELF.items[slot_id], function(a, b)
            -- 报错：table必须是从1到n连续的，即中间不能有nil，否则会报错
            return a > b
        end)

    end)

    

end

AQSELF.updateItemInBags = function()
    for i=0,NUM_BAG_SLOTS do
        local count = GetContainerNumSlots(i)

        for s=1,count do
            if GetContainerItemInfo(i,s) then

                -- fix：背包槽位是空的时候，会中断循环
                local id = GetContainerItemID(i,s)

                -- if id ~= "" then
                local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)

                if itemEquipLoc ~= "" then
                    
                    if AQSELF.itemInBags[id] then
                        AQSELF.itemInBags[id][1] = i
                        AQSELF.itemInBags[id][2] = s
                    else
                        AQSELF.itemInBags[id] = {i,s}
                    end
                end
            end  
        end
    end
end


-- 获取当前装备饰品的状态
AQSELF.getTrinketStatusBySlotId = function( slot_id, queue )

    wipe(AQSELF["e"..(slot_id%2)])

    local slot = AQSELF["e"..(slot_id%2)]

    slot["id"] = GetInventoryItemID("player", slot_id)

    -- 修正slot为空时出现的问题
    if slot["id"] == nil then
        slot["id"] = 0
    end

    -- 获取饰品的冷却状态
    slot["start"], slot["duration"], slot["enable"] = GetItemCooldown(slot["id"])
    -- 剩余冷却时间
    slot["rest"] = slot["duration"] - GetTime() + slot["start"]
    -- buff已经持续的时长
    slot["buff"] = GetTime() - slot["start"]

    slot["busy"] = false

    if slot_id == 13 or slot_id == 14 then
        if tContains(queue, slot["id"]) and AQSV["queue"..slot_id][slot["id"]] then 
            slot["busy"] = true 
        end
    else
        if tContains(queue, slot["id"]) then 
            slot["busy"] = true 
        end
    end

    

    if AQSV.slotStatus[slot_id].locked then
        slot["busy"] = true 
    end

    -- 如果buff时间没有记录，默认为0
    if AQSELF.buffTime[slot["id"]] == nil then
        AQSELF.buffTime[slot["id"]] = 0
    end

    -- 如果当前饰品可用，或者剩余时间30秒之内，取消CD锁
    -- 主动换饰品后，延迟5秒判断，避免出现实际判断的是上一个饰品
    if (slot["duration"] <= 30 or slot["rest"] <30) and (GetTime() - AQSV.slotStatus[slot_id].lockedTime) > 5  then
        AQSV.slotStatus[slot_id].lockedCD = false
        AQSV.slotStatus[slot_id].lockedTime = 0
    end

    -- 饰品已经使用，并且超过了buff时间
    -- 剩余时间要大于30，避免饰品使用后，但是cd快到了，还被换下
    -- 主动CD锁判断
    if slot["duration"] > 30 and slot["buff"] > AQSELF.buffTime[slot["id"]] + 1 and slot["rest"] > 30 and not AQSV.slotStatus[slot_id].lockedCD then
        slot["busy"] = false
        -- 饰品使用后，取消锁定
        AQSELF.cancelLocker( slot_id )
    end

    -- 使用busy属性，控制饰品槽是否参与更换逻辑
    -- 禁用14的话，总是返回busy
    if slot_id == 14 and AQSV.disableSlot14 then
        slot["busy"] = true
    end

    -- 自动换萝卜
    if slot_id == 14 and not AQSV.slotStatus[14].locked and AQSV.enableCarrot then
        -- 不用处理下马逻辑，因为更换主动饰品逻辑直接起效
        if(IsMounted() and not UnitOnTaxi("player")) then

            -- 战场判断放这里，不然进战场不会换下
            -- 副本里也不使用
            if not AQSELF.inInstance() then
                if slot["id"] ~= AQSELF.carrot then
                    AQSV.carrotBackup = slot["id"]
                    EquipItemByName(AQSELF.carrot, 14)
                    -- collectgarbage("collect")
                end
                -- 骑马时一直busy，中断更换主动饰品的逻辑
                slot["busy"] = true
                slot["priority"] = 0
            end

        elseif slot["id"] == AQSELF.carrot and (AQSV.disableSlot14 or #queue== 0 or AQSV.slot14 == 0) then
            -- 禁用14的时候，主动饰品是空的时候，需要追加换下萝卜的逻辑
            -- 避免不停更换萝卜
            if AQSV.carrotBackup == AQSELF.carrot then
                AQSV.carrotBackup = 0
            end
            
            if AQSV.carrotBackup > 0 then
                EquipItemByName(AQSV.carrotBackup, 14)
            end
        end
    end

    return slot
end

function AQSELF.buildQueueRealtime(slot_id)

    wipe(AQSELF.empty1)

    if not AQSV.enable then
        return AQSELF.empty1
    end

    local queue = AQSELF.empty1
    local inBattleground = UnitInBattleground("player")

    for k,v in pairs(AQSV.usableItems[slot_id]) do
        if inBattleground or AQSV.pvpMode then
            AQSELF.pvpIcon:Show()
            if AQSV.pvpTrinkets[v] then
                table.insert(queue, v)
            end
        else
            AQSELF.pvpIcon:Hide()
            if AQSV.pveTrinkets[v] then
                table.insert(queue, v)
            end
        end
    end

    return queue
end

function AQSELF.changeTrinket()
    -- 主要代码部分 --
    
    local queue = AQSELF.buildQueueRealtime(13)

    -- 获取当前饰品的状态
    local slot13 = AQSELF.getTrinketStatusBySlotId(13, queue)
    local slot14 = AQSELF.getTrinketStatusBySlotId(14, queue)

    -- 如果没有主动饰品，则停止更换饰品
    -- if #queue == 0 then
    --     return
    -- end

    -- 强制优先级处理
    if AQSV.forcePriority then
        -- 找到13、14的优先级
        slot13["priority"] = 1000
        if slot14["priority"] == nil then
            slot14["priority"] = 1000
        end

        for k,v in pairs(queue) do
            if v == slot13["id"] then
                slot13["priority"] = k
            end
            if v == slot14["id"] then
                slot14["priority"] = k
            end

            -- 获取队列里饰品的冷却状态
            local start, duration, enable = GetItemCooldown(v)
            -- 剩余冷却时间
            local rest = duration - GetTime() + start

            -- 饰品是可用状态，或者剩余时间30秒之内
            if (duration == 0 or rest < 30) and v ~= slot13["id"] and v ~= slot14["id"]  then
                if k <  slot13["priority"] and not AQSV.slotStatus[13].locked and AQSV.queue13[v] then
                    EquipItemByName(v, 13)
                    slot13["busy"] = true
                    slot13["priority"] = k
                    -- AQSELF.cancelLocker( 13 )
                elseif k <  slot14["priority"] and not AQSV.slotStatus[14].locked and not AQSV.disableSlot14 and AQSV.queue14[v] then
                    EquipItemByName(v, 14)
                    slot14["busy"] = true
                    slot14["priority"] = k
                    -- AQSELF.cancelLocker( 14 )
                end
            end
        end

    end

    -- 13、14都装备主动饰品，退出函数
    if slot13["busy"] and slot14["busy"] then
        return
    end

    -- 遍历饰品队列
    for i,v in ipairs(queue) do

        -- 获取队列里饰品的冷却状态
        local start, duration, enable = GetItemCooldown(v)

        -- 剩余冷却时间
        local rest = duration - GetTime() + start

        -- 饰品是可用状态，或者剩余时间30秒之内
        if duration == 0 or rest < 30 then
            -- 当前不在13或14槽里
            if v ~= slot13["id"] and v ~= slot14["id"] then
                -- 优先13
                if not slot13["busy"] and AQSV.queue13[v] then
                    EquipItemByName(v, 13)
                    slot13["busy"] = true
                    
                elseif not slot14["busy"] and AQSV.queue14[v] then
                    EquipItemByName(v, 14)
                    slot14["busy"] = true
                    
                end
            end
        end

        -- 13、14都装备主动饰品，退出函数
        if slot13["busy"] and slot14["busy"] then
            return
        end
    end

    -- 遍历发现没有可用的主动饰品，则更换被动饰品
    if not slot13["busy"] and AQSV.slotStatus[13].backup ~= slot13["id"] and AQSV.slotStatus[13].backup >0 then
        EquipItemByName(AQSV.slotStatus[13].backup, 13)
    end

    if not slot14["busy"] and AQSV.slotStatus[14].backup ~= slot14["id"] and AQSV.slotStatus[14].backup >0 then
        EquipItemByName(AQSV.slotStatus[14].backup, 14)
    end
end

function AQSELF.changeItem(slot_id)
    -- 主要代码部分 --
    
    local queue = AQSELF.buildQueueRealtime(slot_id)

    -- 获取当前饰品的状态
    local slot13 = AQSELF.getTrinketStatusBySlotId(slot_id, queue)

    -- 如果没有主动饰品，则停止更换饰品
    -- if #queue == 0 then
    --     return
    -- end

    -- 强制优先级处理
    if AQSV.forcePriority then
        -- 找到13、14的优先级
        slot13["priority"] = 1000

        for k,v in pairs(queue) do
            if v == slot13["id"] then
                slot13["priority"] = k
            end

            -- 获取队列里饰品的冷却状态
            local start, duration, enable = GetItemCooldown(v)
            -- 剩余冷却时间
            local rest = duration - GetTime() + start

            -- 饰品是可用状态，或者剩余时间30秒之内
            if (duration == 0 or rest < 30) and v ~= slot13["id"] then
                if k <  slot13["priority"] and not AQSV.slotStatus[slot_id].locked then
                    EquipItemByName(v, slot_id)
                    slot13["busy"] = true
                    slot13["priority"] = k
                end
            end
        end

    end

    -- 13、14都装备主动饰品，退出函数
    if slot13["busy"] then
        return
    end

    -- 遍历饰品队列
    for i,v in ipairs(queue) do

        -- 获取队列里饰品的冷却状态
        local start, duration, enable = GetItemCooldown(v)

        -- 剩余冷却时间
        local rest = duration - GetTime() + start

        -- 饰品是可用状态，或者剩余时间30秒之内
        if duration == 0 or rest < 30 then
            -- 当前不在13或14槽里
            if v ~= slot13["id"] then
                -- 优先13
                if not slot13["busy"] then
                    EquipItemByName(v, slot_id)
                    slot13["busy"] = true
                    
                end
            end
        end

        -- 13、14都装备主动饰品，退出函数
        if slot13["busy"] then
            return
        end
    end

    -- 遍历发现没有可用的主动饰品，则更换被动饰品
    if not slot13["busy"] and AQSV.slotStatus[slot_id].backup ~= slot13["id"] and AQSV.slotStatus[slot_id].backup >0 then
        EquipItemByName(AQSV.slotStatus[slot_id].backup, slot_id)
    end

end

function AQSELF.enablePvpMode()
    AQSV.pvpMode = not AQSV.pvpMode

    AQSELF.menuList[2]["checked"] = AQSV.pvpMode

    local on = ""
    if AQSV.pvpMode then
        on =L["|cFF00FF00Enabled|r"]
    else
        on =L["|cFFFF0000Disabled|r"]
    end

    if AQSV.pvpMode then
        AQSELF.pvpIcon:Show()
    else
        AQSELF.pvpIcon:Hide()
    end
    print(L["prefix"]..L[" PVP mode "]..on)
end

function AQSELF.enableAutoEuquip()
    AQSV.enable = not AQSV.enable

    AQSELF.f.checkbox["enable"]:SetChecked(AQSV.enable)
    AQSELF.menuList[1]["checked"] = AQSV.enable

    if AQSV.enable then
        print(L["AutoEquip: |cFF00FF00Enabled|r"])
    else
        print(L["AutoEquip: |cFFFF0000Disabled|r"])
    end
end

function AQSELF.setCDLock( item_id, slot_id )

    local start, duration, enable = GetItemCooldown(item_id)

    -- 处在使用CD时，才加锁
    if duration > 30 then
        AQSV.slotStatus[slot_id].lockedCD = true
        AQSV.slotStatus[slot_id].lockedTime = GetTime()
    -- else
    --     AQSV.slotStatus[slot_id].lockedCD = false
    --     AQSV["slot"..slot_id.."lockedItem"] = 0
    end
end

function AQSELF.setWait(item_id, slot_id)
    local texture = GetItemTexture(item_id)
    AQSELF.slotFrames[slot_id].wait:SetTexture(texture)
    AQSELF.slotFrames[slot_id].waitFrame:Show()

    AQSV["slot"..slot_id.."Wait"] = {
        item_id,
        slot_id
    }
end

function AQSELF.cancelLocker( slot_id )
    AQSV.slotStatus[slot_id].locked = false
    AQSELF.slotFrames[slot_id].locker:Hide()

    -- 解开CD锁
    AQSV.slotStatus[slot_id].lockedCD = false
    AQSV.slotStatus[slot_id].lockedTime = 0
end

function AQSELF.equipWait(item_id, slot_id)

    EquipItemByName(item_id, slot_id)
    AQSV.slotStatus[slot_id].locked = true
    AQSV["slot"..slot_id.."Wait"] = nil
    AQSELF.slotFrames[slot_id].wait:SetTexture()
    AQSELF.slotFrames[slot_id].waitFrame:Hide()
    AQSELF.slotFrames[slot_id].locker:Show()

    AQSELF.setCDLock( item_id, slot_id )
end

function AQSELF.checkAllWait()
    for k,v in pairs(AQSELF.slots) do
        if AQSV["slot"..v.."Wait"] then
            local one = AQSV["slot"..v.."Wait"]
            AQSELF.equipWait(one[1], one[2])
        end
    end
end

function AQSELF.inInstance()
    local inInstance, instanceType = IsInInstance()

    return inInstance
end

function AQSELF.playerCanEquip()
    local f=UnitAffectingCombat("player")
    local d=UnitIsDeadOrGhost("player")
    local c1 = CastingInfo("player") 
    local c2 = ChannelInfo("player") 
    local fd = UnitIsFeignDeath("player")

    if f or (d and not fd) or c1 or c2 then
        return false
    else
        return true
    end
end

function AQSELF.slotsCanEquip()
    local slots = {16,17,18}

    if AQSELF.playerCanEquip() then
        slots = {1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18}
    end

    return slots
end