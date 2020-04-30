local _, KAKA_AQSELF_FIX = ...

local debug = KAKA_AQSELF_FIX.debug
local clone = KAKA_AQSELF_FIX.clone
local diff = KAKA_AQSELF_FIX.diff
local initSV = KAKA_AQSELF_FIX.initSV

-- 主函数 --

AQSV = initSV(AQSV, {})
AQSV.usable = initSV(AQSV.usable, KAKA_AQSELF_FIX.usable)
AQSV.usableChests = initSV(AQSV.usableChests, KAKA_AQSELF_FIX.usableChests)
AQSV.enable = initSV(AQSV.enable, true)
AQSV.enableBattleground = initSV(AQSV.enableBattleground, true)
AQSV.disableSlot14 = initSV(AQSV.disableSlot14, false)
AQSV.enableCarrot = initSV(AQSV.enableCarrot, true)
AQSV.slot13 = initSV(AQSV.slot13, 0)
AQSV.slot14 = initSV(AQSV.slot14, 0)
AQSV.x = initSV(AQSV.x, 200)
AQSV.y = initSV(AQSV.y, 0)
AQSV.locked = initSV(AQSV.locked, false)
AQSV.enableItemBar = initSV(AQSV.enableItemBar, true)

-- 注册事件
AF=CreateFrame("Frame")

-- 计数器
AF.TimeSinceLastUpdate = 0
-- 函数执行间隔时间
AF.Interval = 1

AF:SetScript("OnUpdate",function(self, elapsed)

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
        if not init then
            KAKA_AQSELF_FIX.addonInit()
            KAKA_AQSELF_FIX.createItemBar()
            debug("init")
            init = true
        end

        -- 插件整体开关，以角色为单位
        if not AQSV.enable then
            return
        end

        -- 记录装备栏位置
        if KAKA_AQSELF_FIX.bar then
            local point, relativeTo, relativePoint, xOfs, yOfs = KAKA_AQSELF_FIX.bar:GetPoint()
            AQSV.x = xOfs
            AQSV.y = yOfs
        end
        

        -- 战场开关
        if UnitInBattleground("player") and not AQSV.enableBattleground then
            return
        end

        -- 角色处在战斗状态或跑尸状态，不进行换饰品逻辑，退出函数
        local f=UnitAffectingCombat("player")
        local d=UnitIsDeadOrGhost("player")

        if f or d then
            return 
        end

        -- 自动更换饰品
        KAKA_AQSELF_FIX.changeTrinket()
        
    end
end)