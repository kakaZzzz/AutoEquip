local _, SELFAQ = ...

local merge = SELFAQ.merge
local initSV = SELFAQ.initSV


-- 棍子上的胡萝卜、骑乘手套、马刺鞋
SELFAQ.carrot = 0
SELFAQ.ride10 = 0
SELFAQ.ride8 = 0

SELFAQ.swim1 = 0
SELFAQ.swim6 = 0
SELFAQ.swim16 = 0

-- 缓存胡萝卜换下的饰品
-- SELFAQ.carrotBackup = 0

-- 常见的主动饰品id和buff持续时间数据
local buffTime = {}	
buffTime[19339] = 20                    -- 思维加速宝石
buffTime[19948] = 20                    -- 赞达拉饰品1
buffTime[19949] = 20                    -- 赞达拉饰品2
buffTime[19950] = 20                    -- 赞达拉饰品3
buffTime[18820] = 15                    -- 短暂能量护符
buffTime[19341] = 0                    	-- 生命宝石
buffTime[11819] = 10                    -- 复苏之风
buffTime[20130] = 60                    -- 钻石水瓶
buffTime[19991] = 20                    -- 魔暴龙眼

buffTime[23040] = 20                    -- 偏斜雕文
buffTime[23041] = 20                    -- 屠龙者的纹章
buffTime[23046] = 20                    -- 萨菲隆的精华
buffTime[23047] = 30                    -- 亡者之眼

buffTime[21579] = 30                    -- 克苏恩的触须
buffTime[23042] = 20                    -- 洛欧塞布之影
buffTime[22954] = 15                    -- 蜘蛛之吻
buffTime[23001] = 20                    -- 衰落之眼
buffTime[23027] = 0                   	-- 宽恕的热情
buffTime[23558] = 20                    -- 穴居虫之壳
buffTime[23570] = 20                    -- 沙虫之毒

buffTime[21625] = 30                    -- 甲虫胸针
buffTime[21647] = 20                    -- 沙漠掠夺者塑像
buffTime[19336] = 10                    -- 奥术能量宝石
buffTime[19337] = 0                   	-- 黑龙之书
buffTime[19340] = 20                    -- 变形符文
buffTime[19342] = 20                    -- 毒性图腾
buffTime[19343] = 20                    -- 盲目光芒卷轴
buffTime[19344] = 20                    -- 自然之盟水晶
buffTime[19345] = 20                    -- 庇护者

buffTime[21670] = 30                    -- 虫群卫士徽章
buffTime[21685] = 60                    -- 石化甲虫
buffTime[21891] = 0                     	-- 坠落星辰碎片
buffTime[21473] = 30                    -- 莫阿姆之眼
buffTime[21488] = 30                    -- 虫刺塑像
buffTime[20636] = 15                    -- 休眠水晶
buffTime[19930] = 30                    -- 玛尔里之眼

buffTime[19947] = 15                    -- 纳特·帕格的卷尺
buffTime[21180] = 20                    -- 大地之击
buffTime[21181] = 0                      -- 大地之握
buffTime[19951] = 0                      -- 格里雷克的力量护符
buffTime[19952] = 15                    -- 格里雷克的勇气护符
buffTime[19953] = 0                      -- 雷纳塔基的野兽护符
buffTime[19954] = 0                      -- 雷纳塔基的狡诈护符
buffTime[19955] = 15                    -- 乌苏雷的自然护符
buffTime[19956] = 20                    -- 乌苏雷的灵魂护符
buffTime[19957] = 20                    -- 哈扎拉尔的毁灭护符
buffTime[19958] = 15                    -- 哈扎拉尔的治疗护符
buffTime[19959] = 20                    -- 哈扎拉尔的魔法护符

buffTime[20071] = 15                    -- 阿拉索护符
buffTime[20072] = 15                    -- 污染者护符
buffTime[22268] = 15                    -- 龙人能量徽章
buffTime[21326] = 0                      -- 木喉防御者
buffTime[14022] = 0                      -- 巴罗夫管家铃
buffTime[14023] = 0                      -- 巴罗夫管家铃

buffTime[13382] = 10                    -- 便携火炮
buffTime[16022] = 60                    -- 奥金机械幼龙
buffTime[22678] = 20                    -- 优越护符
buffTime[18639] = 5                      -- 快速暗影反射器
buffTime[11832] = 10                    -- 博学坠饰
buffTime[18638] = 5                      -- 高辐射烈焰反射器
buffTime[19024] = 20                    -- 竞技场大师饰物	
buffTime[19990] = 20                    -- 祝福珠串	

