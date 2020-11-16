local _, SELFAQ = ...

local debug = SELFAQ.debug
local clone = SELFAQ.clone
local diff = SELFAQ.diff
local diff2 = SELFAQ.diff2
local L = SELFAQ.L
local player = SELFAQ.player
local initSV = SELFAQ.initSV
local GetItemTexture = SELFAQ.GetItemTexture
local GetItemEquipLoc = SELFAQ.GetItemEquipLoc
local tableInsert = SELFAQ.tableInsert
local loopSlots = SELFAQ.loopSlots
local GetItemLink = SELFAQ.GetItemLink
local GetEnchanitID = SELFAQ.GetEnchanitID
local findCarrot = SELFAQ.findCarrot
local findSwim = SELFAQ.findSwim
local chatInfo = SELFAQ.chatInfo
local popupInfo = SELFAQ.popupInfo
local AddonEquipItemByName = SELFAQ.AddonEquipItemByName


-- 初始化插件
function SELFAQ.addonInit()

        SELFAQ.buildBlockTable()
        SELFAQ.addItems()

        SELFAQ.updateAllItems( )

        SELFAQ.settingInit()
        SELFAQ.superInit()
        SELFAQ.suitInit()

end

function SELFAQ.updateAllItems( )
    -- 检查pvp饰品
    for k,v in pairs(SELFAQ.pvpSet) do
        if GetItemCount(v) > 0 then
            table.insert(SELFAQ.pvp, v)
        end
    end

    SELFAQ.undeadTrinket = 0
    for k,v in pairs({13209, 19812}) do
        if GetItemCount(v) > 0 then
            SELFAQ.undeadTrinket = v
        end
    end
    
    SELFAQ.checkUsable()

    loopSlots(SELFAQ.initGroupCheckbox)

    SELFAQ.checkItems()
end

function aetest( )

    -- local t1 = loadstring("function t2() print(1234) end")

    -- local res, info = pcall(t1)
    
    -- if res then
    --     t1()
    --     t1 = nil
    -- else
    --     print(info)
    -- end

    -- print(1)
    -- res, info = pcall(t2)

    -- print(res)

    -- if res then
    --     -- t2()
    --     t2 = nil
    -- else
    --     print(info)
    -- end


    -- local t1 = loadstring("function t2() print(5678) end")

    -- res, info = pcall(t1)
    
    -- if res then
    --     t1()
    --     t1 = nil
    -- else
    --     print(info)
    -- end


    -- res, info = pcall(t2)

    -- print(res)

    -- if res then
    --     t2()
    --     t2 = nil
    -- else
    --     print(info)
    -- end

    -- print(GetUnitName("target"))

    local name, type, difficultyIndex, difficultyName, maxPlayers,
    dynamicDifficulty, isDynamic, instanceMapId, lfgID = GetInstanceInfo()

    print(name, type, difficultyIndex, difficultyName, maxPlayers,
    dynamicDifficulty, isDynamic, instanceMapId, lfgID)

    -- print(GetItemCooldown(21180))
    -- print(GetSpellInfo(1973))

    -- print(SELFAQ.getItemLevel(21180))
    -- SELFAQ.putSuit2Bank(4)
    -- print(GetItemTexture(19339))
    -- debug(GetNumBankSlots())

    -- debug(UnitCreatureType("target"))
end

SELFAQ.buildBlockTable =function()
    
    SELFAQ.blockTable = {}

    local str = string.gsub(AQSV.blockItems,"，", ",")

    local t = {strsplit(",", strtrim(str))}

    for k,v in pairs(t) do
        v = tonumber(v)

        if v then
            table.insert(SELFAQ.blockTable, v)
        end
    end

end

SELFAQ.addItems = function()
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

            local slot_id = SELFAQ.GetItemSlot(id)

            if slot_id > 0 then

                if SELFAQ.usable[slot_id] == nil then
                    SELFAQ.usable[slot_id] = {}
                end

                if not tContains(SELFAQ.usable[slot_id], id) and id and time then
                    table.insert(SELFAQ.usable[slot_id], id)
                    SELFAQ.buffTime[id] = time

                    if AQSV.pvpTrinkets[id] == nil then
                        AQSV.pvpTrinkets[id] = false
                    end
                    if AQSV.pveTrinkets[id] == nil then
                        AQSV.pveTrinkets[id] = false
                    end
                end

                -- 手动修改buff持续时间
                if id and time then
                    SELFAQ.buffTime[id] = time
                end

            end

        end

    end
end

