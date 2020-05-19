local _, AQSELF = ...

local merge = AQSELF.merge
local initSV = AQSELF.initSV
local L = AQSELF.L

-- 配置 --

AQSELF.version = "v3.6"

-- AQSELF.enableDebug = true          -- 调试开关
AQSELF.enableDebug = false          -- 调试开关

AQSELF.init = false

-- 获取当前角色名字
AQSELF.player = UnitName("player")

-- 构建下拉框组时，记录纵坐标
AQSELF.lastHeight = -340

-- 操作的装备栏
AQSELF.slots = {13, 14}
AQSELF.slotFrames = {}

AQSELF.realtimeQueue = {}

AQSELF.needSuit = false
AQSELF.needSuitTimestamp = 0

-- 避免数组内容泄露，全程缓存数组
AQSELF.empty1 = {}			-- realtimeQueue/core
AQSELF.empty2 = {}			-- slotIds/ui
AQSELF.empty3 = {}			-- diff/base
AQSELF.empty4 = {}			-- diff2/base
AQSELF.empty5 = {}			-- waitId/chance2hit
AQSELF.empty13 = {}		-- slot13/core
AQSELF.empty14 = {}		-- slot14/core

AQSELF.slotToName = {
	[1] = L["Head"],
	[2] = L["Neck"],
	[3] = L["Shoulder"],
	[5] = L["Chest"],
	[6] = L["Waist"],
	[7] = L["Legs"],
	[8] = L["Feet"],
	[9] = L["Wrist"],
	[10] = L["Hands"],
	[11] = L["Fingers "]..1,
	[12] = L["Fingers "]..2,
	[13] = L["Trinkets "]..1,
	[14] = L["Trinkets "]..2,
	[15] = L["Cloaks"],
	[16] = L["Main-Hand"],
	[17] = L["Off-Hand"],
	[18] = L["Ranged"],
}

AQSELF.gearSlots = {1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18}


-- 配置结束 --