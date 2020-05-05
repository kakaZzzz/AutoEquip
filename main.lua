local _, AQSELF = ...

local debug = AQSELF.debug
local clone = AQSELF.clone
local diff = AQSELF.diff
local L = AQSELF.L
local initSV = AQSELF.initSV

-- 主函数 --

-- 注册事件
AQSELF.main = CreateFrame("Frame")

-- 计数器
AQSELF.main.TimeSinceLastUpdate = 0
-- 函数执行间隔时间
AQSELF.main.Interval = 1

AQSELF.onMainUpdate = function(self, elapsed)

    self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;  

    -- 每秒执行执行一次
    if (self.TimeSinceLastUpdate > self.Interval) then

        -- 重新计时
        self.TimeSinceLastUpdate = 0;

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
            AQSV.usable = initSV(AQSV.usable, AQSELF.usable)
            AQSV.usableChests = initSV(AQSV.usableChests, AQSELF.usableChests)
            AQSV.enable = initSV(AQSV.enable, true)
            AQSV.enableBattleground = initSV(AQSV.enableBattleground, true)
            AQSV.disableSlot14 = initSV(AQSV.disableSlot14, false)
            AQSV.enableCarrot = initSV(AQSV.enableCarrot, true)
            AQSV.slot13 = initSV(AQSV.slot13, 0)
            AQSV.slot14 = initSV(AQSV.slot14, 0)
            AQSV.x = initSV(AQSV.x, 200)
            AQSV.y = initSV(AQSV.y, 0)
            AQSV.point = initSV(AQSV.point, "CENTER")
            AQSV.locked = initSV(AQSV.locked, false)
            AQSV.enableItemBar = initSV(AQSV.enableItemBar, true)
            AQSV.pveTrinkets = initSV(AQSV.pveTrinkets, {})
            AQSV.pvpTrinkets = initSV(AQSV.pvpTrinkets, {})
            AQSV.pvpMode = initSV(AQSV.pvpMode, false)
            AQSV.slot13Locked = initSV(AQSV.slot13Locked, false)
            AQSV.slot14Locked = initSV(AQSV.slot14Locked, false)
            AQSV.xBuff = initSV(AQSV.xBuff, 200)
            AQSV.yBuff = initSV(AQSV.yBuff, 50)
            AQSV.pointBuff = initSV(AQSV.pointBuff, "CENTER")

            AQSV.enableBuff = initSV(AQSV.enableBuff, true)
            AQSV.buffLocked = initSV(AQSV.buffLocked, false)

            AQSV.forcePriority = initSV(AQSV.forcePriority, false)

            AQSV.buffNames = initSV(AQSV.buffNames, "能量无常,思维敏捷")

            AQSELF.addonInit()
            AQSELF.createItemBar()
            AQSELF.createBuffIcon()
            print(L["AutoEquip: Loaded"])
            AQSELF.init = true
        end

        -- 插件整体开关，以角色为单位
        if not AQSV.enable then
            return
        end

        -- 记录装备栏位置
        if AQSELF.bar then
            local point, relativeTo, relativePoint, xOfs, yOfs = AQSELF.bar:GetPoint()
            AQSV.x = xOfs
            AQSV.y = yOfs
            AQSV.point = point
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

        -- 自动更换饰品
        AQSELF.changeTrinket()
        
    end
end


AQSELF.main:SetScript("OnUpdate", AQSELF.onMainUpdate)