buffTime[20503] = 24                    -- 被迷惑的水之魂		
buffTime[19992] = 0                   	-- 魔暴龙牙		
buffTime[20512] = 25                    -- 神圣宝珠		
buffTime[20036] = 60                    -- 火焰宝石		
buffTime[18634] = 5                      -- 超低温寒冰偏斜器		
buffTime[1404] = 3                        -- 潮汐咒符			
buffTime[2820] = 10                      -- 灵巧秒表			
buffTime[10645] = 0                    	-- 侏儒死亡射线	
buffTime[1973] = 300                  	-- 欺诈宝珠

-- 工程
buffTime[18984] = 0						-- 冬泉谷传送器
buffTime[18986] = 0						-- 加基森传送器
buffTime[10577] = 3						-- 地精迫击炮
buffTime[10725] = 60					-- 侏儒作战小鸡
-- 任务/掉落
buffTime[19141] = 0						-- 丝瓜
buffTime[17744] = 0						-- 诺克赛恩之心

buffTime[7734] = 0						-- 六魔包
buffTime[10716] = 0						-- 侏儒缩小射线
buffTime[10720] = 0						-- 侏儒撒网器
buffTime[4397] = 10						-- 侏儒隐形装置

-- TBC饰品
buffTime[25994] = 15					-- 原力符文
buffTime[25995] = 15					-- 沙纳尔之星
buffTime[25996] = 15					-- 坚定徽章
buffTime[24390] = 10					-- 奥丝蕾的光芒护符
buffTime[28040] = 15					-- 伊利达雷的复仇
buffTime[28041] = 15					-- 刃拳的宽容
buffTime[28042] = 15					-- 皇家护符
buffTime[24551] = 0						-- 部落护符
buffTime[25829] = 0						-- 联盟护符
buffTime[24376] = 20					-- 符文菌帽
buffTime[25786] = 0						-- 催眠怀表
buffTime[25787] = 10					-- 敏锐咒符
buffTime[25619] = 20					-- 闪耀水晶徽记
buffTime[25620] = 20					-- 上古水晶符咒
buffTime[25936] = 15					-- 泰罗卡活力石板
buffTime[25937] = 15					-- 泰罗卡准确石板
buffTime[26055] = 10					-- 隐秘邪眼
buffTime[27416] = 15					-- 亡者塑像
buffTime[25628] = 15					-- 食人魔殴斗者的徽章
buffTime[25633] = 15					-- 联合护符
buffTime[31615] = 15					-- 上古德莱尼奥术神器
buffTime[31617] = 15					-- 上古德莱尼作战咒符
buffTime[29181] = 0						-- 时间流逝碎片
buffTime[25634] = 20					-- 沃舒古圣物
buffTime[29776] = 20					-- 阿尔凯洛斯之核
buffTime[30300] = 15					-- 达比雷之谜
buffTime[29370] = 20					-- 银色新月徽记
buffTime[29376] = 20					-- 殉难者精华
buffTime[29383] = 20					-- 嗜血胸针
buffTime[29387] = 20					-- 诺莫瑞根自动躲闪器600型
buffTime[38287] = 20					-- 空的烈酒杯
buffTime[38288] = 20					-- 烈酒蛇麻草
buffTime[38289] = 20					-- 科林的好运硬币
buffTime[38290] = 20					-- 黑铁烟枪
buffTime[30293] = 15					-- 神圣灵感
buffTime[27891] = 20					-- 精金雕像
buffTime[27900] = 0						-- 非凡秘法宝珠
buffTime[30340] = 15					-- 灭星饰物
buffTime[28528] = 10					-- 莫罗斯的幸运怀表
buffTime[28590] = 20					-- 牺牲绶带
buffTime[28727] = 20					-- 紫罗兰之眼坠饰
buffTime[34471] = 0						-- 太阳之井的水瓶
buffTime[24124] = 30					-- 雕像 - 魔钢野猪
buffTime[24125] = 20					-- 雕像 - 黎明石螃蟹
buffTime[24126] = 20					-- 雕像 - 红曜石毒蛇
buffTime[24127] = 12					-- 雕像 - 水玉猫头鹰
buffTime[24128] = 12					-- 雕像 - 夜目石猎豹
buffTime[27529] = 20					-- 巨人塑像
buffTime[27770] = 20					-- 阿古斯指南针
buffTime[27828] = 20					-- 星界甲虫
buffTime[28121] = 20					-- 不屈勇气徽章
buffTime[28223] = 20					-- 奥术师之石
buffTime[28288] = 10					-- 强烈优势算盘
buffTime[28370] = 20					-- 无尽祝福法链
buffTime[29132] = 15					-- 占星者的血钻石
buffTime[29179] = 15					-- 克希利的礼物
buffTime[30841] = 15					-- 贫民窟祈祷之书
buffTime[32534] = 15					-- 不朽之王的胸针
buffTime[32654] = 10					-- 晶铸饰品
buffTime[32658] = 20					-- 坚韧徽章
buffTime[35693] = 20					-- 雕像 - 天蓝宝石海龟
buffTime[35694] = 30					-- 雕像 - 氪金野猪
buffTime[35700] = 20					-- 雕像 - 赤尖蛇
buffTime[35702] = 15					-- 雕像 - 影歌猎豹
buffTime[35703] = 12					-- 雕像 - 海浪信天翁
buffTime[30620] = 12					-- 隐秘舰队的望远镜
buffTime[30629] = 15					-- 偏移甲虫
buffTime[30665] = 20					-- 热情冥想耳环
buffTime[34029] = 0						-- 小巫毒面具
buffTime[37127] = 0						-- 光明美酒护符
buffTime[37128] = 0						-- 黑暗美酒护符
buffTime[33828] = 20					-- 魔鬼治疗宝典
buffTime[33829] = 20					-- 妖术之颅
buffTime[33830] = 20					-- 上古埃基尔神器
buffTime[33831] = 20					-- 狂暴者的召唤
buffTime[33832] = 15					-- 战斗大师的决心
buffTime[34049] = 15					-- 战斗大师的勇猛
buffTime[34050] = 15					-- 战斗大师的坚定
buffTime[34162] = 15					-- 战斗大师的堕落
buffTime[34163] = 15					-- 战斗大师的残暴
buffTime[34576] = 15					-- 战斗大师的残暴
buffTime[34577] = 15					-- 战斗大师的堕落
buffTime[34578] = 15					-- 战斗大师的决心
buffTime[34579] = 15					-- 战斗大师的勇猛
buffTime[34580] = 15					-- 战斗大师的坚定
buffTime[35326] = 15					-- 战斗大师的活跃
buffTime[35327] = 15					-- 战斗大师的活跃
buffTime[32501] = 20					-- 影月徽记
buffTime[32483] = 20					-- 古尔丹之颅
buffTime[34428] = 15					-- 坚硬的纳鲁薄片
buffTime[34429] = 15					-- 变幻的纳鲁薄片（可能施放有问题）
buffTime[34430] = 8						-- 闪光的纳鲁薄片（可能施放有问题）

