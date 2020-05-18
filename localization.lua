local _, AQSELF = ...

local L = setmetatable({}, {
    __index = function(table, key)
        if key then
            table[key] = tostring(key)
        end
        return tostring(key)
    end,
})

AQSELF.L = L

local locale = GetLocale()

L["enable_battleground"] = "Enable in Battleground / Equip \124cff0070dd\124Hitem:18854:0:0:0:0:0:0:0\124h[Insignia of the Alliance]\124h\124r \124cff0070dd\124Hitem:18854:0:0:0:0:0:0:0\124h[Insignia of the Horde]\124h\124r."
L["enable_carrot"] = "Equip \124cff1eff00\124Hitem:11122:0:0:0:0:0:0:0\124h[Carrot on a Stick]\124h\124r when you're riding (Slot 2 /Not in Battleground). "
L["Disable Slot 2"] = "Disable Trinket Slot 2 (Make the ultimate trinket permanent, such as \124cffa335ee\124Hitem:19379:0:0:0:0:0:0:0\124h[Neltharion's Tear]\124h\124r)"

L[60] = "|cFF00FF0060|r"
L[64] = "|cFFFF0000Boss|r"
L[63] = "|cFFFF000063|r"

L["prefix"] = "|cFF00BFFF[AutoEquip]|r"

if locale == 'zhCN' then

	L[" Loaded"] = " 加载完毕"
	L["Enable"] = "启用"
	L["Enable AutoEquip function"] = "启用自动装备功能"
	L["Automatic switch to PVP mode in Battleground"] = "战场中自动切换到PVP模式"
	L["enable_carrot"] = "骑乘时装备\124cff1eff00\124Hitem:11122:0:0:0:0:0:0:0\124h[棍子上的胡萝卜]\124h\124r（饰品栏2/战场中不生效）"
	L["Disable Slot 2"] = "禁用饰品栏2 (让极品饰品常驻, 比如\124cffa335ee\124Hitem:19379:0:0:0:0:0:0:0\124h[奈萨里奥之泪]\124h\124r)"
	L["Equip item by priority forcibly even if the item in slot is aviilable"] = "强制按优先级装备物品，即使已装备的物品当前可用"
	L["Item queue is displayed above the Inventory Bar"] = "物品队列在装备栏上方显示"

	L["Reload UI"] = "重载UI"
	L["#When the items shown below are different from the actual ones"] = "#下方罗列的饰品和实际不一致时"

	L["Usable Trinkets:"] = "主动饰品:"
	L["Resident Trinkets:"] = "常驻饰品:"

	L["No. "] = "优先级"
	L["Slot "] = "饰品栏"

	L["<There is no suitable trinkets>"] = "<没有适合的饰品>"
	L["<Select a trinket>"] = "<选择一个饰品>"

	L["AutoEquip: |cFF00FF00Enabled|r"] = "AutoEquip: |cFF00FF00启用|r"
	L["AutoEquip: |cFFFF0000Disabled|r"] = "AutoEquip: |cFFFF0000停用|r"

	L[" Lock frame"] = " 锁定框架"
	L["Lock frame"] = "锁定框架"
	L[" Settings"] = " 打开设置"
	L[" Close"] = " 关闭菜单"
	L["Enable Inventory Bar"] = "启用装备栏"
	L["Enable Buff Alert"] = "启用Buff提醒"

	L["|cFF00FF00Enabled|r"] = "|cFF00FF00启用|r"
	L["|cFFFF0000Disabled|r"] = "|cFFFF0000停用|r"
	L["AutoEquip: PVP mode "] = "AutoEquip: PVP模式"

	L["Custom Buff Alert:"] = "自定义Buff提醒:"
	L["Format - BuffName,BuffName,BuffName"] = "格式 - Buff名称,Buff名称,Buff名称"
	L["Append Usable Items:"] = "追加主动装备"
	L["Format - ItemID/BuffTime,ItemID/BuffTime"] = "格式 - 装备ID/Buff持续时间,装备ID/Buff持续时间"
	L["Submit"] = "提交"
	L["Submit & Reload UI"] = "提交并重载UI"

	L["Command:"] = "命令行:"
	L["DRAG"] = "拖拽"
	L[" Enable PVP mode"] = " 启用PVP模式"

	L["-- Enable/disable AutoEquip function"] = "-- 启用/禁用自动更换装备功能"
	L["-- Open settings"] = "-- 打开设置页面"
	L["-- Enable/disable PVP mode manually"] = "-- 手动启动/禁用PVP模式"
	L["-- Unlock Inventory Bar (AutoEquip function is invalid when locked)"] = "-- 解锁装备栏按钮（锁定时自动装备功能不生效）"

	L["1. Equip item manually through the Inventory Bar will temporarily lock the button."] = "1. 通过装备栏手动更换装备，将会暂时锁定对应的按钮"
	L["2. Right click or use the '/aq unlock' command will unlock the button."] = "2. 解锁装备栏可以右键点击按钮，或者聊天框输入/aq unlock"
	L["3. Before using item, the button will be unlocked automatically."] = "3. 使用物品后，对应装备栏按钮将会自动解锁"
	L["4. AutoEquip/Inventory Bar/Buff Alert can be enabled/disabled independently."] = "4. 自动装备、装备栏、Buff提醒，三个功能可以独立启用/禁用"

	L["Unstable Power, Mind Quickening"] = "能量无常,思维敏捷"

	L["Zoom"] = "缩放"
	L["Mode:"] = "模式:"
	L["Slot:"] = "装备栏:"
	L["Hide backdrop"] = "隐藏背景"
	L["[Empty]"] = "[空]"
	L['Trinket Slot '] = "饰品栏"
	L["Inventory Bar Button"] = "装备栏按钮"

	L["Head"] = "头部"
	L["Neck"] = "颈部"
	L["Shoulder"] = "肩部"
	L["Chest"] = "胸部"
	L["Waist"] = "腰部"
	L["Legs"] = "腿部"
	L["Feet"] = "脚"
	L["Wrist"] = "手腕"
	L["Hands"] = "手"
	L["Fingers "] = "手指"
	L["Trinkets "] = "饰品"
	L["Cloaks"] = "背部"
	L["Main-Hand"] = "主手"
	L["Off-Hand"] = "副手"
	L["Ranged"] = "远程"
end
