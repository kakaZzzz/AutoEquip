local _, KAKA_AQSELF_FIX = ...

local debug = KAKA_AQSELF_FIX.debug
local clone = KAKA_AQSELF_FIX.clone
local diff = KAKA_AQSELF_FIX.diff
local L = KAKA_AQSELF_FIX.L
local player = KAKA_AQSELF_FIX.player
local initSV = KAKA_AQSELF_FIX.initSV

-- 初始化插件
function KAKA_AQSELF_FIX.addonInit()

        local reinstall = false
        -- local reinstall = true

        -- if AQSV == nil or reinstall then
        --     debug("init sv")
        --     debug(player)
        --     AQSV = {}
        --     AQSV.usable = clone(KAKA_AQSELF_FIX.usable)
        --     AQSV.usableChests = clone(KAKA_AQSELF_FIX.usableChests)
        --     AQSV.enable = true
        --     AQSV.enableBattleground = true
        --     AQSV.disableSlot14 = false
        --     AQSV.enableCarrot = true
        --     AQSV.slot13 = 0
        --     AQSV.slot14 = 0
        --     AQSV.x = 0
        --     AQSV.y = 0
        -- end

        for k,v in pairs(KAKA_AQSELF_FIX.pvpSet) do
            if GetItemCount(v) > 0 then
                KAKA_AQSELF_FIX.pvp = v
            end
        end

        KAKA_AQSELF_FIX.checkUsable()
        KAKA_AQSELF_FIX.checkTrinket()

        KAKA_AQSELF_FIX.settingInit()

        SLASH_CMD1 = "/aq";
        function SlashCmdList.CMD(msg)

            if msg == "" then
                AQSV.enable = not AQSV.enable

                KAKA_AQSELF_FIX.f.checkbox["enable"]:SetChecked(AQSV.enable)

                if AQSV.enable then
                    print(L["AutoEquip: Enabled"])
                else
                    print(L["AutoEquip: Disabled"])
                end
            end

            if msg == "settings" then
                 InterfaceOptionsFrame_OpenToCategory("AutoEquip");
                 InterfaceOptionsFrame_OpenToCategory("AutoEquip");
            end
        end

end

-- 检查主动饰品
KAKA_AQSELF_FIX.checkUsable = function()
    -- 删除没有或者放在银行里的主动饰品，并保持优先级不变
    local new = {}
    for i,v in ipairs(AQSV.usable) do
        if GetItemCount(v) > 0 then
            table.insert(new, v)
        end
    end
    AQSV.usable = new

    -- 获得新饰品，或者从银行取出，保持优先级不变，追加到最后
    for i,v in ipairs(KAKA_AQSELF_FIX.usable) do
        if GetItemCount(v) > 0 and not tContains(AQSV.usable, v) then
            table.insert(AQSV.usable, v)
        end
    end
end

-- 检查角色身上所有的饰品
KAKA_AQSELF_FIX.checkTrinket = function( )

    local slot13Id = GetInventoryItemID("player", 13)
    local slot14Id = GetInventoryItemID("player", 14)
    local slot5Id = GetInventoryItemID("player", 5)

    if slot13Id then
        table.insert(KAKA_AQSELF_FIX.trinkets, slot13Id)
    end

    if slot14Id then
        table.insert(KAKA_AQSELF_FIX.trinkets, slot13Id)
    end

    if slot5Id then
        table.insert(KAKA_AQSELF_FIX.chests, slot5Id)
    end

    for i=0,NUM_BAG_SLOTS do
        local count = GetContainerNumSlots(i)

        for s=1,count do
            if GetContainerItemInfo(i,s) then

                -- fix：背包槽位是空的时候，会中断循环
                local id = GetContainerItemID(i,s)

                -- if id ~= "" then
                     local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)

                     -- debug(itemEquipLoc)

                    if itemEquipLoc == "INVTYPE_TRINKET" then
                        table.insert(KAKA_AQSELF_FIX.trinkets, id)
                    end

                    if itemEquipLoc == "INVTYPE_CHEST" or itemEquipLoc == "INVTYPE_ROBE" then
                        table.insert(KAKA_AQSELF_FIX.chests, id)
                    end
                -- end
            end  
        end
    end

    -- 去掉主动饰品
    KAKA_AQSELF_FIX.trinkets = diff(KAKA_AQSELF_FIX.trinkets, AQSV.usable)
    -- KAKA_AQSELF_FIX.chests = diff(KAKA_AQSELF_FIX.chests, AQSV.usableChests)

    -- 降幂排序，序号大的正常来看是等级高的饰品
    table.sort(KAKA_AQSELF_FIX.trinkets, function(a, b)
        -- 报错：table必须是从1到n连续的，即中间不能有nil，否则会报错
        return a > b
    end)

