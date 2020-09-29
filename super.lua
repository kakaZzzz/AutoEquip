local _, SELFAQ = ...

local debug = SELFAQ.debug
local clone = SELFAQ.clone
local diff = SELFAQ.diff
local L = SELFAQ.L
local GetItemLink = SELFAQ.GetItemLink
local GetItemEquipLoc = SELFAQ.GetItemEquipLoc

local GetSlotID = SELFAQ.GetSlotID
local player = SELFAQ.player
local chatInfo = SELFAQ.chatInfo
local popupInfo = SELFAQ.popupInfo
local AddonEquipItemByName = SELFAQ.AddonEquipItemByName
local color = SELFAQ.color


-- 设置菜单初始化
function SELFAQ.superInit()

    if SELFAQ.superOption ~= nil then
        return
    end
    
    local p = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate")
    local f = CreateFrame("Frame", nil, p)

    SELFAQ.superOption = f
    f.checkbox = {}
    f.dropdown = {
        [63] = {},
        [64] = {},
        [60] = {}
    }

    p.name = L["Super Equip"]
    p.parent = "AutoEquip"

    local current = 1

    local hold = {}

    SELFAQ.takeoffAll = function()
        
        for k,v in pairs(SELFAQ.takeoffSlots) do

            local id = GetInventoryItemID("player", v)

            if id then

                SELFAQ.takeoffOne(v)

            end
        end
    end

    SELFAQ.takeoffOne = function(slot)

        for i=0,NUM_BAG_SLOTS do
            local count = GetContainerNumSlots(i)

            for s=1,count do

                local index = i*100 +s

                if not GetContainerItemInfo(i,s) and not hold[index] then
                    debug(slot)
                    PickupInventoryItem(slot)
                    if i == 0 then
                        PutItemInBackpack();
                    else
                        PutItemInBag(i + 19);
                    end

                    hold[index] = true

                    C_Timer.After(1.0, function()
                        hold[index] = nil
                    end)

                    return
                end
            end
        end

    end

    SELFAQ.superEquipSuit = function(number)

        if SELFAQ.playerCanEquip()  then

        else
            chatInfo(L["|cFFFF0000In combat|r"])
            popupInfo(L["|cFFFF0000In combat|r"])
            debug(number)
            return
        end

        if SUITAQ[number]["enable"] then

            if tContains(SELFAQ.matchSuit, number) then
                -- debug("已装备")
                return
            end

            for k,v in pairs(SELFAQ.items) do

                if SUITAQ[number]["slot"..k] and SUITAQ[number]["slot"..k] > 0 then

                    if k == 15 and SELFAQ.isNefNest() then
                        -- 奈法房间，披风位置
                    else

                        if SUITAQ[number]["enableLock"] then
                            SELFAQ.equipWait(SUITAQ[number]["slot"..k], k, false)
                        else
                            SELFAQ.equipByID (SUITAQ[number]["slot"..k], k, false)
                        end

                    end

                end

            end

        else
            chatInfo(L["Suit "]..number..L[" disabled"])
            popupInfo(L["Suit "]..number..L[" disabled"])

        end

    end

    SELFAQ.checkSuperSuit = function()

        wipe(SELFAQ.matchSuit)

        for i=1,9 do

            if SUITAQ[i]["enable"] then

                local match = true
                local empty = true

                for k,v in pairs(SELFAQ.items) do

                    if SUITAQ[i]["slot"..k] and SUITAQ[i]["slot"..k] > 0 then

                        empty = false

                        local id = GetInventoryItemID("player", k)

                        if id ~= SELFAQ.reverseId(SUITAQ[i]["slot"..k]) then
                            match = false
                        end

                    end

                end

                if match and not empty then
                    if not SELFAQ.qbs[i]['hl'] then
                        SELFAQ.qbs[i]:LockHighlight()
                        SELFAQ.qbs[i]['hl'] = true

                        if SUITAQ[i]["note"] ~= "" and SUITAQ[i]["note"] ~= nil then
                            chatInfo(color("00FF00", SUITAQ[i]["note"]))
                            popupInfo(color("00FF00", SUITAQ[i]["note"]))
                        else
                            chatInfo(color("00FF00", L["Suit "]..i))
                            popupInfo(color("00FF00", L["Suit "]..i))
                        end

                        
                    end
                    table.insert(SELFAQ.matchSuit, i)
                else
                    if SELFAQ.qbs[i]['hl'] then
                        SELFAQ.qbs[i]:UnlockHighlight()
                        SELFAQ.qbs[i]['hl'] = false
                    end
                end

            end
        end

        return matchSuit

    end

    SELFAQ.runEquipmentRules = function()

        -- 缓存身上的装备
        local equipments = {}

        for k,v in pairs(SELFAQ.items) do
            local id = GetInventoryItemID("player", k)

            if id and id > 0 then
                local name = GetItemInfo(id)
                table.insert(equipments, name)
            end
        end

        -- 检查换装规则
        for k,v in pairs(SUITAQ) do
            
            if v["enable"] and v["enableEquipment"] then

                for k1,name in pairs(equipments) do
                    
                    if strfind(v["itemText"], name) then
                        -- if not tContains(matchSuit, k) then
                            SELFAQ.superEquipSuit(k)
                            return
                        -- end
                    end
                end

            end

        end

    end

    SELFAQ.runLeaveCombatRules = function()

        -- 检查换装规则
        for k,v in pairs(SUITAQ) do
            
            if v["enable"] and v["enableLeaveCombat"] then

                SELFAQ.superEquipSuit(k)
                return

            end

        end

    end

    SELFAQ.runEnterRules = function()

        local inInstance, instanceType = IsInInstance()

        for k,v in pairs(SUITAQ) do

            if v["enable"] then
            
                -- 进入世界
                if not inInstance and v["enableWorld"] then
                    SELFAQ.superEquipSuit(k)
                    return
                end

                -- 进入战场
                if instanceType == "pvp" and v["enableBattleground"] then
                    SELFAQ.superEquipSuit(k)
                    return
                end

                -- 进入团本
                if instanceType == "raid" and v["enableRaid"] then
                    SELFAQ.superEquipSuit(k)
                    return
                end

                -- 进入5人本
                if instanceType == "party" and v["enableParty"] then
                    SELFAQ.superEquipSuit(k)
                    return
                end

            end

        end

    end

    SELFAQ.checkTargetRules = function(target)

        local level = UnitLevel(target)

        -- if level ~= -1 then
        --     -- 不是boss
        --     return false
        -- end

        if UnitIsFriend("player", target) or UnitIsDead(target) then
            -- 目标友好，或者死了
            return false
        end

        local name = GetUnitName(target)

        if not name then
            return
        end

        -- 检查换装规则
        for k,v in pairs(SUITAQ) do
            
            if v["enableTarget"] then
                    
                    if strfind(v["bossText"], name) then
                        -- if not tContains(matchSuit, k) then
                            debug(name)
                            return k
                        -- end
                    end

            end

        end

        return false
    end

    SELFAQ.checkTargetMemberRules = function(target)

        local level = UnitLevel(target)

        -- if level ~= -1 then
        --     -- 不是boss
        --     return false
        -- end

        if UnitIsFriend("player", target) or UnitIsDead(target) then
            -- 目标友好，或者死了
            return false
        end

        local name = GetUnitName(target)

        if not name then
            return
        end

        -- 检查换装规则
        for k,v in pairs(SUITAQ) do
            
            if v["enableTargetMember"] then
                    
                    if strfind(v["bossText"], name) then
                        -- if not tContains(matchSuit, k) then
                            debug(name)
                            return k
                        -- end
                    end

            end

        end

        return false
    end

    function SELFAQ.runTargetMemberRules()

        if not SELFAQ.haveTargetMember then
            return
        end

        if not SELFAQ.inInstance() then
            return
        end

        if not UnitInRaid("player") then
            return
        end

        wipe(SELFAQ.memberTargets)

        -- print(SELFAQ.needSuit)
        
        if UnitInRaid("player") then

            for i=1,MAX_RAID_MEMBERS  do
                
                local name = GetRaidRosterInfo(i)
                local target = "raid"..i.."target"

                local boss = GetUnitName(target)

                -- 如果有成员
                if name and UnitLevel(target) == -1 and not UnitIsDead(target)  then

                    local boss = GetUnitName(target)

                    if SELFAQ.memberTargets[boss] == nil then
                        SELFAQ.memberTargets[boss] = 1
                    else
                        SELFAQ.memberTargets[boss] = SELFAQ.memberTargets[boss] + 1
                    end

                end

            end

        end

        for k,v in pairs(SELFAQ.memberTargets) do
            
            -- 团员目标大于1
            if v > AQSV.raidTargetThreshold then

                -- 检查换装规则
                for k1,v1 in pairs(SUITAQ) do
                    
                    if v1["enable"] and v1["enableTarget"] and v1["enableTargetMember"] then
                            
                            if strfind(v1["bossText"], k) then

                                -- debug(k)
                                -- debug(v)
                                -- debug(k1)
                                
                                SELFAQ.superEquipSuit(k1)

                                return k1
                            end

                    end

                end

            end

        end


    end

    SELFAQ.updatePage = function()
        
        local c = {
            "enable",
            "enableEquipment",
            "enableTarget",
            "enableLeaveCombat",
            "enableWorld",
            "enableRaid",
            "enableParty",
            "enableBattleground",
            "enableLock",
            "enableTargetMember",
        }

        for k,v in pairs(c) do
            f.checkbox[v]:SetChecked(SUITAQ[current][v])
        end

        if SUITAQ[current]["enableTarget"] then
            f.checkbox["enableTargetMember"]:Enable()
        else
            f.checkbox["enableTargetMember"]:Disable()
        end

         if SUITAQ[current]["note"] == nil then
            SUITAQ[current]["note"] = ""
        end
        f.note:SetText(strtrim(SUITAQ[current]["note"]))
        f.note:SetText(strtrim(SUITAQ[current]["note"]))

        if SUITAQ[current]["itemText"] == nil then
            SUITAQ[current]["itemText"] = ""
        end
        f.itemBox:SetText(SUITAQ[current]["itemText"])

        if SUITAQ[current]["bossText"] == nil then
            SUITAQ[current]["bossText"] = ""
        end
        f.bossBox:SetText(SUITAQ[current]["bossText"])

        for k,v in pairs(SELFAQ.items) do
            UIDropDownMenu_SetSelectedValue(f.dropdown[k], SUITAQ[current]["slot"..k], 0)
            UIDropDownMenu_SetText(f.dropdown[k], GetItemLink(SUITAQ[current]["slot"..k])) 
        end

        SELFAQ.haveTargetMember = false

        for k,v in pairs(SUITAQ) do
            if v['enableTarget'] and v['enableTargetMember'] then
                SELFAQ.haveTargetMember = true
            end
        end

    end

    function buildCheckbox(text, key, pos, x)

        local posX = 20

        if x ~= nil then
            posX = x
        end

        local b = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        b:SetPoint("TOPLEFT", f, posX, pos)
        -- b:SetChecked(SUITAQ[current][key])

        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
        b.text:SetText(text)
        b:SetScript("OnClick", function()
            SUITAQ[current][key] = not SUITAQ[current][key]
            b:SetChecked(SUITAQ[current][key])

            if key == "enable" then
                debug("render")
                SELFAQ.renderQuickButton()
            end

            SELFAQ.updatePage()
        end)

        f.checkbox[key] = b
    end


    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        t:SetText(L["Suit"])
        t:SetPoint("TOPLEFT", f, 25, -30)
    end

    do

        function Suit_Init(self,level)
            level = level or 1;
            if (level == 1) then
                for i=1,9 do
                    
                    local number = i

                    local info = UIDropDownMenu_CreateInfo();
                   info.text = " "..number
                   info.value = number

                   info.func = function( frame )
                        current = number
                        UIDropDownMenu_SetSelectedValue(f.suitDropdown, number, 0)
                        UIDropDownMenu_SetText(f.suitDropdown, " "..number) 

                        -- 更新页面中的数据
                        SELFAQ.updatePage()
                   end

                   UIDropDownMenu_AddButton(info, level)

                   -- 初始化缓存
                   if SUITAQ[number] == nil then
                        SUITAQ[number] = {}
                    end

                    -- 默认锁定
                    if SUITAQ[number]["enableLock"] == nil then
                        SUITAQ[number]["enableLock"] = true
                    end

                end
            end
        end

        local dropdown = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate")

        dropdown:SetPoint("TOPLEFT", 50, -25)

        f.suitDropdown = dropdown

        UIDropDownMenu_SetButtonWidth(dropdown, 70)
        UIDropDownMenu_Initialize(dropdown, Suit_Init)

        -- 默认显示第一套
        UIDropDownMenu_SetSelectedValue(dropdown, 1, 0)
        UIDropDownMenu_SetText(dropdown, " 1")
        
        UIDropDownMenu_SetWidth(dropdown, 70)
        UIDropDownMenu_JustifyText(dropdown, "LEFT")

    end

    buildCheckbox(L["Enable"], "enable", -23, 180)

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["Note"])
        t:SetPoint("TOPLEFT", f, 25, -60)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["#Effective after ENTER"])
        t:SetPoint("TOPLEFT", f, 210, -60)
    end

    do
        local e = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
        f.note = e

        e:SetFontObject("GameFontHighlight")
        e:SetWidth(130)
        e:SetHeight(40)
        e:SetMultiLine(true)
        -- e:SetJustifyH("")
        e:SetPoint("TOPLEFT", f, 73,  -60)
        e:SetAutoFocus(false)
        e:SetText("dfd")
        e:SetCursorPosition(0)

        e:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()

            local v = self:GetText()

            SUITAQ[current]["note"] = strtrim(v)

        end)
    end

    buildCheckbox(L["Lock equipment bar first"], "enableLock", -83)

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["CMD: "].."/ae ".."1")
        t:SetPoint("TOPLEFT", f, 25, -120)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        t:SetText(SELFAQ.color("FF4500", L["AutoEquip Rules:"]))
        t:SetPoint("TOPLEFT", f, 25, -160)
    end

    local leftHight = -200

    buildCheckbox(L["Equip one of the items"], "enableEquipment", leftHight)

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Format - ItemName,ItemName"])
        t:SetPoint("TOPLEFT", f, 25, leftHight-35)
    end

    do

        local s = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate") -- or you actual parent instead
        s:SetSize(250,60)
        s:SetPoint("TOPLEFT", f, 26, leftHight-65)
        s:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 2});
        s:SetBackdropBorderColor(1,1,1,0.7);
        local e = CreateFrame("EditBox", nil, s)
        e:SetMultiLine(true)
        e:SetFontObject("GameFontHighlight")
        e:SetWidth(250)
        -- e:SetText(AQSV.ignoreBoss)
        e:SetTextInsets(8,8,8,8)
        e:SetAutoFocus(false)

        s:SetScrollChild(e)

        f.itemBox = e

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Save"])
        b:SetWidth(80)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 25, leftHight-133)
        b:SetScript("OnClick", function(self)
            SUITAQ[current]["itemText"] = e:GetText()
        end)
    end

    leftHight = -395

    buildCheckbox(L["Target one of the Boss"], "enableTarget", leftHight)
    buildCheckbox(L["Raid member's target (>1)"], "enableTargetMember", leftHight-35)

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Format - BossName,BossName"])
        t:SetPoint("TOPLEFT", f, 25, leftHight-35-35)
    end

    do

        local s = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate") -- or you actual parent instead
        s:SetSize(250,60)
        s:SetPoint("TOPLEFT", f, 26, leftHight-65-35)
        s:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 2});
        s:SetBackdropBorderColor(1,1,1,0.7);
        local e = CreateFrame("EditBox", nil, s)
        e:SetMultiLine(true)
        e:SetFontObject("GameFontHighlight")
        e:SetWidth(250)
        -- e:SetText(AQSV.ignoreBoss)
        e:SetTextInsets(8,8,8,8)
        e:SetAutoFocus(false)

        s:SetScrollChild(e)

        f.bossBox = e

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Save"])
        b:SetWidth(80)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 25, leftHight-133-35)
        b:SetScript("OnClick", function(self)
            SUITAQ[current]["bossText"] = e:GetText()
        end)
    end

    leftHight = -540-35-30

    buildCheckbox(L["Leave combat every time"], "enableLeaveCombat", leftHight)
    buildCheckbox(L["Enter the world"], "enableWorld", leftHight-25)
    buildCheckbox(L["Enter a Raid instance"], "enableRaid", leftHight-50)
    buildCheckbox(L["Enter a Party instance"], "enableParty", leftHight-75)
    buildCheckbox(L["Enter a Battleground"], "enableBattleground", leftHight-100)

    function DropDown_Initialize(self,level)
        level = level or 1;
        if (level == 1) then
         for k, v in pairs(self.items) do
           local info = UIDropDownMenu_CreateInfo();
           -- info.hasArrow = true; -- creates submenu
           info.text = GetItemLink(v);
           info.value = v

            local index = self.index
            local key = k
            local boss = self.boss

           info.func = function( frame )

                SUITAQ[current]["slot"..index] = v
                UIDropDownMenu_SetSelectedValue(f.dropdown[index], v, 0)
                UIDropDownMenu_SetText(f.dropdown[index], GetItemLink(v)) 
            end

           UIDropDownMenu_AddButton(info, level);
         end 
        end
    end

    function buildLine( boss, v, k, height )
        local dropdown = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate")
        local left = 333

        dropdown:SetPoint("TOPLEFT", left, height)
        -- 保存当前选项序号
        dropdown.index = k
        dropdown.items = v
        dropdown.boss = boss
        -- 缓存到父框架中，供后续调用
        f.dropdown[k] = dropdown

        UIDropDownMenu_SetButtonWidth(dropdown, 160)
        UIDropDownMenu_Initialize(dropdown, DropDown_Initialize)
        
        -- 检查保存的装备是否在身上
        if not tContains(v, SUITAQ[current]["slot"..k]) then
            SUITAQ[current]["slot"..k] = 0
        end

        UIDropDownMenu_SetSelectedValue(dropdown, SUITAQ[current]["slot"..k], 0)
        UIDropDownMenu_SetText(dropdown, GetItemLink(SUITAQ[current]["slot"..k])) 
        
        
        UIDropDownMenu_SetWidth(dropdown, 130)
        UIDropDownMenu_JustifyText(dropdown, "LEFT")
    end

    local height = -90
    local lastHeight = 0

    -- 复制装备按钮
    do
        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Copy Current Suit"])
        b:SetWidth(160)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 349, -30)
        b:SetScript("OnClick", function(self)
            for k,v in pairs(SELFAQ.items) do

                local id = GetInventoryItemID("player", k)

                if id then
                    UIDropDownMenu_SetSelectedValue(f.dropdown[k], id, 0)
                    UIDropDownMenu_SetText(f.dropdown[k], GetItemLink(id)) 

                    SUITAQ[current]["slot"..k] = id
                end
            end
        end)
    end

    -- 复制装备按钮
    do
        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Empty"])
        b:SetWidth(80)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 349, -70)
        b:SetScript("OnClick", function(self)
            for k,v in pairs(SELFAQ.items) do
                UIDropDownMenu_SetSelectedValue(f.dropdown[k], 0, 0)
                UIDropDownMenu_SetText(f.dropdown[k], GetItemLink(0)) 

                SUITAQ[current]["slot"..k] = 0
            end
        end)
    end

    -- 右侧装备栏
    for k,v in pairs(SELFAQ.items) do

        local heightK = k

        if heightK > 4 then
            heightK = heightK -1
        end

        local l = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        l:SetText(SELFAQ.slotToName[k])
        l:SetPoint("TOPLEFT", f, 515, height - heightK*35)

        buildLine(60, v, k, height + 5 - heightK*35)

        -- 保存最后一个下拉框的位置
        lastHeight = height - heightK*35
    end

    -- 初始化页面选择
    SELFAQ.updatePage()


    f:SetAllPoints(p)
    p:SetScrollChild(f)
    f:SetSize(1000, -lastHeight)

    InterfaceOptions_AddCategory(p)

    -- 运行两遍才行
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
end