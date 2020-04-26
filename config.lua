
-- 配置 --

version = "v1.0"

enableDebug = true          -- 调试开关

-- 获取当前角色名字
player = UnitName("player")

-- 棍子上的胡萝卜
carrot = 11122

-- 缓存胡萝卜换下的饰品
carrotBackup = 0

-- 常见的主动饰品id和buff持续时间数据
buffTime = {}	
buffTime[19339] = 20                    -- 思维加速宝石
buffTime[19950] = 20                    -- 赞达拉饰品
buffTime[18820] = 15                    -- 短暂能量护符
buffTime[19341] = 15                    -- 生命宝石
buffTime[11819] = 10                    -- 复苏之风
buffTime[20130] = 60                    -- 钻石水瓶

-- 角色身上和背包中所有饰品
trinkets = {}

-- 构建下拉框组时，记录纵坐标
lastHeight = 0

-- 插件在每帧处理时，以获取到GetItemInfo作为初始化标志
init = false

-- 主动饰品集合
usable = {}

for k,v in pairs(buffTime) do
	table.insert(usable, k)
end

-- 联盟、部落各个职业的徽记
pvpSet = {
	18854,18856,18857,18858,18859,18862,18863,18864,
	18834,18845,18846,18849,18850,18851,18852,18853
}

-- 徽记的buff时间都是0
for k,v in pairs(pvpSet) do
	buffTime[v] = 0
end

-- 记录当前角色的徽记
pvp = 0

-- 配置结束 --