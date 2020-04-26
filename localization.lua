
L = setmetatable({}, {
    __index = function(table, key)
        if key then
            table[key] = tostring(key)
        end
        return tostring(key)
    end,
})


local locale = GetLocale()

L["enable_battleground"] = "Enable in Battleground / Equip \124cff0070dd\124Hitem:18854:0:0:0:0:0:0:0\124h[Insignia of the Alliance]\124h\124r \124cff0070dd\124Hitem:18854:0:0:0:0:0:0:0\124h[Insignia of the Horde]\124h\124r."
L["enable_carrot"] = "Equip \124cff1eff00\124Hitem:11122:0:0:0:0:0:0:0\124h[Carrot on a Stick]\124h\124r when you're riding (Slot 2 /Not in Battleground). "

if locale == 'zhCN' then

	L["Enable"] = "启用"
	L["enable_battleground"] = "战场中启用/优先装备 \124cff0070dd\124Hitem:18854:0:0:0:0:0:0:0\124h[联盟徽记]\124h\124r\124cff0070dd\124Hitem:18854:0:0:0:0:0:0:0\124h[部落徽记]\124h\124r"
	L["enable_carrot"] = "骑乘时装备\124cff1eff00\124Hitem:11122:0:0:0:0:0:0:0\124h[棍子上的胡萝卜]\124h\124r（饰品栏2/战场中不生效）"
	L["Disable Slot 2"] = "禁用饰品栏2"

	L["Reload UI"] = "重载UI"
	L["If you get a new trinket (include take it from bank)."] = "（如果发现有的饰品没显示）"

	L["Usable Trinkets:"] = "主动饰品:"
	L["Resident Trinkets:"] = "常驻饰品:"

	L["No. "] = "优先级"
	L["Slot "] = "饰品栏"

end
