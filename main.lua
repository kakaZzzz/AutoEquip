local _, AQSELF = ...

local debug = AQSELF.debug
local clone = AQSELF.clone
local diff = AQSELF.diff

-- 主函数 --

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
            AQSELF.addonInit()
            AQSELF.createItemBar()
            debug("init")
            init = true
        end

        -- 装备栏的开关
        if not AQSV.enableItemBar or not AQSV.enable then
            AQSELF.bar:Hide()
        else
            AQSELF.bar:Show()
        end

        -- 插件整体开关，以角色为单位
        if not AQSV.enable then
            return
        end

        -- 记录装备栏位置
        local point, relativeTo, relativePoint, xOfs, yOfs = AQSELF.bar:GetPoint()
        AQSV.x = xOfs
        AQSV.y = yOfs

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
        AQSELF.changeTrinket()
        
    end
end)