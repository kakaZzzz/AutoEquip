local _, AQSELF = ...

local debug = AQSELF.debug
local clone = AQSELF.clone
local diff = AQSELF.diff
local L = AQSELF.L
local initSV = AQSELF.initSV
local loopSlots = AQSELF.loopSlots
local addonInfo = AQSELF.addonInfo



-- 主函数 --

for k,v in pairs(AQSELF.gearSlots) do
    _G["BINDING_NAME_AUTOEQUIP_BUTTON"..v] = AQSELF.slotToName[v]
end

-- _G.BINDING_NAME_AUTOEQUIP_BUTTON14 = L['Trinket Slot ']..2
_G.BINDING_HEADER_AUTOEQUIP_INVENTORYBAR_BUTTON = L["Equipment Bar Button"]

-- 注册事件
AQSELF.main = CreateFrame("Frame")

-- 计数器
AQSELF.main.TimeSinceLastUpdate = 0
-- 函数执行间隔时间
AQSELF.main.Interval = 1
AQSELF.main.garbageCount = 0

AQSELF.onMainUpdate = function(self, elapsed)

    self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;  

    -- 每秒执行执行一次
    if (self.TimeSinceLastUpdate > self.Interval) then

        -- 重新计时
        self.TimeSinceLastUpdate = 0;

        self.garbageCount = self.garbageCount + 1

        if self.garbageCount > 5 then
            -- collectgarbage("collect")
            self.garbageCount = 0
        end

        -- 以能读取到物品信息为基准，开始执行
        -- 尝试过在ADDON_LOADED等事件中初始化，发现无法读取物品信息，所以改为现在这个逻辑
        if GetItemInfo(12930) == nil then
            debug("not ready")
            return
        end

        -- 插件初始化，包括构建选项菜单
        if not AQSELF.init then

            -- 初始化全局变量
            AQSV = initSV(AQSV, {})
            AQSV.usableItems = initSV(AQSV.usableItems, AQSELF.usable)
            AQSV.usableChests = initSV(AQSV.usableChests, AQSELF.usableChests)
            AQSV.enable = initSV(AQSV.enable, true)
            AQSV.enableBattleground = initSV(AQSV.enableBattleground, true)
            AQSV.disableSlot14 = initSV(AQSV.disableSlot14, false)
            AQSV.enableCarrot = initSV(AQSV.enableCarrot, true)
            AQSV.slot13 = initSV(AQSV.slot13, 0)
            AQSV.slot14 = initSV(AQSV.slot14, 0)
            AQSV.queue13 = initSV(AQSV.queue13, {})
            AQSV.queue14 = initSV(AQSV.queue14, {})

            AQSV.x = initSV(AQSV.x, 200)
            AQSV.y = initSV(AQSV.y, 0)
            AQSV.point = initSV(AQSV.point, "CENTER")
            AQSV.locked = initSV(AQSV.locked, false)
            AQSV.enableItemBar = initSV(AQSV.enableItemBar, true)
            AQSV.enableItemBarSlot = initSV(AQSV.enableItemBarSlot, {})

            AQSV.pveTrinkets = initSV(AQSV.pveTrinkets, {})
            AQSV.pvpTrinkets = initSV(AQSV.pvpTrinkets, {})
            AQSV.pvpMode = initSV(AQSV.pvpMode, false)
            AQSV.reverseCooldownUnit = initSV(AQSV.reverseCooldownUnit, false)

            AQSV.carrotBackup = initSV(AQSV.carrotBackup, 0)
            AQSV.backup8 = initSV(AQSV.backup8, 0)
            AQSV.backup10 = initSV(AQSV.backup10, 0)

            AQSV.slot13Locked = initSV(AQSV.slot13Locked, false)
            AQSV.slot14Locked = initSV(AQSV.slot14Locked, false)

            AQSV.slot13LockedCD = initSV(AQSV.slot13LockedCD, false)
            AQSV.slot14LockedCD = initSV(AQSV.slot14LockedCD, false)
            
            AQSV.slot13LockedTime = initSV(AQSV.slot13LockedTime, 0)
            AQSV.slot14LockedTime = initSV(AQSV.slot14LockedTime, 0)
            AQSV.slot13LockedTime = 0
            AQSV.slot14LockedTime = 0

            AQSV.xBuff = initSV(AQSV.xBuff, 200)
            AQSV.yBuff = initSV(AQSV.yBuff, 50)
            AQSV.pointBuff = initSV(AQSV.pointBuff, "CENTER")

            AQSV.enableBuff = initSV(AQSV.enableBuff, true)
            AQSV.buffLocked = initSV(AQSV.buffLocked, false)

            AQSV.forcePriority = initSV(AQSV.forcePriority, false)

            AQSV.buffNames = initSV(AQSV.buffNames, L["Unstable Power, Mind Quickening"])
            AQSV.additionItems = initSV(AQSV.additionItems, "14023/0")

            AQSV.barZoom = initSV(AQSV.barZoom, 1)
            AQSV.buffZoom = initSV(AQSV.buffZoom, 1)
            AQSV.hideBackdrop = initSV(AQSV.hideBackdrop, false)

            AQSV.suit = initSV(AQSV.suit, {})
            AQSV.suit[63] = initSV(AQSV.suit[63], {})
            AQSV.suit[64] = initSV(AQSV.suit[64], {})
            AQSV.suit[60] = initSV(AQSV.suit[60], {})
            AQSV.currentSuit = initSV(AQSV.currentSuit, 60)
            AQSV.enableSuit = initSV(AQSV.enableSuit, false)
            AQSV.enableAutoSuit60 = initSV(AQSV.enableAutoSuit60, false)
            AQSV.enableTargetSuit60 = initSV(AQSV.enableTargetSuit60, false)

            AQSV.itemsPerColumn = initSV(AQSV.itemsPerColumn, 4)
            AQSV.customSlots = initSV(AQSV.customSlots, {})
            AQSV.hideItemQueue = initSV(AQSV.hideItemQueue, false)
            AQSV.hideTooltip = initSV(AQSV.hideTooltip, false)
            AQSV.shiftLeftShowDropdown = initSV(AQSV.shiftLeftShowDropdown, false)

            if AQSV.slotStatus == nil then
                AQSV.slotStatus = {}
                for k,v in pairs(AQSELF.slotToName) do
                    AQSV.slotStatus[k] = {
                        ["backup"] = 0,
                        ["locked"] = false,
                        ["lockedCD"] = false,
                        ["lockedTime"] = 0,
                    }
                end
            end

            AQSELF.addonInit()
            AQSELF.createItemBar()
            AQSELF.createBuffIcon()
            AQSELF.mainInit( )

            print(L["prefix"]..L[" Loaded"])

            AQSELF.init = true

        end

        -- 记录装备栏位置
        if AQSELF.bar then
            local point, relativeTo, relativePoint, xOfs, yOfs = AQSELF.bar:GetPoint()
            AQSV.x = xOfs
            AQSV.y = yOfs
            AQSV.point = point
        end

        -- 记录buff提醒位置
        if AQSELF.buff then
            local point, relativeTo, relativePoint, xOfs, yOfs = AQSELF.buff:GetPoint()
            AQSV.xBuff = xOfs
            AQSV.yBuff = yOfs
            AQSV.pointBuff = point
        end

        -- collectgarbage("collect")
        -- UpdateAddOnMemoryUsage()
        -- print(string.format("%.2f mb", (GetAddOnMemoryUsage("AutoEquip") / 1024)))

        -- 插件整体开关，以角色为单位
        if not AQSV.enable then
            return
        end

        -- 战场开关
        if UnitInBattleground("player") and not AQSV.enableBattleground then
            return
        end

        -- 角色处在战斗状态或跑尸状态，不进行换饰品逻辑，退出函数
        if not AQSELF.playerCanEquip() then
            return 
        end

        AQSELF.checkAllWait()

        if AQSV.needSuit then
            if GetTime() - AQSELF.needSuitTimestamp > 1 then
                AQSELF.changeSuit(AQSV.needSuit)
                AQSV.needSuit = false
                AQSELF.needSuitTimestamp = 0
            end
        end

        -- 自动更换饰品

        loopSlots(function(slot_id)
            if slot_id == 13 then
                AQSELF.changeTrinket()
            else
                AQSELF.changeItem(slot_id)
            end
        end)
        
    end
