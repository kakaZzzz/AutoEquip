local _, AQSELF = ...

local merge = AQSELF.merge
local initSV = AQSELF.initSV
local L = AQSELF.L

-- 配置 --

AQSELF.version = "v4.4"

-- AQSELF.enableDebug = true          -- 调试开关
AQSELF.enableDebug = false          -- 调试开关

AQSELF.init = false

-- 获取当前角色名字
AQSELF.player = UnitName("player")

if AQSELF.player == "卡法" or AQSELF.player == "卡卡咔" or AQSELF.player == "水猎"  then
	AQSELF.enableDebug = true          -- 调试开关
end

-- 构建下拉框组时，记录纵坐标


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
AQSELF.empty6 = {}			-- 
AQSELF.empty7 = {}			-- 
AQSELF.empty8 = {}			-- 

AQSELF.e0 = {}		-- slot13/core
AQSELF.e1 = {}		-- slot14/core

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
	[16] = L["MainHand"],
	[17] = L["OffHand"],
	[18] = L["Ranged"],
}

AQSELF.slotName = {
	[1] = "HeadSlot",
	[2] = "NeckSlot",
	[3] = "ShoulderSlot",
	[15] = "BackSlot",
	[5] = "ChestSlot",
	[9] = "WristSlot",
	[10] = "HandsSlot",
	[6] = "WaistSlot",
	[7] = "LegsSlot",
	[8] = "FeetSlot",
	[11] = "Finger0Slot",
	[12] = "Finger1Slot",
	[13] = "Trinket0Slot",
	[14] = "Trinket1Slot",
	[16] = "MainHandSlot",
	[17] = "SecondaryHandSlot",
	[18] = "RangedSlot",
}

AQSELF.gearSlots = {1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18}


-- 配置结束 --