SELFAQ.initGroupCheckbox = function(slot_id)
    for k,v in pairs(SELFAQ.pvp) do
        if AQSV.pveTrinkets[v] == nil then
            AQSV.pveTrinkets[v] = false
        end
    end

    for k,v in pairs(AQSV.usableItems[slot_id]) do
        if AQSV.pvpTrinkets[v] == nil then
            AQSV.pvpTrinkets[v] = false
        end
        if AQSV.pveTrinkets[v] == nil then
            AQSV.pveTrinkets[v] = false
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
SELFAQ.checkUsable = function()
    -- 删除没有或者放在银行里的主动饰品，并保持优先级不变

    SELFAQ.needSlots = {}

    for sid,items in pairs(SELFAQ.usable) do
        
        local new = {}

        if not AQSV.usableItems[sid] then
            AQSV.usableItems[sid] = {}
        end

        for i,v in pairs(AQSV.usableItems[sid]) do

            if GetItemCount(v) > 0 and not tContains(new, v) and tContains(SELFAQ.usable[sid], v) then
                table.insert(new, v)
            end
            -- debug(new)
        end
        AQSV.usableItems[sid] = new

        -- 获得新饰品，或者从银行取出，保持优先级不变，追加到最后
        for i,v in ipairs(SELFAQ.usable[sid]) do
            if GetItemCount(v) > 0 and not tContains(AQSV.usableItems[sid], v) then
                table.insert(AQSV.usableItems[sid], v)
            end
        end

        if #AQSV.usableItems[sid] > 0 then
            table.insert(SELFAQ.needSlots, sid)
        end

    end

    table.sort(SELFAQ.needSlots)

    local new = {}

    for k,v in pairs(SELFAQ.needSlots) do
        if v == 13 then
            table.insert(new, 1, v)
        else
            table.insert(new, v)
        end
    end

    SELFAQ.needSlots = new

    SELFAQ.updateButtonSwitch()

end

-- 检查角色身上所有的饰品
SELFAQ.checkItems = function( )
    
    wipe(SELFAQ.empty6)

    SELFAQ.items = SELFAQ.empty6

    wipe(SELFAQ.empty7)

    -- 保存饰品在背包中的位置
    SELFAQ.itemInBags = SELFAQ.empty7

    for i=1,18 do
        if i ~= 4 then
            SELFAQ.items[i] = tableInsert(SELFAQ.items[i], 0)

            local id = GetInventoryItemID("player", i)

            if id then
                -- 保存身上的装备
                SELFAQ.itemInBags[id] = 1000*i

                tableInsert(SELFAQ.items[i], id)
                if i == 11 or i == 13 then
                    SELFAQ.items[i+1] = tableInsert(SELFAQ.items[i+1], id)
                elseif i == 12 or i == 14 then
                    SELFAQ.items[i-1] = tableInsert(SELFAQ.items[i-1], id)
                elseif i == 16 or i == 17 then
                    if(GetItemEquipLoc(id) == "INVTYPE_WEAPON") then
                        SELFAQ.items[33-i] = tableInsert(SELFAQ.items[33-i], id)
                    end
                end

                if i == 8 or i == 10 then
                    local link = GetInventoryItemLink("player",i)
                    findCarrot(id, i, link)
                elseif i == 13 or i == 14 then
                    findCarrot(id, 13)
                elseif i == 1 and i == 6 or i == 16 then
                    findSwim(id, i)
                end

            end
        end
    end

    

    for i=0,NUM_BAG_SLOTS do
        local count = GetContainerNumSlots(i)

        for s=1,count do
            if GetContainerItemInfo(i,s) then

                -- fix：背包槽位是空的时候，会中断循环
                local id = GetContainerItemID(i,s)

                -- 不在屏蔽列表里
                if not tContains(SELFAQ.blockTable, id) then
                     local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)

                     -- debug(itemEquipLoc)

                     -- if id == 7961 then
                     --    print(itemEquipLoc)
                     -- end

                    if itemEquipLoc ~= "" and itemEquipLoc ~= "INVTYPE_AMMO" then
                        -- 拥有物品的个数，计算出内部id
                        id = SELFAQ.findItemsOrder(id)
                        SELFAQ.itemInBags[id] = i*100 + s
                        
                    end

                    if itemEquipLoc == "INVTYPE_TRINKET" then
                        table.insert(SELFAQ.items[13], id)
                        table.insert(SELFAQ.items[14], id)

                        findCarrot(id, 13)
                        

                    elseif itemEquipLoc == "INVTYPE_CHEST" or itemEquipLoc == "INVTYPE_ROBE" then
                        table.insert(SELFAQ.items[5], id)
                    elseif itemEquipLoc == "INVTYPE_HEAD" then
                        table.insert(SELFAQ.items[1], id)
                        findSwim(id, 1)
                    elseif itemEquipLoc == "INVTYPE_NECK" then
                        table.insert(SELFAQ.items[2], id)
                    elseif itemEquipLoc == "INVTYPE_SHOULDER" then
                        table.insert(SELFAQ.items[3], id)
                    elseif itemEquipLoc == "INVTYPE_WAIST" then
                        table.insert(SELFAQ.items[6], id)
                        findSwim(id, 6)
                    elseif itemEquipLoc == "INVTYPE_LEGS" then
                        table.insert(SELFAQ.items[7], id)
                    elseif itemEquipLoc == "INVTYPE_FEET" then
                        table.insert(SELFAQ.items[8], id)

                        local link = GetContainerItemLink(i, s)
                        findCarrot(id, 8, link)

                    elseif itemEquipLoc == "INVTYPE_WRIST" then
                        table.insert(SELFAQ.items[9], id)
                    elseif itemEquipLoc == "INVTYPE_HAND" then
                        table.insert(SELFAQ.items[10], id)

                        local link = GetContainerItemLink(i, s)
                        findCarrot(id, 10, link)

                    elseif itemEquipLoc == "INVTYPE_FINGER" then
                        table.insert(SELFAQ.items[11], id)
                        table.insert(SELFAQ.items[12], id)
                    elseif itemEquipLoc == "INVTYPE_CLOAK" then
                        table.insert(SELFAQ.items[15], id)
                    elseif itemEquipLoc == "INVTYPE_WEAPON" then
                        table.insert(SELFAQ.items[16], id)
                        table.insert(SELFAQ.items[17], id)
                    elseif itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND" or itemEquipLoc == "INVTYPE_HOLDABLE" then
                        table.insert(SELFAQ.items[17], id)
                    elseif itemEquipLoc == "INVTYPE_2HWEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND" then
                        table.insert(SELFAQ.items[16], id)
                        -- 水藤是双手武器
                        findSwim(id, 16)
                    elseif itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_THROWN" or itemEquipLoc == "INVTYPE_RANGEDRIGHT" or itemEquipLoc == "INVTYPE_RELIC" then
                        table.insert(SELFAQ.items[18], id)
                    end
                    
                end
            end  
        end
    end

    -- loopSlots(function(slot_id)

    --     -- 去掉主动饰品
    --     -- SELFAQ.items[slot_id] = diff2(SELFAQ.items[slot_id], AQSV.usableItems[slot_id])

    --     -- 降幂排序，序号大的正常来看是等级高的饰品
    --     table.sort(SELFAQ.items[slot_id], function(a, b)
    --         -- 报错：table必须是从1到n连续的，即中间不能有nil，否则会报错
    --         return a > b
    --     end)

    -- end)

    -- debug(SELFAQ.itemInBags)

