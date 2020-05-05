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
	L["Automatic switch to PVP mode in Battleground"] = "战场中自动切换到PVP模式"
	L["enable_carrot"] = "骑乘时装备\124cff1eff00\124Hitem:11122:0:0:0:0:0:0:0\124h[棍子上的胡萝卜]\124h\124r（饰品栏2/战场中不生效）"
	L["Disable Slot 2"] = "禁用饰品栏2（让极品被动饰品常驻，如耐泪）"
	L["Equip item by priority forcibly even if the item in slot is aviilable"] = "强制按优先级装备物品，即使已装备的物品当前可用"

	L["Reload UI"] = "重载UI"
	L["If you get a new trinket (include take it from bank)."] = "<=下方罗列的饰品和实际不一致"

	L["Usable Trinkets:"] = "主动饰品:"
	L["Resident Trinkets:"] = "常驻饰品:"

	L["No. "] = "优先级"
	L["Slot "] = "饰品栏"

	L["<There is no suitable trinkets>"] = "<没有适合的饰品>"
	L["<Select a trinket>"] = "<选择一个饰品>"

	L["AutoEquip: Enabled"] = "AutoEquip: 已启用"
	L["AutoEquip: Disabled"] = "AutoEquip: 已禁用"

	L[" Lock"] = " 锁定位置"
	L["Lock"] = "锁定位置"
	L[" Settings"] = " 打开设置"
	L[" Close"] = " 关闭菜单"
	L["Enable ItemBar"] = "启用装备栏"

	L["|cFF00FF00Enabled|r"] = "|cFF00FF00启用|r"
	L["|cFFFF0000Disabled|r"] = "|cFFFF0000停用|r"
	L["AutoEquip: PVP mode "] = "AutoEquip: PVP模式 "

	L["Buff Alert:"] = "Buff提醒:"
	L["Format - BuffName1,BuffName2,BuffName3"] = "格式 - Buff名称1,Buff名称2,Buff名称3"
end
