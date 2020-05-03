local _, AQSELF = ...

local merge = AQSELF.merge
local initSV = AQSELF.initSV

-- 配置 --

AQSELF.version = "v2.10"

AQSELF.enableDebug = true          -- 调试开关
-- AQSELF.enableDebug = false          -- 调试开关

AQSELF.init = false

-- 获取当前角色名字
AQSELF.player = UnitName("player")

-- 构建下拉框组时，记录纵坐标
AQSELF.lastHeight = 0

-- 操作的装备栏
AQSELF.slots = {13, 14}
AQSELF.slotFrames = {}

-- 配置结束 --