end

SELFAQ.updateItemInBags = function()
    for i=0,NUM_BAG_SLOTS do
        local count = GetContainerNumSlots(i)

        for s=1,count do
            if GetContainerItemInfo(i,s) then

                -- fix：背包槽位是空的时候，会中断循环
                local id = GetContainerItemID(i,s)

                -- if id ~= "" then
                local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)

                if itemEquipLoc ~= "" then
                    
                    if SELFAQ.itemInBags[id] then
                        SELFAQ.itemInBags[id][1] = i
                        SELFAQ.itemInBags[id][2] = s
                    else
                        SELFAQ.itemInBags[id] = {i,s}
                    end
                end
            end  
        end
    end
end


-- 获取当前装备饰品的状态
SELFAQ.getTrinketStatusBySlotId = function( slot_id, queue )

    wipe(SELFAQ["e"..(slot_id%2)])

    local slot = SELFAQ["e"..(slot_id%2)]

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
    if SELFAQ.buffTime[slot["id"]] == nil then
        SELFAQ.buffTime[slot["id"]] = 0
    end

    -- 如果当前饰品可用，或者剩余时间30秒之内，取消CD锁
    -- 主动换饰品后，延迟5秒判断，避免出现实际判断的是上一个饰品
    -- 增加cd锁判断，避免一直取消cd锁
    if (slot["duration"] <= 30 or slot["rest"] <30) and (GetTime() - AQSV.slotStatus[slot_id].lockedTime) > 5 and AQSV.slotStatus[slot_id].lockedCD then
        debug("unlock cd")
        AQSV.slotStatus[slot_id].lockedCD = false
        AQSV.slotStatus[slot_id].lockedTime = 0
    end

    -- 饰品已经使用，并且超过了buff时间
    -- 剩余时间要大于30，避免饰品使用后，但是cd快到了，还被换下
    -- 主动CD锁判断
    if slot["duration"] > 30 and slot["buff"] > SELFAQ.buffTime[slot["id"]] and slot["rest"] > 30 and not AQSV.slotStatus[slot_id].lockedCD then
        slot["busy"] = false
        -- 饰品使用后，取消锁定
        SELFAQ.cancelLocker( slot_id )
    end

    -- 饰品已经使用
    -- buff大于5秒，避免延时误判
    if slot["duration"] > 30 and slot["buff"] > 5 and slot["buff"] <= SELFAQ.buffTime[slot["id"]] then

        local spellName = GetItemSpell(slot["id"])

        if spellName then

            local index = 1
            local find = false
            local name, icon, count, debuffType, duration, expire = UnitBuff("player", index)

            while name do
                if spellName == name then
                    name = nil
                    find = true
                else
                    index = index + 1
                    name, icon, count, debuffType, duration, expire = UnitBuff("player", index)
                end
            end

            -- 找不到buff名称
            if not find then
                debug("not find")
                slot["busy"] = false
                SELFAQ.cancelLocker( slot_id )
            end

        end

    end

    -- 使用busy属性，控制饰品槽是否参与更换逻辑
    -- 禁用14的话，总是返回busy
    if slot_id == 14 and AQSV.disableSlot14 then
        slot["busy"] = true
    end

    -- 自动换萝卜
    if slot_id == 14 
        and (not AQSV.slotStatus[14].locked or AQSV.forceAcc) 
        and AQSV.enableCarrot 
        and SELFAQ.carrot > 0 
        then

        -- 不用处理下马逻辑，因为更换主动饰品逻辑直接起效
        if(IsMounted() 
            and not UnitOnTaxi("player")
            and not (AQSV.pauseAccWhenTarget and SELFAQ.targetEnemy)
            and not (AQSV.pauseAccWhenTargetFriend and SELFAQ.targetFriend)
            and not (AQSV.pauseAccWhenTargetMember and SELFAQ.targetEnemyMember)
            ) then

            -- 战场判断放这里，不然进战场不会换下
            -- 副本里也不使用
            -- if not SELFAQ.inInstance() then

            if (not SELFAQ.inInstance()) -- 不在副本里
            or AQSV.enableAccInstance -- 副本生效
            or (AQSV.enableAccTAQ and SELFAQ.inTAQ()) -- TAQ生效功能
            then


                if slot["id"] ~= SELFAQ.carrot then
                    AQSV.carrotBackup = slot["id"]
                    AddonEquipItemByName(SELFAQ.carrot, 14)
                    -- collectgarbage("collect")
                end
                -- 骑马时一直busy，中断更换主动饰品的逻辑
                slot["busy"] = true
                slot["priority"] = 0
            end

        elseif slot["id"] == SELFAQ.carrot and (AQSV.disableSlot14 or AQSV.slotStatus[14].locked or (#queue== 0 and AQSV.slotStatus[14].backup == 0)) then
            -- 禁用14的时候，主动饰品是空的时候，需要追加换下萝卜的逻辑
            -- 避免不停更换萝卜
            if AQSV.carrotBackup == SELFAQ.carrot then
                AQSV.carrotBackup = 0
            end

            if AQSV.carrotBackup == slot["id"] then
                AQSV.carrotBackup = 0
            end

            -- print(AQSV.disableSlot14, #queue)
            
            if AQSV.carrotBackup > 0 then
                debug("carrot")
                AddonEquipItemByName(AQSV.carrotBackup, 14)
            end
        end
    end

    -- 自动换手套或靴子
    if tContains({8,10}, slot_id) and SELFAQ["ride"..slot_id] >0 and (not AQSV.slotStatus[slot_id].locked or AQSV.forceAcc) and AQSV.enableCarrot  then

        local link = GetInventoryItemLink("player",slot_id)
        local enchantId = GetEnchanitID(link)

        -- 不用处理下马逻辑，因为更换主动饰品逻辑直接起效
        if(IsMounted() 
            and not UnitOnTaxi("player")
            and not (AQSV.pauseAccWhenTarget and SELFAQ.targetEnemy)
            and not (AQSV.pauseAccWhenTargetFriend and SELFAQ.targetFriend)
            and not (AQSV.pauseAccWhenTargetMember and SELFAQ.targetEnemyMember)
            ) then

            -- 战场判断放这里，不然进战场不会换下
            -- 副本里也不使用
            if (not SELFAQ.inInstance()) -- 不在副本里
            or AQSV.enableAccInstance -- 副本生效
            or (AQSV.enableAccTAQ and SELFAQ.inTAQ()) -- TAQ生效功能
            then

                if enchantId ~= "930" and enchantId ~= "464" and SELFAQ["ride"..slot_id] > 0 then

                    AQSV["backup"..slot_id] = slot["id"]

                    -- 存在两个相同物品的可能
                    SELFAQ.equipByID(SELFAQ["ride"..slot_id], slot_id)

                    -- collectgarbage("collect")
                end
                -- 骑马时一直busy，中断更换主动饰品的逻辑
                slot["busy"] = true
                slot["priority"] = 0
            end

        elseif AQSV["backup"..slot_id] > 0 and (AQSV.slotStatus[slot_id].locked or (#queue== 0 and AQSV.slotStatus[slot_id].backup == 0)) then
            -- print( AQSV["backup"..slot_id], SELFAQ["ride"..slot_id])
            -- 禁用14的时候，主动饰品是空的时候，需要追加换下萝卜的逻辑
            -- 避免不停更换萝卜
            if AQSV["backup"..slot_id] == SELFAQ["ride"..slot_id] then
                AQSV["backup"..slot_id] = 0
            end

            if AQSV["backup"..slot_id] == slot["id"] then
                AQSV["backup"..slot_id] = 0
            end
            
            if AQSV["backup"..slot_id] > 0 then
                AddonEquipItemByName(AQSV["backup"..slot_id], slot_id)
            end
        end
    end

    -- 自动换水藤
    if tContains({1,6,16}, slot_id) and SELFAQ["swim"..slot_id] >0 and (not AQSV.slotStatus[slot_id].locked or AQSV.forceAcc) and AQSV.enableSwim  then

        -- 不用处理下马逻辑，因为更换主动饰品逻辑直接起效
        if 
            IsSwimming() 
            and not (AQSV.pauseAccWhenTarget and SELFAQ.targetEnemy)
            and not (AQSV.pauseAccWhenTargetFriend and SELFAQ.targetFriend)
            and not (AQSV.pauseAccWhenTargetMember and SELFAQ.targetEnemyMember)
        then

            if (not SELFAQ.inInstance()) -- 不在副本里
            or AQSV.enableAccInstance -- 副本生效
            or (AQSV.enableAccTAQ and SELFAQ.inTAQ()) -- TAQ生效功能
            then

                if slot["id"] ~= SELFAQ["swim"..slot_id] and SELFAQ["swim"..slot_id] > 0 then

                    AQSV["backup"..slot_id] = slot["id"]

                    if slot_id == 16 then

                        local slot17 = GetInventoryItemID("player", 17)

                        -- 修正slot为空时出现的问题
                        if slot17 == nil then
                            slot17 = 0
                        end

                        AQSV["backup17"] = slot17

                    end

                    -- 存在两个相同物品的可能
                    SELFAQ.equipByID(SELFAQ["swim"..slot_id], slot_id)
      
                end
                -- 骑马时一直busy，中断更换主动饰品的逻辑
                slot["busy"] = true
                slot["priority"] = 0
            end

        elseif AQSV["backup"..slot_id] > 0 and (AQSV.forceAcc or (#queue== 0 and AQSV.slotStatus[slot_id].backup == 0)) then

                     
            if AQSV["backup"..slot_id] > 0 then
                AddonEquipItemByName(AQSV["backup"..slot_id], slot_id)

                if slot_id == 16 and AQSV["backup17"] > 0 then
                     AddonEquipItemByName(AQSV["backup17"], 17)
                end
            end

            if AQSV["backup"..slot_id] == SELFAQ["swim"..slot_id] then

                if slot_id == 16 then
                     AQSV["backup17"] = 0
                end

                AQSV["backup"..slot_id] = 0
            end

            if AQSV["backup"..slot_id] == slot["id"] then
                AQSV["backup"..slot_id] = 0

                if slot_id == 16 then
                     AQSV["backup17"] = 0
                end
            end
            
        end
    end

    return slot
end

function SELFAQ.buildQueueRealtime(slot_id)

    wipe(SELFAQ.empty1)

    if not AQSV.enable then
        return SELFAQ.empty1
    end

    local queue = SELFAQ.empty1
    local inBattleground = UnitInBattleground("player")

    if not AQSV.usableItems[slot_id] then
        return queue
    end

    for k,v in pairs(AQSV.usableItems[slot_id]) do
        if inBattleground or AQSV.pvpMode then
            SELFAQ.pvpIcon:Show()
            if AQSV.pvpTrinkets[v] then
                table.insert(queue, v)
            end
        elseif AQSV.enableRaidQueue and SELFAQ.inInstance() then
            if AQSV.raidTrinkets[v] then
                table.insert(queue, v)
            end
        else
            SELFAQ.pvpIcon:Hide()
            if AQSV.pveTrinkets[v] then
                table.insert(queue, v)
            end
        end
    end

    return queue
end

function SELFAQ.changeTrinket()
    -- 主要代码部分 --
    
    local queue = SELFAQ.buildQueueRealtime(13)

    -- 获取当前饰品的状态
    local slot13 = SELFAQ.getTrinketStatusBySlotId(13, queue)
    local slot14 = SELFAQ.getTrinketStatusBySlotId(14, queue)

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
                    AddonEquipItemByName(v, 13)
                    slot13["busy"] = true
                    slot13["priority"] = k
                    -- SELFAQ.cancelLocker( 13 )
                elseif k <  slot14["priority"] and not AQSV.slotStatus[14].locked and not AQSV.disableSlot14 and AQSV.queue14[v] then
                    AddonEquipItemByName(v, 14)
                    slot14["busy"] = true
                    slot14["priority"] = k
                    -- SELFAQ.cancelLocker( 14 )
                end
            end
        end

    end

    -- 13、14都装备主动饰品，退出函数
    if slot13["busy"] and slot14["busy"] then
        return
    end

    -- 遍历饰品队列
    if not AQSV.forcePriority then
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
                        AddonEquipItemByName(v, 13)
                        slot13["busy"] = true
                        
                    elseif not slot14["busy"] and AQSV.queue14[v] then
                        AddonEquipItemByName(v, 14)
                        slot14["busy"] = true
                        
                    end
                end
            end

            -- 13、14都装备主动饰品，退出函数
            if slot13["busy"] and slot14["busy"] then
                return
            end
        end
    end

    -- 处理银色黎明饰品
    -- if SELFAQ.targetUndead then

    --     if slot13["id"] ~= 13209 or slot14["id"] ~= 13209 then

    --         if not slot13["busy"] and 13209 ~= slot13["id"] then
    --             AddonEquipItemByName(13209, 13)
    --             slot13["busy"] = true
    --         end

    --         if not slot14["busy"] and 13209 ~= slot14["id"] then
    --             AddonEquipItemByName(13209, 14)
    --             slot14["busy"] = true
    --         end

    --     end

    -- end

    -- 遍历发现没有可用的主动饰品，则更换被动饰品

    if AQSV.enableFixedPosition then
        -- 备选饰品固定位置
        if not slot13["busy"] and AQSV.slotStatus[13].backup ~= slot13["id"] and AQSV.slotStatus[13].backup >0 then
            AddonEquipItemByName(AQSV.slotStatus[13].backup, 13)
        end

        if (AQSV.enableTargetUndead and SELFAQ.targetUndead 
            or (AQSV.enableInUndeadInstance and SELFAQ.inNaxxStsmTL() and not SELFAQ.targetNotUndead) ) 
            and SELFAQ.undeadTrinket > 0 then
            if not slot14["busy"] and SELFAQ.undeadTrinket ~= slot14["id"] then
                AddonEquipItemByName(SELFAQ.undeadTrinket, 14)
            end
        else
            if not slot14["busy"] and AQSV.slotStatus[14].backup ~= slot14["id"] and AQSV.slotStatus[14].backup >0 then
                AddonEquipItemByName(AQSV.slotStatus[14].backup, 14)
            end
        end

    else
        -- 备选饰品优先级模式
        local b1 = AQSV.slotStatus[13].backup
        local b2 = AQSV.slotStatus[14].backup

        -- 银色黎明自动换
        if (AQSV.enableTargetUndead and SELFAQ.targetUndead 
            or (AQSV.enableInUndeadInstance and SELFAQ.inNaxxStsmTL() and not SELFAQ.targetNotUndead) ) 
            and SELFAQ.undeadTrinket > 0 then

            b2 = b1
            b1 = SELFAQ.undeadTrinket
        end

        if b1 >0 and b1 ~= slot13["id"] and b1 ~= slot14["id"] then
             if not slot13["busy"] then
                AddonEquipItemByName(b1, 13)
                slot13["busy"] = true
             elseif not slot14["busy"] then
                AddonEquipItemByName(b1, 14)
                slot14["busy"] = true
             end
        end
        
        if b2 >0 and b2 ~= slot13["id"] and b2 ~= slot14["id"] then
             if not slot13["busy"] and b1 ~= slot13["id"] then
                AddonEquipItemByName(b2, 13)
                slot13["busy"] = true
             elseif not slot14["busy"] and b1 ~= slot14["id"] then
                AddonEquipItemByName(b2, 14)
                slot14["busy"] = true
             end
        end

    end

end

function SELFAQ.changeItem(slot_id)
    -- 主要代码部分 --
    -- debug(slot_id)
    local queue = SELFAQ.buildQueueRealtime(slot_id)

    -- 获取当前饰品的状态
    local slot13 = SELFAQ.getTrinketStatusBySlotId(slot_id, queue)

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
                    AddonEquipItemByName(v, slot_id)
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
                    AddonEquipItemByName(v, slot_id)
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
        AddonEquipItemByName(AQSV.slotStatus[slot_id].backup, slot_id)
    end

end

function SELFAQ.enablePvpMode()
    AQSV.pvpMode = not AQSV.pvpMode

    SELFAQ.menuList[2]["checked"] = AQSV.pvpMode

    local on = ""
    if AQSV.pvpMode then
        on =L["|cFF00FF00Enabled|r"]
    else
        on =L["|cFFFF0000Disabled|r"]
    end

    if AQSV.pvpMode then
        SELFAQ.pvpIcon:Show()
    else
        SELFAQ.pvpIcon:Hide()
    end
    chatInfo(L["PVP queue "]..on)
    popupInfo(L["PVP queue "]..on)
end

function SELFAQ.enableAutoEuquip()
    AQSV.enable = not AQSV.enable

    SELFAQ.f.checkbox["enable"]:SetChecked(AQSV.enable)
    SELFAQ.menuList[1]["checked"] = AQSV.enable

    SELFAQ.updateButtonSwitch()

    if AQSV.enable then
        chatInfo(L["AutoEquip function |cFF00FF00Enabled|r"])
        popupInfo(L["AutoEquip function |cFF00FF00Enabled|r"])
    else
        chatInfo(L["AutoEquip function |cFFFF0000Disabled|r"])
        popupInfo(L["AutoEquip function |cFFFF0000Disabled|r"])
    end
end

function SELFAQ.setCDLock( item_id, slot_id )

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

function SELFAQ.setWait(item_id, slot_id)

    local rid = SELFAQ.reverseId(item_id)

    local texture = GetItemTexture(rid)

    -- 所有slot都可能出现队列，没显示装备栏的这里会报错
    if SELFAQ.slotFrames[slot_id] then
        SELFAQ.slotFrames[slot_id].wait:SetTexture(texture)
        SELFAQ.slotFrames[slot_id].waitFrame:Show()
    end

    AQSV["slot"..slot_id.."Wait"] = {
        item_id,
        slot_id
    }
end

function SELFAQ.cancelLocker( slot_id )
    AQSV.slotStatus[slot_id].locked = false

    if  SELFAQ.slotFrames[slot_id] then
        SELFAQ.slotFrames[slot_id].locker:Hide()
    end

    -- 解开CD锁
    AQSV.slotStatus[slot_id].lockedCD = false
    AQSV.slotStatus[slot_id].lockedTime = 0
end

function SELFAQ.equipWait(item_id, slot_id, popup)

    if popup == nil then
        popup = true
    end

    local rid = SELFAQ.reverseId(item_id)

    SELFAQ.equipByID(item_id, slot_id, popup)

    SELFAQ.setLocker(slot_id)

    AQSV["slot"..slot_id.."Wait"] = nil

    if SELFAQ.slotFrames[slot_id] then
        SELFAQ.slotFrames[slot_id].wait:SetTexture()
        SELFAQ.slotFrames[slot_id].waitFrame:Hide()
    end

    -- AQSV.slotStatus[slot_id].locked = true
    -- AQSV["slot"..slot_id.."Wait"] = nil

    -- if SELFAQ.slotFrames[slot_id] then
    --     SELFAQ.slotFrames[slot_id].wait:SetTexture()
    --     SELFAQ.slotFrames[slot_id].waitFrame:Hide()
    --     SELFAQ.slotFrames[slot_id].locker:Show()
    -- end

    SELFAQ.setCDLock( rid, slot_id )
end

function SELFAQ.setLocker(slot_id)

    if tContains(SELFAQ.needSlots, slot_id) or (slot_id==14 and tContains(SELFAQ.needSlots, 13)) then

        AQSV.slotStatus[slot_id].locked = true

        if SELFAQ.slotFrames[slot_id] then
            SELFAQ.slotFrames[slot_id].locker:Show()
        end

    end
end

function SELFAQ.checkAllWait()
    for k,v in pairs(SELFAQ.slots) do
        if AQSV["slot"..v.."Wait"] then
            SELFAQ.equipWait(AQSV["slot"..v.."Wait"][1], AQSV["slot"..v.."Wait"][2])
        end
    end
end

function SELFAQ.inInstance()
    local inInstance, instanceType = IsInInstance()

    return inInstance
end

function SELFAQ.playerCanEquip()
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

function SELFAQ.slotsCanEquip()
    local slots = {16,17,18}

    if SELFAQ.playerCanEquip() then
        slots = {1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18}
    end

    return slots
end

local onyxiaAlert = false

SELFAQ.equipOnyxiaCloak = function()

    if not AQSV.enableOnyxiaCloak then
        return
    end
    
    if SELFAQ.isNefNest() then
        
        if GetInventoryItemID("player", 15) == 15138 then
            return
        end

        if GetItemCount(15138) > 0 then
            AQSV.cloakBackup = GetInventoryItemID("player", 15)
            SELFAQ.equipWait(15138, 15)

            if not onyxiaAlert then

                onyxiaAlert = true

                chatInfo(L["Equip "]..GetItemLink(15138))

                -- 避免在团队频道重复多次
                if AQSV.enableOnyxiaCloakAlert  then   
                    SendChatMessage(L["<AutoEquip> Equiped "]..SELFAQ.GetItemLink(15138), "RAID")
                end

                C_Timer.After(5.0, function()
                    onyxiaAlert = false
                end)

            end

            
        end

    elseif GetInventoryItemID("player", 15) == 15138 and AQSV.cloakBackup > 0 then
        AddonEquipItemByName(AQSV.cloakBackup, 15)
        chatInfo(L["Equip "]..GetItemLink(AQSV.cloakBackup))
        SELFAQ.cancelLocker( 15 )
        AQSV.cloakBackup = 0
    end

end


-- 团队目标规则

function SELFAQ.runTargetMemberRules()

        -- 必须在副本中
        if not SELFAQ.inInstance() then
            return
        end

        -- 玩家在团队里
        if not UnitInRaid("player") then
            return
        end

        if not SELFAQ.haveTargetMember      -- 超级换装
            and not AQSV.pauseAccWhenTargetMember         -- 自动骑乘
            and not (AQSV.enableSuit and AQSV.enableMembersTarget)       -- boss套装
        then

            return
        end

        -- wipe(SELFAQ.memberTargets)

        local level63 = 0
        local level64 = 0
        local enemy = 0
        local boss = ""

        SELFAQ.targetEnemyMember = false

        -- print(SELFAQ.needSuit)
        
        if UnitInRaid("player") then

            for i=1,MAX_RAID_MEMBERS  do
                
                local name = GetRaidRosterInfo(i)
                local target = "raid"..i.."target"

                local bName = GetUnitName(target)

                local level = UnitLevel(target)

                -- 如果有成员
                -- boss和63判断
                if name and (level == -1 or level == 63) and not UnitIsDead(target)  then

                    -- 目标是boss
                    if level == -1 then

                        -- 记录boss名字
                        -- if SELFAQ.memberTargets[boss] == nil then
                        --     SELFAQ.memberTargets[boss] = 1
                        -- else
                        --     SELFAQ.memberTargets[boss] = SELFAQ.memberTargets[boss] + 1
                        -- end
                        boss = bName

                        -- 统计boss目标人数
                        level64 = level64 + 1
                    end

                    
                    -- 目标是63
                    if level == 63 then
                        level63 = level63 + 1
                    end

                end


                -- 敌人判断
                if name and bName and not UnitIsDead(target) and not UnitIsFriend("player", target) then
                    enemy = enemy + 1
                end

            end

        end

        -- 超级换装检查boss名字
        -- for k,v in pairs(SELFAQ.memberTargets) do
        if SELFAQ.haveTargetMember and boss ~= "" then
            
            -- 团员目标大于1
            if level64 > AQSV.raidTargetThreshold then

                -- 检查换装规则
                local pass = false
                for k1,v1 in pairs(SUITAQ) do
                    
                    if not pass and v1["enable"] and v1["enableTarget"] and v1["enableTargetMember"] then
                            
                            if strfind(v1["bossText"], boss) then

                                -- debug(k)
                                -- debug(v)
                                -- debug(k1)
                                
                                SELFAQ.superEquipSuit(k1)

                                pass = true

                                -- return k1
                            end

                    end

                end

            end

        end

        -- 自动骑乘检查
        if AQSV.pauseAccWhenTargetMember and enemy > AQSV.raidTargetThreshold then
            SELFAQ.targetEnemyMember = true
        end

        -- boss套装检查
        if (AQSV.enableSuit and AQSV.enableMembersTarget) then
            if level63 > AQSV.raidTargetThreshold and level63 > level64 then
                SELFAQ.needSuit = 63
            end

            if level64 > AQSV.raidTargetThreshold and level64 > level63 then
                -- 不在排除列表里
                if not string.find(AQSV.ignoreBoss, boss) then
                    SELFAQ.needSuit = 64
                end
            end
        end

    end