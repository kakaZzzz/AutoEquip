local _, SELFAQ = ...

local color = SELFAQ.color

SELFAQ.color =  function( rgb, text )
    return "|cFF"..rgb..text.."|r"
end

local color = SELFAQ.color

local L = setmetatable({}, {
    __index = function(table, key)
        if key then
            table[key] = tostring(key)
        end
        return tostring(key)
    end,
})

SELFAQ.L = L

local locale = GetLocale()

L["enable_battleground"] = "Enable in Battleground / Equip \124cff0070dd\124Hitem:18854:0:0:0:0:0:0:0\124h[Insignia of the Alliance]\124h\124r \124cff0070dd\124Hitem:18854:0:0:0:0:0:0:0\124h[Insignia of the Horde]\124h\124r."
L["enable_carrot"] = "Equip |cff1eff00[Carrot on a Stick]|r|cff1eff00[Mithril Spurs]|r|cffffffff[Riding Skill]|r when riding (Not in Instance). "
L["enable_swim"] = "Equip |cff0070dd[Hydrocane]|r|cff1eff00[Azure Silk Belt]|r|cff1eff00[Deepdive Helmet]|r when swiming."
L["Disable Slot 2"] = "Disable Trinket Slot 2 (Make the ultimate trinket permanent, such as \124cffa335ee\124Hitem:19379:0:0:0:0:0:0:0\124h[Neltharion's Tear]\124h\124r)"

L[60] = color("00FF00", "General")
L[64] = color("FF0000", "Lv.?? Boss")
L[63] = color("FF4500", "Lv.63 Elite")

L["prefix"] = "|cFFFFFF00<AutoEquip>|r"

