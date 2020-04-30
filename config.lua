local _, KAKA_AQSELF_FIX = ...

local merge = KAKA_AQSELF_FIX.merge

-- 配置 --

KAKA_AQSELF_FIX.version = "v1.1"

-- KAKA_AQSELF_FIX.enableDebug = true          -- 调试开关
KAKA_AQSELF_FIX.enableDebug = false          -- 调试开关

-- 获取当前角色名字
KAKA_AQSELF_FIX.player = UnitName("player")

-- 构建下拉框组时，记录纵坐标
KAKA_AQSELF_FIX.lastHeight = 0

-- 棍子上的胡萝卜
KAKA_AQSELF_FIX.carrot = 11122

-- 缓存胡萝卜换下的饰品
KAKA_AQSELF_FIX.carrotBackup = 0

-- 操作的装备栏
KAKA_AQSELF_FIX.slots = {13, 14}
KAKA_AQSELF_FIX.slotFrames = {}

-- 常见的主动饰品id和buff持续时间数据
local buffTime = {}	
buffTime[19339] = 20                    -- 思维加速宝石
buffTime[19950] = 20                    -- 赞达拉饰品
buffTime[18820] = 15                    -- 短暂能量护符
buffTime[19341] = 15                    -- 生命宝石
buffTime[11819] = 10                    -- 复苏之风
buffTime[20130] = 60                    -- 钻石水瓶
buffTime[19991] = 20                    -- 魔暴龙眼
-- buffTime[14023] = 0                    -- 管家铃（测试用）

-- 主动饰品集合
KAKA_AQSELF_FIX.usable = {}

for k,v in pairs(buffTime) do
	table.insert(KAKA_AQSELF_FIX.usable, k)
end

KAKA_AQSELF_FIX.buffTime = buffTime

-- 能主动使用的衣服

local chestBuffTime = {}
chestBuffTime[14152] = 0				-- 大法师之袍

-- 可使用的胸甲集合
KAKA_AQSELF_FIX.usableChests = {}

for k,v in pairs(chestBuffTime) do
	table.insert(KAKA_AQSELF_FIX.usableChests, k)
end

KAKA_AQSELF_FIX.buffTime = merge(KAKA_AQSELF_FIX.buffTime, chestBuffTime)

-- 角色身上和背包中所有饰品
KAKA_AQSELF_FIX.trinkets = {}
KAKA_AQSELF_FIX.chests = {}

-- 联盟、部落各个职业的徽记
KAKA_AQSELF_FIX.pvpSet = {
	18854,18856,18857,18858,18859,18862,18863,18864,
	18834,18845,18846,18849,18850,18851,18852,18853
}

-- 徽记的buff时间都是0
for k,v in pairs(KAKA_AQSELF_FIX.pvpSet) do
	KAKA_AQSELF_FIX.buffTime[v] = 0
end

KAKA_AQSELF_FIX.debug(KAKA_AQSELF_FIX.buffTime)

-- 记录当前角色的徽记
KAKA_AQSELF_FIX.pvp = 0

-- 配置结束 --