end


-- 获取当前装备饰品的状态
KAKA_AQSELF_FIX.getTrinketStatusBySlotId = function( slot_id, queue )
    local slot = {}

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

    if tContains(queue, slot["id"]) 
        then slot["busy"] = true 
    end

    -- 饰品已经使用，并且超过了buff时间
    if slot["duration"] > 30 and slot["buff"] > KAKA_AQSELF_FIX.buffTime[slot["id"]] + 1 then
        slot["busy"] = false
    end

    -- 使用busy属性，控制饰品槽是否参与更换逻辑
    -- 禁用14的话，总是返回busy
    if slot_id == 14 and AQSV.disableSlot14 then
        slot["busy"] = true
    end

    -- 自动换萝卜
    if slot_id == 14 and AQSV.enableCarrot and not UnitInBattleground("player") then
        -- 不用处理下马逻辑，因为更换主动饰品逻辑直接起效
        if(IsMounted() and not UnitOnTaxi("player"))  then
            if slot["id"] ~= KAKA_AQSELF_FIX.carrot then
                KAKA_AQSELF_FIX.carrotBackup = slot["id"]
                EquipItemByName(KAKA_AQSELF_FIX.carrot, 14)
            end
            -- 骑马时一直busy，中断更换主动饰品的逻辑
            slot["busy"] = true

        elseif (AQSV.disableSlot14 or #queue== 0) and slot["id"] == KAKA_AQSELF_FIX.carrot then
            -- 禁用14的时候，主动饰品是空的时候，需要追加换下萝卜的逻辑
            -- 避免不停更换萝卜
            if KAKA_AQSELF_FIX.carrotBackup == KAKA_AQSELF_FIX.carrot then
                KAKA_AQSELF_FIX.carrotBackup = 0
            end
            
            if KAKA_AQSELF_FIX.carrotBackup > 0 then
                EquipItemByName(KAKA_AQSELF_FIX.carrotBackup, 14)
            end
        end
    end

    return slot
end

function KAKA_AQSELF_FIX.changeTrinket()
    -- 主要代码部分 --
    local queue = clone(AQSV.usable)

    -- 如果在战场里，执行联盟徽记逻辑
    if UnitInBattleground("player") then
        table.insert(queue, 1, KAKA_AQSELF_FIX.pvp)
    end

    -- 获取当前饰品的状态
    local slot13 = KAKA_AQSELF_FIX.getTrinketStatusBySlotId(13, queue)
    local slot14 = KAKA_AQSELF_FIX.getTrinketStatusBySlotId(14, queue)

    -- 如果没有主动饰品，则停止更换饰品
    if #queue == 0 then
        return
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
                if not slot13["busy"] then
                    EquipItemByName(v, 13)
                    slot13["busy"] = true
                elseif not slot14["busy"] then
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
    if not slot13["busy"] and AQSV.slot13 ~= slot13["id"] and AQSV.slot13 >0 then
        EquipItemByName(AQSV.slot13, 13)
    end

    if not slot14["busy"] and AQSV.slot14 ~= slot14["id"] and AQSV.slot14 >0 then
        EquipItemByName(AQSV.slot14, 14)
    end
end