if locale == 'zhCN' or locale == 'zhTW' then

	L["Loaded"] = " 加载完毕"
	L["Enable"] = "启用"
	L["Enable AutoEquip function"] = "启用自动换装功能"
	L["Automatic switch to PVP mode in Battleground"] = "战场中自动切换到PVP模式"
	L["enable_carrot"] = "骑乘时装备|cff1eff00[棍子上的胡萝卜]|r|cff1eff00[秘银马刺]|r|cffffffff[附魔手套-骑乘]|r（战场/副本中不生效）"
	L["enable_swim"] = "游泳时装备|cff0070dd[水藤]|r|cff1eff00[碧蓝丝质腰带]|r|cff1eff00[潜水头盔]|r"
	L["Disable Slot 2"] = "禁用饰品栏2 (让极品饰品常驻, 比如\124cffa335ee\124Hitem:19379:0:0:0:0:0:0:0\124h[奈萨里奥之泪]\124h\124r)"
	L["Equip item by priority forcibly even if the item in slot is aviilable"] = "强制按优先级装备物品，即使已装备的物品当前可用"
	L["Item queue is displayed above the Equipment Bar"] = "物品队列在装备栏上方显示"
	L["In combat |cFF00FF00shift + left-click|r equipment button to display the items list"] = "战斗中|cFF00FF00按住Shift左键单击|r装备栏按钮显示物品列表"
	L["Show simple tooltip (only item name)"] = "显示精简提示（只有物品名）"

	L["Expand Settings"] = "展开设置列表"

	L["Reload UI"] = "重载UI"
	L["#When the equippable items you carry have changed"] = "#当已携带装备发生变化"

	L["Usable Trinkets:"] = "主动饰品:"
	L["Resident Trinkets:"] = "常驻饰品:"

	L["No. "] = "优先级"
	L["Slot "] = "饰品栏"

	L["Trinkets"] = "饰品"
	L["Usable "] = "主动"
	L["Backup (Be equiped when usable items are all on CD):"] = "备选（当主动装备都CD时装备）:"

	L["<There is no suitable trinkets>"] = "<没有适合的饰品>"
	L["<Select a trinket>"] = "<选择一个饰品>"

	L["AutoEquip: |cFF00FF00Enabled|r"] = "AutoEquip: |cFF00FF00启用|r"
	L["AutoEquip: |cFFFF0000Disabled|r"] = "AutoEquip: |cFFFF0000停用|r"

	L[" Lock frame"] = " 锁定框架"
	L["Lock frame"] = "锁定框架"
	L[" Settings"] = " 打开设置"
	L[" Close"] = " 关闭菜单"
	L["Enable Equipment Bar"] = "启用装备栏"
	L["Enable Buff Alert"] = "启用Buff提醒"

	L["|cFF00FF00Enabled|r"] = "|cFF00FF00启用|r"
	L["|cFFFF0000Disabled|r"] = "|cFFFF0000停用|r"
	L["PVP mode "] = " PVP模式"

	L["Custom Buff Alert:"] = "自定义Buff提醒:"
	L["Format - BuffName,BuffName,BuffName"] = "格式 - Buff名称,Buff名称,Buff名称"
	L["Append Usable Items (not only trinket):"] = "追加主动装备（不只是饰品）:"
	L["Unidentified usable items need to be added manually by yourself"] = "未被识别的主动装备，需要自己手动添加"
	L["Format - ItemID/BuffTime,ItemID/BuffTime"] = "格式 - 装备ID/Buff持续时间,装备ID/Buff持续时间"
	L["Submit"] = "提交"
	L["Submit & Reload UI"] = "提交并重载UI"

	L["Command (/aq /autoequip are valid):"] = "命令行（也可用 /aq /autoequip）:"
	L["Advanced Settings:"] = "进阶设置:"
	L["DRAG"] = "拖拽"
	L[" Enable PVP mode"] = " 启用PVP模式"

	L["-- Enable/disable AutoEquip function"] = "-- 启用/禁用自动更换装备功能"
	L["-- Open settings"] = "-- 打开设置页面"
	L["-- Enable/disable PVP mode manually"] = "-- 手动启用/禁用PVP模式"
	L["-- Unlock Equipment Bar (AutoEquip function is invalid when locked)"] = "-- 解锁装备栏按钮（锁定时自动换装功能不生效）"
	L["-- Customize equipment bar (enter 0 to disable)"] = "-- 自定义装备栏（输入0禁用）"
	L["-- Hide the usable items queue (hide 1, show 0)"] = "-- 隐藏主动物品队列（隐藏1，显示0）"
	L["-- Set equipment button spacing to 1 (default 3)"] = "-- 将装备栏按钮间距设置为1（默认是3）"
	L["-- Set threshold of member's target to 3 (default 1)"] = "-- 将团员目标阈值设置为3（默认是1）"


	L["1. Equip item manually through the Equipment Bar will temporarily lock the button."] = "1. 通过装备栏手动更换装备，将会暂时锁定对应的按钮"
	L["2. Right click or use the '/aq unlock' command will unlock the button."] = "2. 解锁装备栏可以右键点击按钮，或者聊天框输入/aq unlock"
	L["3. Before using item, the button will be unlocked automatically."] = "3. 使用物品后，对应装备栏按钮将会自动解锁"
	L["4. AutoEquip/Equipment Bar/Buff Alert can be enabled/disabled independently."] = "4. 自动换装、装备栏、Buff提醒，三个功能可以独立启用/禁用"

	L["Unstable Power, Mind Quickening"] = "能量无常,思维敏捷"

	L["Zoom"] = "缩放"
	L["Mode:"] = "模式:"
	L["Slot:"] = "装备栏:"
	L["Hide black translucent border"] = "隐藏黑色半透明边框"
	L["#Effective after ENTER"] = "#回车后生效"
	L["Hide tooltip when the mouse moves over the button"] = "鼠标在装备栏按钮上停留时不显示提示框"
	L["[Empty]"] = "[空]"
	L['Trinket Slot '] = "饰品栏"
	L["Equipment Bar Button"] = "装备栏按钮"

	L["Head"] = "头部"
	L["Neck"] = "颈部"
	L["Shoulder"] = "肩部"
	L["Chest"] = "胸部"
	L["Waist"] = "腰部"
	L["Legs"] = "腿部"
	L["Feet"] = "脚"
	L["Wrist"] = "手腕"
	L["Hands"] = "手"
	L["Finger "] = "手指"
	L["Trinket "] = "饰品"
	L["Back"] = "背部"
	L["MainHand"] = "主手"
	L["OffHand"] = "副手"
	L["Ranged"] = "远程"

	L[60] = color("00FF00", "常规")
	L[63] = color("FF4500", "Lv.63 精英")

	L["General"] = "常规设置"
	L["Suit for 63+"] = "63+套装"
	L["Usable Queue"] = "主动队列"

	L["[Enable] Equip customized suit when you target lv.63 elite or lv.?? boss"] = "[启用]当目标为63级精英或??级Boss时，装备自定义的套装"
	L["Equip suit when more than 1 raid members target lv.63 elite or boss"] = "当团队中超过1人目标是63级精英或者Boss时，装备套装"
	L["Automatic equip Suit "..L[60].." when you leave combat"] = "离开战斗时自动切换回"..L[60].."套装"
	L["#The following options only take effect in instance"] = "#以下选项只在副本中生效"
	L["Equip Suit "..L[60].." when you target enemy under lv.63"] = "当目标为63级以下的敌方单位，装备"..L[60].."套装"
	L["Suit "..L[64]] = L[64].."套装"
	L["Suit "..L[63]] = L[63].."套装"
	L["Suit "..L[60]] = L[60].."套装"

	L["-- Equip Suit "] = "-- 装备套装"
	L["-- Set 5 items per column in dropdown list (default 4)"] = "-- 设置物品下拉框每列显示5件物品（默认4）"

	L["Help"] = "帮助"
	L["#The above selections will take effect after reloading UI"] = "#重载UI后以上的选择生效"

	L["Go to 'General' page and add the unidentified usable items manually"] = "前往“常规设置”页面手动添加未被识别的主动装备"
	L["Not only trinkets, any equippable usable item is acceptable"] = "任何主动装备都能添加，不只是饰品"

	L["Custom equipment bar was |cFFFF0000CANCELED|r."] = " 自定义装备|cFFFF0000已取消|r。"
	L[" Please reload UI manually (/reload)."] = "请手动重载UI（/reload）。"
	L["Custom equipment bar |cFF00FF00SUCCESS|r."] = " 自定义装备栏|cFF00FF00成功|r。"

	L["Equip "] = "装备"

	L["AutoEquip function |cFF00FF00Enabled|r"] = "自动换装功能|cFF00FF00启用|r"
	L["AutoEquip function |cFFFF0000Disabled|r"] = "自动换装功能|cFFFF0000停用|r"

	L["|cFFFF0000Disable|r  the display of item list when moseover"] = "|cFFFF0000停用|r鼠标经过时显示装备列表"
	L["|cFF00FF00Enable|r the display of item list when moseover"] = "|cFF00FF00启用e|r鼠标经过时显示装备列表"
	L["-- Disable the display of item list when moseover (enable 0)"] = "-- 鼠标经过时不显示装备列表（显示0）"
	L["Hide popup addon info at the top of screen"] = "隐藏屏幕上方的插件提示"
	L["-- Set popup info to the center of screen (default 0,320)"] = "-- 将插件提示定位到屏幕正中（默认0,320）"
	L["|cFF00FF00Unlocked|r all equipment buttons"] = "|cFF00FF00解锁|r全部装备栏按钮"
	L["Set threshold of member's target to "] = "将团员目标阈值设置为"
end
