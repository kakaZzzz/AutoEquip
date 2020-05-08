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

if locale == 'zhCN' then

	L["Enable"] = "启用"
	L["Enable AutoEquip function"] = "启用自动装备功能"
	L["Automatic switch to PVP mode in Battleground"] = "战场中自动切换到PVP模式"
	L["enable_carrot"] = "骑乘时装备\124cff1eff00\124Hitem:11122:0:0:0:0:0:0:0\124h[棍子上的胡萝卜]\124h\124r（饰品栏2/战场中不生效）"
	L["Disable Slot 2"] = "禁用饰品栏2（让极品被动饰品常驻，如耐泪）"
	L["Equip item by priority forcibly even if the item in slot is aviilable"] = "强制按优先级装备物品，即使已装备的物品当前可用"
	L["Item queue is displayed above the Inventory Bar"] = "物品队列在装备栏上方显示"

	L["Reload UI"] = "重载UI"
	L["If you get a new trinket (include take it from bank)."] = "<=下方罗列的饰品和实际不一致"

	L["Usable Trinkets:"] = "主动饰品:"
	L["Resident Trinkets:"] = "常驻饰品:"

	L["No. "] = "优先级"
	L["Slot "] = "饰品栏"

	L["<There is no suitable trinkets>"] = "<没有适合的饰品>"
	L["<Select a trinket>"] = "<选择一个饰品>"

	L["AutoEquip: |cFF00FF00Enabled|r"] = "AutoEquip: |cFF00FF00启用|r"
	L["AutoEquip: |cFFFF0000Disabled|r"] = "AutoEquip: |cFFFF0000停用|r"

	L[" Lock"] = " 锁定位置"
	L["Lock"] = "锁定位置"
	L[" Settings"] = " 打开设置"
	L[" Close"] = " 关闭菜单"
	L["Enable ItemBar"] = "启用装备栏"
	L["Enable BuffAlert"] = "启用Buff提醒"

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
end
