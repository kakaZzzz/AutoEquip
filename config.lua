local _, AQSELF = ...

local merge = AQSELF.merge

-- 配置 --

AQSELF.version = "v1.1"

AQSELF.enableDebug = false          -- 调试开关

-- 获取当前角色名字
AQSELF.player = UnitName("player")

-- 棍子上的胡萝卜
AQSELF.carrot = 11122

-- 缓存胡萝卜换下的饰品
AQSELF.carrotBackup = 0

-- 常见的主动饰品id和buff持续时间数据
local buffTime = {}	
buffTime[19339] = 20                    -- 思维加速宝石
buffTime[19950] = 20                    -- 赞达拉饰品
buffTime[18820] = 15                    -- 短暂能量护符
buffTime[19341] = 15                    -- 生命宝石
buffTime[11819] = 10                    -- 复苏之风
buffTime[20130] = 60                    -- 钻石水瓶

-- 主动饰品集合
AQSELF.usable = {}

for k,v in pairs(buffTime) do
	table.insert(AQSELF.usable, k)
end

AQSELF.buffTime = buffTime

-- 能主动使用的衣服

local bodyBuffTime = {}
bodyBuffTime[14152] = 0				-- 大法师之袍

-- 主动饰品集合
AQSELF.usableBody = {}

for k,v in pairs(bodyBuffTime) do
	table.insert(AQSELF.usableBody, k)
end

AQSELF.bodyBuffTime = bodyBuffTime

-- 角色身上和背包中所有饰品
AQSELF.trinkets = {}

-- 构建下拉框组时，记录纵坐标
AQSELF.lastHeight = 0



-- 联盟、部落各个职业的徽记
AQSELF.pvpSet = {
	18854,18856,18857,18858,18859,18862,18863,18864,
	18834,18845,18846,18849,18850,18851,18852,18853
}

-- 徽记的buff时间都是0
for k,v in pairs(AQSELF.pvpSet) do
	buffTime[v] = 0
end

-- 记录当前角色的徽记
AQSELF.pvp = 0

-- 配置结束 --