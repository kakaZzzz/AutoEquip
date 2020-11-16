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
L["enable_swim"] = "Equip |cff0070dd[Hydrocane]|r|cff1eff00[Azure Silk Belt]|r|cff1eff00[Deepdive Helmet]|r when swiming (Not in Instance)."
L["Disable Slot 2"] = "Disable Trinket Slot 2 (Make the ultimate trinket permanent, such as \124cffa335ee\124Hitem:19379:0:0:0:0:0:0:0\124h[Neltharion's Tear]\124h\124r)"

L[60] = color("00FF00", "General")
L[64] = color("FF0000", "Lv.?? Boss")
L[63] = color("FF4500", "Lv.63 Elite")

L["prefix"] = "|cFFBF6B31<|r|cFFFFFF00AE|r|cFFBF6B31>|r"

if locale == 'zhCN' or locale == 'zhTW' then

	L["Loaded"] = "加载完毕"
	L["Enable"] = "启用"
	L["Enable AutoEquip function"] = "启用自动换装功能"
	L["Automatic switch to PVP queue in Battleground"] = "战场中自动切换到PVP队列"
	L["enable_carrot"] = "骑乘时装备|cff1eff00[棍子上的胡萝卜]|r|cff1eff00[秘银马刺]|r|cffffffff[附魔手套-骑乘]|r（战场/副本中不生效）"
	L["enable_swim"] = "游泳时装备|cff0070dd[水藤]|r|cff1eff00[碧蓝丝质腰带]|r|cff1eff00[潜水头盔]|r（战场/副本中不生效）"
	L["Disable Slot 2"] = "禁用饰品栏2 (让极品饰品常驻, 比如\124cffa335ee\124Hitem:19379:0:0:0:0:0:0:0\124h[奈萨里奥之泪]\124h\124r)"
	L["Equip item by priority forcibly even if the item in slot is aviilable"] = "强制按优先级装备物品，即使已装备的物品当前可用"
	L["Item queue is displayed above the Equipment Bar"] = "物品队列在装备栏上方显示"
	L["In combat |cFF00FF00shift + left-click|r equipment button to display the item list"] = "战斗中|cFF00FF00按住Shift左键单击|r装备栏按钮显示物品列表"
	L["Hide item level on the item list (Need reload UI)"] = "隐藏装备列表上的物品等级（需要重载UI）"
	L["Show simple tooltip (only item name)"] = "显示精简提示（只有物品名）"
	L["Equip |cff0070dd[Onyxia Scale Cloak]|r when entering |cffffffffNefarian's Lair|r"] = "进入|cffffffff奈法利安的巢穴|r装备|cff0070dd[奥妮克希亚鳞片披风]|r"
	L["Remind on Raid channel when auto-equiped |cff0070dd[Onyxia Scale Cloak]|r"] = "自动装备|cff0070dd[奥妮克希亚鳞片披风]|r后在团队频道发出提醒"

	L["#Don't change clock when you are in Nefarian's Lair"] = "#进入 奈法利安的巢穴 后不会更换披风"

	L["Expand Settings"] = "展开设置列表"

	L["Reload UI"] = "重载UI"
	L["#When the equippable items you carry have changed"] = "#当已携带装备发生变化"

	L["Usable Trinkets:"] = "主动饰品:"
	L["Resident Trinkets:"] = "常驻饰品:"

	L["No. "] = "优先级"
	L["Priority "] = "优先"
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
	L["PVP queue "] = " PVP队列"

	L["Custom Buff Alert:"] = "自定义Buff提醒:"
	L["Format - BuffName,BuffName,BuffName"] = "格式 - Buff名称,Buff名称,Buff名称"
	L["Append Usable Items (not only trinket):"] = "追加主动装备（不只是饰品）:"
	L["Unidentified usable items need to be added manually by yourself"] = "未被识别的主动装备，需要自己手动添加"
	L["Format - ItemID/BuffTime,ItemID/BuffTime"] = "格式 - 物品ID/Buff持续时间,物品ID/Buff持续时间"
	L["Submit"] = "提交"
	L["Save & Reload UI"] = "保存并重载UI"

	L["Command (/aq /autoequip are valid):"] = "命令行（也可用 /aq /autoequip）:"
	L["Advanced Settings:"] = "进阶设置:"
	L["DRAG"] = "拖拽"
	L[" Enable PVP queue"] = " 启用PVP队列"

	L["-- Enable/disable AutoEquip function"] = "-- 启用/禁用自动更换装备功能"
	L["-- Open settings"] = "-- 打开设置页面"
	L["-- Enable/disable PVP queue manually"] = "-- 手动启用/禁用PVP队列"
	L["-- Unlock Equipment Bar (AutoEquip function is invalid when locked)"] = "-- 解锁装备栏全部按钮（锁定时自动换装功能不生效）"
	L["-- Lock Equipment Bar"] = "-- 锁定装备栏全部按钮"
	L["-- Customize equipment bar (enter 0 to disable)"] = "-- 自定义装备栏（输入0禁用）"
	L["-- Hide the usable items queue (hide 1, show 0)"] = "-- 隐藏主动物品队列（隐藏1，显示0）"
	L["-- Set equipment button spacing to 1 (default 3)"] = "-- 将装备栏按钮间距设置为1（默认是3）"
	L["-- Set threshold of member's target to 3 (default 1)"] = "-- 将团员目标阈值设置为3（默认是1）"
	L["-- Hide equipment bar outside Instance (show 0)"] = "-- 副本外隐藏装备栏（显示0）"


	L["1. Equip item manually through the Equipment Bar will temporarily lock the button."] = "1. 通过装备栏手动更换装备，将会暂时锁定对应的按钮"
	L["2. Right click or use the '/ae unlock' command will unlock the button."] = "2. 解锁装备栏可以右键点击按钮，或者聊天框输入/ae unlock"
	L["3. Before using item, the button will be unlocked automatically."] = "3. 使用物品后，对应装备栏按钮将会自动解锁"
	L["4. AutoEquip/Equipment Bar/Buff Alert can be enabled/disabled independently."] = "4. 自动换装、装备栏、Buff提醒，三个功能可以独立启用/禁用"

	L["Unstable Power, Mind Quickening"] = "能量无常,思维敏捷"

	L["Zoom"] = "缩放"
	L["Queue:"] = "队列:"
	L["Slot:"] = "装备栏:"
	L["Hide black translucent border"] = "隐藏黑色半透明边框"
	L["#Effective after ENTER"] = "#回车后生效"
	L["Hide tooltip when the mouse moves over the button"] = "鼠标在装备栏按钮上停留时不显示提示框"
	L["[Empty]"] = "[空|不更换]"
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

	L["[Enable] Equip specific suit when |cffffffffYou|r target lv.63 elite or lv.?? boss"] = "[启用]当|cffffffff自己|r目标是63级精英或??级Boss时，装备对应套装"
	L["Equip specific suit when more than 1 |cffffffffRaid members|r target lv.63 elite or boss"] = "当|cffffffff团队成员|r超过1人目标是63级精英或者Boss时，装备对应套装"
	L["Automatic equip Suit "..L[60].." when you leave combat"] = "离开战斗时自动切换回"..L[60].."套装"
	L["#The following options only take effect in instance"] = "#以下选项只在副本中生效"
	L["Equip Suit "..L[60].." when you target enemy under lv.63"] = "当目标为63级以下的敌方单位，装备"..L[60].."套装"
	L["Suit "..L[64]] = L[64].."套装"
	L["Suit "..L[63]] = L[63].."套装"
	L["Suit "..L[60]] = L[60].."套装"

	L["-- Equip Suit "] = "-- 装备套装"
	L["-- Set 5 items per column in dropdown list (default 4)"] = "-- 设置物品下拉框每列显示5件物品（默认4）"

	L["Help"] = "帮助(必看)"
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
	L["|cFF00FF00Locked|r all equipment buttons"] = "|cFFFF0000锁定|r全部装备栏按钮"
	L["Set threshold of member's target to "] = "将团员目标阈值设置为"

	L["Block Items:"] = "屏蔽物品:"
	L["Format - ItemID,ItemID,ItemID"] = "格式 - 物品ID,物品ID,物品ID"

	L["AutoEquip Function:"] = "自动换装功能:"
	L["Display:"] = "显示:"

	L["Enable Raid checkbox / Automatic switch to Raid queue in Instance"] = "启用Raid勾选框/副本中自动切换到Raid队列"
	L["Default"] = "默认"
	L["Don't equip suit when you target those boss"] = "面对以下Boss时不切换套装"
	L["Format - BossName,BossName,BossName"] = "格式 - Boss名字,Boss名字,Boss名字"

	L["Suit"] = "套装"
	L["Suit "] = "套装"
	L["CMD: "] = "命令行: "
	L["AutoEquip Terms"] = "自动换装条件"

	L["Equip one of the items"] = "装备以下物品之一"
	L["Target one of the Boss"] = "目标是以下Boss之一"
	L["Super Equip"] = "超级换装"
	L["Leave combat every time"] = "每次脱离战斗时"
	L["AutoEquip Rules:"] = "自动换装规则:"
	L["Copy Current Suit"] = "复制当前装备"
	L["Empty"] = "清空"
	L["Save"] = "保存"

	L["Enter the World / Leave Instance"] = "进入世界/离开副本"
    L["Enter a Raid instance"] = "进入团队副本"
    L["Enter a Party instance"] = "进入5人副本"
    L["Enter a Battleground"] = "进入战场"
    L["Lock equipment bar first"] = "换装前锁定装备栏"

    L["Takeoff"] = "一键脱装"
    L["AutoEquip |cFF00FF00ON|r/|cFFFF0000OFF|r"] = "自动换装|cFF00FF00开|r|cFFFF0000关|r"
    L["Hide quick button"] = "隐藏快捷按钮"
    L["<AutoEquip> Equiped "] = "<AutoEquip>自动装备"
    L["Raid member's target (>1)"] = "团队成员目标（大于1）"
    L["Format - ItemName,ItemName"] = "格式 - 装备名称,装备名称"
    L["Format - BossName,BossName"] = "格式 - Boss名字,Boss名字"
    L["|cFFFF0000In combat|r"] = "|cFFFF0000战斗中|r"

    L["Hide addon info in the chat box"] = "隐藏聊天框里的插件通告"
    L["Hide quick buttons"] = "隐藏快捷按钮"
    L["Disable the takeoff quick button"] = "禁用一键脱装按钮"
    L["|cFF00FF00Takeoff|r all equipments"] = "|cFF00FF00一键脱装|r"

    L["Fixed position: Priority 1 = Slot 1, Priority 2 = Slot 2"] = "固定位置: 优先1=饰品栏1, 优先2=饰品栏2"
    L["Trinket Slot:"] = "饰品栏:"

   	L["Unlock:"] = "未锁定:"
	L["Right-Click: Lock Position"] = "右键点击: 锁定位置"
	L["Left-Drag: Move Frame"] = "左键拖拽: 移动框体"
	L["Locked:"] = "锁定:"
	L["Right-Click: Cancel Aura"] = "右键点击: 取消光环"
	L["Auto-detect trinket buff"] = "自动识别饰品Buff"	
	L["Buff Alert"] = "Buff提醒"
	L["-- Reset equipment bar position"] = "-- 重置装备栏位置"

	L["Auto Acceleration Function:"] = "自动加速功能:"
	L["When |cffffffffYou|r target an |cFFFF0000enemy|r, takeoff acceleration items"] = "当|cffffffff自己|r选中|cFFFF0000敌对|r目标时脱下加速装备"
	L["When |cffffffffYou|r target a |cFF00FF00friend|r, takeoff acceleration items"] = "当|cffffffff自己|r选中|cFF00FF00友善|r目标时脱下加速装备"
	L["When |cffffffffRaid members|r target |cFFFF0000enemies|r, takeoff acceleration items"] = "当|cffffffff团队成员|r选中|cFFFF0000敌对|r目标时脱下加速装备"
	L["When equipment bar is locked, Auto Acceleration function also takes effect"] = "当装备栏锁定时，自动加速功能也生效"
	L["In Instance and Battleground, enable Auto Acceleration function"] = "在所有副本/战场中，启用自动加速功能"
	L["In TAQ, enable Auto Acceleration function"] = "在TAQ副本，启用自动加速功能"

	L["Separate Quick Button and move it separately (Need reload UI)"] = "分离快捷按钮，可以单独移动位置（需要重载UI）"
	L["Lock frame in Settings"] = "设置里锁定框架"

	L["-- Takeoff all equipments"] = "-- 一键脱装"
	L["-- Reset quick button position after separation"] = "-- 重置分离后的快捷按钮位置"

	L["Click Left button to equip trinket 1, Right button trinket 2"] = "左键点击装备到饰品栏1，右键饰品栏2"
	L["Enable Quick Equip on charactor panel (Need reload UI)"] = "启用角色面板快速换装（需要重载UI）"

	L["Tutorial:"] = "使用教程(中文):"
	L["Press Ctrl+C to copy the link. Paste it into browser and open it."] = "按Ctrl+C复制链接，粘贴到浏览器中打开。"

	L["Equipment Bar:"] = "装备栏:"
	L["More:"] = "更多:"

	L["Enable Minimap Icon (Need reload UI)"] = "启用小地图图标（需要重载UI）"