end


function AQSELF.mainInit()

    SLASH_AQCMD1 = "/aq";
    function SlashCmdList.AQCMD(msg)

        debug(msg)

        if msg == "" then
            AQSELF.enableAutoEuquip()

        elseif msg == "settings" then
             InterfaceOptionsFrame_OpenToCategory(AQSELF.general);
             InterfaceOptionsFrame_OpenToCategory(AQSELF.general);

        elseif msg == "pvp" then
            AQSELF. enablePvpMode()

        elseif msg == "unlock" then
             for k,v in pairs(AQSV.slotStatus) do
                 AQSELF.cancelLocker(k)
             end
             addonInfo(L[" |cFF00FF00Unlocked|r equipment bar"])

        elseif msg == "60" or msg == "63" or msg == "64"   then
            -- EquipItemByName(19891, 17)
            if AQSELF.playerCanEquip()  then
                AQSV.needSuit = tonumber(msg)
                AQSELF.needSuitTimestamp = GetTime()
            else
                print(L["prefix"]..L[" |cFF00FF00In combat|r"])
            end

        elseif strfind(msg, "ipc") then

            -- items per column
            local n = tonumber(strmatch(msg, "%d+"))

            if n > 0 then
                AQSV.itemsPerColumn = n
            end

        elseif strfind(msg, "ceb") then

            local _, str = strsplit(" ", msg)

            if tonumber(str) == 0 then
                print(L["prefix"]..L[" Custom equipment bar was |cFFFF0000CANCELED|r."]..L[" Please reload UI manually (/reload)."])
                AQSV.customSlots = {}
                return
            end

            str = string.gsub(str,"，", ",")

            local t = {strsplit(",", strtrim(str))}

            local new = {}

            for k,v in pairs(t) do
                v = tonumber(v)
                if v and v >= 1 and v <= 18 and v~= 4 and not tContains(new, v) then
                    table.insert(new, v)
                end
            end

            if #new > 0 then
                print(L["prefix"]..L[" Custom equipment bar |cFF00FF00SUCCESS|r."]..L[" Please reload UI manually (/reload)."])
                AQSV.customSlots = new
            end

        elseif strfind(msg, "hiq") then

            if strfind(msg, "1") then
                AQSV.hideItemQueue = true
                print(L["prefix"]..L[" |cFFFF0000Hide|r item queue"])
            elseif strfind(msg, "0") then
                AQSV.hideItemQueue = false
                print(L["prefix"]..L[" |cFF00FF00Show|r item queue"])
            end

        end
    end

    AQSELF.main:RegisterEvent("UNIT_INVENTORY_CHANGED")
    AQSELF.main:RegisterEvent("UPDATE_BINDINGS")
    AQSELF.main:RegisterEvent("PLAYER_REGEN_ENABLED")
    AQSELF.main:RegisterEvent("PLAYER_TARGET_CHANGED") 
    AQSELF.main:RegisterEvent("BAG_UPDATE") 

    AQSELF.main:SetScript("OnEvent", function( self, event, arg1 )
        if event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" then
            for k,v in pairs(AQSELF.slots) do
                AQSELF.updateItemButton( v )
            end
        end

        if event == "UPDATE_BINDINGS" then
            AQSELF.bindingSlot()
        end

        if event == "PLAYER_REGEN_ENABLED" then
            if AQSV.enableSuit and AQSV.enableAutoSuit60 then
                AQSV.needSuit = 60
                AQSELF.needSuitTimestamp = GetTime()
            end
        end

        if event == "BAG_UPDATE" then
            AQSELF.updateAllItems( )
        end

        if event == "PLAYER_TARGET_CHANGED" then

            if not AQSV.enableSuit then
                return
            end

            local level = UnitLevel("target")
            local boss = 60

            if level == 63 then
            -- if level == 6 then
                boss = 63
            elseif level == -1 then
            -- elseif level == 7 then
                boss = 64
            end

            if boss == 60 and not AQSV.enableTargetSuit60 then
                return
            end

            -- print(boss,UnitAffectingCombat("player"))
            -- 目标为空或者是玩家的情况下，并且目标不是死亡状态，不做更换
            if level ~= 0 and UnitIsEnemy("player", "target") and not UnitIsDead("target") and AQSELF.playerCanEquip() then
                -- print(boss,UnitAffectingCombat("player"))
                -- AQSELF.changeSuit(boss)               
               AQSV.needSuit = boss
               AQSELF.needSuitTimestamp = GetTime()
            end
        end

    end)
end


AQSELF.main:SetScript("OnUpdate", AQSELF.onMainUpdate)