-- 主动饰品集合
SELFAQ.usable = {}
SELFAQ.pveSet = {}

SELFAQ.usable[13] = {}
SELFAQ.pveSet[13] = {}

for k,v in pairs(buffTime) do
	table.insert(SELFAQ.pveSet[13], k)
end

SELFAQ.buffTime = buffTime

-- 衣服5

local tempBuffTime = {}
tempBuffTime[14152] = 0				-- 大法师之袍

-- 可使用的胸甲集合
SELFAQ.usable[5] = {}

for k,v in pairs(tempBuffTime) do
	table.insert(SELFAQ.usable[5], k)
	SELFAQ.buffTime[k] = v
end

-- 鞋子8

wipe(tempBuffTime)
tempBuffTime[7189] = 20						-- 地精火箭靴
tempBuffTime[10724] = 20						-- 侏儒火箭靴

SELFAQ.usable[8] = {}

for k,v in pairs(tempBuffTime) do
	table.insert(SELFAQ.usable[8], k)
	SELFAQ.buffTime[k] = v
end

-- 副手17

wipe(tempBuffTime)
tempBuffTime[16768] = 10						-- 熊怪医疗包
tempBuffTime[4984] = 10						-- 末日颅骨
tempBuffTime[17067] = 0						-- 上古角石魔典


SELFAQ.usable[17] = {}

for k,v in pairs(tempBuffTime) do
	table.insert(SELFAQ.usable[17], k)
	SELFAQ.buffTime[k] = v
end

-- 头部1

wipe(tempBuffTime)
tempBuffTime[10588] = 0						-- 地精火箭头盔
tempBuffTime[10726] = 20						-- 侏儒洗脑帽

SELFAQ.usable[1] = {}

for k,v in pairs(tempBuffTime) do
	table.insert(SELFAQ.usable[1], k)
	SELFAQ.buffTime[k] = v
end

-- 腿部7

wipe(tempBuffTime)
tempBuffTime[14554] = 30						-- 踏云腿甲

SELFAQ.usable[7] = {}

for k,v in pairs(tempBuffTime) do
	table.insert(SELFAQ.usable[7], k)
	SELFAQ.buffTime[k] = v
end

-----------------------

-- 联盟、部落各个职业的徽记
SELFAQ.pvpSet = {
	18854,18856,18857,18858,18859,18862,18863,18864,
	18834,18845,18846,18849,18850,18851,18852,18853
}

SELFAQ.usable[13] = merge(SELFAQ.pveSet[13], SELFAQ.pvpSet)

-- 徽记的buff时间都是0
for k,v in pairs(SELFAQ.pvpSet) do
	SELFAQ.buffTime[v] = 0
end

-- 记录当前角色的徽记
SELFAQ.pvp = {}

-- 配置结束 --