end

if locale == 'koKR' then

	L["Loaded"] = "로드됨"
	L["Enable"] = "사용"
	L["Enable AutoEquip function"] = "자동 전환 기능 켜기"
	L["Automatic switch to PVP queue in Battleground"] = "전장에서 PVP 대기열로 자동 전환"
	L["enable_carrot"] = "말타기 장비|cff1eff00[당근 달린 지팡이]|r|cff1eff00[미스릴 박차]|r|cffffffff[조련술-마부]|r（전장 / 던전에서 효과적이지 않음）"
	L["enable_swim"] = "수영 장비|cff0070dd[수력지팡이]|r|cff1eff00[감청색 비단 허리띠]|r|cff1eff00[고급 잠수용 보호모]|r（전장 / 던전에서 효과적이지 않음）"
	L["Disable Slot 2"] = "장신구2 비활성화 (최고탬을 고정으로 사용할때, 예시>\124cffa335ee\124Hitem:19379:0:0:0:0:0:0:0\124h[넬타리온의 눈물]\124h\124r)"
	L["Equip item by priority forcibly even if the item in slot is aviilable"] = "현재 장착 된 아이템이 있더라도 우선 순위에 따라 아이템을 장착해야합니다."
	L["Item queue is displayed above the Equipment Bar"] = "장비 바 위에 아이템 대기열이 표시됩니다"
	L["In combat |cFF00FF00shift + left-click|r equipment button to display the items list"] = "전투중|cFF00FF00장비 버튼을 Shift+좌클릭|r하여 이이탬 록록 표시"
	L["Show simple tooltip (only item name)"] = "간단한 툴팁 표시（아이템 이름만）"
	L["Equip |cff0070dd[Onyxia Scale Cloak]|r when entering |cffffffffNefarian's Lair|r"] = "|cffffffff<네파리안의 둥지>|r에 들어갈 때 |cff0070dd[오닉시아 비늘 망토]|r 착용"
	L["Remind on Raid channel when auto-equiped |cff0070dd[Onyxia Scale Cloak]|r"] = "|cff0070dd[오닉시아 비늘 망토]|r자동장착시 공격대 채널에서 알림"

	L["#Don't change cloak when you are in Nefarian's Lair"] = "#네파리안의 둥지에 들어가면 망토 바꾸지 않는다"

	L["Expand Settings"] = "설정옵션목록"

	L["Reload UI"] = "리로드 UI"
	L["#When the equippable items you carry have changed"] = "#착용장비가 변경되었을 때"

	L["Usable Trinkets:"] = "사용 장신구:"
	L["Resident Trinkets:"] = "고정 장신구:"
	
	L["No. "] = "우선순위"
	L["Priority "] = "선순위"
	L["Slot "] = "장신구 자리"

	L["Trinkets"] = "장신구"
	L["Usable "] = "사용효과"
	L["Backup (Be equiped when usable items are all on CD):"] = "백업 (사용 가능한 항목이 모두 CD에있을 때 장착):"

	L["<There is no suitable trinkets>"] = "<적합한 장신구 없음>"
	L["<Select a trinket>"] = "<장신구 선택>"

	L["AutoEquip: |cFF00FF00Enabled|r"] = "AutoEquip: |cFF00FF00사용|r"
	L["AutoEquip: |cFFFF0000Disabled|r"] = "AutoEquip: |cFFFF0000사용안함|r"

	L[" Lock frame"] = " 위치장금"
	L["Lock frame"] = "위치 잠금"
	L[" Settings"] = "설정 열기"
	L[" Close"] = " 닫기"
	L["Enable Equipment Bar"] = "장비 바 켜기"
	L["Enable Buff Alert"] = "버프 알림 켜기"

	L["|cFF00FF00Enabled|r"] = "|cFF00FF00켜기|r"
	L["|cFFFF0000Disabled|r"] = "|cFFFF0000끄기|r"
	L["PVP queue "] = " PVP 대기열"

	L["Custom Buff Alert:"] = "자체 정의 버프 알림:"
	L["Format - BuffName,BuffName,BuffName"] = "양식 - 버프이름,버프이름,버프이름"
	L["Append Usable Items (not only trinket):"] = "사용효과 장비 추가 (반지/장신구 외에도):"
	L["Unidentified usable items need to be added manually by yourself"] = "인식되지 않는 장비는 수동으로 추가해야합니다."
	L["Format - ItemID/BuffTime,ItemID/BuffTime"] = "양식 - 물품ID/버프지속시간,물품ID/버프지속시간"
	L["Submit"] = "제출"
	L["Save & Reload UI"] = "저장 및 리로드"

	L["Command (/aq /autoequip are valid):"] = "명령어（/aq /autoequip 사용가능）:"
	L["Advanced Settings:"] = "고급설정:"
	L["DRAG"] = "拖拽"
	L[" Enable PVP queue"] = " PVP 대기열 켜기"

	L["-- Enable/disable AutoEquip function"] = "-- AutoEquip 기능 켜기/끄기"
	L["-- Open settings"] = "-- 설정 페이지 열기"
	L["-- Enable/disable PVP queue manually"] = "-- PVP 대기열을 수동으로 켜기/끄기"
	L["-- Unlock Equipment Bar (AutoEquip function is invalid when locked)"] = "-- 장비 바 잠금 해제（잠긴 경우 AutoEquip 기능은 작동하지 않습니다.）"
	L["-- Lock Equipment Bar"] = "-- 장비 바의 모든 버튼 잠금"
	L["-- Customize equipment bar (enter 0 to disable)"] = "-- 사용자설정 장비 바（비사용 0 입력）"
	L["-- Hide the usable items queue (hide 1, show 0)"] = "-- 사용가능 아이템 대기열 숨기기 (1 숨기기, 0 표시)"
	L["-- Set equipment button spacing to 1 (default 3)"] = "-- 장비 버튼 간격을 1 (기본값 3)로 설정"
	L["-- Set threshold of member's target to 3 (default 1)"] = "-- 구성원 대상의 임계 값을 3으로 설정 (기본값 1)"
	L["-- Hide equipment bar outside Instance (show 0)"] = "-- 인던 외부에서는 장비 버튼 숨기기（0 표시）"


	L["1. Equip item manually through the Equipment Bar will temporarily lock the button."] = "1. 장비 바를 통해 수동으로 장비 변경할 시 해당 버튼이 일시적으로 잠 깁니다."
	L["2. Right click or use the '/ae unlock' command will unlock the button."] = "2. 버튼 장금해제 - 마우스 오른쪽버튼 클릭 또는, /ae unlock 을 입력."
	L["3. Before using item, the button will be unlocked automatically."] = "3. 해당 아이템을 사용 후에 잠금이 자동 해제 됩니다."
	L["4. AutoEquip/Equipment Bar/Buff Alert can be enabled/disabled independently."] = "4. 자동 변경, 장비 바, 버프 알림, 세 가지 기능을 독립적으로 켜기/끄기 할 수 있습니다."

	L["Unstable Power, Mind Quickening"] = "불안정한 마력,사고 촉진"

	L["Zoom"] = "확대"
	L["Queue:"] = "대열:"
	L["Slot:"] = "장비란:"
	L["Hide black translucent border"] = "검정 반투명 테두리 숨김"
	L["#Effective after ENTER"] = "#ENTER 이후 유효"
	L["Hide tooltip when the mouse moves over the button"] = "마우스가 버튼 위로 이동할 때 툴팁 숨기기"
	L["[Empty]"] = "[빈칸]"
	L['Trinket Slot '] = "장신구 란"
	L["Equipment Bar Button"] = "장비 바 버튼"

	L["Head"] = "머리"
	L["Neck"] = "목걸이"
	L["Shoulder"] = "어께"
	L["Chest"] = "가슴"
	L["Waist"] = "허리띠"
	L["Legs"] = "다리"
	L["Feet"] = "발"
	L["Wrist"] = "손목"
	L["Hands"] = "장갑"
	L["Finger "] = "반지"
	L["Trinket "] = "장신구"
	L["Back"] = "망토"
	L["MainHand"] = "장장비"
	L["OffHand"] = "보조장비"
	L["Ranged"] = "원거리"

	L[60] = color("00FF00", "일반")
	L[63] = color("FF4500", "Lv.63 정예")

	L["General"] = "일반설정"
	L["Suit for 63+"] = "63+세트"
	L["Usable Queue"] = "능동 대열"

	L["[Enable] Equip customized suit when you target lv.63 elite or lv.?? boss"] = "[사용]목표가 63 레벨 엘리트 또는 보스 인 경우 사용자세팅 장비를 착용합니다."
	L["Equip suit when more than 1 raid members target lv.63 elite or boss"] = "팀원 중 1 명 이상이 레벨 63 엘리트 또는 보스를 목표로 할 때 장비 세트를 착용하십시오."
	L["Automatic equip Suit "..L[60].." when you leave combat"] = "전장으로 떠날때 "..L[60].."장비 세트 장착"
	L["#The following options only take effect in instance"] = "#다음 옵션은 인던에서만 적용됩니다."
	L["Equip Suit "..L[60].." when you target enemy under lv.63"] = "Lv.63 이하 적을 목표로 할 때"..L[60].."착용 세트"
	L["Suit "..L[64]] = L[64].."세트"
	L["Suit "..L[63]] = L[63].."세트"
	L["Suit "..L[60]] = L[60].."세트"

	L["-- Equip Suit "] = "-- 장비 세트"
	L["-- Set 5 items per column in dropdown list (default 4)"] = "-- 드롭 다운 목록에서 열당 5 개 항목 설정 (기본값 4)"

	L["Help"] = "도움말 (필수)"
	L["#The above selections will take effect after reloading UI"] = "# 위의 선택은 UI를 다시로드 한 후에 적용됩니다."

	L["Go to 'General' page and add the unidentified usable items manually"] = "인식되지 않는 활성 장비를 수동으로 추가하려면 [일반 설정]페이지로 이동하십시오."
	L["Not only trinkets, any equippable usable item is acceptable"] = "액세서리뿐만 아니라 모든 활성 장비를 추가 할 수 있습니다."

	L["Custom equipment bar was |cFFFF0000CANCELED|r."] = " 사용자 지정 장비 바가 |cFFFF0000취소됨|r。"
	L[" Please reload UI manually (/reload)."] = "UI를 리로드 하셔야합니다. 진행해주세요.（/reload or /rl）。"
	L["Custom equipment bar |cFF00FF00SUCCESS|r."] = " 사용자 지정 장비 바가|cFF00FF00저장|r 되었습니다.。"

	L["Equip "] = "장비"

	L["AutoEquip function |cFF00FF00Enabled|r"] = "AutoEquip 기능 |cFF00FF00사용|r"
	L["AutoEquip function |cFFFF0000Disabled|r"] = "AutoEquip 기능|cFFFF0000끄기|r"

	L["|cFFFF0000Disable|r  the display of item list when moseover"] = "마우스오버시 장비목록 보여주기 :|cFFFF0000끄기|r"
	L["|cFF00FF00Enable|r the display of item list when moseover"] = "마우스오버시 장비 목록 표시 |cFF00FF00사용|r"
	L["-- Disable the display of item list when moseover (enable 0)"] = "-- 마우스오버시 장비 목록 표시 끄기 (0 켜기)"
	L["Hide popup addon info at the top of screen"] = "화면 상단에 플러그인 팁 숨기기"
	L["-- Set popup info to the center of screen (default 0,320)"] = "-- 팝업 정보창 를 화면 중앙으로 설정 (기본값 0,320)"
	L["|cFF00FF00Unlocked|r all equipment buttons"] = "모든 장비 버튼 |cFFFF0000잠금해제|r"
	L["|cFF00FF00Locked|r all equipment buttons"] = "모든 장비 버튼 |cFFFF0000잠금|r"
	L["Set threshold of member's target to "] = "룹 구성원 대상 임계 값을 다음으로 설정"

	L["Block Items:"] = "차단 아이템:"
	L["Format - ItemID,ItemID,ItemID"] = "형식 - 아이템ID,아이템ID,아이템ID"

	L["AutoEquip Function:"] = "자동 변경 기능:"
	L["Display:"] = "디스플레이:"

	L["Enable Raid checkbox / Automatic switch to Raid queue in Instance"] = "RAID 확인란 켜기 / 인던에서 RAID 대기열로 자동 전환"
	L["Default"] = "기본값"
	L["Don't equip suit when you target those boss"] = "다음의 보스를 목표로 할때, 장비를 변경 안함."
	L["Format - BossName,BossName,BossName"] = "형식 - 보스이름,보스게임,보스이름"

	L["Suit"] = "세트"
	L["Suit "] = "세트 "
	L["CMD: "] = "명령형: "
	L["AutoEquip Terms"] = "자동 변경 조건"

	L["Equip one of the items"] = "다음 아이템 중 하나를 장비하십시오."
	L["Target one of the Boss"] = "목표는 다음 보스 중 하나입니다."
	L["Super Equip"] = "최고의 장비"
	L["Leave combat every time"] = "전투를 떠날 때마다"
	L["AutoEquip Rules:"] = "자동 변경 규칙:"
	L["Copy Current Suit"] = "현재 장비 복사"
	L["Empty"] = "빈칸"
	L["Save"] = "저장"

	L["Enter the World / Leave Instance"] = "월드 들어가기/ 인던 나가기"
    L["Enter a Raid instance"] = "레이드 입장"
    L["Enter a Party instance"] = "5인 인던 입장"
    L["Enter a Battleground"] = "잔장에 입장"
    L["Lock equipment bar first"] = "장비바를 먼저 잠금"

    L["Takeoff"] = "원클릭 벗기"
    L["AutoEquip |cFF00FF00ON|r/|cFFFF0000OFF|r"] = "자동 변경|cFF00FF00켜기|r/|cFFFF0000끄기|r"
    L["Hide quick button"] = "단축 버튼 숨기기"
    L["<AutoEquip> Equiped "] = "<AutoEquip> 설치됨"
    L["Raid member's target (>1)"] = true
    L["Format - ItemName,ItemName"] = "형식 - 장비명,장비명"
    L["Format - BossName,BossName"] = "형식 - 보스이름,보스이름"
    L["|cFFFF0000In combat|r"] = "|cFFFF0000전투중|r"

    L["Hide addon info in the chat box"] = "채팅창에서 플러그인 알림 숨김"
    L["Hide quick buttons"] = "퀵 버튼 버튼 숨기기"
    L["Disable the takeoff quick button"] = "원클릭 장비벗기 버튼 사용안함"
    L["|cFF00FF00Takeoff|r all equipments"] = "|cFF00FF00모든 장비 벗기|r"

    L["Fixed position: Priority 1 = Slot 1, Priority 2 = Slot 2"] = "고정 위치: 우선순위 1 = 장신구 1, 우선순위 2 = 장신구 2"
    L["Trinket Slot:"] = "장신구 자리"

   	L["Unlock:"] = "잠금해제:"
	L["Right-Click: Lock Position"] = "오른쪽 클릭 : 위치 잠금"
	L["Left-Drag: Move Frame"] = "왼쪽 클릭 드래그 : 프레임 이동"
	L["Locked:"] = "잠금:"
	L["Right-Click: Cancel Aura"] = "오른쪽 클릭 : 오라 취소"
	L["Auto-detect trinket buff"] = "장신구 버프 자동 감지"	
	L["Buff Alert"] = "버프 알림"
	L["-- Reset equipment bar position"] = "-- 장비 슬롯 위치 재설정"

	L["Auto Acceleration Function:"] = "이속장비 자동착용 기능:"
	L["Takeoff [Acceleration Items] when |cffffffffYou|r target an enemy"] = "|cffffffff자신이|r 적대적인 목표를 타겟으로하면 [이속아이템]을 벗는다."
	L["Takeoff [Acceleration Items] when |cffffffffRaid members|r target enemies"] = "|cffffffff레이드 팀원이|r 적을 목표로하면 [이속 아이템]을 벗는다."
	L["When equipment bar is locked, those 2 functions also take effect"] = "장비 바가 잠기도 위의 두 기능도 적용."
	L["In Instance and Battleground, enable those 2 functions"] = "인던 및 전장에서 이 두 기능을 적용."
	L["In TAQ, enable Riding Acceleration function"] = "안퀴라즈 던전에서 위의 2 가지 기능을 적용."

	L["Separate Quick Button and move it separately (Nedd reload UI)"] = "[퀵 버튼]을 분리하여 사용할 수 있습니다. |cffffffff(UI 리로드 필요)|r"
	L["Lock frame in Settings"] = "설정 프레임을 잠금"

	L["-- Takeoff all equipments"] = "-- 모든장비 벗기"
	L["-- Reset quick button position after separation"] = "-- 분리된 단축 버튼 위치 재설정"

	L["Click Left button to equip trinket 1, Right button trinket 2"] = "왼쪽 버튼 클릭으로 장신구 1, 오른쪽 버튼 장신구 2 착용 합니다."
	L["Enable Quick Equip on charactor panel (Nedd reload UI)"] = " 특정패널을 가동하여 빠른 장착 사용.|cffffffff(UI 리로드 필요)|r"
end