local _, SELFAQ = ...

local debug = SELFAQ.debug
local clone = SELFAQ.clone
local diff = SELFAQ.diff
local L = SELFAQ.L
local GetItemLink = SELFAQ.GetItemLink
local player = SELFAQ.player

-- 设置菜单初始化
function SELFAQ.settingInit()

    if SELFAQ.f ~= nil then
        return
    end

    local top = CreateFrame("Frame", nil, UIParent)

    local p = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate")
    local f = CreateFrame("Frame", nil, p)

    local queueOption = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate")
    local queueFrame = CreateFrame("Frame", nil, queueOption)

    local helpOption = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate")
    local helpFrame = CreateFrame("Frame", nil, helpOption)
    
    SELFAQ.general = p
    SELFAQ.f = f

    SELFAQ.queueOption = queueOption
    SELFAQ.queueFrame = queueFrame

    SELFAQ.helpOption = helpOption
    SELFAQ.helpFrame = helpFrame

    top.name = "AutoEquip"

    p.name = L["General"]
    p.parent = "AutoEquip"

    queueOption.name = L["Usable Queue"]
    queueOption.parent = "AutoEquip"

    helpOption.name = L["Help"]
    helpOption.parent = "AutoEquip"

    SELFAQ.lastHeight = -475
    SELFAQ.lastHeightQueue = -30
    SELFAQ.lastHeightHelp = 30

    -- 缓存主动饰品下拉框
    f.dropdown = {}
    -- 缓存常驻饰品下拉框
    f.resident = {}
    -- 缓存单选框
    f.checkbox = {}
    f.pveCheckbox = {}
    f.pvpCheckbox = {}
    f.raidCheckbox = {}
    f.queue13 = {}
    f.queue14 = {}

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        t:SetText(L["AutoEquip "]..SELFAQ.version)
        t:SetPoint("TOPLEFT", f, 25, -20)
    end

    do
        local t = top:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        t:SetText(L["AutoEquip "]..SELFAQ.version)
        t:SetPoint("TOPLEFT", top, 25, -20)
    end

    local 
        b = CreateFrame("Button", nil, top, "GameMenuButtonTemplate")
        b:SetText(L["Expand Settings"])
        b:SetWidth(140)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", top, 23, -60)
        b:SetScript("OnClick", function(self)
            InterfaceOptionsFrame_OpenToCategory(p);
            InterfaceOptionsFrame_OpenToCategory(p);
    end)

    do
        local t = top:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        t:SetText(L["Feedback and Bug report:"])
        t:SetPoint("TOPLEFT", top, 25, -115)
    end

    do
        local t = top:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["NGA: https://bbs.nga.cn/read.php?tid=21494303"])
        t:SetPoint("TOPLEFT", top, 25, -140)
    end

    do
        local t = top:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Github: https://github.com/lanyu7/AutoEquip"])
        t:SetPoint("TOPLEFT", top, 25, -165)
    end

    do
        local t = top:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["CurseForge:  https://curseforge.com/wow/addons/autoequip-classic"])
        t:SetPoint("TOPLEFT", top, 25, -190)
    end

    -- 构建主动饰品组
    function DropDown_Initialize(self,level)
        level = level or 1;
        if (level == 1) then
            local slot_id = self.slot
         for k, v in ipairs(AQSV.usableItems[slot_id]) do
           local info = UIDropDownMenu_CreateInfo();
           -- info.hasArrow = true; -- creates submenu
           info.text = GetItemLink(v);
           info.value = v

            local index = self.index
            local key = k

           info.func = function( frame )
                -- 选择的不是当前顺序的饰品
                if index ~= key then
                    -- 交换数据table中两个饰品的顺序
                    local value = AQSV.usableItems[slot_id][key]
                    AQSV.usableItems[slot_id][key] = AQSV.usableItems[slot_id][index]
                    AQSV.usableItems[slot_id][index] = value

                    -- 根据新的数据table更新选中状态
                    for k,v in ipairs(AQSV.usableItems[slot_id]) do
                        UIDropDownMenu_SetSelectedValue(f.dropdown[slot_id][k], v, 0)
                        UIDropDownMenu_SetText(f.dropdown[slot_id][k], GetItemLink(v)) 
                        f.pveCheckbox[slot_id][k]:SetChecked(AQSV.pveTrinkets[v])
                        f.pvpCheckbox[slot_id][k]:SetChecked(AQSV.pvpTrinkets[v])
                        f.raidCheckbox[slot_id][k]:SetChecked(AQSV.raidTrinkets[v])

                        if slot_id == 13 then
                            f.queue13[k]:SetChecked(AQSV.queue13[v])
                            f.queue14[k]:SetChecked(AQSV.queue14[v])
                        end
                    end


                end
            end
           UIDropDownMenu_AddButton(info, level);
         end 
        end
    end

    -- 构建常驻饰品组
    function Resident_Trinket_Initialize(self,level)
        level = level or 1;
        if (level == 1) then
            local slot_id = self.slot
         for k, v in ipairs(SELFAQ.items[slot_id]) do
           local info = UIDropDownMenu_CreateInfo();
           -- info.hasArrow = true; -- creates submenu
           info.text = GetItemLink(v);
           info.value = v

            local index = self.index
            local key = k
            
           info.func = function( frame )
                -- 选中现有饰品则无效
                
                if v ~= AQSV.slotStatus[slot_id].backup then
                    UIDropDownMenu_SetSelectedValue(f.resident[slot_id], v, 0)
                    UIDropDownMenu_SetText(f.resident[slot_id], GetItemLink(v)) 
                end

                if slot_id == 13 or slot_id == 14 then
                    local one = AQSV.slotStatus[slot_id].backup
                    -- 如果跟另一个饰品一样，则更换
                    if v == AQSV.slotStatus[27 - slot_id].backup and v ~= 0 then
                        UIDropDownMenu_SetSelectedValue(f.resident[27-slot_id], one, 0)
                        UIDropDownMenu_SetText(f.resident[27-slot_id], GetItemLink(one)) 
                        AQSV.slotStatus[27 - slot_id].backup = one
                    end
                end

                AQSV.slotStatus[slot_id].backup = v


                -- if v ~= AQSV.slot13 and v ~= AQSV.slot14 then
                --     UIDropDownMenu_SetSelectedValue(f.resident[index], v, 0)
                --     UIDropDownMenu_SetText(f.resident[index], GetItemLink(v)) 
                --     -- 更新数据
                --     AQSV["slot"..(12+index)] = v
                -- end
            end
           UIDropDownMenu_AddButton(info, level);
         end
        end
    end

    

    -- 构建两个饰品组
    function buildDropdownGroup(slot_id)

        if not AQSV.usableItems[slot_id] then
            return
        end

        local line = CreateFrame("Button", nil, queueFrame)

        line:SetWidth(570)
        line:SetHeight(1)
        line:SetPoint("TOPLEFT", queueFrame, 25, SELFAQ.lastHeightQueue)

        line:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"});
        line:SetBackdropColor(0.8,0.8,0.8,0.8);

        SELFAQ.lastHeightQueue = SELFAQ.lastHeightQueue - 25

        do
            local t = queueFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            t:SetFont(STANDARD_TEXT_FONT, 20)
            if slot_id == 13 then
                t:SetText(SELFAQ.color("FF4500", L["Trinkets"]))
            else
                t:SetText(SELFAQ.color("FF4500", SELFAQ.slotToName[slot_id]))
            end
            t:SetPoint("TOPLEFT", queueFrame, 25, SELFAQ.lastHeightQueue)
        end

        do
            local t = queueFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            t:SetText(L["Queue:"])
            t:SetPoint("TOPLEFT", queueFrame, 284, SELFAQ.lastHeightQueue)
        end

        if slot_id == 13 then
            do
                local t = queueFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
                t:SetText(L["Trinket Slot:"])
                t:SetPoint("TOPLEFT", queueFrame, 509, SELFAQ.lastHeightQueue)
            end
        end

        local height = 0
        f.dropdown[slot_id] = {}
        f.pveCheckbox[slot_id] = {}
        f.pvpCheckbox[slot_id] = {}
        f.raidCheckbox[slot_id] = {}
        -- 主动饰品
        for k,v in ipairs(AQSV.usableItems[slot_id]) do
            local dropdown = CreateFrame("Frame", nil, queueFrame, "UIDropDownMenuTemplate");
            dropdown:SetPoint("TOPLEFT", 100, SELFAQ.lastHeightQueue + 5 - k*35)
            -- 保存当前选项序号
            dropdown.index = k
            dropdown.slot = slot_id
            -- 缓存到父框架中，供后续调用
            f.dropdown[slot_id][k] = dropdown

            local l = queueFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            l:SetText(L["Usable "]..k)
            l:SetPoint("TOPLEFT", queueFrame, 25, SELFAQ.lastHeightQueue - k*35)

            -- 保存最后一个下拉框的位置
            height = SELFAQ.lastHeightQueue - k*35

            UIDropDownMenu_SetButtonWidth(dropdown, 130)
            UIDropDownMenu_Initialize(dropdown, DropDown_Initialize)
            UIDropDownMenu_SetSelectedValue(dropdown, v, 0)
            
            UIDropDownMenu_SetText(dropdown, GetItemLink(v)) 
            
            
            UIDropDownMenu_SetWidth(dropdown, 130)
            UIDropDownMenu_JustifyText(dropdown, "LEFT")

            -- 后面追加checkbox
            do
                local b = CreateFrame("CheckButton", nil, queueFrame, "UICheckButtonTemplate")
                b:SetPoint("TOPLEFT", 280, SELFAQ.lastHeightQueue + 7 - k*35)
                b:SetChecked(AQSV.pveTrinkets[v])
                f.pveCheckbox[slot_id][k] = b

                b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
                b.text:SetText(L["Default"])
                b.text:SetFont(STANDARD_TEXT_FONT, 12)
                b:SetScript("OnClick", function()
                    local vaule = UIDropDownMenu_GetSelectedValue(dropdown)
                    AQSV.pveTrinkets[vaule] = not AQSV.pveTrinkets[vaule]
                    b:SetChecked(AQSV.pveTrinkets[vaule])
                end)
            end

            do
                local b = CreateFrame("CheckButton", nil, queueFrame, "UICheckButtonTemplate")
                b:SetPoint("TOPLEFT", 365, SELFAQ.lastHeightQueue + 7 - k*35)
                b:SetChecked(AQSV.raidTrinkets[v])
                f.raidCheckbox[slot_id][k] = b

                b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
                b.text:SetText("Raid")
                b.text:SetFont(STANDARD_TEXT_FONT, 12)

                b.dtext = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                b.dtext:SetPoint("LEFT", b, "RIGHT", 0, 0)
                b.dtext:SetText("Raid")
                b.dtext:SetFont(STANDARD_TEXT_FONT, 12)
                b.dtext:SetTextColor(0.5,0.5,0.5,0.7)

                if AQSV.enableRaidQueue then
                    b:Enable()
                    b.dtext:Hide()
                    b.text:Show()
                else
                    b:Disable()
                    b.dtext:Show()
                    b.text:Hide()
                end

                b:SetScript("OnClick", function()
                    local vaule = UIDropDownMenu_GetSelectedValue(dropdown)
                    AQSV.raidTrinkets[vaule] = not AQSV.raidTrinkets[vaule]
                    b:SetChecked(AQSV.raidTrinkets[vaule])
                end)
            end

            do
                local b = CreateFrame("CheckButton", nil, queueFrame, "UICheckButtonTemplate")
                b:SetPoint("TOPLEFT", 435, SELFAQ.lastHeightQueue + 7 - k*35)
                b:SetChecked(AQSV.pvpTrinkets[v])
                f.pvpCheckbox[slot_id][k] = b

                b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
                b.text:SetText("PVP")
                b.text:SetFont(STANDARD_TEXT_FONT, 12)
                b:SetScript("OnClick", function()
                    local vaule = UIDropDownMenu_GetSelectedValue(dropdown)
                    AQSV.pvpTrinkets[vaule] = not AQSV.pvpTrinkets[vaule]
                    b:SetChecked(AQSV.pvpTrinkets[vaule])
                end)
            end

            if slot_id == 13 then
                do
                    local b = CreateFrame("CheckButton", nil, queueFrame, "UICheckButtonTemplate")
                    b:SetPoint("TOPLEFT", 505, SELFAQ.lastHeightQueue + 7 - k*35)
                    b:SetChecked(AQSV.queue13[v])
                    f.queue13[k] = b

                    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                    b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
                    b.text:SetText("1")
                    b.text:SetFont(STANDARD_TEXT_FONT, 12)
                    b:SetScript("OnClick", function()
                        local vaule = UIDropDownMenu_GetSelectedValue(dropdown)
                        AQSV.queue13[vaule] = not AQSV.queue13[vaule]
                        b:SetChecked(AQSV.queue13[vaule])
                    end)
                end

                do
                    local b = CreateFrame("CheckButton", nil, queueFrame, "UICheckButtonTemplate")
                    b:SetPoint("TOPLEFT", 555, SELFAQ.lastHeightQueue + 7 - k*35)
                    b:SetChecked(AQSV.queue14[v])
                    f.queue14[k] = b

                    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                    b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
                    b.text:SetText("2")
                    b.text:SetFont(STANDARD_TEXT_FONT, 12)
                    b:SetScript("OnClick", function()
                        local vaule = UIDropDownMenu_GetSelectedValue(dropdown)
                        AQSV.queue14[vaule] = not AQSV.queue14[vaule]
                        b:SetChecked(AQSV.queue14[vaule])
                    end)
                end
            end
        end

        

        -- 没有主动饰品的情况
        if #AQSV.usableItems[slot_id] == 0 then
            local l = queueFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            l:SetText(L["<There is no suitable trinkets>"])
            l:SetPoint("TOPLEFT", queueFrame, 25, SELFAQ.lastHeightQueue - 35)

            height = SELFAQ.lastHeightQueue - 35
        end

        SELFAQ.lastHeightQueue = height

        do
            local t = queueFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            t:SetText(L["Backup (Be equiped when usable items are all on CD):"] )
            t:SetPoint("TOPLEFT", queueFrame, 25, SELFAQ.lastHeightQueue - 45)
        end

        

        local max = 1
        if slot_id == 13 then
            max = 2
        end

        for k=1, max do
            f.resident[slot_id -1 +k] = {}

            local dropdown = CreateFrame("Frame", nil, queueFrame, "UIDropDownMenuTemplate");
            dropdown:SetPoint("TOPLEFT", 100, SELFAQ.lastHeightQueue-(40 + k*35))
            dropdown.index = k
            dropdown.slot = slot_id -1 +k

            f.resident[dropdown.slot] = dropdown

            local l = queueFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")

            if dropdown.slot == 13 then
                l:SetText(L["Priority "]..1)
            elseif dropdown.slot  == 14 then
                l:SetText(L["Priority "]..2)
            else
                l:SetText(L["Priority "])
            end

            
            l:SetPoint("TOPLEFT", queueFrame, 25, SELFAQ.lastHeightQueue-(45 + k*35))

            UIDropDownMenu_SetButtonWidth(dropdown, 130)
            UIDropDownMenu_Initialize(dropdown, Resident_Trinket_Initialize)

            local seleted = AQSV.slotStatus[dropdown.slot].backup

            UIDropDownMenu_SetSelectedValue(dropdown, seleted, 0)
            UIDropDownMenu_SetText(dropdown, GetItemLink(seleted))      
            
            UIDropDownMenu_SetWidth(dropdown, 130)
            UIDropDownMenu_JustifyText(dropdown, "LEFT")

            -- 固定模式选项
            if dropdown.slot == 13 then
                do
                    local b = CreateFrame("CheckButton", nil, queueFrame, "UICheckButtonTemplate")
                    b:SetPoint("TOPLEFT", 280, SELFAQ.lastHeightQueue -(38 + k*35))
                    b:SetChecked(AQSV.enableFixedPosition)

                    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                    b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
                    b.text:SetText(L["Fixed position: Priority 1 = Slot 1, Priority 2 = Slot 2"])
                    b.text:SetFont(STANDARD_TEXT_FONT, 12)
                    b:SetScript("OnClick", function()
                        AQSV.enableFixedPosition = not AQSV.enableFixedPosition
                    end)
                end
            end

            height = SELFAQ.lastHeightQueue-(45 + k*35)
        end

        SELFAQ.lastHeightQueue = height - 43

    end

    function buildCheckbox(text, key, pos, x)

        local posX = 20

        if x ~= nil then
            posX = x
        end

        local b = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        b:SetPoint("TOPLEFT", f, posX, pos)
        b:SetChecked(AQSV[key])

        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
        b.text:SetText(text)
        b:SetScript("OnClick", function()
            AQSV[key] = not AQSV[key]
            b:SetChecked(AQSV[key])

            if key == "enableItemBar" then  
                -- 装备栏的开关
                if not AQSV.enableItemBar then
                    SELFAQ.bar:Hide()
                else
                    SELFAQ.bar:Show()
                end
            end

            if key == "enableBuff" then  
                -- 装备栏的开关
                if not AQSV.enableBuff then
                    SELFAQ.buff:Hide()
                else
                    SELFAQ.buff:Show()
                end
            end

            if key == "locked" then
                SELFAQ.lockItemBar()
            end

            if key == "buffLocked" then
                SELFAQ.lockBuff()
            end

            if key == "hideBackdrop" then
                SELFAQ.hideBackdrop()
            end

            if key == "reverseCooldownUnit" then
                SELFAQ.renderQuickButton()
            end

            if key == "hideQuickButton" then
                SELFAQ.renderQuickButton()
            end

             if key == "hideTakeoffButton" then
                SELFAQ.renderQuickButton()
            end
        end)

        f.checkbox[key] = b
    end

    function buildSlotCheckbox(text, key, pos, x)

        local b = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        b:SetPoint("TOPLEFT", f, x, pos)
        b:SetChecked(AQSV.enableItemBarSlot[key])

        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
        b.text:SetText(text)
        b:SetScript("OnClick", function()
            AQSV.enableItemBarSlot[key] = not AQSV.enableItemBarSlot[key]
            b:SetChecked(AQSV.enableItemBarSlot[key])
        end)

        f.checkbox[key] = b
    end

    function buildLine( y )
        local line = CreateFrame("Button", nil, f)

        line:SetWidth(10)
        line:SetHeight(1)
        line:SetPoint("TOPLEFT", f, 53, y)

        line:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"});
        line:SetBackdropColor(0.8,0.8,0.8,0.8);
    end

    buildCheckbox(L["Enable AutoEquip function"], "enable", -60)

    buildLine(-95+3)

    buildCheckbox(L["Enable Equipment Bar"], "enableItemBar", -85-10)
    buildCheckbox(L["Lock frame"], "locked", -85-10, 190)
    buildCheckbox(L["Hide black translucent border"], "hideBackdrop", -110-10, 190)

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["Zoom"])
        t:SetPoint("TOPLEFT", f, 320, -93-10)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["#Effective after ENTER"])
        t:SetPoint("TOPLEFT", f, 430, -93-10)
    end

    do
        local e = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
        e:SetFontObject("GameFontHighlight")
        e:SetWidth(50)
        e:SetHeight(40)
        e:SetJustifyH("CENTER")
        e:SetPoint("TOPLEFT", f, 370,  -80-10)
        e:SetAutoFocus(false)
        e:SetText(AQSV.barZoom)
        e:SetCursorPosition(0)

        e:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()

            local v = self:GetText()
            v = tonumber(v)

            if not v then
                v = 1
            end

            self:SetText(v)
            AQSV.barZoom = v

            SELFAQ.bar:SetScale(AQSV.barZoom)

        end)
    end

    local slotCheckbosHeight = -115-25-10

    buildSlotCheckbox(L["MainHand"], 16, slotCheckbosHeight, 45)
    buildSlotCheckbox(L["OffHand"], 17, slotCheckbosHeight, 155)
    buildSlotCheckbox(L["Ranged"], 18, slotCheckbosHeight, 265)
    buildSlotCheckbox(L["Head"], 1, slotCheckbosHeight, 375)
    buildSlotCheckbox(L["Neck"], 2, slotCheckbosHeight, 485)

    slotCheckbosHeight = -140-25-10

    buildSlotCheckbox(L["Shoulder"], 3, slotCheckbosHeight, 45)
    buildSlotCheckbox(L["Chest"], 5, slotCheckbosHeight, 155)
    buildSlotCheckbox(L["Waist"], 6, slotCheckbosHeight, 265)
    buildSlotCheckbox(L["Legs"], 7, slotCheckbosHeight, 375)
    buildSlotCheckbox(L["Feet"], 8, slotCheckbosHeight, 485)

    slotCheckbosHeight = -165-25-10

    buildSlotCheckbox(L["Wrist"], 9, slotCheckbosHeight, 45)
    buildSlotCheckbox(L["Hands"], 10, slotCheckbosHeight, 155)
    buildSlotCheckbox(L["Finger "]..1, 11, slotCheckbosHeight, 265)
    buildSlotCheckbox(L["Finger "]..2, 12, slotCheckbosHeight, 375)
    buildSlotCheckbox(L["Back"], 15, slotCheckbosHeight, 485)

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["#The above selections will take effect after reloading UI"])
        t:SetPoint("TOPLEFT", f, 53, -200-25-10)
    end

    local otherHight = -245-10-10

    buildLine(otherHight+3)

    buildCheckbox(L["Enable Buff Alert"], "enableBuff", otherHight)
    buildCheckbox(L["Lock frame"], "buffLocked", otherHight, 190)

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["Zoom"])
        t:SetPoint("TOPLEFT", f, 320, otherHight-8)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["#Effective after ENTER"])
        t:SetPoint("TOPLEFT", f, 430, otherHight-8)
    end

    do
        local e = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
        e:SetFontObject("GameFontHighlight")
        e:SetWidth(50)
        e:SetHeight(40)
        e:SetJustifyH("CENTER")
        e:SetPoint("TOPLEFT", f, 370,  otherHight+5)
        e:SetAutoFocus(false)
        e:SetText(AQSV.buffZoom)
        e:SetCursorPosition(0)

        e:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()

            local v = self:GetText()
            v = tonumber(v)

            if not v then
                v = 1
            end

            self:SetText(v)
            AQSV.buffZoom = v

            SELFAQ.buff:SetScale(AQSV.buffZoom)

        end)
    end

    otherHight = -290-10-10

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["AutoEquip Function:"])
        t:SetPoint("TOPLEFT", f, 25, otherHight)
    end

    otherHight = otherHight-25

    buildCheckbox(L["Automatic switch to PVP queue in Battleground"], "enableBattleground", otherHight)

    buildLine(otherHight - 32)

    buildCheckbox(L["Disable Slot 2"], "disableSlot14", otherHight-35)
    buildCheckbox(L["Equip item by priority forcibly even if the item in slot is aviilable"], "forcePriority", otherHight-60)

    buildLine(otherHight - 92)

    buildCheckbox(L["Equip |cff0070dd[Onyxia Scale Cloak]|r when entering |cffffffffNefarian's Lair|r"], "enableOnyxiaCloak", otherHight-95)
    buildCheckbox(L["Remind on Raid channel when auto-equiped |cff0070dd[Onyxia Scale Cloak]|r"], "enableOnyxiaCloakAlert", otherHight-120)

    otherHight = otherHight-120-45

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Auto Acceleration Function:"])
        t:SetPoint("TOPLEFT", f, 25, otherHight)
    end

    otherHight = otherHight-25

    buildCheckbox(L["enable_carrot"], "enableCarrot", otherHight)
    buildCheckbox(L["enable_swim"], "enableSwim", otherHight-25)

    buildLine(otherHight-60+3)

    buildCheckbox(L["Takeoff [Acceleration Items] when |cffffffffYou|r target an enemy"], "pauseAccWhenTarget", otherHight-60)
    buildCheckbox(L["Takeoff [Acceleration Items] when |cffffffffRaid members|r target enemies"], "pauseAccWhenTargetMember", otherHight-85)

    buildLine(otherHight-120+3)

    buildCheckbox(L["When equipment bar is locked, those 2 functions also take effect"], "forceAcc", otherHight-120)

    buildLine(otherHight-155+3)

    buildCheckbox(L["In Instance and Battleground, enable those 2 functions"], "enableAccInstance", otherHight-155)
    buildCheckbox(L["In TAQ, enable Riding Acceleration function"], "enableAccTAQ", otherHight-180)

    otherHight = otherHight-180-45

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Display:"])
        t:SetPoint("TOPLEFT", f, 25, otherHight)
    end

    buildCheckbox(L["Item queue is displayed above the Equipment Bar"], "reverseCooldownUnit", otherHight-25)
    buildCheckbox(L["In combat |cFF00FF00shift + left-click|r equipment button to display the items list"], "shiftLeftShowDropdown", otherHight-50)

    buildLine(otherHight-85+3)

    buildCheckbox(L["Hide tooltip when the mouse moves over the button"], "hideTooltip", otherHight-85)
    buildCheckbox(L["Show simple tooltip (only item name)"], "simpleTooltip", otherHight-110)

    buildLine(otherHight-145+3)

    buildCheckbox(L["Hide popup addon info at the top of screen"], "hidePopupInfo", otherHight-145)
    buildCheckbox(L["Hide addon info in the chat box"], "hideChatInfo", otherHight-170)

    buildLine(otherHight-205+3)

    buildCheckbox(L["Hide quick buttons"], "hideQuickButton", otherHight-205)
    buildCheckbox(L["Disable the takeoff quick button"], "hideTakeoffButton", otherHight-230)

    otherHight = otherHight - 230

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["#When the equippable items you carry have changed"])
        t:SetPoint("TOPLEFT", f, 135, otherHight-45)

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Reload UI"])
        b:SetWidth(100)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 23, otherHight-35)
        b:SetScript("OnClick", function(self)
            C_UI.Reload()
        end)
    end

    do
        local t = queueFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Go to 'General' page and add the unidentified usable items manually"])
        t:SetPoint("TOPLEFT", queueFrame, 25, SELFAQ.lastHeightQueue)
    end
    do
        local t = queueFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Not only trinkets, any equippable usable item is acceptable"])
        t:SetPoint("TOPLEFT", queueFrame, 25, SELFAQ.lastHeightQueue - 25)
    end

    do
        local b = CreateFrame("CheckButton", nil, queueFrame, "UICheckButtonTemplate")
        b:SetPoint("TOPLEFT", queueFrame, 20, SELFAQ.lastHeightQueue - 50)
        b:SetChecked(AQSV.enableRaidQueue)

        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
        b.text:SetText(L["Enable Raid checkbox / Automatic switch to Raid queue in Instance"])
        b:SetScript("OnClick", function()
            
            AQSV.enableRaidQueue = not AQSV.enableRaidQueue
            b:SetChecked(AQSV.enableRaidQueue)

            for k,v in pairs(f.raidCheckbox) do

                for k1,v1 in pairs(v) do
                    
                    if AQSV.enableRaidQueue then
                        v1:Enable()
                        v1.dtext:Hide()
                        v1.text:Show()
                    else
                        v1:Disable()
                        v1.dtext:Show()
                        v1.text:Hide()
                    end

                end
            end


        end)
    end

    SELFAQ.lastHeightQueue = SELFAQ.lastHeightQueue - 95

    SELFAQ.loopSlots(buildDropdownGroup)

    SELFAQ.lastHeight = otherHight - 40

    -- 添加主动装备
    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Append Usable Items (not only trinket):"])
        t:SetPoint("TOPLEFT", f, 25, SELFAQ.lastHeight-60)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["Unidentified usable items need to be added manually by yourself"])
        t:SetPoint("TOPLEFT", f, 25, SELFAQ.lastHeight - 85)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["Format - ItemID/BuffTime,ItemID/BuffTime"])
        t:SetPoint("TOPLEFT", f, 25, SELFAQ.lastHeight - 110)
    end

    do

        local s = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate") -- or you actual parent instead
        s:SetSize(350,80)
        s:SetPoint("TOPLEFT", f, 26, SELFAQ.lastHeight - 135)
        s:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 2});
        s:SetBackdropBorderColor(1,1,1,0.7);
        local e = CreateFrame("EditBox", nil, s)
        e:SetMultiLine(true)
        e:SetFontObject("GameFontHighlight")
        e:SetWidth(350)
        -- AQSV.buffNames = nil
        e:SetText(AQSV.additionItems)
        e:SetTextInsets(8,8,8,8)
        e:SetAutoFocus(false)

        s:SetScrollChild(e)

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Save & Reload UI"])
        b:SetWidth(160)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 410, SELFAQ.lastHeight - 131)
        b:SetScript("OnClick", function(self)
            AQSV.additionItems = e:GetText()
            C_UI.Reload()
        end)
    end

    SELFAQ.lastHeight = SELFAQ.lastHeight - 185

    -- 自定义buff
    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Custom Buff Alert:"])
        t:SetPoint("TOPLEFT", f, 25, SELFAQ.lastHeight-60)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["Format - BuffName,BuffName,BuffName"])
        t:SetPoint("TOPLEFT", f, 25, SELFAQ.lastHeight - 85)
    end

    do

        local s = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate") -- or you actual parent instead
        s:SetSize(350,80)
        s:SetPoint("TOPLEFT", f, 26, SELFAQ.lastHeight - 110)
        s:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 2});
        s:SetBackdropBorderColor(1,1,1,0.7);
        local e = CreateFrame("EditBox", nil, s)
        e:SetMultiLine(true)
        e:SetFontObject("GameFontHighlight")
        e:SetWidth(350)
        -- AQSV.buffNames = nil
        -- print(AQSV.buffNames[2])
        e:SetText(AQSV.buffNames)
        e:SetTextInsets(8,8,8,8)
        e:SetAutoFocus(false)

        s:SetScrollChild(e)

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Save & Reload UI"])
        b:SetWidth(160)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 410, SELFAQ.lastHeight - 108)
        b:SetScript("OnClick", function(self)
            AQSV.buffNames = e:GetText()
            C_UI.Reload()
            -- SELFAQ.buffs = SELFAQ.comma2Table(AQSV.buffNames)
            -- debug(SELFAQ.buffs)
        end)

        SELFAQ.buffs = SELFAQ.comma2Table(AQSV.buffNames)
        debug(SELFAQ.buffs)
    end

    SELFAQ.lastHeight = SELFAQ.lastHeight - 160

    -- 自定义buff
    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Block Items:"])
        t:SetPoint("TOPLEFT", f, 25, SELFAQ.lastHeight-60)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["Format - ItemID,ItemID,ItemID"])
        t:SetPoint("TOPLEFT", f, 25, SELFAQ.lastHeight - 85)
    end

    do

        local s = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate") -- or you actual parent instead
        s:SetSize(350,80)
        s:SetPoint("TOPLEFT", f, 26, SELFAQ.lastHeight - 110)
        s:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 2});
        s:SetBackdropBorderColor(1,1,1,0.7);
        local e = CreateFrame("EditBox", nil, s)
        e:SetMultiLine(true)
        e:SetFontObject("GameFontHighlight")
        e:SetWidth(350)
        -- AQSV.buffNames = nil
        -- print(AQSV.buffNames[2])
        e:SetText(AQSV.blockItems)
        e:SetTextInsets(8,8,8,8)
        e:SetAutoFocus(false)

        s:SetScrollChild(e)

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Save & Reload UI"])
        b:SetWidth(160)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 410, SELFAQ.lastHeight - 131)
        b:SetScript("OnClick", function(self)
            AQSV.blockItems = e:GetText()
            C_UI.Reload()
        end)
    end

    SELFAQ.lastHeight = SELFAQ.lastHeight - 220

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Command (/aq /autoequip are valid):"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 60)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 85)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Enable/disable AutoEquip function"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 85)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae settings"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 105)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Open settings"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 105)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae pvp"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 125)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Enable/disable PVP queue manually"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 125)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae unlock"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 145)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Unlock Equipment Bar (AutoEquip function is invalid when locked)"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 145)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText("/ae 60(63/64)")
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 165)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Equip Suit "]..L[60].."/"..L[63].."/"..L[64])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 165)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText("/ae lock")
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 185)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Lock Equipment Bar"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 185)
    end

    SELFAQ.lastHeightHelp = SELFAQ.lastHeightHelp - 20

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Advanced Settings:"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 205)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae ipc 5"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 230)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Set 5 items per column in dropdown list (default 4)"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 230)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae ceb 5,13,16"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 250)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Customize equipment bar (enter 0 to disable)"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 250)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae hiq 1(0)"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 270)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Hide the usable items queue (hide 1, show 0)"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 270)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae bs 1"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 290)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Set equipment button spacing to 1 (default 3)"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 290)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae dm 1"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 310)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Disable the display of item list when moseover (enable 0)"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 310)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae pp 0,0"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 330)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Set popup info to the center of screen (default 0,320)"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 330)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae rm 3"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 350)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Set threshold of member's target to 3 (default 1)"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 350)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/ae resetp"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 370)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Reset equipment bar position"])
        t:SetPoint("TOPLEFT", helpFrame, 170, SELFAQ.lastHeightHelp - 370)
    end

    SELFAQ.lastHeightHelp = SELFAQ.lastHeightHelp - 335

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Tips:"])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 60)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["1. Equip item manually through the Equipment Bar will temporarily lock the button."])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 85)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["2. Right click or use the '/ae unlock' command will unlock the button."])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 105)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["3. Before using item, the button will be unlocked automatically."])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 125)
    end

    do
        local t = helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["4. AutoEquip/Equipment Bar/Buff Alert can be enabled/disabled independently."])
        t:SetPoint("TOPLEFT", helpFrame, 25, SELFAQ.lastHeightHelp - 145)
    end

    SELFAQ.lastHeightHelp = SELFAQ.lastHeightHelp - 200


    f:SetAllPoints(p)
    p:SetScrollChild(f)
    f:SetSize(1000, -SELFAQ.lastHeight)

    queueFrame:SetAllPoints(queueOption)
    queueOption:SetScrollChild(queueFrame)
    queueFrame:SetSize(1000, -SELFAQ.lastHeightQueue)

    helpFrame:SetAllPoints(helpOption)
    helpOption:SetScrollChild(helpFrame)
    helpFrame:SetSize(1000, -SELFAQ.lastHeightHelp)

    InterfaceOptions_AddCategory(top)
    InterfaceOptions_AddCategory(p)
    InterfaceOptions_AddCategory(queueOption)

    -- top:SetScript('OnShow', function(self)
    --     InterfaceOptionsFrame_OpenToCategory(p);
    --     InterfaceOptionsFrame_OpenToCategory(p);
    -- end)

    -- 运行两遍才行
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
end